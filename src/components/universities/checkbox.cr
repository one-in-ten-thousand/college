class Universities::CheckBox < BaseComponent
  needs name : String
  needs description : String
  needs full_path : String

  def render
    div class: "switch m3 " do
      label for: name do
        text description
        if context.request.query_params[name]?
          input(
            type: "checkbox",
            name: name,
            value: "true",
            id: name,
            "hx-get": Index.path,
            "hx-target": "#main",
            "hx-select": "#main",
            "hx-push-url": "true",
            "hx-include": "[name='q']",
            checked: "checked"
          )
        else
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
        end

        span class: "lever"
      end
    end
  end
end
