class RemoveBatchNumberFromUniversity::V20240428072906 < Avram::Migrator::Migration::V1
  def migrate
    alter table_for(University) do
      remove :batch_number
    end
  end

  def rollback
    # drop table_for(Thing)
  end
end
