class AddSelectionColumnsIntoUniversities::V20240524090721 < Avram::Migrator::Migration::V1
  def migrate
    alter table_for(University) do
      add chong_2023 : Bool, default: false
      add chong_2022 : Bool, default: false
      add chong_2021 : Bool, default: false
      add chong_2020 : Bool, default: false

      add bao_2023 : Bool, default: false
      add bao_2022 : Bool, default: false
      add bao_2021 : Bool, default: false
      add bao_2020 : Bool, default: false

      add wen_2023 : Bool, default: false
      add wen_2022 : Bool, default: false
      add wen_2021 : Bool, default: false
      add wen_2020 : Bool, default: false
    end

    create_index table_for(University), [:chong_2023, :chong_2022, :chong_2021, :chong_2020]
    create_index table_for(University), [:bao_2023, :bao_2022, :bao_2021, :bao_2020]
    create_index table_for(University), [:wen_2023, :wen_2022, :wen_2021, :wen_2020]
  end

  def rollback
    # drop table_for(Thing)
  end
end
