class Universities::AddressSelector < BaseComponent
  needs operation : SaveUniversity

  def render
    div id: "select_address" do
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

    raw <<-'HEREDOC'
<script>
var selectAddress = document.getElementById('select_address');
var showAddress = document.getElementById('show_address');
var provinceCode = document.getElementById('province-code');
var provinceName = document.getElementById('province-name');
var cityCode = document.getElementById('city-code');
var cityName = document.getElementById('city-name');

selectAddress.addEventListener('click', function () {
    var oneLevelId = showAddress.getAttribute('data-province-code');
    var twoLevelId = showAddress.getAttribute('data-city-code');

    var iosSelect = new IosSelect(2,
        [iosProvinces, iosCitys],
        {
            title: '地址选择',
            itemHeight: 35,
            relation: [1, 1],
            oneLevelId: oneLevelId,
            twoLevelId: twoLevelId,
            callback: function (selectOneObj, selectTwoObj) {
                provinceCode.value = selectOneObj.id
                provinceName.value = selectOneObj.value

                cityCode.value = selectTwoObj.id
                cityName.value = selectTwoObj.value

                showAddress.setAttribute('data-province-code', selectOneObj.id);
                showAddress.setAttribute('data-city-code', selectTwoObj.id);
                showAddress.innerHTML = '点击选择省、市：    ' + selectOneObj.value + ' ' + selectTwoObj.value;
            }
        });
});
</script>
HEREDOC
  end
end
