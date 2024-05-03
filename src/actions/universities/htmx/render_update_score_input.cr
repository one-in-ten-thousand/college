class Universities::Htmx::RenderUpdateScoreInput < HtmxAction
  get "/universities/render_update_score_input" do
    id = params.get("id")
    column_name = params.get("column_name")
    column_value = params.get("column_value")

    html UpdateScoreInputPage,
      column_name: column_name,
      column_value: column_value,
      id: id
  end
end
