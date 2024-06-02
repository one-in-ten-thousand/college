class Universities::Index < BrowserAction
  param q : String = ""
  param is_985 : Bool = false
  param is_211 : Bool = false
  param is_good : Bool = false
  param is_exists_remark : Bool = false
  param chong_2023 : Bool = false
  param chong_2022 : Bool = false
  param chong_2021 : Bool = false
  param chong_2020 : Bool = false

  param wen_2023 : Bool = false
  param wen_2022 : Bool = false
  param wen_2021 : Bool = false
  param wen_2020 : Bool = false

  param bao_2023 : Bool = false
  param bao_2022 : Bool = false
  param bao_2021 : Bool = false
  param bao_2020 : Bool = false

  param order_by : String = ""
  param click_on : String = ""
  param batch_level : String = ""
  param range_min_value : Int32 = 0
  param range_max_value : Int32 = 0
  param filter_by_column : String = ""
  param page : Int32 = 1

  get "/universities" do
    user_chong_wen_bao_query = ChongWenBaoQuery.new.user_id(current_user.id)
    query = UniversityQuery.new.preload_chong_wen_baos(user_chong_wen_bao_query).preload_city

    if q.presence
      if q.matches? /\b\d{4}\b/
        query = query.code(q)
      else
        query = query.where("(name &@~ ?", q)
          .or(&.where_chong_wen_baos(
            ChongWenBaoQuery.new.where("chong_wen_baos.university_remark &@~ ?)", q),
            auto_inner_join: false
          ).left_join_chong_wen_baos).distinct
      end
    end

    query = query.is_985(true) if is_985

    query = query.is_211(true) if is_211

    query = query.is_good(true) if is_good

    query = query.batch_level(batch_level) if batch_level.presence

    query = query.where_chong_wen_baos(user_chong_wen_bao_query.university_remark.is_not_nil) if is_exists_remark

    if chong_2023 || chong_2022 || chong_2021 || chong_2020 ||
       wen_2023 || wen_2022 || wen_2021 || wen_2020 ||
       bao_2023 || bao_2022 || bao_2021 || bao_2020
      cwb_query = user_chong_wen_bao_query

      cwb_query = cwb_query.chong_2023(true) if chong_2023
      cwb_query = cwb_query.chong_2022(true) if chong_2022
      cwb_query = cwb_query.chong_2021(true) if chong_2021
      cwb_query = cwb_query.chong_2020(true) if chong_2020

      cwb_query = cwb_query.bao_2023(true) if bao_2023
      cwb_query = cwb_query.bao_2022(true) if bao_2022
      cwb_query = cwb_query.bao_2021(true) if bao_2021
      cwb_query = cwb_query.bao_2020(true) if bao_2020

      cwb_query = cwb_query.wen_2023(true) if wen_2023
      cwb_query = cwb_query.wen_2022(true) if wen_2022
      cwb_query = cwb_query.wen_2021(true) if wen_2021
      cwb_query = cwb_query.wen_2020(true) if wen_2020

      query = query.where_chong_wen_baos(cwb_query)
    end

    range_max, range_min, query = filter_by_column_action(query)

    query = order_by_action(query)

    pages, universities = paginate(query.id.desc_order, per_page: 50)

    all_name_inputs = [
      "q", "is_985", "is_211", "is_good",
      "order_by", "batch_level", "filter_by_column",
      "range_min_value", "range_max_value",
      "chong_2023", "chong_2022", "chong_2021", "chong_2020",
      "wen_2023", "wen_2022", "wen_2021", "wen_2020",
      "bao_2023", "bao_2022", "bao_2021", "bao_2020",
      "is_exists_remark",
    ]

    if request.headers["HX-Trigger"]?
      component(
        Main,
        universities: universities,
        pages: pages,
        range_max: range_max.to_i,
        range_min: range_min.to_i,
        all_name_inputs: all_name_inputs,
        current_user: current_user
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

  def filter_by_column_action(query)
    range_max, range_min = fetch_range_max_min(filter_by_column, query)

    min_value = range_min_value.zero? ? range_min.to_i : range_min_value
    max_value = range_max_value.zero? ? range_max.to_i : range_max_value

    if filter_by_column.presence
      params.from_query["range_min_value"] = min_value.to_s
      params.from_query["range_max_value"] = max_value.to_s
      params.from_query["order_by"] = "#{filter_by_column}_min" if click_on.blank?

      case filter_by_column
      when "ranking_2023"
        cookies.set("order_by", "ranking_2023_min_desc_order") if click_on.blank?
        query = query.ranking_2023_min.gte(min_value).ranking_2023_min.lte(max_value) if !min_value.nil? && !max_value.nil?
      when "ranking_2022"
        cookies.set("order_by", "ranking_2022_min_desc_order") if click_on.blank?
        query = query.ranking_2022_min.gte(min_value).ranking_2022_min.lte(max_value) if !min_value.nil? && !max_value.nil?
      when "ranking_2021"
        cookies.set("order_by", "ranking_2021_min_desc_order") if click_on.blank?
        query = query.ranking_2021_min.gte(min_value).ranking_2021_min.lte(max_value) if !min_value.nil? && !max_value.nil?
      when "ranking_2020"
        cookies.set("order_by", "ranking_2020_min_desc_order") if click_on.blank?
        query = query.ranking_2020_min.gte(min_value).ranking_2020_min.lte(max_value) if !min_value.nil? && !max_value.nil?
      when "score_2023"
        cookies.set("order_by", "score_2023_min_asc_order") if click_on.blank?
        query = query.score_2023_min.gte(min_value).score_2023_min.lte(max_value) if !min_value.nil? && !max_value.nil?
      when "score_2022"
        cookies.set("order_by", "score_2022_min_asc_order") if click_on.blank?
        query = query.score_2022_min.gte(min_value).score_2022_min.lte(max_value) if !min_value.nil? && !max_value.nil?
      when "score_2021"
        cookies.set("order_by", "score_2021_min_asc_order") if click_on.blank?
        query = query.score_2021_min.gte(min_value).score_2021_min.lte(max_value) if !min_value.nil? && !max_value.nil?
      when "score_2020"
        cookies.set("order_by", "score_2020_min_asc_order") if click_on.blank?
        query = query.score_2020_min.gte(min_value).score_2020_min.lte(max_value) if !min_value.nil? && !max_value.nil?
      end
    end

    {range_max, range_min, query}
  end

  def order_by_action(query)
    # 检测在哪一个 tab head 上点击, 只要每次点击一次, 就判断有没有 cookie
    # 如果没有, 就默认排序, 如果有, 就反转
    if click_on.presence
      params.from_query["click_on"] = ""

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

    query
  end
end
