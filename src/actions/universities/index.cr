class Universities::Index < BrowserAction
  get "/universities" do
    q = params.get?(:q)
    is_985 = params.get?(:is_985)
    is_211 = params.get?(:is_211)
    is_good = params.get?(:is_good)

    query = UniversityQuery.new

    if q.presence
      if q.not_nil!.matches? /\d+/
        query = query.code(q.not_nil!)
      else
        query = query.where("(name &@~ ?", q).or(&.where("description &@~ ?)", q))

        if is_985.presence
          query = query.is_985(true)
        end

        if is_211.presence
          query = query.is_211(true)
        end

        if is_good.presence
          query = query.is_good(true)
        end
      end
    end

    pages, universities = paginate(query.id.desc_order, per_page: 50)

    html IndexPage, universities: universities, pages: pages
  end
end
