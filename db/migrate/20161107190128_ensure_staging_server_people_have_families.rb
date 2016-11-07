class EnsureStagingServerPeopleHaveFamilies < ActiveRecord::Migration
  def change
    reversible do
      up do
        Person.where(family_id: nil).update_all(family_id: 1)
      end
    end
  end
end
