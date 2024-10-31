
Welcome to HLMENU!

This is a little tool by thennothing to generate menus for games in the same style as
menus in source games.

Currently supports the following:
	- Checkboxes
	- Free floating text
	- Pickers (Similar to checkboxes, but come in groups, and only one can be chosen)
	- Dropdowns
	- Buttons to change to a new menu
	- Buttons to load files
	- Sliders between two values

HOW TO FORMAT:
	- General
		This applies to all of the below.
		In your menu array, you should format like so:
		
		["Title Text", HLGuiLegacyOption.(type), (other data)]
		
		"other data" is commonly an array, or a pointer in string form to a global.
	
	- Checkbox
		Variable is a boolean.
		["Title Text", HLGuiLegacyOption.Checkbox, "some_global"]
		
	- Text
		Text only needs a string.
		
	- Picker
		Variable is an integer, which stores the current selection.
		["Title Text", HLGuiLegacyOption.Picker, ["array","of","options"], "some_global"]
		
	- Dropdown
		Variable is an integer, which stores the current selection.
		["Title Text", HLGuiLegacyOption.Dropdown, ["array","of","options"], "some_global"]
	
	- Function
		["Title Text", HLGuiLegacyOption.Func, data (see below for functions)]
	
	- Slider
		Variable is an array, storing the current value (integer), and whether it is currently being dragged (bool).
		["Title Text", HLGuiLegacyOption.Slider, "some_global"]

Functions Included (You can add custom ones):
	- open_menu(x, y, text, menu_index);
		draws button which sets mpos[3] to index of menu
		
	- open_file(x, y, text, filter, dir);
		draws button which prompts user for a file which the name of which is then stored in the global.
