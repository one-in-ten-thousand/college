class Universities::OrderByTH < BaseComponent
  needs column_name : String
  needs description : String

  def render
    th(
      "hx-get": "/universities",
      "hx-target": "#main",
      "hx-select": "#main",
      "hx-push-url": "true",
      "hx-vals": "{\"order_by\": \"#{column_name}\"}",
      "hx-include": "[name='is_985'],[name='is_211'],[name='is_good'], [name='q']"
    ) do
      text description
    end
  end
end
