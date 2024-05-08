class Universities::OrderByTH < BaseComponent
  needs column_name : String
  needs description : String
  needs all_name_inputs : Array(String)

  def render
    th(
      class: "tooltipped",
      "data-position": "top",
      "data-tooltip": "点击按照 #{description} 排序",
      "hx-get": "/universities",
      "hx-target": "#main",
      "hx-select": "#main",
      "hx-push-url": "true",
      "hx-vals": "{\"order_by\": \"#{column_name}\"}",
      "hx-include": all_name_inputs.reject { |e| e == "order_by" }.join(",") { |e| "[name='#{e}']" }
    ) do
      text description
    end
  end
end
