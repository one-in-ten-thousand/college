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
    filter_by_column = params.get?(:filter_by_column).presence
    min_value = params.get?(:min_value).presence
    max_value = params.get?(:max_value).presence

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
        if cookies.get?("order_by") == "score_2023_min_asc_order"
          query = query.score_2023_min.desc_order(:nulls_last)
          cookies.set("order_by", "score_2023_min_desc_order")
        else
          query = query.score_2023_min.asc_order(:nulls_last)
          cookies.set("order_by", "score_2023_min_asc_order")
        end
      when "score_2022_min"
        if cookies.get?("order_by") == "score_2022_min_asc_order"
          query = query.score_2022_min.desc_order(:nulls_last)
          cookies.set("order_by", "score_2022_min_desc_order")
        else
          query = query.score_2022_min.asc_order(:nulls_last)
          cookies.set("order_by", "score_2022_min_asc_order")
        end
      when "score_2021_min"
        if cookies.get?("order_by") == "score_2021_min_asc_order"
          query = query.score_2021_min.desc_order(:nulls_last)
          cookies.set("order_by", "score_2021_min_desc_order")
        else
          query = query.score_2021_min.asc_order(:nulls_last)
          cookies.set("order_by", "score_2021_min_asc_order")
        end
      when "score_2020_min"
        if cookies.get?("order_by") == "score_2020_min_asc_order"
          query = query.score_2020_min.desc_order(:nulls_last)
          cookies.set("order_by", "score_2020_min_desc_order")
        else
          query = query.score_2020_min.asc_order(:nulls_last)
          cookies.set("order_by", "score_2020_min_asc_order")
        end
      when "ranking_2023_min"
        if cookies.get?("order_by") == "ranking_2023_min_desc_order"
          query = query.ranking_2023_min.asc_order(:nulls_last)
          cookies.set("order_by", "ranking_2023_min_asc_order")
        else
          query = query.ranking_2023_min.desc_order(:nulls_last)
          cookies.set("order_by", "ranking_2023_min_desc_order")
        end
      when "ranking_2022_min"
        if cookies.get?("order_by") == "ranking_2022_min_desc_order"
          query = query.ranking_2022_min.asc_order(:nulls_last)
          cookies.set("order_by", "ranking_2022_min_asc_order")
        else
          query = query.ranking_2022_min.desc_order(:nulls_last)
          cookies.set("order_by", "ranking_2022_min_desc_order")
        end
      when "ranking_2021_min"
        if cookies.get?("order_by") == "ranking_2021_min_desc_order"
          query = query.ranking_2021_min.asc_order(:nulls_last)
          cookies.set("order_by", "ranking_2021_min_asc_order")
        else
          query = query.ranking_2021_min.desc_order(:nulls_last)
          cookies.set("order_by", "ranking_2021_min_desc_order")
        end
      when "ranking_2020_min"
        if cookies.get?("order_by") == "ranking_2020_min_desc_order"
          query = query.ranking_2020_min.asc_order(:nulls_last)
          cookies.set("order_by", "ranking_2020_min_asc_order")
        else
          query = query.ranking_2020_min.desc_order(:nulls_last)
          cookies.set("order_by", "ranking_2020_min_desc_order")
        end
      end
    end

    unless filter_by_column.nil?
      case filter_by_column
      when "ranking_2023"
        range_max = 42458
        range_min = 5000
        query = query.ranking_2023_min.gte(min_value).ranking_2023_min.lte(max_value) if !min_value.nil? && !max_value.nil?
      when "ranking_2022"
        range_max = 40000
        range_min = 5000
        query = query.ranking_2022_min.gte(min_value).ranking_2022_min.lte(max_value) if !min_value.nil? && !max_value.nil?
      when "ranking_2021"
        range_max = 40000
        range_min = 5000
        query = query.ranking_2021_min.gte(min_value).ranking_2021_min.lte(max_value) if !min_value.nil? && !max_value.nil?
      when "ranking_2020"
        range_max = 40000
        range_min = 5000
        query = query.ranking_2020_min.gte(min_value).ranking_2020_min.lte(max_value) if !min_value.nil? && !max_value.nil?
      when "score_2023"
        range_max = 650
        range_min = 400
        query = query.score_2023_min.gte(min_value).score_2023_min.lte(max_value) if !min_value.nil? && !max_value.nil?
      when "score_2022"
        range_max = 650
        range_min = 400
        query = query.score_2022_min.gte(min_value).score_2022_min.lte(max_value) if !min_value.nil? && !max_value.nil?
      when "score_2021"
        range_max = 650
        range_min = 400
        query = query.score_2021_min.gte(min_value).score_2021_min.lte(max_value) if !min_value.nil? && !max_value.nil?
      when "score_2020"
        range_max = 650
        range_min = 400
        query = query.score_2020_min.gte(min_value).score_2020_min.lte(max_value) if !min_value.nil? && !max_value.nil?
      else
        range_max = 0
        range_min = 0
      end
    end

    unless batch_level.nil?
      query = query.batch_level(batch_level)
    end

    pages, universities = paginate(query.id.desc_order, per_page: 50)

    html(
      IndexPage,
      universities: universities,
      pages: pages,
      range_max: range_max,
      range_min: range_min,
      all_name_inputs: [
        "q", "is_985", "is_211", "is_good",
        "order_by", "batch_level", "filter_by_column",
        "min_value", "max_value",
      ]
    )
  end
end
