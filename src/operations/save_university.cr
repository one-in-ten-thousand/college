class SaveUniversity < University::SaveOperation
  upsert_lookup_columns [code, batch_level]

  permit_columns name, description, code,
    is_211, is_985, is_good,
    score_2023_min, ranking_2023_min,
    batch_level

  attribute province_code : Int32
  attribute province_name : String
  attribute city_code : Int32
  attribute city_name : String

  before_save do
    validate_required province_code
    validate_required province_name

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

  before_save code_and_batch_level_must_uniq

  def code_and_batch_level_must_uniq
    code.value.try do |code_value|
      batch_level.value.try do |batch_level_value|
        if UniversityQuery.new.code(code_value).batch_level(batch_level_value).select_count > 1
          code.add_error("编码和批次的组合, 必须唯一")
        end
      end
    end
  end
end