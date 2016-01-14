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
    format: 'YYYY-MM-DD HH:mm a'
	});
	$('#datetimepicker_end').datetimepicker({
    format: 'YYYY-MM-DD HH:mm a'
	});
	$(".week > ul > li:first-child").addClass("active");
	$(".week > .tab-content > div:first-child").addClass("in active");
	$(".week").on("click", ".next", function() {
		$current_week = $(this).parent();
		if ($current_week.is($(".week").last()) !== true) {
			$current_week.hide();
			$current_week.next().show();
		} else {
			$(this).hide();
		}
	});
	$(".week").on("click", ".prev", function() {
		$current_week = $(this).parent();
		if ($current_week.is($(".week").first()) !== true) {
			$current_week.hide();
			$current_week.prev().show();
		} else {
			$(this).hide();
		}
	});
});
