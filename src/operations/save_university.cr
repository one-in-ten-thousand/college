class SaveUniversity < University::SaveOperation
  upsert_lookup_columns name
  permit_columns name, description, code,
    is_211, is_985, is_good,
    score_2023_min, ranking_2023_min,
    batch_level

  attribute province_code : Int32
  attribute province_name : String
  attribute city_code : Int32
  attribute city_name : String

  before_save do
    validate_required name

    validate_uniqueness_of name
    validate_uniqueness_of code

    if province_code.value.nil? || province_name.value.nil?
    else
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
