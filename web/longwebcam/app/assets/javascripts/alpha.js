function showDescription() {
	$('#alpha_info').hide();
	$('#projectDescription').show("fade", {direction: "up"}, 500);
	setTimeout(function() {
		$('body').css('overflow', 'auto');
	}, 510);
	return false;
}

function hideDescription() {
	$('html, body').animate({ scrollTop: 0 }, 'fast');
	$('body').css('overflow', 'hidden');
	$('#alpha_info').show("fade", {direction: "up"}, 500);
	$('#projectDescription').hide();
	return false;
}
