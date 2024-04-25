class Universities::AddressSelector < BaseComponent
  needs operation : SaveUniversity

  def render
    div class: "form-item item-line", id: "select_address" do
      label "点击选择省、市"
      div class: "pc-box" do
        hidden_input(operation.province_name, attrs: [:required], id: "province", class: "form-item item-line", value: operation.province_name.value.to_s)
        hidden_input(operation.city_name, attrs: [:required], id: "city", class: "form-item item-line", value: operation.city_name.value.to_s)

        span(id: "show_address") do
          text "#{operation.province_name.value} #{operation.city_name.value}"
        end
      end
    end

    raw <<-'HEREDOC'
<script>
var selectAddress = document.getElementById('select_address');
    var showAddress = document.getElementById('show_address');
    var province = document.getElementById('province');
    var city = document.getElementById('city');

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
                    province.setAttribute('value', selectOneObj.value);
                    city.setAttribute('value', selectTwoObj.value);

                    showAddress.setAttribute('data-province-code', selectOneObj.id);
                    showAddress.setAttribute('data-city-code', selectTwoObj.id);
                    showAddress.innerHTML = selectOneObj.value + ' ' + selectTwoObj.value;
                }
            });
    });
</script>
HEREDOC
  end
end
