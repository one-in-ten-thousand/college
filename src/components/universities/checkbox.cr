class Universities::CheckBox < BaseComponent
  needs field : Avram::PermittedAttribute(Bool)
  needs id : String
  needs description : String

  def render
    label for: id do
      checkbox(field, "false", "true", id: id)
      span description
    end
  end
end
