class SaveUniversity < University::SaveOperation
  upsert_lookup_columns code, batch_level

  permit_columns name, code,
                 is_211, is_985, is_good, batch_level,
                 score_2023_min, ranking_2023_min,
                 score_2022_min, ranking_2022_min,
                 score_2021_min, ranking_2021_min,
                 score_2020_min, ranking_2020_min

  attribute province_code : Int32
  attribute province_name : String
  attribute city_code : Int32
  attribute city_name : String

  attribute chong_2023 : Bool
  attribute chong_2022 : Bool
  attribute chong_2021 : Bool
  attribute chong_2020 : Bool

  attribute wen_2023 : Bool
  attribute wen_2022 : Bool
  attribute wen_2021 : Bool
  attribute wen_2020 : Bool

  attribute bao_2023 : Bool
  attribute bao_2022 : Bool
  attribute bao_2021 : Bool
  attribute bao_2020 : Bool

  attribute university_remark : String

  attribute current_user_id : Int64

  before_save do
    # 这两行造成单独 update 某一个字段失败.
    # validate_required province_code
    # validate_required province_name

    province_name.value.try do |province_name_value|
      province_code.value.try do |proinvce_code_value|
        province = SaveProvince.upsert!(
          name: province_name.value.to_s,
          code: province_code.value.as(Int32)
        )

        city = SaveCity.upsert!(
          name: city_name.value.to_s,
          code: city_code.value.as(Int32),
          province_id: province.id
        )

        province_id.value = province.id
        city_id.value = city.id
      end
    end
  end

  after_save code_and_batch_level_must_uniq
  after_save update_chong_wen_bao_options

  private def code_and_batch_level_must_uniq(saved_record : University)
    code.value.try do |code_value|
      batch_level.value.try do |batch_level_value|
        if UniversityQuery.new.code(code_value).batch_level(batch_level_value).select_count > 1
          self.code.add_error("编码和批次的组合, 必须唯一")
          database.rollback
        end
      end
    end
  end

  private def update_chong_wen_bao_options(saved_record : University)
    user_id = current_user_id.value.not_nil!
    SaveChongWenBao.upsert!(
      university_id: saved_record.id,
      user_id: user_id,
      university_remark: university_remark.value,
      chong_2023: chong_2023.value.not_nil!,
      chong_2022: chong_2022.value.not_nil!,
      chong_2021: chong_2021.value.not_nil!,
      chong_2020: chong_2020.value.not_nil!,
      wen_2023: wen_2023.value.not_nil!,
      wen_2022: wen_2022.value.not_nil!,
      wen_2021: wen_2021.value.not_nil!,
      wen_2020: wen_2020.value.not_nil!,
      bao_2023: bao_2023.value.not_nil!,
      bao_2022: bao_2022.value.not_nil!,
      bao_2021: bao_2021.value.not_nil!,
      bao_2020: bao_2020.value.not_nil!,
    )
  end
end
