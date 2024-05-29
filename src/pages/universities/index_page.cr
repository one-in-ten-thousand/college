class Universities::IndexPage < MainLayout
  include PageHelpers

  needs universities : UniversityQuery
  needs pages : Lucky::Paginator
  needs range_max : Int32
  needs range_min : Int32
  needs all_name_inputs : Array(String)
  quick_def page_title, "学校列表"

  def content
    h3 do
      link "所有学校", Index
    end

    div class: "row" do
      div class: "col m1 valign-wrapper" do
        link "新增学校", New, "hx-boost": "false"
      end

      div class: "col m3" do
        render_search
      end
      div class: "col m1" do
        img id: "spinner", class: "htmx-indicator", src: asset("images/spinning-circles.svg"), style: "max-width: 30px;"
      end
    end

    mount(
      Main,
      universities: universities,
      pages: pages,
      range_max: range_max,
      range_min: range_min,
      all_name_inputs: all_name_inputs,
      current_user: current_user
    )
  end

  def render_search
    input(
      type: "search",
      value: context.request.query_params["q"]?.to_s,
      name: "q",
      id: "search",
      class: "s12 m8 input-field",
      placeholder: "输入学校名称、备注的部分信息或完整编码搜索",
      "hx-get": "/universities",
      "hx-target": "#main",
      "hx-trigger": "search, keyup delay:400ms changed",
      "hx-push-url": "true",
      "hx-include": all_name_inputs.reject { |x| x == "q" }.join(",") { |e| "[name='#{e}']" },
      "hx-indicator": "#spinner",
    )
  end
end
