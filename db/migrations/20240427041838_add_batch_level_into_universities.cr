class AddBatchLevelIntoUniversities::V20240427041838 < Avram::Migrator::Migration::V1
  def migrate
    alter table_for(University) do
      add batch_level : Int32?, index: true
    end
  end

  def rollback
    alter table_for(University) do
      remove :batch_level
    end
    # drop table_for(Thing)
  end
end
