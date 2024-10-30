
function debug() {
	
	var text = "";
	
	for (var i = 0; i < argument_count; i ++) {
		text += string(argument[i]) + ",";
	}

	show_debug_message(string_copy(text, 1, string_length(text)-1));
	
}
