class Universities::ClickEditTD < BaseComponent
  needs id : String
  needs column_name : String
  needs column_value : String
  needs action : String
  needs tooltip : String
  needs current_user : User

  def render
    args1 = {
      "hx-trigger": "click",
      "hx-swap":    "outerHTML",
      "hx-get":     action,
      "hx-vals":    "{
\"id\":\"#{id}\",
\"column_name\":\"#{column_name}\",
\"column_value\": \"#{column_value}\"
}",
    }
    args2 = {
      "hx-trigger": "click",
    }

    if false
      if tooltip.blank?
        td(**args1) do
          text column_value
        end
      else
        td(**args1.merge(
          class: "tooltipped",
          "data-position": "top",
          "data-tooltip": tooltip,
        )) do
          text column_value
        end
      end
    else
      if tooltip.blank?
        td(**args2) do
          text column_value
        end
      else
        td(**args2.merge(
          class: "tooltipped",
          "data-position": "top",
          "data-tooltip": tooltip,
        )) do
          text column_value
        end
      end
    end
  end
end
