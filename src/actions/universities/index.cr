class Universities::Index < BrowserAction
  get "/universities" do
    q = params.get?(:q)

    builder = Avram::QueryBuilder.new(table: :universities)
    builder = builder.where(Avram::Where::Raw.new("name &@~ ?", q)) if q
    query = UniversityQuery.new
    query.query = builder
    pages, universities = paginate(query.id.desc_order, per_page: 50)

    html IndexPage, universities: universities, pages: pages
  end
end
