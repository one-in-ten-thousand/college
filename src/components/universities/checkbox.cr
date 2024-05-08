class Universities::CheckBox < BaseComponent
  needs name : String
  needs description : String
  needs full_path : String
  needs all_name_inputs : Array(String)

  def render
    div class: "switch col m3" do
      label for: name do
        span description, class: "valign-wrapper"
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
            "hx-include": all_name_inputs.reject { |x| x == name }.join(",") { |e| "[name='#{e}']" },
            checked: "checked",
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
            "hx-include": all_name_inputs.reject { |x| x == name }.join(",") { |e| "[name='#{e}']" }
          )
        end

        span class: "lever"
      end
    end
  end
end
