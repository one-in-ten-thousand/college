class AddBatchNumberIntoUniversities::V20240426072954 < Avram::Migrator::Migration::V1
  def migrate
    alter table_for(University) do
      add batch_number : String?, index: true
    end
  end

  def rollback
    alter table_for(University) do
      remove :batch_number
    end
  end
end
