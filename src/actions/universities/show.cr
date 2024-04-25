class Universities::Show < BrowserAction
  get "/universities/:university_id" do
    html ShowPage, university: UniversityQuery.find(university_id)
  end
end
