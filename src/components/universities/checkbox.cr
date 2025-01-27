class Universities::CheckBox < BaseComponent
  needs name : String
  needs description : String
  needs all_name_inputs : Array(String)
  needs disabled : Bool = false

  def render
    div class: "switch" do
      label for: name do
        span description, class: "valign-wrapper" if description.presence
        args = {
          type:           "checkbox",
          name:           name,
          value:          "true",
          id:             name,
          "hx-get":       Index.path,
          "hx-target":    "#main",
          "hx-push-url":  "true",
          "hx-include":   all_name_inputs.reject { |x| x == name }.join(",") { |e| "[name='#{e}']" },
          "hx-indicator": "#spinner"
        }

        if disabled?
          input(**args.merge(disabled: ""))
        else
          if context.request.query_params[name]?
            input(**args.merge(checked: "checked"))
          else
            input(**args)
          end
        end

        span class: "lever"
      end
    end
  end
end
