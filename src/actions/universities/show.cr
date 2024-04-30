class Universities::Show < BrowserAction
  get "/universities/:university_id" do
    html ShowPage, university: UniversityQuery.new
      .preload_province
      .preload_city
      .find(university_id)
  end
end
