
enum HLGuiLegacyOption {
	Checkbox = 32, // True or false
	Text = 10, // Free floating text, doesn't have interactability.
	Picker = 62, // Similar to checkbox, but user forced to pick specific option.
	Dropdown = 70, // Similar to picker but fancier
	Func = 40, // This is for interacting with files.
	Slider = 45 // Self explanatory.
};


function setup_menu(arr) {
	// make sure menu is corrent height for content.
	var yin = 20;
	for (var i = 0; i < array_length(arr[4]); i ++) {
		switch (arr[4][i][1]) {
			case HLGuiLegacyOption.Text: yin += string_height(arr[4][i][0]); break;
			case HLGuiLegacyOption.Dropdown: yin += array_length(arr[4][i][2])*21; break;
		}
		yin += arr[4][i][1];
	}
	
	arr[2] = max(arr[2], yin+20);
	return arr;
}

/// @param {Struct.HLGuiMenu} menu
/// @param {Real} old_mouse_x
/// @param {Real} old_mouse_y
/// @param {String} title
/// @param {Bool} closable
function draw_window(menu, old_mouse_x, old_mouse_y, title, closable) {

	HLGuiDrawUtils.setColour(c_grey);
	
	if mouse_check_button(mb_left) {
		// Check if user is dragging window
		if point_in_rectangle(device_mouse_x_to_gui(0), device_mouse_y_to_gui(0), menu.x, menu.y-20, menu.x+menu.width, menu.y) || pos_array[2] {
			pos_array[2] = true;
			menu.x += device_mouse_x_to_gui(0) - old_mouse_x;
			menu.y += device_mouse_y_to_gui(0) - old_mouse_y;
		}
	} else pos_array[2] = false;
	
	menu.x = clamp(menu.x, 20-menu.width, camera_get_view_width(view_current)-20);
	menu.y = clamp(menu.y, 20, camera_get_view_height(view_current));
	
	draw_roundrect(menu.x, menu.y-20, menu.x+menu.width, menu.y+menu.height, false);
	
	draw_set_alpha(1);
	draw_line(menu.x, menu.y, menu.x+menu.width, menu.y);
	
	HLGuiDrawUtils.resetColour();
	
	draw_text(menu.x+4, menu.y-20, title);
	
	if closable {
		// Window can be closed
		if alt2DrawButton(menu.x+menu.width-18, menu.y-18, 16, 16, "X") pos_array[3] = -1;
	}
	
}

/// @param {Array<Any>} menu
/// @param {Array<Real>} pos_array
/// @param {Real} old_mouse_x
/// @param {Real} old_mouse_y
function draw_hlgui(menu, pos_array, old_mouse_x, old_mouse_y) {
	
	// Get new position and draw window
	var newp = draw_window(pos_array, menu[1], menu[2], old_mouse_x, old_mouse_y, menu[0], true);
	var os = 20;
	
	legacy_source_highlight(pos_array[0]+10, pos_array[1]+10, menu[1]-20, menu[2]-20, false);
	
	var yin = 20;
	for (var i = 0; i < array_length(menu[4]); i ++) {
		switch (menu[4][i][1]) {
			case HLGuiLegacyOption.Text:
				// Draw a block of text
				draw_text(pos_array[0]+os, pos_array[1]+yin, menu[4][i][0]);
				yin += string_height(menu[4][i][0]);
				break;
		
			case HLGuiLegacyOption.Checkbox:
				// Draw a checkbox
				if draw_checkbox(pos_array[0]+os, pos_array[1]+yin, variable_global_get(menu[4][i][2]), menu[4][i][0]) variable_global_set(menu[4][i][2], !variable_global_get(menu[4][i][2]));
				break;
			
			case HLGuiLegacyOption.Picker:
				// Draw an option picker, similar to checkbox.
				var picked = draw_picker(pos_array[0]+os, pos_array[1]+yin, menu[4][i][0], menu[4][i][2], variable_global_get(menu[4][i][3]));
				variable_global_set(menu[4][i][3], picked);
				break;
			
			case HLGuiLegacyOption.Dropdown:
				// Draw a dropdown menu of which many options can be chosen
				var open = variable_global_get(menu[4][i][3]);
				var newopen = draw_dropdown(pos_array[0]+menu[1]/2, pos_array[1]+yin, menu[4][i][0], menu[4][i][2], open[0], open[1]);
				
				variable_global_set(menu[4][i][3], newopen);
				
				yin += array_length(menu[4][i][2])*21*newopen[1];
				break;
				
			case HLGuiLegacyOption.Func:
				// Draw a button that can perform a function
				
				switch menu[4][i][2] {
					case open_menu:
						var _newmenu = open_menu(pos_array[0]+os, pos_array[1]+yin, menu[4][i][3], menu[4][i][4]);
						if _newmenu != -1 { newp[3] = _newmenu; return newp;}
						
						break;
					
					case open_file:
						var _newfile = open_file(pos_array[0]+os, pos_array[1]+yin, menu[4][i][3], menu[4][i][4], menu[4][i][5]);
						if _newfile != "" variable_global_set(menu[4][i][6], _newfile);
						
						break;
				}
				break;
				
			case HLGuiLegacyOption.Slider:
				// Draw a button that can open another menu
				var current = menu[4][i];
				
				var newslide = draw_slider(pos_array[0]+os, pos_array[1]+yin, current[2][1]/2, current[2][0], current[2][1], variable_global_get(current[3])[0], old_mouse_x, variable_global_get(current[3])[1], current[0]);
				variable_global_set(menu[4][i][3], newslide);
				
				break;
		}
		yin += menu[4][i][1];
	}
	
	return newp;
}

