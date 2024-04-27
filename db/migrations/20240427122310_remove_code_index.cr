class RemoveCodeIndex::V20240427122310 < Avram::Migrator::Migration::V1
  def migrate
    drop_index table_for(University), [:code]
    drop_index table_for(University), [:name, :batch_number]
  end

  def rollback
    # drop table_for(Thing)
  end
end
