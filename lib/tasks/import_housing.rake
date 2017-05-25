def df(date, row)
  begin
    Date.strptime(date, '%m/%d/%Y')
  rescue => e
    puts e.message
    raise row.inspect
  end
end

namespace :import do
  desc 'Import housing assignments from spreadsheet'
  task housing: :environment do
    table = CSV.table(Rails.root.join('tmp','june-4-17-assignments.csv'))
    missing_rooms = []

    FACILITIES = {
      'corbett' => HousingFacility.find_by(name: 'Corbett (suite style, no A/C)'),
      'laurel village-alpine suites' => HousingFacility.find_by(name: 'Alpine (suite style, with A/C)'),
      'laurel village-alpine traditional' => HousingFacility.find_by(name: 'Alpine (community bathroom with A/C)'),
      'laurel villiage-alpine traditional' => HousingFacility.find_by(name: 'Alpine (community bathroom with A/C)'),
      'laurel village-pinon traditional' => HousingFacility.find_by(name: 'Pinon (community bathroom with A/C)'),
      'laurel village-pinon private' => HousingFacility.find_by(name: 'Pinon (private bathroom, with A/C)'),
      'laurel village-pinon suites' => HousingFacility.find_by(name: 'Pinon (suite style, with A/C)'),
      'westfall' => HousingFacility.find_by(name: 'Westfall (community bathroom, no A/C)')
    }

    table.each do |row|
      next unless row[:block]
      raise row.inspect unless row[:arrival_date] && row[:departure_date]# && row[:first_name] && row[:last_name]
      facility_name = FACILITIES[row[:block].to_s.downcase]
      raise row.inspect unless facility_name

      person = Person.find_by('lower(email) = ?', row[:email])

      person ||= Person.where('lower(first_name) = ? AND lower(last_name) = ?',
                            row[:first_name].to_s.strip.downcase,
                            row[:last_name].strip.downcase).first

      unless person
        msg = "Couldn't find: #{row[:first_name]} #{row[:last_name]}. "
        unless ['jones', 'johnson'].include?(row[:last_name].downcase)
          people = Person.where('lower(last_name) = ?',
                                row[:last_name].strip.downcase).order(:first_name)
        end

        msg += 'Did you mean: ' + people.collect {|p| [p.first_name, p.last_name].join(' ')}.join(' - ') if people.present?
        puts msg
        next
      end

      room_name = row[:room_name].split(' ').last.sub(/(\w?\d+)\w?/, '\1')

      room = HousingUnit.find_by(housing_facility_id: FACILITIES[row[:block].downcase], name: room_name)
      raise row[:block].inspect unless FACILITIES[row[:block].downcase]
      unless room
        missing_rooms << row[:room_name]
        next
      end

      notes = ''
      notes += "#{row[:license_plate]}\n" if row[:license_plate].present?
      notes += "#{row[:notes]}\n"

      person.stays.where(
          arrived_at: df(row[:arrival_date], row),
          departed_at: df(row[:departure_date], row)
      ).first_or_create!(
           housing_unit_id: room.id,
           comment: notes
      )
    end
    puts "Andy doesn't know about the following rooms: #{missing_rooms.join(', ')}"
  end

  desc 'Import comments'
  task housing: :environment do
    table = CSV.table(Rails.root.join('tmp','export.csv'))
    table.each do |row|
      if row[:housing_comments].to_s.length >= 255
        family = Family.find_by(import_tag: row[:family])
        if family.housing_preference.comment.length == 255
          family.housing_preference.update_column(:comment, row[:housing_comments])
        end
      end
      columns = {
          mobility_needs_comment: :mobility_comment,
          personal_comments: :personal_comment,
          conference_comments: :conference_comment,
          childcare_comments: :childcare_comment,
          ibs_comments: :ibs_comment
      }
      columns.each do |key, db_column|
        if row[key].to_s.length >= 255
          family = Family.find_by(import_tag: row[:family])
          next unless family
          person = family.people.find_by(first_name: row[:first], last_name: row[:last])
          raise row.inspect unless person
          if person.send(db_column).length == 255
            person.update_column(db_column, row[key])
            puts row[key]
            puts person.id
            puts key
          end
        end
      end
    end
  end
end
