class Universities::IndexPage < MainLayout
  include PageHelpers

  needs universities : UniversityQuery
  needs pages : Lucky::Paginator
  needs range_max : Int32?
  needs range_min : Int32?
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
    end

    # render main
    mount(
      Main,
      all_name_inputs: all_name_inputs,
      range_min: range_min,
      range_max: range_max,
      pages: pages,
      universities: universities
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
      "hx-select": "#main",
      "hx-trigger": "search, keyup delay:400ms changed",
      "hx-push-url": "true",
      "hx-include": all_name_inputs.reject { |x| x == "q" }.join(",") { |e| "[name='#{e}']" }
    )
  end
end
