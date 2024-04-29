class Universities::Edit < BrowserAction
  get "/universities/:university_id/edit" do
    university = UniversityQuery.new
      .preload_province
      .preload_city
      .find(university_id)

    op = CreateUniversity.new(
      university,
      province_name: university.province.name,
      province_code: university.province.code,
      city_name: university.city.name,
      city_code: university.city.code
    )

    html EditPage, operation: op, university: university
  end
end
