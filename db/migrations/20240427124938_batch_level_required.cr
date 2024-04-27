class BatchLevelRequired::V20240427124938 < Avram::Migrator::Migration::V1
  def migrate
    make_required table_for(University), :batch_level
  end

  def rollback
    # drop table_for(Thing)
  end
end
