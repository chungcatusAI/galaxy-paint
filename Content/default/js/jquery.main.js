// page init
var user_agent = navigator.userAgent;

var is_ie = user_agent.indexOf('MSIE') > -1;
var is_ie7 = user_agent.indexOf('MSIE 7') > -1;
var is_ie8 = user_agent.indexOf('MSIE 8') > -1;
var is_ie9 = user_agent.indexOf('MSIE 9') > -1;

// Add window on-load event
if (typeof window.addLoadEvent == "undefined") {

	window.addLoadEvent = function(fn) {
		if (window.addEventListener) {
			window.addEventListener("load", fn, false);
		}
		else if (window.attachEvent) {
			window.attachEvent("onload", fn);
		}
		else {
			var fo = window.onload;
			if (typeof fo !== "function") {
				window.onload = fn;
			}
			else {
				window.onload = function() { fo(); fn(); }
			}
		}
	}
}

jQuery(function () {
    if ($.fn.superfish) {
        $('div.tabs .sf-menu').supersubs({
            minWidth: 12,
            maxWidth: 27,
            extraWidth: 1
        }).superfish({
            speed: 300
        });
    }

});

$.fn.showPopup = function(opt) {
	var defaults = {
		width: 400,
		opacity: 0.6,
		overlayColor: "#11619d",
		padding: 0,
		closeButton: false
	};
	opt = $.extend(defaults, opt);

	var el = $(this);
	$(document).ready(function() {
		$.fancybox(el, {
			padding: opt.padding,
			closeBtn: opt.closeButton,
			width: opt.width,
			minWidth: opt.width,
			maxWidth: opt.width,
			helpers: {
				overlay: {
					opacity: opt.opacity,
					css: { "background-color": opt.overlayColor }
				}
			},
			beforeClose: function() { if (!opt.closeButton) return false; }
		});
	});
};

$.fn.showAlert = function (opt) {
	var opt = $.extend({
		width: 400,
		height: 'auto',
		resizable: false
	}, opt);

	var i = $(this);

	i.dialog({
		width: opt.width,
		height: opt.height,
		resizable: opt.resizable
	});
};