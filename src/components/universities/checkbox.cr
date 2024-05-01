class Universities::CheckBox < BaseComponent
  needs name : String
  needs description : String
  needs full_path : String

  def render
    label for: name, class: "m4 input-field" do
      input(
        type: "checkbox",
        name: name,
        value: "true",
        id: name,
        "hx-get": Index.path,
        "hx-target": "#main",
        "hx-select": "#main",
        "hx-push-url": "true",
        "hx-include": "[name='q']"
      )
      span description
    end
  end
end
