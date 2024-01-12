/// @description
global.menu_hovered = point_in_rectangle(device_mouse_x_to_gui(0), device_mouse_y_to_gui(0), mpos[0], mpos[1]-20, mpos[0]+ds_menu[mpos[3]][1], mpos[1]+ds_menu[mpos[3]][2]);