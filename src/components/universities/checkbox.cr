class Universities::CheckBox < BaseComponent
  needs attribute : Avram::PermittedAttribute(Bool)
  needs id : String
  needs description : String

  def render
    label for: id do
      checkbox(attribute, "false", "true", id: id)
      span description
    end
    mount Shared::FieldErrors, attribute
  end
end
