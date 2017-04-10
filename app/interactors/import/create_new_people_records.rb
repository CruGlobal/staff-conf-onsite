module Import
  # == Context Input
  #
  # [+context.import_people+ [+Array<Import::Person>+]]
  class CreateNewPeopleRecords
    include Interactor

    Error = Class.new(StandardError)

    before do
      @families = {}
    end

    def call
      context.people =
        context.import_people.each_with_index.map(&method(:create_from_row))

      persist_records!(@families.values, context.people)

    rescue Error => e
      context.fail!(message: e.message)
    end

    private

    def create_from_row(import, index)
      row_number = index + 2
      find_or_create_person(import).tap { |p| set_attributes(p, import) }
    rescue StandardError => e
      raise Error, format('Row #%d: "%s"', row_number, e)
    end

    def find_or_create_person(import)
      family = find_or_create_family(import)

      existing_person = family.people.find do |p|
        p.birthdate == import.birthdate && p.first_name == import.first_name
      end

      if existing_person.present?
        existing_person
      else
        import.record_class.new.tap { |p| p.family = family }
      end
    end

    def find_or_create_family(import)
      tag = import.family_tag
      return @families[tag] if @families.key?(tag)

      primary_person =
        context.import_people.find do |p|
          p.family_tag == tag && p.primary_family_member?
        end
      primary_person ||= import # fallback if primary is missing (unusual)

      @families[primary_person.family_tag] =
        if (family = primary_person.family_record)
          family
        else
          create_family(primary_person)
        end
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
      raise result.message unless result.success?
    end

    def update_person(person, import)
      result = UpdatePersonFromImport.call(person: person, import: import)
      raise result.message unless result.success?
    end

    def persist_records!(families, people)
      Family.transaction do
        families.each(&:save!)
        people.each(&:save!)
      end
    end
  end
end
