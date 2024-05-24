class Universities::CheckBox < BaseComponent
  needs name : String
  needs description : String
  needs all_name_inputs : Array(String)

  def render
    label for: name do
      span description, class: "valign-wrapper"
      args = {
        type:           "checkbox",
        name:           name,
        value:          "true",
        id:             name,
        "hx-get":       Index.path,
        "hx-target":    "#main",
        "hx-push-url":  "true",
        "hx-include":   all_name_inputs.reject { |x| x == name }.join(",") { |e| "[name='#{e}']" },
        "hx-indicator": "#spinner",
      }

      if context.request.query_params[name]?
        input(**args.merge(checked: "checked"))
      else
        input(**args)
      end

      span class: "lever"
    end
  end
end
