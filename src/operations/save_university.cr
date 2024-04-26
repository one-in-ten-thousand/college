class SaveUniversity < University::SaveOperation
  upsert_lookup_columns name
  permit_columns name, description, code,
    is_211, is_985, is_good,
    batch_number, score_2023_min, ranking_2023_min

  attribute province_code : Int32
  attribute province_name : String
  attribute city_code : Int32
  attribute city_name : String

  before_save do
    validate_required name
    validate_required province_code, province_name
    validate_required city_code, city_name

    validate_uniqueness_of name
    validate_uniqueness_of code

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
