class Universities::OrderByTH < BaseComponent
  needs column_name : String
  needs order_description : String
  needs text : String
  needs all_name_inputs : Array(String)

  def render
    th(
      class: "tooltipped",
      id: "order_by_column",
      "data-position": "top",
      "data-tooltip": "#{order_description}",
      "hx-get": "/universities",
      "hx-target": "#main",
      "hx-push-url": "true",
      "hx-vals": "{\"order_by\": \"#{column_name}\", \"click_on\": \"#{column_name}\"}",
      "hx-include": all_name_inputs.reject { |e| e == "order_by" }.join(",") { |e| "[name='#{e}']" },
      "hx-indicator": "#spinner"
    ) do
      text text
    end
  end
end
