class PortData::V20240529134741 < Avram::Migrator::Migration::V1
  def migrate
    drop_index table_for(ChongWenBao), [:university_remark], if_exists: true

    execute <<-'HEREDOC'
    CREATE INDEX chong_wen_bao_university_remark_pgroonga_index
              ON chong_wen_baos
           USING pgroonga (university_remark);
    HEREDOC

    # user = UserQuery.new.email("zw963@163.com").first

    # UniversityQuery.new.description.is_not_nil
    #   .preload_chong_wen_baos
    #   .each do |university|
    #     SaveChongWenBao.upsert!(
    #       university_id: university.id,
    #       user_id: user.id,
    #       university_remark: university.description
    #     )
    #   end
  end

  def rollback
    # drop table_for(Thing)
  end
end
