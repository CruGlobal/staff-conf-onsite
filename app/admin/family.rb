ActiveAdmin.register Family do
  includes :attendees, :housing_preference

  partial_view(
    :index,
    show: { title: ->(f) { family_label(f) } },
    form: { title: ->(f) { f.new_record? ? 'New Family' : "Edit #{family_label(f)}" } },
    sidebar: ['Family Members', only: [:edit]]
  )

  menu parent: 'People', priority: 1

  permit_params :last_name, :staff_number, :address1, :address2, :city, :county,
                :state, :zip, :country_code, :primary_person_id, :license_plates,
                :handicap, :precheck_status, required_team_action: [],
                housing_preference_attributes: %i[
                  id housing_type roommates beds_count single_room
                  children_count bedrooms_count other_family
                  accepts_non_air_conditioned location1 location2 location3
                  confirmed_at comment
                ],
                people_attributes: [:id, { stays_attributes: %i[
                  id _destroy housing_unit_id arrived_at departed_at
                  single_occupancy no_charge waive_minimum percentage comment
                  no_bed
                ] }]

  filter :last_name
  filter :attendees_first_name, label: 'Attendee Name', as: :string
  filter :staff_number
  filter :address1
  filter :address2
  filter :city
  filter :county
  filter :state
  filter :country_code, as: :select, collection: -> { country_select }
  filter :zip
  filter :precheck_status, as: :select, collection: Family.precheck_statuses
  filter :created_at
  filter :updated_at

  collection_action :new_spreadsheet, title: 'Import Spreadsheet'
  action_item :import_spreadsheet, only: :index do
    link_to 'Import Spreadsheet', action: :new_spreadsheet if authorized?(:import, Family)
  end

  collection_action :import_spreadsheet, method: :post do
    return head :forbidden unless authorized?(:import, Family)
  
    import_params = params.require(:import_spreadsheet).permit(:file)
  
    job = UploadJob.create!(
      user_id: current_user.id,
      filename: import_params[:file].path
    )
  
    ImportPeopleFromSpreadsheetJob.perform_later(job.id)
  
    redirect_to job
  end
  

  action_item :accounting_report, only: %i[show edit] do
    link_to 'Accounting Report', family_accounting_reports_path(family)
  end

  action_item :summary, only: %i[show edit] do
    link_to 'Summary', summary_family_path(family)
  end

  action_item :new_payment, only: :summary do
    link_to 'New Payment', new_family_payment_path(params[:id])
  end

  action_item :link_back, only: :summary do
    link_to 'Back to Family', action: :show
  end

  member_action :summary do
    family = Family.find(params[:id])    
    finances = FamilyFinances::Report.call(family: family)
    hotels = HousingFacility.order(:position)

    render :summary, locals: { family: family, finances: finances, hotels: hotels }
  end

  collection_action :balance_due do
    csv_string = CSV.generate do |csv|
      csv << %w(FamilyID Last First Email Phone Amount Checked-in)
      Family.includes(:chargeable_staff_number).order(:last_name).each do |f|
        next if f.chargeable_staff_number?

        finances = FamilyFinances::Report.call(family: f)
        balance = finances.subtotal - finances.paid
        next if balance == 0

        csv << [f.id, f.last_name, f.first_name, f.email, f.phone, balance, f.checked_in?]
      end
    end

    send_data(csv_string, filename: "Balance Due - #{Date.today.to_s(:db)}.csv")
  end

  collection_action :finance_track_dump do
    csv_string = CSV.generate do |csv|
      csv << %w(FamilyID Last First StaffId Checked-in StaffConf Xtrack NST NSO MTL MTLSpouse MPD Legacy CW)
      Family.includes(:chargeable_staff_number, {attendees: :conferences}).order(:last_name).each do |f|
        row = [f.id, f.last_name, f.first_name, "_#{f.staff_number}", f.checked_in?]

        row << StaffConference::SumFamilyCost.call(family: f).total

        xtrack = nst = nso = mtl = mtl_spouse = mpd = legacy = cw = 0

        f.attendees.each do |attendee|
          attendee.conferences.reject(&:staff_conference?).each do |conference|
            next if conference.price.zero?

            sum = Conference::SumAttendeeCost.call(attendee: attendee)
            amount = ApplyCostAdjustments.call(charges: sum.charges,
                                      cost_adjustments: sum.cost_adjustments).total
            case
              when conference.name == 'XTrack Participant'
                xtrack += amount
              when conference.name == 'New Staff Training'
                nst += amount
              when conference.name == 'New Staff Orientation'
                nso += amount
              when conference.name == 'Missional Team Leader Training Participant'
                mtl += amount
              when conference.name == 'Missional Team Leader Spouse'
                mtl_spouse += amount
              when /MPD/.match?(conference.name)
                mpd += amount
              when /legacy/i.match?(conference.name)
                legacy += amount
              when /Connection Weekend Attendee/.match?(conference.name)
                cw += amount
            end
          end
        end

        row += [xtrack, nst, nso, mtl, mtl_spouse, mpd, legacy, cw]

        csv << row
      end
    end

    send_data(csv_string, filename: "Finance Track Dump - #{Date.today.to_s(:db)}.csv")
  end

  collection_action :full_accounting_report do
    row_num = 0

    csv_string = CSV.generate do |csv|
      csv << [
        'Row Num', 'Id', 'Bus unit','Oper unit','Dept','Project','Account','Product','Amount','Description','Reference', '', 'Family',
        'Last name', 'First name', 'Spouse first name'
      ]
      Family.includes(:primary_person, :payments, {attendees: [:courses, :conferences, :cost_adjustments]},
                      {children: :cost_adjustments})
          .order(:last_name).each do |family|
        report = AccountingReport::Report.call(family_id: family.id).table

        (1..report.total_pages).each do |page|
          report.page(page).each do |row|
            row_num += 1
            csv << [row_num, row.attributes.values].flatten
          end
        end
      end
    end

    send_data(csv_string, filename: "Accounting Report - #{Date.today.to_s(:db)}.csv")
  end

  collection_action :finance_full_dump do
    csv_string = CSV.generate do |csv|
      csv << ['FamilyID', 'Last','First','Staff Id','Checked-In','Adult Dorm','Adult Dorm Adj','Apt Rent','Apt Rent Adj',
              'Child Dorm','Child Dorm Taxable', 'Child Dorm Nontaxable', 'Child Dorm Adj','Cru Kids','Cru Kids Adj',  
              'Hot Lunch Care',
              'Hot Lunch Care Adj',
              'Hot Lunch Camp',
              'Hot Lunch Camp Adj',
              'Hot Lunch CruStu',
              'Hot Lunch CruStu Adj',
              'Hot Lunch Total',              
              'Hot Lunch Adj Total', 
              'JrSr','JrSr Adj',
              'Facility Use Fee','Facility Use Fee Adj','Class Tuition','Class Tuition Adj','Track Tuition',
              'Track Tuition Adj','USSC Tuition','USSC Tuition Adj','Rec Pass',
              'Rec Pass Adj', 'Total Due', 'Balance Due', 'Total Paid', 'Pre Paid', 'Ministry Acct', 'Cash/Check', 'Credit Card', 'Charge Staff Acct',
              'Business Unit', 'Operating Unit', 'Department', 'Project', 'Reference'
      ]
      Family.includes(:primary_person, :payments, {attendees: [:courses, :conferences, :cost_adjustments]},
                      {children: :cost_adjustments})
          .order(:last_name).each do |family|

        finances = FamilyFinances::Report.call(family: family)

        total_due = 0

        totals = Stay::SumFamilyAttendeesDormitoryCost.call(family: family)
        adult_dorm = totals.total
        adult_dorm_adj = totals.total_adjustments
        total_due += adult_dorm

        totals = Stay::SumFamilyAttendeesApartmentCost.call(family: family)
        adult_apt = totals.total
        adult_apt_adj = totals.total_adjustments
        total_due += adult_apt

        totals = Stay::SumFamilyChildrenCost.call(family: family)
        child_dorm = totals.total
        child_dorm_taxable = totals.taxable_total
        child_dorm_nontaxable = totals.nontaxable_total
        child_dorm_adj = totals.total_adjustments
        total_due += child_dorm

        totals = Childcare::SumFamilyCost.call(family: family)
        childcare = totals.total
        childcare_adj = totals.total_adjustments
        total_due += childcare

        totals = HotLunch::SumFamilyCareCost.call(family: family)
        hot_lunch_care = totals.total
        hot_lunch_care_adj = totals.total_adjustments
        total_due += hot_lunch_care

        totals = HotLunch::SumFamilyCampCost.call(family: family)
        hot_lunch_camp = totals.total
        hot_lunch_camp_adj = totals.total_adjustments
        total_due += hot_lunch_camp

        totals = HotLunch::SumFamilyCruStuCost.call(family: family)
        hot_lunch_cru_stu = totals.total
        hot_lunch_cru_stu_adj = totals.total_adjustments
        total_due += hot_lunch_cru_stu
        
        totals = HotLunch::SumFamilyCost.call(family: family)
        hot_lunch = totals.total
        hot_lunch_adj = totals.total_adjustments

        totals = JuniorSenior::SumFamilyCost.call(family: family)
        jrsr = totals.total
        jrsr_adj = totals.total_adjustments
        total_due += jrsr

        totals = FacilityUseFee::SumFamilyCost.call(family: family)
        fuf = totals.total
        fuf_adj = totals.total_adjustments
        total_due += fuf

        totals = Course::SumFamilyCost.call(family: family)
        class_tuition = totals.total
        class_tuition_adj = totals.total_adjustments
        total_due += class_tuition

        totals = Conference::SumFamilyCost.call(family: family)
        track_tuition = totals.total
        track_tuition_adj = totals.total_adjustments
        total_due += track_tuition

        totals = StaffConference::SumFamilyCost.call(family: family)
        ussc_tuition = totals.total
        ussc_tuition_adj = totals.total_adjustments
        total_due += ussc_tuition

        totals = RecPass::SumFamilyCost.call(family: family)
        rec = totals.total
        rec_adj = totals.total_adjustments
        total_due += rec

        pre_paid = family.payments.to_a.select(&:pre_paid?).inject(0) {|sum, p| sum + p.price}
        ministry_payments = family.payments.to_a.select {|p| p.business_account? || p.staff_code?}
        ministry_payment_amount = ministry_payments.inject(0) {|sum, p| sum + p.price}
        cash_check = family.payments.to_a.select(&:cash_check?).inject(0) {|sum, p| sum + p.price}
        credit_card = family.payments.to_a.select(&:credit_card?).inject(0) {|sum, p| sum + p.price}
        staff_code = family.chargeable_staff_number? ? finances.unpaid : 0
        total_paid = pre_paid + ministry_payment_amount + cash_check + credit_card + staff_code
        balance_due = total_due - total_paid

        csv << [
          family.id, family.last_name, family.first_name, "_#{family.staff_number}", family.checked_in?,
          adult_dorm, adult_dorm_adj, adult_apt, adult_apt_adj, child_dorm, child_dorm_taxable, child_dorm_nontaxable, child_dorm_adj, childcare, childcare_adj,
          hot_lunch_care, hot_lunch_care_adj, hot_lunch_camp, hot_lunch_camp_adj, hot_lunch_cru_stu, hot_lunch_cru_stu_adj, hot_lunch, hot_lunch_adj, jrsr, jrsr_adj, fuf, fuf_adj, class_tuition, class_tuition_adj,
          track_tuition, track_tuition_adj, ussc_tuition, ussc_tuition_adj, rec, rec_adj, total_due, balance_due, total_paid, pre_paid, ministry_payment_amount,
          cash_check, credit_card, staff_code, ministry_payments.collect(&:business_unit).join(', '),
          ministry_payments.collect(&:operating_unit).join(', '), ministry_payments.collect(&:department_code).join(', '),
          ministry_payments.collect(&:project_code).join(', '), ministry_payments.collect(&:reference).join(', ')
        ]
      end
    end

    # output = '<html><body><table>'
    # csv_string.split("\n").each do |row|
    #   output += '<tr>'
    #   row.split(',').each do |cell|
    #     output += "<td>#{cell}</td>"
    #   end
    #   output += '</tr>'
    # end
    #
    # output + '</table></body></html>'
    #
    # render html: output.html_safe
    send_data(csv_string, filename: "Finance Full Dump - #{Date.today.strftime('%Y-%m-%d')}.csv")
  end

  member_action :checkin, method: :post do
    return head :forbidden unless authorized?(:checkin, Family)

    @family = Family.find(params[:id])
    @finances = FamilyFinances::Report.call(family: @family)
    @hotels = HousingFacility.order(:position)

    if @finances.remaining_balance.zero?
      hotel = params['hotel'] == 'Other' ? " OTHER - #{params['other_hotel']} " : params['hotel']
      HotelStay.create(:hotel => hotel  , :family_id => @family.id)
      @family.check_in!

      respond_to do |format|
        format.html do
          redirect_to summary_family_path(@family.id), notice: 'Checked-in!'
        end
        format.js
      end
    else
      redirect_to summary_family_path(@family.id),
                  alert: "The family's balance must be zero to check-in."
    end
  end

  member_action :toggle_action_required_by_team, method: :post do
    @family = Family.find(params[:id])
    team = params[:team]

    @family.toggle_required_team_action(team)
    redirect_to family_path(@family)
  end

  controller do
    def update
      update! do |format|
        Precheck::UpdatedFamilyStatusService.new(family: @family).call
        format.html do
          if request.referer.include?('housing')
            redirect_to housing_path(family_id: @family.id)
          else
            redirect_to family_path(@family)
          end
        end
      end
    end
  end

  # The nametag feature has been disabled for Cru 2019 (nametags will be handled outside of this system).
  # The code was intentionally left in as comments for possible future-use.
  #
  #   action_item :nametag, only: %i[show edit] do
  #     link_to 'Nametags (PDF)', nametag_family_path(family), target: '_blank', rel: 'noopener' if family.checked_in?
  #   end
  #
  #   collection_action :nametags do
  #     applicable = collection.select(&:checked_in?)
  #     roster = AggregatePdfService.call(Family::Nametag, applicable,
  #                                       key: :family, author: current_user)
  #     send_data(roster.render, type: 'application/pdf', disposition: :inline)
  #   end
  #
  #   member_action :nametag do
  #     roster = Family::Nametag.call(family: Family.find(params[:id]),
  #                                   author: current_user)
  #
  #     send_data(roster.render, type: 'application/pdf', disposition: :inline)
  #   end
  #
  #   sidebar 'Nametags', only: :index do
  #     link_to 'Checked-in Families (PDF)', params.merge(action: :nametags)
  #   end
end
