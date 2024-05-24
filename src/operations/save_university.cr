class SaveUniversity < University::SaveOperation
  upsert_lookup_columns [code, batch_level]

  permit_columns name, description, code,
    is_211, is_985, is_good,
    score_2023_min, ranking_2023_min,
    score_2022_min, ranking_2022_min,
    score_2021_min, ranking_2021_min,
    score_2020_min, ranking_2020_min,
    batch_level, chong_2023, wen_2023, bao_2023,
    chong_2022, wen_2022, bao_2022,
    chong_2021, wen_2021, bao_2021,
    chong_2020, wen_2020, bao_2020

  attribute province_code : Int32
  attribute province_name : String
  attribute city_code : Int32
  attribute city_name : String

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

  def code_and_batch_level_must_uniq(saved_record : University)
    code.value.try do |code_value|
      batch_level.value.try do |batch_level_value|
        if UniversityQuery.new.code(code_value).batch_level(batch_level_value).select_count > 1
          self.code.add_error("编码和批次的组合, 必须唯一")
          database.rollback
        end
      end
    end
  end
end
