class Universities::CheckBoxFor < BaseComponent
  needs attribute : Avram::PermittedAttribute(Bool)
  needs id : String
  needs description : String
  needs record : University?

  def render
    label for: id, class: "s12 input-field" do
      args = {
        field:           attribute,
        unchecked_value: "false",
        checked_value:   "true",
        id:              id,
      }

      if (u = record).nil?
        checkbox(**args)
      else
        checkbox(**args.merge(
          "hx-put": Update.with(u.id).path,
          "hx-swap": "none"
        ))
      end

      span description
    end
    mount Shared::FieldErrors, attribute
  end
end
