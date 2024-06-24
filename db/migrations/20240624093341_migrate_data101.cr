class MigrateData101::V20240624093341 < Avram::Migrator::Migration::V1
  def migrate
    xuan = UserQuery.new.email("zw963@163.com").first
    fu = UserQuery.new.email("3535378298@qq.com").first

    # Avram::QueryLog.dexter.configure(:info)

    ChongWenBaoQuery.new.user_id(xuan.id).each do |cwb|
      SaveChongWenBao.upsert!(user_id: fu.id, university_id: cwb.university_id, university_remark: cwb.university_remark)
    end
  end

  # UniversityQuery.new.score_2023_min.gte(score - offset).score_2023_min.lte(score + offset).each do |university|
  #     # p! university.name
  #     SaveChongWenBao.upsert!(user_id: current_user.id, university_id: university.id, is_marked_2023: true)
  #   end
  # end

  def rollback
    # drop table_for(Thing)
  end
end
