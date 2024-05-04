class Universities::Htmx::UpdateScoreInputPage < NoLayout
  needs id : String
  needs column_name : String
  needs column_value : String

  def content
    td do
      input(
        type: "text",
        value: "#{column_value}",
        name: "university:#{column_name}",
        id: "update_score_input",
        "hx-put": Universities::Update.with(id).path,
        "hx-include": "next input[type='hidden']",
        "hx-target": "closest td",
        "hx-swap": "outherHTML",
        # "hx-trigger": "mouseout",
        style: "max-width: 60px; max-height: 30px;"
      )
    end
  end
end
