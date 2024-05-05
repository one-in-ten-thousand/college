class Universities::Index < BrowserAction
  # param q : String? = nil
  # param is_985 : Bool? = nil
  # param is_211 : Bool? = nil
  # param is_good : Bool? = nil
  # param batch_level : University::BatchLevel? = nil

  get "/universities" do
    q = params.get?(:q).presence
    is_985 = params.get?(:is_985).presence
    is_211 = params.get?(:is_211).presence
    is_good = params.get?(:is_good).presence
    order_by = params.get?(:order_by).presence
    batch_level = params.get?(:batch_level).presence

    query = UniversityQuery.new

    unless q.nil?
      if q.matches? /\d+/
        query = query.code(q)
      else
        # 这里如果是正常的参数 = 比较, 可以使用 where 的 block 像是来生成圆括号.
        # 例如:
        # query = Foo::BaseQuery.new.where do |q|
        #   q.name("foo1").or(&.description("bar1"))
        # end
        query = query.where("(name &@~ ?", q).or(&.where("description &@~ ?)", q))
      end
    end

    unless is_985.nil?
      query = query.is_985(true)
    end

    unless is_211.nil?
      query = query.is_211(true)
    end

    unless is_good.nil?
      query = query.is_good(true)
    end

    unless order_by.nil?
      case order_by
      when "score_2023_min"
        query = query.score_2023_min.asc_order(:nulls_last)
      when "score_2022_min"
        query = query.score_2022_min.asc_order(:nulls_last)
      when "score_2021_min"
        query = query.score_2021_min.asc_order(:nulls_last)
      when "score_2020_min"
        query = query.score_2020_min.asc_order(:nulls_last)
      end
    end

    unless batch_level.nil?
      query = query.batch_level(batch_level)
    end

    pages, universities = paginate(query.id.desc_order, per_page: 50)

    html IndexPage, universities: universities, pages: pages
  end
end
