class Universities::IndexPage < MainLayout
  needs universities : UniversityQuery
  needs pages : Lucky::Paginator
  quick_def page_title, "All Universities"

  def content
    h1 "所有大学"
    link "新增", New

    div class: "row" do
      render_search
      render_select_batch_level
    end

    div id: "main" do
      render_select_985
      mount PaginationLinks, pages unless pages.one_page?
      render_universities
      mount PaginationLinks, pages unless pages.one_page?
    end
  end

  def render_search
    input(
      type: "search",
      value: "#{context.request.query_params["q"]?}",
      name: "q",
      class: "s12 m8 input-field",
      placeholder: "输入大学名称模糊搜索",
      "hx-get": "/universities",
      "hx-target": "#main",
      "hx-select": "#main",
      "hx-trigger": "search, keyup delay:400ms changed",
      "hx-push-url": "true",
      "hx-include": "[name='is_985'],[name='is_211'],[name='is_good']",
      "hx-vals": "{\"batch_level\": \"#{context.request.query_params["batch_level"]?}\"}"
    )
  end

  def render_select_batch_level
    a class: "dropdown-trigger btn m2 input-field", href: "#", "data-target": "dropdown1" do
      if (bl = context.request.query_params["batch_level"]?.presence)
        text "当前录取批次 #{University::BatchLevel.from_value?(bl.to_i).not_nil!.display_name}"
      else
        text "选择录取批次"
      end
    end

    ul(
      id: "dropdown1",
      class: "dropdown-content",
      "hx-target": "#main",
      "hx-select": "#main",
      "hx-push-url": "true",
      "hx-include": "[name='is_985'],[name='is_211'],[name='is_good'],[name='q']",
    ) do
      University::BatchLevel.each do |bl|
        if bl.value == 3
          li class: "divider", tableindex: "-1"
        end
        li do
          a href: "#!", "hx-get": Index.path, "hx-vals": "{\"batch_level\": \"#{bl.value}\"}" do
            text bl.display_name
          end
        end
      end
    end
  end

  def render_select_985
    div class: "row" do
      full_path = context.request.resource
      mount CheckBox, "is_985", "仅显示985", full_path
      mount CheckBox, "is_211", "仅显示211", full_path
      mount CheckBox, "is_good", "显示包含双一流专业高校", full_path
    end
  end

  def render_universities
    table class: "highlight" do
      thead do
        tr do
          th "ID编号"
          th "报考编码"
          th "大学名称(点击名称编辑)"
          th "录取批次"
          th "补充信息"
          mount OrderByTH, "score_2023_min", "2023最低分"
          mount OrderByTH, "ranking_2023_min", "2023最低位次"
          mount OrderByTH, "score_2022_min", "2022最低分"
          mount OrderByTH, "ranking_2022_min", "2022最低位次"
          mount OrderByTH, "score_2021_min", "2021最低分"
          mount OrderByTH, "ranking_2021_min", "2021最低位次"
          mount OrderByTH, "score_2020_min", "2020最低分"
          mount OrderByTH, "ranking_2020_min", "2020最低位次"
          th "修改时间"
        end
      end

      tbody do
        universities.each do |university|
          tr do
            td university.id
            td university.code.to_s
            td do
              link university.name, Edit.with(university)
            end
            td university.batch_level.display_name
            td do
              text university.description.to_s
            end
            mount(
              ClickEditTD,
              id: university.id.to_s,
              column_value: university.score_2023_min.to_s,
              column_name: "score_2023_min",
              action: "/htmx/v1/universities/render_update_score_input"
            )
            mount(
              ClickEditTD,
              id: university.id.to_s,
              column_value: university.ranking_2023_min.to_s,
              column_name: "ranking_2023_min",
              action: "/htmx/v1/universities/render_update_score_input"
            )
            mount(
              ClickEditTD,
              id: university.id.to_s,
              column_value: university.score_2022_min.to_s,
              column_name: "score_2022_min",
              action: "/htmx/v1/universities/render_update_score_input"
            )
            mount(
              ClickEditTD,
              id: university.id.to_s,
              column_value: university.ranking_2022_min.to_s,
              column_name: "ranking_2022_min",
              action: "/htmx/v1/universities/render_update_score_input"
            )
            mount(
              ClickEditTD,
              id: university.id.to_s,
              column_value: university.score_2021_min.to_s,
              column_name: "score_2021_min",
              action: "/htmx/v1/universities/render_update_score_input"
            )
            mount(
              ClickEditTD,
              id: university.id.to_s,
              column_value: university.ranking_2021_min.to_s,
              column_name: "ranking_2021_min",
              action: "/htmx/v1/universities/render_update_score_input"
            )
            mount(
              ClickEditTD,
              id: university.id.to_s,
              column_value: university.score_2020_min.to_s,
              column_name: "score_2020_min",
              action: "/htmx/v1/universities/render_update_score_input"
            )
            mount(
              ClickEditTD,
              id: university.id.to_s,
              column_value: university.ranking_2020_min.to_s,
              column_name: "ranking_2020_min",
              action: "/htmx/v1/universities/render_update_score_input"
            )
            td university.updated_at.to_s("%m月%d日 %H:%M:%S")
          end
        end
        input(type: "hidden", value: context.session.get("X-CSRF-TOKEN"), name: "_csrf")
      end
    end
  end
end
