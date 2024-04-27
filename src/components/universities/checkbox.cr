class Universities::CheckBox < BaseComponent
  needs attribute : Avram::PermittedAttribute(Bool)
  needs id : String
  needs description : String

  def render
    label for: id, class: "input-field" do
      checkbox(attribute, "false", "true", id: id)
      span description
    end
    mount Shared::FieldErrors, attribute
  end
end
