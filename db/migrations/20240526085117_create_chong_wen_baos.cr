class CreateChongWenBaos::V20240526085117 < Avram::Migrator::Migration::V1
  def migrate
    create table_for(ChongWenBao) do
      primary_key id : Int64
      add_timestamps
      add chong_2023 : Bool, default: false, index: true
      add chong_2022 : Bool, default: false, index: true
      add chong_2021 : Bool, default: false, index: true
      add chong_2020 : Bool, default: false, index: true

      add bao_2023 : Bool, default: false, index: true
      add bao_2022 : Bool, default: false, index: true
      add bao_2021 : Bool, default: false, index: true
      add bao_2020 : Bool, default: false, index: true

      add wen_2023 : Bool, default: false, index: true
      add wen_2022 : Bool, default: false, index: true
      add wen_2021 : Bool, default: false, index: true
      add wen_2020 : Bool, default: false, index: true

      add user_university_remark : String?, index: true

      add_belongs_to user : User, on_delete: :cascade
      add_belongs_to university : University, on_delete: :cascade
    end
  end

  def rollback
    drop table_for(ChongWenBao)
  end
end
