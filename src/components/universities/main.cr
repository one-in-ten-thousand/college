class Universities::Main < BaseComponent
  include PageHelpers

  needs all_name_inputs : Array(String)
  needs range_min : Int32?
  needs range_max : Int32?
  needs pages : Lucky::Paginator
  needs universities : UniversityQuery

  def render
    div id: "main" do
      div class: "row" do
        div class: "col m2 valign-wrapper" do
          render_score_ranking_dropdown
        end

        if context.request.query_params["filter_by_column"]?.presence
          render_range_input
        end
      end

      div class: "row" do
        render_select_985
        div class: "col m2" do
          render_batch_level_dropdown
        end
      end
      mount PaginationLinks, pages unless pages.one_page?
      render_universities
      mount PaginationLinks, pages unless pages.one_page?
    end
  end

  private def render_score_ranking_dropdown
    list = {
      "ranking_2023" => "2023 位次",
      "ranking_2022" => "2022 位次",
      "ranking_2021" => "2021 位次",
      "ranking_2020" => "2020 位次",
      "score_2023"   => "2023 分数",
      "score_2022"   => "2022 分数",
      "score_2021"   => "2021 分数",
      "score_2020"   => "2020 分数",
    }

    input type: "hidden", name: "filter_by_column", value: context.request.query_params["filter_by_column"]?.to_s
    a class: "dropdown-trigger btn input-field", href: "#", "data-target": "dropdown2" do
      if (cl = context.request.query_params["filter_by_column"]?.presence)
        text "按照 #{list[cl]} 过滤"
      else
        text "选择过滤条件"
      end
      text ""
    end

    ul(
      id: "dropdown2",
      class: "dropdown-content",
      "hx-target": "#main",
      "hx-push-url": "true",
      "hx-include": all_name_inputs.reject { |x| x.in? ["filter_by_column", "min_value", "max_value"] }.join(",") { |e| "[name='#{e}']" }
    ) do
      li do
        a href: "#!", "hx-get": Index.path, "hx-vals": "{\"filter_by_column\": \"\"}", id: "filter_by_column", "hx-indicator": "#spinner" do
          text "取消过滤"
        end
      end
      list.each do |k, v|
        li do
          a href: "#!", "hx-get": Index.path, "hx-vals": "{\"filter_by_column\": \"#{k}\"}", id: "filter_by_column", "hx-indicator": "#spinner" do
            text v
          end
        end
      end
    end
  end

  private def render_range_input
    div class: "col m8", style: "margin-right: 25px" do
      para class: "range-field" do
        span "#{context.request.query_params["min_value"]?}", id: "min_value"
        input(type: "range", min: range_min.to_s, max: range_max.to_s, id: "range_min", name: "min_value", value: context.request.query_params["min_value"]?.to_s)
      end

      para class: "range-field" do
        span "#{context.request.query_params["max_value"]?}", id: "max_value"
        input(type: "range", min: range_min.to_s, max: range_max.to_s, id: "range_max", name: "max_value", value: context.request.query_params["max_value"]?.to_s)
      end
    end

    div class: "col m1 valign-wrapper" do
      submit(
        "提交过滤",
        id: "submit_filter_by_column",
        "hx-get": "/universities",
        "hx-target": "#main",
        "hx-push-url": "true",
        "hx-include": all_name_inputs.join(",") { |e| "[name='#{e}']" },
        "hx-indicator": "#spinner"
      )
    end
  end

  private def render_select_985
    full_path = context.request.resource
    mount CheckBox, "is_985", "仅显示985", full_path, all_name_inputs
    mount CheckBox, "is_211", "仅显示211", full_path, all_name_inputs
    mount CheckBox, "is_good", "显示包含双一流专业高校", full_path, all_name_inputs
  end

  private def render_batch_level_dropdown
    input type: "hidden", name: "batch_level", value: context.request.query_params["batch_level"]?.to_s
    a class: "dropdown-trigger btn input-field", href: "#", "data-target": "dropdown1" do
      if (bl = context.request.query_params["batch_level"]?.presence)
        text "选择的录取批次 #{University::BatchLevel.from_value?(bl.to_i).not_nil!.display_name}"
      else
        text "选择录取批次"
      end
    end

    ul(
      id: "dropdown1",
      class: "dropdown-content",
      "hx-target": "#main",
      "hx-push-url": "true",
      "hx-include": all_name_inputs.reject { |x| x == "batch_level" }.join(",") { |e| "[name='#{e}']" }
    ) do
      li do
        a href: "#!", "hx-get": Index.path, "hx-vals": "{\"batch_level\": \"\"}", id: "batch_level", "hx-indicator": "#spinner" do
          text "取消选择"
        end
      end
      University::BatchLevel.each do |bl|
        if bl.value == 3
          li class: "divider", tableindex: "-1"
        end
        li do
          a href: "#!", "hx-get": Index.path, "hx-vals": "{\"batch_level\": \"#{bl.value}\"}", id: "batch_level", "hx-indicator": "#spinner" do
            text bl.display_name
          end
        end
      end
    end
  end

  private def render_universities
    input type: "hidden", name: "order_by", value: context.request.query_params["order_by"]?.to_s
    table class: "highlight" do
      thead do
        tr do
          th "ID编号"
          th "报考编码"
          th "大学名称(点击名称编辑)"
          th "录取批次"
          th "补充信息"
          order_by_score_description_2023 = "点击排序(低分优先)"
          order_by_score_description_2022 = "点击排序(低分优先)"
          order_by_score_description_2021 = "点击排序(低分优先)"
          order_by_score_description_2020 = "点击排序(低分优先)"
          order_by_ranking_description_2023 = "点击排序(低位次优先)"
          order_by_ranking_description_2022 = "点击排序(低位次优先)"
          order_by_ranking_description_2021 = "点击排序(低位次优先)"
          order_by_ranking_description_2020 = "点击排序(低位次优先)"

          case context.cookies.get?("order_by")
          when "score_2023_min_asc_order"
            order_by_score_description_2023 = "点击排序(高分优先)"
          when "score_2022_min_asc_order"
            order_by_score_description_2022 = "点击排序(高分优先)"
          when "score_2021_min_asc_order"
            order_by_score_description_2021 = "点击排序(高分优先)"
          when "score_2020_min_asc_order"
            order_by_score_description_2020 = "点击排序(高分优先)"
          when "ranking_2023_min_desc_order"
            order_by_ranking_description_2023 = "点击排序(高位次优先)"
          when "ranking_2022_min_desc_order"
            order_by_ranking_description_2022 = "点击排序(高位次优先)"
          when "ranking_2021_min_desc_order"
            order_by_ranking_description_2021 = "点击排序(高位次优先)"
          when "ranking_2020_min_desc_order"
            order_by_ranking_description_2020 = "点击排序(高位次优先)"
          end
          mount OrderByTH, "score_2023_min", order_by_score_description_2023, "2023最低分", all_name_inputs
          mount OrderByTH, "ranking_2023_min", order_by_ranking_description_2023, "2023最低位次", all_name_inputs
          mount OrderByTH, "score_2022_min", order_by_score_description_2022, "2022最低分", all_name_inputs
          mount OrderByTH, "ranking_2022_min", order_by_ranking_description_2022, "2022最低位次", all_name_inputs
          mount OrderByTH, "score_2021_min", order_by_score_description_2021, "2021最低分", all_name_inputs
          mount OrderByTH, "ranking_2021_min", order_by_ranking_description_2021, "2021最低位次", all_name_inputs
          mount OrderByTH, "score_2020_min", order_by_score_description_2020, "2020最低分", all_name_inputs
          mount OrderByTH, "ranking_2020_min", order_by_ranking_description_2020, "2020最低位次", all_name_inputs
        end
      end

      tbody do
        universities.each do |university|
          tr do
            td university.id
            td university.code.to_s
            td do
              link university.name, Edit.with(university), "hx-boost": "false"
            end
            td university.batch_level.display_name
            td style: "max-width: 100px;" do
              text university.description.to_s
            end
            mount(
              ClickEditTD,
              id: university.id.to_s,
              column_value: university.score_2023_min.to_s,
              column_name: "score_2023_min",
              action: "/htmx/v1/universities/render_update_score_input",
              tooltip: ""
            )
            mount(
              ClickEditTD,
              id: university.id.to_s,
              column_value: university.ranking_2023_min.to_s,
              column_name: "ranking_2023_min",
              action: "/htmx/v1/universities/render_update_score_input",
              tooltip: show_ranking_number(university.ranking_2023_min)
            )
            mount(
              ClickEditTD,
              id: university.id.to_s,
              column_value: university.score_2022_min.to_s,
              column_name: "score_2022_min",
              action: "/htmx/v1/universities/render_update_score_input",
              tooltip: ""
            )
            mount(
              ClickEditTD,
              id: university.id.to_s,
              column_value: university.ranking_2022_min.to_s,
              column_name: "ranking_2022_min",
              action: "/htmx/v1/universities/render_update_score_input",
              tooltip: show_ranking_number(university.ranking_2022_min)
            )
            mount(
              ClickEditTD,
              id: university.id.to_s,
              column_value: university.score_2021_min.to_s,
              column_name: "score_2021_min",
              action: "/htmx/v1/universities/render_update_score_input",
              tooltip: ""
            )
            mount(
              ClickEditTD,
              id: university.id.to_s,
              column_value: university.ranking_2021_min.to_s,
              column_name: "ranking_2021_min",
              action: "/htmx/v1/universities/render_update_score_input",
              tooltip: show_ranking_number(university.ranking_2021_min)
            )
            mount(
              ClickEditTD,
              id: university.id.to_s,
              column_value: university.score_2020_min.to_s,
              column_name: "score_2020_min",
              action: "/htmx/v1/universities/render_update_score_input",
              tooltip: ""
            )
            mount(
              ClickEditTD,
              id: university.id.to_s,
              column_value: university.ranking_2020_min.to_s,
              column_name: "ranking_2020_min",
              action: "/htmx/v1/universities/render_update_score_input",
              tooltip: show_ranking_number(university.ranking_2020_min)
            )
          end
        end
        input(type: "hidden", value: context.session.get("X-CSRF-TOKEN"), name: "_csrf")
      end
    end
  end
end
