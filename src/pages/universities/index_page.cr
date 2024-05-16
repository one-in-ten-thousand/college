class Universities::IndexPage < MainLayout
  include PageHelpers

  needs universities : UniversityQuery
  needs pages : Lucky::Paginator
  needs range_max : Float64 | Int32 | Nil
  needs range_min : Float64 | Int32 | Nil
  needs all_name_inputs : Array(String)
  quick_def page_title, "All Universities"

  def content
    h3 do
      link "所有大学", Index
    end

    div class: "row" do
      div class: "col m1 valign-wrapper" do
        link "新增", New, "hx-boost": "false"
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
      all_name_inputs: all_name_inputs
    )
  end

  def render_search
    input(
      type: "search",
      value: context.request.query_params["q"]?.to_s,
      name: "q",
      id: "search",
      class: "s12 m8 input-field",
      placeholder: "输入大学名称模糊搜索",
      "hx-get": "/universities",
      "hx-target": "#main",
      "hx-trigger": "search, keyup delay:400ms changed",
      "hx-push-url": "true",
      "hx-include": all_name_inputs.reject { |x| x == "q" }.join(",") { |e| "[name='#{e}']" },
      "hx-indicator": "#spinner",
    )
  end
end
