class Universities::Index < BrowserAction
  get "/universities" do
    html IndexPage, universities: UniversityQuery.new
  end
end
