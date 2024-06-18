class AddMarkedIntoChongWenBao::V20240612114411 < Avram::Migrator::Migration::V1
  def migrate
    alter table_for(ChongWenBao) do
      add is_marked : Bool, default: false, index: true
    end
  end

  def rollback
    alter table_for(ChongWenBao) do
      remove :is_marked
    end
  end
end
