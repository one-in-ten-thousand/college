class Universities::Index < BrowserAction
  param q : String = ""
  param is_985 : Bool = false
  param is_211 : Bool = false
  param is_good : Bool = false
  param is_exists_remark : Bool = false
  param is_marked : Bool = false
  param is_excluded : Bool = false
  param is_marked_2023 : Bool = false
  param is_marked_2022 : Bool = false
  param is_marked_2021 : Bool = false
  param is_marked_2020 : Bool = false

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

  param cwb_union_set : Bool = false

  param order_by : String = ""
  param click_on : String = ""
  param batch_level : String = ""
  param range_min_value : Int32 = 0
  param range_max_value : Int32 = 0
  param filter_by_column : String = ""
  param page : Int32 = 1

  param search_all : Bool = false

  get "/universities" do
    cwb_query = ChongWenBaoQuery.new
    # 这里的 preload 是 lazy 的, 即, 它并不会立即 preload 所有的记录, 而是在最后 paginate
    # 的时候, 考虑实际的 where 条件, 仅 select 所需的记录.
    query = UniversityQuery.new.preload_chong_wen_baos(cwb_query).preload_city

    if q.presence
      if q.matches? /^\d{4}$/
        query = query.code(q)
      else
        query = query.where("(name &@~ ?", q)
          .or(&.where_chong_wen_baos(
            cwb_query.where("chong_wen_baos.university_remark &@~ ?)", q),
            auto_inner_join: false
          ).left_join_chong_wen_baos)
      end
    end

    query = query.is_985(true) if is_985

    query = query.is_211(true) if is_211

    query = query.is_good(true) if is_good

    query = query.batch_level(batch_level) if batch_level.presence

    cwb_query = cwb_query.university_remark.is_not_nil if is_exists_remark

    unless search_all
      if is_excluded
        cwb_query = cwb_query.is_excluded(true)
      else
        cwb_query = cwb_query.where do |wh|
          # is_excluded.is_nil 代表 left join 右表中, 对应的冲稳保数据不存在
          wh.is_excluded(false).or(&.is_excluded.is_nil)
        end

        cwb_query = handle_marked(cwb_query)
      end
    end

    query = query.join("left join chong_wen_baos on universities.id = chong_wen_baos.university_id AND chong_wen_baos.user_id = ?", current_user.id).where_chong_wen_baos(cwb_query, auto_inner_join: false)

    range_max, range_min, query = filter_by_column_action(query)

    query = order_by_action(query)

    query = query.id.desc_order unless query.query.ordered?

    pages, universities = paginate(query.distinct, per_page: 50)

    all_name_inputs = [
      "q", "is_985", "is_211", "is_good", "is_exists_remark", "is_marked",
      "is_marked_2023", "is_marked_2022", "is_marked_2021", "is_marked_2020",
      "order_by", "batch_level", "filter_by_column", "cwb_union_set",
      "range_min_value", "range_max_value", "search_all",
      "chong_2023", "chong_2022", "chong_2021", "chong_2020",
      "wen_2023", "wen_2022", "wen_2021", "wen_2020",
      "bao_2023", "bao_2022", "bao_2021", "bao_2020",
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

  private def filter_by_column_action(query)
    range_max, range_min = fetch_range_max_min(filter_by_column, query)

    min_value = range_min_value.zero? ? range_min.to_i : range_min_value
    max_value = range_max_value.zero? ? range_max.to_i : range_max_value

    if filter_by_column.presence
      params.from_query["range_min_value"] = min_value.to_s
      params.from_query["range_max_value"] = max_value.to_s
      params.from_query["order_by"] = "#{filter_by_column}_min" if click_on.blank? && order_by.blank?

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

  private def order_by_action(query)
    # 检测在哪一个 tab head 上点击, 只要每次点击一次, 就判断有没有 cookie
    # 如果没有, 就默认排序, 如果有, 就反转

    # !context.request.headers["Referer"] 解决的是当用户点击 back 按钮时, (不期望的)重新排序的问题.
    # 当用户点 back 按钮时, context.request.headers["Referer"] 是 Nil
    if click_on.presence && !context.request.headers["Referer"]?.nil?
      # 确保用户点下一页时, click_on 参数为空.
      params.from_query["click_on"] = ""

      case click_on
      when "id"
        if cookies.get?("order_by") == "id_asc_order"
          cookies.set("order_by", "id_desc_order")
        else
          cookies.set("order_by", "id_asc_order")
        end
      when "code"
        if cookies.get?("order_by") == "code_asc_order"
          cookies.set("order_by", "code_desc_order")
        else
          cookies.set("order_by", "code_asc_order")
        end
      when "updated_at"
        if cookies.get?("order_by") == "updated_at_desc_order"
          cookies.set("order_by", "updated_at_asc_order")
        else
          cookies.set("order_by", "updated_at_desc_order")
        end
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
      # query_params["order_by"] = order_by

      case order_by
      when "id"
        if cookies.get?("order_by") == "id_asc_order"
          query = query.id.asc_order(:nulls_last)
        else
          query = query.id.desc_order(:nulls_last)
        end
      when "code"
        if cookies.get?("order_by") == "code_asc_order"
          query = query.code.asc_order(:nulls_last)
        else
          query = query.code.desc_order(:nulls_last)
        end
      when "updated_at"
        if cookies.get?("order_by") == "updated_at_asc_order"
          query = query.updated_at.asc_order(:nulls_last)
        else
          query = query.updated_at.desc_order(:nulls_last)
        end
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

  private def handle_marked(cwb_query)
    if is_marked_2023 || is_marked_2022 || is_marked_2021 || is_marked_2020 || is_marked ||
       chong_2023 || chong_2022 || chong_2021 || chong_2020 ||
       wen_2023 || wen_2022 || wen_2021 || wen_2020 ||
       bao_2023 || bao_2022 || bao_2021 || bao_2020
      cwb_query = cwb_query.is_marked(true) if is_marked
      cwb_query = cwb_query.is_marked_2023(true) if is_marked_2023
      cwb_query = cwb_query.is_marked_2022(true) if is_marked_2022
      cwb_query = cwb_query.is_marked_2021(true) if is_marked_2021
      cwb_query = cwb_query.is_marked_2020(true) if is_marked_2020

      if cwb_union_set
        cwb_query = cwb_query.where do |q|
          q = q.none
          q = chong_2023 ? q.or(&.chong_2023(true)) : q
          q = chong_2022 ? q.or(&.chong_2022(true)) : q
          q = chong_2021 ? q.or(&.chong_2021(true)) : q
          q = chong_2020 ? q.or(&.chong_2020(true)) : q

          q = wen_2023 ? q.or(&.wen_2023(true)) : q
          q = wen_2022 ? q.or(&.wen_2022(true)) : q
          q = wen_2021 ? q.or(&.wen_2021(true)) : q
          q = wen_2020 ? q.or(&.wen_2020(true)) : q

          q = bao_2023 ? q.or(&.bao_2023(true)) : q
          q = bao_2022 ? q.or(&.bao_2022(true)) : q
          q = bao_2021 ? q.or(&.bao_2021(true)) : q
          q = bao_2020 ? q.or(&.bao_2020(true)) : q

          q
        end
      else
        cwb_query = cwb_query.chong_2023(true) if chong_2023
        cwb_query = cwb_query.chong_2022(true) if chong_2022
        cwb_query = cwb_query.chong_2021(true) if chong_2021
        cwb_query = cwb_query.chong_2020(true) if chong_2020

        cwb_query = cwb_query.wen_2023(true) if wen_2023
        cwb_query = cwb_query.wen_2022(true) if wen_2022
        cwb_query = cwb_query.wen_2021(true) if wen_2021
        cwb_query = cwb_query.wen_2020(true) if wen_2020

        cwb_query = cwb_query.bao_2023(true) if bao_2023
        cwb_query = cwb_query.bao_2022(true) if bao_2022
        cwb_query = cwb_query.bao_2021(true) if bao_2021
        cwb_query = cwb_query.bao_2020(true) if bao_2020
      end
    end

    cwb_query
  end
end
