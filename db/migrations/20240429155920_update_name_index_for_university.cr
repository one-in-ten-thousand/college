class UpdateNameIndexForUniversity::V20240429155920 < Avram::Migrator::Migration::V1
  def migrate
    drop_index table_for(University), :name, if_exists: true

    execute <<-'HEREDOC'
CREATE INDEX university_name_pgroonga_index
          ON universities
       USING pgroonga (name);
HEREDOC
  end

  def rollback
    # drop table_for(Thing)
  end
end
