/* eslint no-console:0 */

// Rails Unobtrusive JavaScript (UJS) is *required* for links in Lucky that use DELETE, POST and PUT.
// Though it says "Rails" it actually works with any framework.
import Rails from "@rails/ujs";
Rails.start();
import M from '@materializecss/materialize';

document.addEventListener('DOMContentLoaded', function() {
    var callback = function (_, trigger) {
        modal1 = document.getElementById('modal1')
        modal1.querySelector("a.waves-red").onclick = function () {
            var xhttp = new XMLHttpRequest();
            xhttp.open("POST", trigger.dataset.url, false);
            xhttp.send();
            location.reload();
            return false;
        }
        modal1.querySelector(".modal-content p").innerText = trigger.dataset.content
    };

    var elems = document.querySelectorAll('.modal');
    M.Modal.init(elems, {"onOpenStart": callback});
});
