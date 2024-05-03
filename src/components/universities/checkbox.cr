class Universities::CheckBox < BaseComponent
  needs name : String
  needs description : String
  needs full_path : String

  def render
    div class: "switch m4 " do
      label for: name do
        text description
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
        span class: "lever"
      end
    end
  end
end
