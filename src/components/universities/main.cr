class Universities::Main < BaseComponent
  include PageHelpers

  needs all_name_inputs : Array(String)
  needs range_min : Int32
  needs range_max : Int32
  needs pages : Lucky::Paginator
  needs universities : UniversityQuery
  needs current_user : User

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

      br

      div class: "row" do
        render_985_checkboxs
        div class: "col m2" do
          render_batch_level_dropdown
        end
      end

      br

      render_chong_wen_bao_checkboxs

      br

      render_marked

      br

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
    a class: "dropdown-trigger btn input-field", href: "#", data_target: "dropdown2" do
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
      hx_target: "#main",
      hx_include: all_name_inputs.reject { |x| x.in? ["filter_by_column"] }.join(",") { |e| "[name='#{e}']" }
    ) do
      li do
        a href: "#!", hx_get: Index.path, hx_vals: "{\"filter_by_column\": \"\", \"range_min_value\": \"0\", \"range_max_value\": \"0\"}", id: "filter_by_column", hx_indicator: "#spinner", hx_push_url: "true" do
          text "取消过滤"
        end
      end
      list.each do |k, v|
        li do
          a href: "#!", hx_get: Index.path, hx_vals: "{\"filter_by_column\": \"#{k}\", \"range_min_value\": \"0\", \"range_max_value\": \"0\"}", id: "filter_by_column", hx_indicator: "#spinner" do
            text v
          end
        end
      end
    end
  end

  private def render_range_input
    default_min = context.request.query_params["range_min_value"]?.presence || range_min.to_s
    default_max = context.request.query_params["range_max_value"]?.presence || range_max.to_s

    para class: "range-field col m8", style: "margin-right: 120px; margin-left: 30px;" do
      input type: "hidden", name: "range_min_value", value: default_min
      span default_min, style: "margin-right: 10px;"
      tag(
        "tc-range-slider",
        "slider-width": "800px",
        min: range_min.to_s,
        max: range_max.to_s,
        value1: default_min,
        value2: default_max,
        round: 0,
        # put 的默认目标就是 innerHTML, 因此特别适合 span 这种设置 html
        # set 则更适合设置某个属性的值, 例如: input
        script: "on change put my.value1 into the previous <span/>
then put my.value2 into the next <span/>
then set (previous <input/>).value to my.value1
then set (next <input/>).value to my.value2
") do
      end
      span default_max, style: "margin-left: 10px;"
      input type: "hidden", name: "range_max_value", value: default_max
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

  private def render_chong_wen_bao_checkboxs
    div class: "row" do
      fieldset class: "row", style: "width: 380px;" do
        legend "冲"
        span class: "m3" do
          span "2023"
          mount CheckBox, "chong_2023", "", all_name_inputs, !!(context.request.query_params["wen_2023"]? || context.request.query_params["bao_2023"]?)
        end
        span class: "m3" do
          span "2022"
          mount CheckBox, "chong_2022", "", all_name_inputs, !!(context.request.query_params["wen_2022"]? || context.request.query_params["bao_2022"]?)
        end

        span class: "m3" do
          span "2021"
          mount CheckBox, "chong_2021", "", all_name_inputs, !!(context.request.query_params["wen_2021"]? || context.request.query_params["bao_2021"]?)
        end

        span class: "m3" do
          span "2020"
          mount CheckBox, "chong_2020", "", all_name_inputs, !!(context.request.query_params["wen_2020"]? || context.request.query_params["bao_2020"]?)
        end
      end

      fieldset class: "row", style: "width: 380px; margin-left: 20px;" do
        legend "稳", class: "valign-wrapper"
        span class: "m3" do
          span "2023"
          mount CheckBox, "wen_2023", "", all_name_inputs, !!(context.request.query_params["chong_2023"]? || context.request.query_params["bao_2023"]?)
        end

        span class: "m3" do
          span "2022"
          mount CheckBox, "wen_2022", "", all_name_inputs, !!(context.request.query_params["chong_2022"]? || context.request.query_params["bao_2022"]?)
        end

        span class: "m3" do
          span "2021"
          mount CheckBox, "wen_2021", "", all_name_inputs, !!(context.request.query_params["chong_2021"]? || context.request.query_params["bao_2021"]?)
        end

        span class: "m3" do
          span "2020"
          mount CheckBox, "wen_2020", "", all_name_inputs, !!(context.request.query_params["chong_2020"]? || context.request.query_params["bao_2020"]?)
        end
      end

      fieldset class: "row", style: "width: 380px; margin-left: 20px;" do
        legend "保"
        span class: "m3" do
          span "2023"
          mount CheckBox, "bao_2023", "", all_name_inputs, !!(context.request.query_params["chong_2023"]? || context.request.query_params["wen_2023"]?)
        end

        span class: "m3" do
          span "2022"
          mount CheckBox, "bao_2022", "", all_name_inputs, !!(context.request.query_params["chong_2022"]? || context.request.query_params["wen_2022"]?)
        end

        span class: "m3" do
          span "2021"
          mount CheckBox, "bao_2021", "", all_name_inputs, !!(context.request.query_params["chong_2021"]? || context.request.query_params["wen_2021"]?)
        end

        span class: "m3" do
          span "2020"
          mount CheckBox, "bao_2020", "", all_name_inputs, !!(context.request.query_params["chong_2020"]? || context.request.query_params["wen_2020"]?)
        end
      end
    end
  end

  private def render_marked
    fieldset class: "row", style: "width: 380px; margin-left: 20px;" do
      legend "已标记"
      span class: "m3" do
        span "2023"
        mount CheckBox, "is_marked_2023", "", all_name_inputs
      end

      span class: "m3" do
        span "2022"
        mount CheckBox, "is_marked_2022", "", all_name_inputs
      end

      span class: "m3" do
        span "2021"
        mount CheckBox, "is_marked_2021", "", all_name_inputs
      end

      span class: "m3" do
        span "2020"
        mount CheckBox, "is_marked_2020", "", all_name_inputs
      end
    end
  end

  private def render_985_checkboxs
    div class: "col m2" do
      mount CheckBox, "is_985", "仅显示985", all_name_inputs
    end
    div class: "col m2" do
      mount CheckBox, "is_211", "仅显示211", all_name_inputs
    end
    div class: "col m2" do
      mount CheckBox, "is_good", "仅显示包含双一流专业高校", all_name_inputs
    end
    div class: "col m2" do
      mount CheckBox, "is_exists_remark", "仅显示含备注学校", all_name_inputs
    end
    div class: "col m2" do
      mount CheckBox, "is_marked", "仅显示手动标记的学校", all_name_inputs
    end
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
          th "大学名称"
          th "所在城市"
          th "录取批次"
          th "学校备注"
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
          mount OrderByTH, "ranking_2023_min", order_by_ranking_description_2023, "2023位次区间", all_name_inputs
          mount OrderByTH, "score_2022_min", order_by_score_description_2022, "2022最低分", all_name_inputs
          mount OrderByTH, "ranking_2022_min", order_by_ranking_description_2022, "2022位次区间", all_name_inputs
          mount OrderByTH, "score_2021_min", order_by_score_description_2021, "2021最低分", all_name_inputs
          mount OrderByTH, "ranking_2021_min", order_by_ranking_description_2021, "2021位次区间", all_name_inputs
          mount OrderByTH, "score_2020_min", order_by_score_description_2020, "2020最低分", all_name_inputs
          mount OrderByTH, "ranking_2020_min", order_by_ranking_description_2020, "2020位次区间", all_name_inputs
        end
      end

      tbody do
        universities.each do |university|
          tr do
            if (url1 = university.linian_fenshu_url).nil?
              td university.id
            else
              td do
                a(university.id,
                  href: url1,
                  class: "tooltipped",
                  "data-position": "top",
                  "data-tooltip": "历年分数"
                )
              end
            end

            if (url2 = university.zhaosheng_zhangcheng_url).nil?
              td university.code.to_s
            else
              td do
                a(university.code,
                  href: url2,
                  class: "tooltipped",
                  "data-position": "top",
                  "data-tooltip": "招生章程"
                )
              end
            end

            td do
              mount NameLink, university, current_user
            end
            td university.city.name
            td university.batch_level.display_name
            td style: "max-width: 100px;", class: "double-line" do
              text university.remark(current_user)
            end
            mount(
              ClickEditTD,
              id: university.id.to_s,
              column_value: university.score_2023_min.to_s,
              column_name: "score_2023_min",
              action: "/htmx/v1/universities/render_update_score_input",
              tooltip: "",
              current_user: current_user
            )
            mount(
              ClickEditTD,
              id: university.id.to_s,
              column_value: university.ranking_2023_min.to_s,
              column_name: "ranking_2023_min",
              action: "/htmx/v1/universities/render_update_score_input",
              tooltip: show_ranking_info(university, 2023, university.ranking_2023_min),
              current_user: current_user
            )
            mount(
              ClickEditTD,
              id: university.id.to_s,
              column_value: university.score_2022_min.to_s,
              column_name: "score_2022_min",
              action: "/htmx/v1/universities/render_update_score_input",
              tooltip: "",
              current_user: current_user
            )
            mount(
              ClickEditTD,
              id: university.id.to_s,
              column_value: university.ranking_2022_min.to_s,
              column_name: "ranking_2022_min",
              action: "/htmx/v1/universities/render_update_score_input",
              tooltip: show_ranking_info(university, 2022, university.ranking_2022_min),
              current_user: current_user
            )
            mount(
              ClickEditTD,
              id: university.id.to_s,
              column_value: university.score_2021_min.to_s,
              column_name: "score_2021_min",
              action: "/htmx/v1/universities/render_update_score_input",
              tooltip: "",
              current_user: current_user
            )
            mount(
              ClickEditTD,
              id: university.id.to_s,
              column_value: university.ranking_2021_min.to_s,
              column_name: "ranking_2021_min",
              action: "/htmx/v1/universities/render_update_score_input",
              tooltip: show_ranking_info(university, 2021, university.ranking_2021_min),
              current_user: current_user
            )
            mount(
              ClickEditTD,
              id: university.id.to_s,
              column_value: university.score_2020_min.to_s,
              column_name: "score_2020_min",
              action: "/htmx/v1/universities/render_update_score_input",
              tooltip: "",
              current_user: current_user
            )
            mount(
              ClickEditTD,
              id: university.id.to_s,
              column_value: university.ranking_2020_min.to_s,
              column_name: "ranking_2020_min",
              action: "/htmx/v1/universities/render_update_score_input",
              tooltip: show_ranking_info(university, 2020, university.ranking_2020_min),
              current_user: current_user
            )
          end
        end
        input(type: "hidden", value: context.session.get("X-CSRF-TOKEN"), name: "_csrf")
      end

      ul id: "dropdown3", class: "dropdown-content" do
        li do
          a "点击编辑", href: "data_edit_url", "hx-boost": "false"
        end
        li do
          label do
            input(type: "hidden", name: "university:is_marked_2023", value: "false", id: "marked_2023_unmark")
            input(
              type: "checkbox",
              name: "university:is_marked_2023",
              value: "true",
              id: "marked_2023",
              "hx-put": "data_marked_2023_url",
              "hx-target": "",
              "hx-swap": "outerHTML",
              "hx-indicator": "#spinner",
              "hx-include": "[name='_csrf'],input#marked_2023_unmark"
            )
            span "标记2023"
          end
        end

        li do
          label do
            input(type: "hidden", name: "university:is_marked_2022", value: "false", id: "marked_2022_unmark")
            input(
              type: "checkbox",
              name: "university:is_marked_2022",
              value: "true",
              id: "marked_2022",
              "hx-put": "data_marked_2022_url",
              "hx-target": "",
              "hx-swap": "outerHTML",
              "hx-indicator": "#spinner",
              "hx-include": "[name='_csrf'],input#marked_2022_unmark"
            )
            span "标记2022"
          end
        end

        li do
          label do
            input(type: "hidden", name: "university:is_marked_2021", value: "false", id: "marked_2021_unmark")
            input(
              type: "checkbox",
              name: "university:is_marked_2021",
              value: "true",
              id: "marked_2021",
              "hx-put": "data_marked_2021_url",
              "hx-target": "",
              "hx-swap": "outerHTML",
              "hx-indicator": "#spinner",
              "hx-include": "[name='_csrf'],input#marked_2021_unmark"
            )
            span "标记2021"
          end
        end

        li do
          label do
            input(type: "hidden", name: "university:is_marked_2020", value: "false", id: "marked_2020_unmark")
            input(
              type: "checkbox",
              name: "university:is_marked_2020",
              value: "true",
              id: "marked_2020",
              "hx-put": "data_marked_2020_url",
              "hx-target": "",
              "hx-swap": "outerHTML",
              "hx-indicator": "#spinner",
              "hx-include": "[name='_csrf'],input#marked_2020_unmark"
            )
            span "标记2020"
          end
        end

        li do
          label do
            input(type: "hidden", name: "university:is_marked", value: "false", id: "marked_unmark")
            input(
              type: "checkbox",
              name: "university:is_marked",
              value: "true",
              id: "marked",
              "hx-put": "data_marked_url",
              "hx-target": "",
              "hx-swap": "outerHTML",
              "hx-indicator": "#spinner",
              "hx-include": "[name='_csrf'],input#marked_unmark"
            )
            span "手动标记"
          end
        end
      end
    end
  end
end
