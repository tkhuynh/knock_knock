// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, vendor/assets/javascripts,
// or any plugin's vendor/assets/javascripts directory can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// compiled file.
//
// Read Sprockets README (https://github.com/rails/sprockets#sprockets-directives) for details
// about supported directives.
//
//= require jquery
//= require jquery_ujs
//= require bootstrap-sprockets
//= require moment
//= require bootstrap-datetimepicker
//= require_tree .

$(function() {
	$('#datetimepicker_start').datetimepicker({
    format: 'YYYY-MM-DD HH:mm a',
    sideBySide: true,
    // disabledTimeIntervals: [[moment({ h: 0 }), moment({ h: 8 })], [moment({ h: 21 }), moment({ h: 24 })]],
    // disabledHours: [0, 1, 2, 3, 4, 5, 6, 7, 22, 23, 24],
		// enabledHours: [8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20, 21]
	});
	$('#datetimepicker_end').datetimepicker({
    format: 'YYYY-MM-DD HH:mm a',
	    sideBySide: true,
	    // disabledTimeIntervals: [[moment({ h: 0 }), moment({ h: 8 })], [moment({ h: 21 }), moment({ h: 24 })]],
	    // disabledHours: [0, 1, 2, 3, 4, 5, 6, 7, 22, 23, 24],
		// enabledHours: [8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20, 21]
	});
	$(".week > ul > li:first").addClass("active");
	$(".week > .tab-content > div:first").addClass("in active");
});
