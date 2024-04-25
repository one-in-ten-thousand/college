class SaveUniversity < University::SaveOperation
  upsert_lookup_columns name
  permit_columns name, description, code, is_211, is_985, is_good

  attribute province_name : String
  attribute city_name : String

  before_save do
    validate_required name
    validate_required province_name
    validate_required city_name

    validate_uniqueness_of name
    validate_uniqueness_of code

    province = SaveProvince.upsert!(name: province_name.value.to_s)
    city = SaveCity.upsert!(name: city_name.value.to_s, province_id: province.id)

    province_id.value = province.id
    city_id.value = city.id
  end
end
