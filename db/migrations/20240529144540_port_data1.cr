class PortData1::V20240529144540 < Avram::Migrator::Migration::V1
  def migrate
    user = UserQuery.new.email("zw963@163.com").first

    UniversityQuery.new.description.is_not_nil
      .preload_chong_wen_baos
      .each do |university|
        SaveChongWenBao.upsert!(
          university_id: university.id,
          user_id: user.id,
          university_remark: university.description
        )
      end
  end

  def rollback
    # drop table_for(Thing)
  end
end
