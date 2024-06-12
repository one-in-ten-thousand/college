class AddMoreIsMarkedToChongWenBao::V20240612153720 < Avram::Migrator::Migration::V1
  def migrate
    alter table_for(ChongWenBao) do
      add is_marked_2023 : Bool, default: false
      add is_marked_2022 : Bool, default: false
      add is_marked_2021 : Bool, default: false
      add is_marked_2020 : Bool, default: false
    end

    create_index table_for(ChongWenBao), [:is_marked_2023, :is_marked_2022, :is_marked_2021, :is_marked_2020]
  end

  def rollback
    alter table_for(ChongWenBao) do
      remove :is_marked_2023
      remove :is_marked_2022
      remove :is_marked_2021
      remove :is_marked_2020
    end
  end
end
