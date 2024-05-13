class Universities::AddressSelector < BaseComponent
  needs operation : SaveUniversity

  def render
    div class: "s12 m8 input-field", attrs: [:data_select_address] do
      hidden_input(operation.province_code, attrs: [:required], id: "province-code", value: operation.province_code.value.to_s)
      hidden_input(operation.province_name, attrs: [:required], id: "province-name", value: operation.province_name.value.to_s)
      hidden_input(operation.city_code, attrs: [:required], id: "city-code", value: operation.city_code.value.to_s)
      hidden_input(operation.city_name, attrs: [:required], id: "city-name", value: operation.city_name.value.to_s)

      span(
        id: "show_address",
        "data-province-code": operation.province_code.value.to_s,
        "data-city-code": operation.city_code.value.to_s
      ) do
        text "点击选择省、市：    #{operation.province_name.value} #{operation.city_name.value}"
      end

      mount Shared::FieldErrors, operation.province_name
      mount Shared::FieldErrors, operation.city_name
    end
  end
end
