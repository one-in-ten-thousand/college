class Universities::Index < BrowserAction
  param q : String = ""
  param is_985 : Bool = false
  param is_211 : Bool = false
  param is_good : Bool = false
  param order_by : String = ""
  param click_on : String = ""
  param batch_level : String = ""
  param min_value : Int32 = 0
  param max_value : Int32 = 0
  param filter_by_column : String = ""
  param page : Int32 = 1

  get "/universities" do
    query = UniversityQuery.new

    if q.presence
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

    query = query.is_985(true) if is_985

    query = query.is_211(true) if is_211

    query = query.is_good(true) if is_good

    # 检测在哪一个 tab head 上点击, 只要每次点击一次, 就判断有没有 cookie
    # 如果没有, 就默认排序, 如果有, 就反转
    if click_on.presence
      case click_on
      when "score_2023_min"
        if cookies.get?("order_by") == "score_2023_min_asc_order"
          cookies.set("order_by", "score_2023_min_desc_order")
        else
          cookies.set("order_by", "score_2023_min_asc_order")
        end
      when "score_2022_min"
        if cookies.get?("order_by") == "score_2022_min_asc_order"
          cookies.set("order_by", "score_2022_min_desc_order")
        else
          cookies.set("order_by", "score_2022_min_asc_order")
        end
      when "score_2021_min"
        if cookies.get?("order_by") == "score_2021_min_asc_order"
          cookies.set("order_by", "score_2021_min_desc_order")
        else
          cookies.set("order_by", "score_2021_min_asc_order")
        end
      when "score_2020_min"
        if cookies.get?("order_by") == "score_2020_min_asc_order"
          cookies.set("order_by", "score_2020_min_desc_order")
        else
          cookies.set("order_by", "score_2020_min_asc_order")
        end
      when "ranking_2023_min"
        if cookies.get?("order_by") == "ranking_2023_min_desc_order"
          cookies.set("order_by", "ranking_2023_min_asc_order")
        else
          cookies.set("order_by", "ranking_2023_min_desc_order")
        end
      when "ranking_2022_min"
        if cookies.get?("order_by") == "ranking_2022_min_desc_order"
          cookies.set("order_by", "ranking_2022_min_asc_order")
        else
          cookies.set("order_by", "ranking_2022_min_desc_order")
        end
      when "ranking_2021_min"
        if cookies.get?("order_by") == "ranking_2021_min_desc_order"
          cookies.set("order_by", "ranking_2021_min_asc_order")
        else
          cookies.set("order_by", "ranking_2021_min_desc_order")
        end
      when "ranking_2020_min"
        if cookies.get?("order_by") == "ranking_2020_min_desc_order"
          cookies.set("order_by", "ranking_2020_min_asc_order")
        else
          cookies.set("order_by", "ranking_2020_min_desc_order")
        end
      end
    end

    if order_by.presence
      case order_by
      when "score_2023_min"
        if cookies.get?("order_by") == "score_2023_min_asc_order"
          query = query.score_2023_min.asc_order(:nulls_last)
        else
          query = query.score_2023_min.desc_order(:nulls_last)
        end
      when "score_2022_min"
        if cookies.get?("order_by") == "score_2022_min_asc_order"
          query = query.score_2022_min.asc_order(:nulls_last)
        else
          query = query.score_2022_min.desc_order(:nulls_last)
        end
      when "score_2021_min"
        if cookies.get?("order_by") == "score_2021_min_asc_order"
          query = query.score_2021_min.asc_order(:nulls_last)
        else
          query = query.score_2021_min.desc_order(:nulls_last)
        end
      when "score_2020_min"
        if cookies.get?("order_by") == "score_2020_min_asc_order"
          query = query.score_2020_min.asc_order(:nulls_last)
        else
          query = query.score_2020_min.desc_order(:nulls_last)
        end
      when "ranking_2023_min"
        if cookies.get?("order_by") == "ranking_2023_min_desc_order"
          query = query.ranking_2023_min.desc_order(:nulls_last)
        else
          query = query.ranking_2023_min.asc_order(:nulls_last)
        end
      when "ranking_2022_min"
        if cookies.get?("order_by") == "ranking_2022_min_desc_order"
          query = query.ranking_2022_min.desc_order(:nulls_last)
        else
          query = query.ranking_2022_min.asc_order(:nulls_last)
        end
      when "ranking_2021_min"
        if cookies.get?("order_by") == "ranking_2021_min_desc_order"
          query = query.ranking_2021_min.desc_order(:nulls_last)
        else
          query = query.ranking_2021_min.asc_order(:nulls_last)
        end
      when "ranking_2020_min"
        if cookies.get?("order_by") == "ranking_2020_min_desc_order"
          query = query.ranking_2020_min.desc_order(:nulls_last)
        else
          query = query.ranking_2020_min.asc_order(:nulls_last)
        end
      end
    else
      cookies.delete("order_by")
    end

    query = query.batch_level(batch_level) if batch_level.presence

    range_max, range_min = fetch_range_max_min(filter_by_column, query)

    min_value = range_min.to_i if min_value.zero?
    max_value = range_max.to_i if max_value.zero?

    if filter_by_column.presence
      case filter_by_column
      when "ranking_2023"
        query = query.ranking_2023_min.gte(min_value).ranking_2023_min.lte(max_value) if !min_value.nil? && !max_value.nil?
      when "ranking_2022"
        query = query.ranking_2022_min.gte(min_value).ranking_2022_min.lte(max_value) if !min_value.nil? && !max_value.nil?
      when "ranking_2021"
        query = query.ranking_2021_min.gte(min_value).ranking_2021_min.lte(max_value) if !min_value.nil? && !max_value.nil?
      when "ranking_2020"
        query = query.ranking_2020_min.gte(min_value).ranking_2020_min.lte(max_value) if !min_value.nil? && !max_value.nil?
      when "score_2023"
        query = query.score_2023_min.gte(min_value).score_2023_min.lte(max_value) if !min_value.nil? && !max_value.nil?
      when "score_2022"
        query = query.score_2022_min.gte(min_value).score_2022_min.lte(max_value) if !min_value.nil? && !max_value.nil?
      when "score_2021"
        query = query.score_2021_min.gte(min_value).score_2021_min.lte(max_value) if !min_value.nil? && !max_value.nil?
      when "score_2020"
        query = query.score_2020_min.gte(min_value).score_2020_min.lte(max_value) if !min_value.nil? && !max_value.nil?
      end
    end

    pages, universities = paginate(query.id.desc_order, per_page: 50)
    all_name_inputs = [
      "q", "is_985", "is_211", "is_good",
      "order_by", "batch_level", "filter_by_column",
      "range_min_value", "range_max_value",
    ]

    if request.headers["HX-Trigger"]?
      component(
        Main,
        universities: universities,
        pages: pages,
        range_max: range_max.to_i,
        range_min: range_min.to_i,
        all_name_inputs: all_name_inputs,
      )
    else
      html(
        IndexPage,
        universities: universities,
        pages: pages,
        range_max: range_max.to_i,
        range_min: range_min.to_i,
        all_name_inputs: all_name_inputs
      )
    end
  end

  memoize def fetch_range_max_min(column : String, query : UniversityQuery) : Tuple(Float64 | Int32, Float64 | Int32)
    case column
    when "ranking_2023"
      max = query.ranking_2023_min.select_max
      min = query.ranking_2023_min.select_min
    when "ranking_2022"
      max = query.ranking_2022_min.select_max
      min = query.ranking_2022_min.select_min
    when "ranking_2021"
      max = query.ranking_2021_min.select_max
      min = query.ranking_2021_min.select_min
    when "ranking_2020"
      max = query.ranking_2020_min.select_max
      min = query.ranking_2021_min.select_min
    when "score_2023"
      max = query.score_2023_min.select_max
      min = query.score_2023_min.select_min
    when "score_2022"
      max = query.score_2022_min.select_max
      min = query.score_2022_min.select_min
    when "score_2021"
      max = query.score_2021_min.select_max
      min = query.score_2021_min.select_min
    when "score_2020"
      max = query.score_2020_min.select_max
      min = query.score_2020_min.select_min
    end

    {max || 0, min || 0}
  end
end
