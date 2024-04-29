class Universities::Index < BrowserAction
  get "/universities" do
    pages, universities = paginate(UniversityQuery.new.id.desc_order, per_page: 50)
    html IndexPage, universities: universities, pages: pages
  end
end
