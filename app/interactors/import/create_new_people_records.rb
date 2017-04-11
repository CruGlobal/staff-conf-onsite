module Import
  # == Context Input
  #
  # [+context.import_people+ [+Array<Import::Person>+]]
  class CreateNewPeopleRecords
    include Interactor

    # Associates the row number a given record was created on, so in the event
    # of an error we can report to the end user which row of the spreadsheet
    # caused the error.
    RowRecord = Struct.new(:record, :row)

    Error = Class.new(StandardError)

    before do
      @families = {}
      @imports = context.import_people
    end

    def call
      ApplicationRecord.transaction do
        people = @imports.each_with_index.map(&method(:create_from_import))
        persist_records!(@families.values, people)

        context.people = people.map(&:record)
        context.families = @families.values.map(&:record)
      end
    rescue Error => e
      context.fail!(message: e.message)
    end

    private

    def create_from_import(import, index)
      row = index + 2
      find_or_create_person(import, row).tap do |p|
        set_attributes(p.record, import)
      end
    rescue StandardError => e
      raise Error, format('Row #%d: %s', row, e)
    end

    def find_or_create_person(import, row)
      family = find_or_create_family(import, row)

      existing_person = family.record.people.find do |p|
        p.birthdate == import.birthdate && p.first_name == import.first_name
      end

      person =
        if existing_person.present?
          existing_person
        else
          import.record_class.new.tap { |p| p.family = family.record }
        end
      RowRecord.new(person, row)
    end

    def find_or_create_family(import, row)
      tag = import.family_tag
      return @families[tag] if @families.key?(tag)

      primary_person =
        @imports.find { |p| p.family_tag == tag && p.primary_family_member? }
      primary_person ||= import # fallback if primary is missing (unusual)

      family = primary_person.family_record || create_family(primary_person)
      @families[primary_person.family_tag] = RowRecord.new(family, row)
    end

    def create_family(primary)
      Family.create!(
        last_name: primary.last_name,
        import_tag: primary.family_tag
      ).tap do |family|
        update_family(family, primary)
      end
    end

    def set_attributes(person, import)
      update_family(person.family, import) if import.primary_family_member?
      update_person(person, import)
    end

    def update_family(family, import)
      result = UpdateFamilyFromImport.call(family: family, import: import)
      raise Error, result.message unless result.success?
    end

    def update_person(person, import)
      result = UpdatePersonFromImport.call(person: person, import: import,
                                           ministries: ministries)
      raise Error, result.message unless result.success?
    end

    def ministries
      @ministries ||= Ministry.all
    end

    def persist_records!(families, people)
      families.each(&method(:save_record!))
      people.each(&method(:save_record!))
    end

    def save_record!(row_record)
      record = row_record.record
      record.save!
    rescue ActiveRecord::ActiveRecordError => e
      raise Error, format('Row #%d: Could not persist %s, %p. %s',
                          row_record.row, record.class.name, record.audit_name,
                          e.message)
    end
  end
end
