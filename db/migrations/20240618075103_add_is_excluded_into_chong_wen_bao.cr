class AddIsExcludedIntoChongWenBao::V20240618075103 < Avram::Migrator::Migration::V1
  def migrate
    alter table_for(ChongWenBao) do
      add is_excluded : Bool, default: false, index: true
    end
  end

  def rollback
    alter table_for(ChongWenBao) do
      remove :is_excluded
    end
  end
end
