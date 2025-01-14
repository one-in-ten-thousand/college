/* eslint no-console:0 */

// Rails Unobtrusive JavaScript (UJS) is *required* for links in Lucky that use DELETE, POST and PUT.
// Though it says "Rails" it actually works with any framework.
// import Rails from "@rails/ujs";
// Rails.start();
import { M } from '@materializecss/materialize';
import { iosProvinces, iosCitys } from './areaData_v2.js';
import 'toolcool-range-slider';
import IosSelect from "iosselect";
import htmx from 'htmx.org';
import _hyperscript from 'hyperscript.org';
_hyperscript.browserInit();

function init () {
    document.querySelector("[data-select-address]")?.addEventListener('click', function () {
        var showAddress = document.getElementById('show_address');
        var provinceCode = document.getElementById('province-code');
        var provinceName = document.getElementById('province-name');
        var cityCode = document.getElementById('city-code');
        var cityName = document.getElementById('city-name');
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

    var elems = document.querySelectorAll('select');
    var instances = M.FormSelect.init(elems, {
        // specify options here
    });

    var elems = document.querySelectorAll('.dropdown-trigger');
    var instances = M.Dropdown.init(elems, {
        // specify options here
    });

    var elems = document.querySelectorAll('.tooltipped');
    var instances = M.Tooltip.init(elems, {
        enterDelay: 1000,
        // specify options here
    });

    var elems = document.querySelectorAll('.modal');
    var instances = M.Modal.init(elems, {
        // specify options here
    });

    // htmx.logger = function (elt, event, data) {
    //     if (console) {
    //         console.log(event, elt, data);
    //     }
    // };
}

htmx.onLoad(init);
