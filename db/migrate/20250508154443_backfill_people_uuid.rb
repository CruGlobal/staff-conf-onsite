class BackfillPeopleUuid < ActiveRecord::Migration[7.1]
  disable_ddl_transaction!  # avoid long locks for large tables

  def up
    say_with_time "Backfilling UUIDs for existing people records..." do
      Person.reset_column_information
      Person.where(uuid: nil).find_in_batches(batch_size: 1000) do |batch|
        batch.each do |person|
          person.update_column(:uuid, SecureRandom.uuid)
        end
      end
    end
  end

  def down
    # Clear the UUIDs (not usually needed)    
  end
end
