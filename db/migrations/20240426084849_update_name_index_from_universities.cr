class UpdateNameIndexFromUniversities::V20240426084849 < Avram::Migrator::Migration::V1
  def migrate
    drop_index table_for(University), [:name]
    drop_index table_for(University), [:batch_number]
    create_index table_for(University), [:name, :batch_number], unique: true
  end

  def rollback
    # drop table_for(Thing)
  end
end
