class Universities::Htmx::UpdatedScoreInputPage < NoLayout
  needs column_name : String
  needs column_value : String
  needs action : String
  needs id : String

  def content
    mount(
      MouseenterTD,
      id: id,
      column_value: column_value,
      column_name: column_name,
      action: action
    )
  end
end
