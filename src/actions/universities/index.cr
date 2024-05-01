class Universities::Index < BrowserAction
  get "/universities" do
    q = params.get?(:q)

    builder = Avram::QueryBuilder.new(table: :universities)
    unless q.blank?
      builder = builder.where(Avram::Where::Raw.new("name &@~ ?", q))
      builder = builder.or do |or|
        or.where(Avram::Where::Raw.new("description &@~ ?", q))
      end
    end
    results = UniversityQuery.new
    results.query = builder

    pages, universities = paginate(results.id.desc_order, per_page: 50)

    html IndexPage, universities: universities, pages: pages
  end
end
