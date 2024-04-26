/* eslint no-console:0 */

// Rails Unobtrusive JavaScript (UJS) is *required* for links in Lucky that use DELETE, POST and PUT.
// Though it says "Rails" it actually works with any framework.
import Rails from "@rails/ujs";
Rails.start();
import M from '@materializecss/materialize';
import { iosProvinces, iosCitys } from './areaData_v2.js';
import IosSelect from "iosselect";
import 'htmx.org';
window.htmx = require('htmx.org');

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
//
