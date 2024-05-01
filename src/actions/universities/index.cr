class Universities::Index < BrowserAction
  get "/universities" do
    q = params.get?(:q)
    is_985 = params.get?(:is_985)
    is_211 = params.get?(:is_211)
    is_good = params.get?(:is_good)

    builder = Avram::QueryBuilder.new(table: :universities)
    unless q.blank?
      builder = builder.where(Avram::Where::Raw.new("(universities.name &@~ ?", q))
      builder = builder.or do |or|
        or.where(Avram::Where::Raw.new("universities.description &@~ ?)", q))
      end
    end

    results = UniversityQuery.new
    results.query = builder

    unless is_985.blank?
      results = results.is_985(true)
    end

    unless is_211.blank?
      results = results.is_211(true)
    end

    unless is_good.blank?
      results = results.is_good(true)
    end

    pages, universities = paginate(results.id.desc_order, per_page: 50)

    html IndexPage, universities: universities, pages: pages
  end
end
