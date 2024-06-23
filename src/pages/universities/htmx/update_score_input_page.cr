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
        "hx-include": "input[name='_csrf']",
        "hx-target": "closest td",
        "hx-swap": "outherHTML",
        style: "min-width: 25px; max-height: 30px;"
      )
    end
  end
end
