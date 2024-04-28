class Universities::Index < BrowserAction
  get "/universities" do
    pages, universities = paginate(UniversityQuery.new.id.asc_order)
    html IndexPage, universities: universities, pages: pages
  end
end