function open_menu(x, y, index, text) {
	var newmenu = drawButton(x, y, string_width(text), 20, text);
	if newmenu return index;
	
	return -1;
}

function open_file(x, y, text, filter, fname) {
	
	var newfile = drawButton(x, y, string_width(text), 20, text);
	
	if newfile {
		
		var file = get_open_filename(filter, fname);
		debug(file);
		
		if file != "" return file;
	}
	
	return "";
	
}

/**
 * @param {Real} x
 * @param {Real} y
 * @param {Real} w Width
 * @param {Real} h Height
 * @param {Bool} pressed Whether the item is pressed.
 */
function legacy_source_highlight(x, y, w, h, pressed) {
	
	if pressed {
		// Hovered
		draw_set_colour(c_black);
		draw_line(x-1, y-1, x+w+1, y-1);
		draw_line(x-1, y-1, x-1, y+h+1);
		
		draw_set_colour(c_white);
		draw_line(x-1, y+h+1, x+w+1, y+h+1);
		draw_line(x+w+1, y-1, x+w+1, y+h+1);
	} else {
		// Not hovered
		draw_set_colour(c_white);
		draw_line(x-1, y-1, x+w+1, y-1);
		draw_line(x-1, y-1, x-1, y+h+1);
		
		draw_set_colour(c_black);
		draw_line(x-1, y+h+1, x+w+1, y+h+1);
		draw_line(x+w+1, y-1, x+w+1, y+h+1);
	}
	
	draw_set_colour(c_white);
}

function drawButton(x, y, w, h, text) {
	/// @arg x
	/// @arg y
	/// @arg width
	/// @arg height
	
	// Draw shaded rectangle in the source style
	
	var pressed = point_in_rectangle(device_mouse_x_to_gui(0), device_mouse_y_to_gui(0), x, y, x+w, y+h);
	
	if pressed && mouse_check_button_pressed(mb_left) {
		return true;
	}
	
	legacy_source_highlight(x, y, w, h, pressed);
	
	draw_set_halign(fa_center);
	draw_set_valign(fa_middle);
	draw_set_colour(c_white);
	draw_text(x+w/2, y+h/2, text);
	
	// Reset for future draws
	draw_set_halign(fa_left);
	draw_set_valign(fa_top);
	
	return false;
}

/// Draw button that only highlights when hovered.
/// 
/// @param {Real} x Description
/// @param {Real} y Description
/// @param {Real} width Description
/// @param {Real} height Description
/// @param {String} text Description
/// @returns {Bool} Description
function alt2DrawButton(x, y, w, h, text) {
	
	var pressed = point_in_rectangle(device_mouse_x_to_gui(0), device_mouse_y_to_gui(0), x, y, x+w, y+h);
	var c = c_white;
	
	draw_set_alpha(0);
	if pressed {
		if mouse_check_button_pressed(mb_left) return true;
		draw_set_colour(c_grey);
		draw_set_alpha(0.4);
		c = c_black;
	}
	
	draw_rectangle(x, y, x+w, y+h, false);
	
	draw_set_halign(fa_center);
	draw_set_valign(fa_middle);
	draw_set_colour(c);
	draw_set_alpha(1);
	draw_text(x+w/2, y+h/2, text);
	
	// Reset for future draws
	draw_set_halign(fa_left);
	draw_set_valign(fa_top);
	draw_set_colour(c_white);
	
	return false;
}

