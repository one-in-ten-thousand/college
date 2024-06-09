class AddZhaoshengJianzhangIntoCollege::V20240609092515 < Avram::Migrator::Migration::V1
  def migrate
    alter table_for(University) do
      add zhaosheng_zhangcheng_url : String?
      add linian_fenshu_url : String?
    end
  end

  def rollback
    alter table_for(University) do
      remove :zhaosheng_zhangcheng_url
      remove :linian_fenshu_url
    end
  end
end
