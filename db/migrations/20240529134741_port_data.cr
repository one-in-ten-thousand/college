class PortData::V20240529134741 < Avram::Migrator::Migration::V1
  def migrate
    drop_index table_for(ChongWenBao), [:university_remark], if_exists: true

    execute <<-'HEREDOC'
    CREATE INDEX chong_wen_bao_university_remark_pgroonga_index
              ON chong_wen_baos
           USING pgroonga (university_remark);
    HEREDOC
  end

  def rollback
    # drop table_for(Thing)
  end
end