function altDrawButton(x, y, w, h, text) {
	/// @arg x
	/// @arg y
	/// @arg width
	/// @arg height
	/// @arg text
	
	// This is an alternate button drawing method that looks like dropdown buttons.
	
	var pressed = point_in_rectangle(device_mouse_x_to_gui(0), device_mouse_y_to_gui(0), x, y, x+w, y+h);
	var c = c_white;
	
	draw_set_alpha(0.4);
	if pressed {
		if mouse_check_button_pressed(mb_left) return true;
		draw_set_colour(c_orange);
		draw_set_alpha(1);
		c = c_black;
	}
	
	draw_rectangle(x, y, x+w, y+h, false);
	
	draw_set_halign(fa_center);
	draw_set_valign(fa_middle);
	draw_set_colour(c);
	draw_set_alpha(1);
	draw_text(x+w/2, y+h/2, text);
	
	// Reset for future draws
	draw_set_halign(fa_left);
	draw_set_valign(fa_top);
	draw_set_colour(c_white);
	
	return false;
}

function draw_checkbox(x, y, checked, text) {
	// Draw a checkbox
	var pressed = point_in_rectangle(device_mouse_x_to_gui(0), device_mouse_y_to_gui(0), x, y, x+16, y+16);
	
	
	if checked { draw_line_width(x, y+10, x+8, y+16, 4); draw_line_width(x+8, y+16, x+16, y, 4); }
	
	legacy_source_highlight(x, y, 16, 16, !pressed);
	
	HLGuiDrawUtils.setVAlign(fa_middle);
	draw_text(x+32, y+8, text);
	HLGuiDrawUtils.resetVAlign();
	
	if pressed && mouse_check_button_pressed(mb_left) {
		return true;
	}
	
	return false;
}

function draw_picker(x, y, title, options, selected) {
	/// @arg x
	/// @arg y
	/// @arg desc_text
	/// @arg options_array
	/// @arg current_selected
	var xof = 0;
	
	draw_text(x, y, title);
	
	for (var i = 0; i < array_length(options); i ++) {
		// Loop through all options
		var chosen = draw_checkbox(x+xof, y+30, i==selected, options[i]); if chosen {
			return i;
		}
		xof += string_width(options[i]) + 48;
	}
	return selected;
}

function draw_dropdown(x, y, title, options, selected, o) {
	/// @arg x
	/// @arg y
	/// @arg desc_text
	/// @arg options_array
	/// @arg current_selected
	/// @arg is_open
	
	draw_set_halign(fa_center);
	var width = longest_string_in_arr(options)+string_width(" >");
	draw_text(x, y, title);
	draw_set_halign(fa_left);
	
	if !o o = drawButton(x-width/2, y+30, width, 20, options[selected]+" >"); else o = !drawButton(x-width/2, y+30, width, 20, options[selected]);
	
	if o {
		// Draw dropdown list
		var yof = 21;
		for (var i = 0; i < array_length(options); i ++) {
			var newselect = altDrawButton(x-width/2, y+yof+30, width, 20, options[i]);
			if newselect { selected = i; o = false; break; }
			
			yof += 21;
		}
	}
	
	return [selected, o];
}

function draw_slider(x, y, width, mn, mx, current, omx, dragged, title) {
	/// @arg x
	/// @arg y
	/// @arg width
	/// @arg minimum
	/// @arg maximum
	/// @arg current_val
	/// @arg old_mouse_x
	/// @arg currently_dragged
	/// @arg title
	
	draw_text(x, y-5, title);
	
	draw_line(x, y+20, x+width, y+20);
	var slider_pos = current/(mx-mn)*width;
	
	for (var i = 0; i < 11; i ++) {
		draw_line(x+i*width/10, y+20, x+i*width/10, y+25);
	}
	
	if point_in_rectangle(device_mouse_x_to_gui(0), device_mouse_y_to_gui(0), x+slider_pos-5, y-5+20, x+slider_pos+5, y+5+20) dragged = true;
	
	if dragged {
		if mouse_check_button(mb_left) {
			current = (device_mouse_x_to_gui(0)-x)*2;
		} else dragged = false;
	}
	
	draw_rectangle(x+slider_pos-5, y-5+20, x+slider_pos+5, y+5+20, false);
	
	draw_text(x, y+20, string(mn));
	
	draw_set_halign(fa_right);
	draw_text(x+width, y+20, string(mx));
	
	draw_set_halign(fa_left);
	current = round(clamp(current, mn, mx));
	return [current, dragged];
}

function longest_string_in_arr(arr) {
	var width = string_width(arr[0]);
	
	for (var i = 0; i < array_length(arr); i ++) {
		if width < string_width(arr[i]) width = string_width(arr[i]);
	}
	
	return width;
}