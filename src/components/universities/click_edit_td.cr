class Universities::ClickEditTD < BaseComponent
  needs id : String
  needs column_name : String
  needs column_value : String
  needs action : String
  needs tooltip : String

  def render
    if tooltip.blank?
      td(
        "hx-trigger": "click",
        "hx-swap": "outerHTML",
        "hx-get": action,
        "hx-vals": "{
\"id\":\"#{id}\",
\"column_name\":\"#{column_name}\",
\"column_value\": \"#{column_value}\"
}",
      ) do
        text column_value
      end
    else
      td(
        class: "tooltipped",
        "data-position": "top",
        "data-tooltip": tooltip,
        "hx-trigger": "click",
        "hx-swap": "outerHTML",
        "hx-get": action,
        "hx-vals": "{
\"id\":\"#{id}\",
\"column_name\":\"#{column_name}\",
\"column_value\": \"#{column_value}\"
}",
      ) do
        text column_value
      end
    end
  end
end
