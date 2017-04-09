module Import
  # == Context Input
  #
  # [+context.import_people+ [+Array<Import::Person>+]]
  class CreateNewPeopleRecords
    include Interactor

    def call
      context.import_people.each(&method(:create_person))
    end

    private

    def create_person(import_person)
    end
  end
end
