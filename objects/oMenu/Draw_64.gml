if mpos[3] == -1 exit;

var s = ds_menu[mpos[3]];

// Draw Menu
mpos = draw_hlgui(s, mpos, omx, omy);

// Get mouse position for update
omx = device_mouse_x_to_gui(0); omy = device_mouse_y_to_gui(0);