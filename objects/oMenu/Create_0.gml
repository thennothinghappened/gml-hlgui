//////////////////////////////
//         HL_MENU          //
//////////////////////////////

/*

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
		
		["Title Text", menu_types.(type), (other data)]
		
		"other data" is commonly an array, or a pointer in string form to a global.
	
	- Checkbox
		Variable is a boolean.
		["Title Text", menu_types.checkbox, "some_global"]
		
	- Text
		Text only needs a string.
		
	- Picker
		Variable is an integer, which stores the current selection.
		["Title Text", menu_types.picker, ["array","of","options"], "some_global"]
		
	- Dropdown
		Variable is an integer, which stores the current selection.
		["Title Text", menu_types.dropdown, ["array","of","options"], "some_global"]
	
	- Function
		["Title Text", menu_types.func, data (see below for functions)]
	
	- Slider
		Variable is an array, storing the current value (integer), and whether it is currently being dragged (bool).
		["Title Text", menu_types.slider, "some_global"]

Functions Included (You can add custom ones):
	- open_menu(x, y, text, menu_index);
		draws button which sets mpos[3] to index of menu
		
	- open_file(x, y, text, filter, dir);
		draws button which prompts user for a file which the name of which is then stored in the global.
*/

enum menu_types {
	checkbox = 32, // True or false
	text = 10, // Free floating text, doesn't have interactability.
	picker = 62, // Similar to checkbox, but user forced to pick specific option.
	dropdown = 70, // Similar to picker but fancier
	func = 40, // This is for interacting with files.
	slider = 45 // Self explanatory.
};

// List of menu pages in order on the array
// This needs to be in the same order as the "ds_menu" array.
enum menu_page {
	options,
	advanved
};

// This can be used to tell other parts of our game that we are interacting with the menu.
global.menu_hovered = false;

// These are some sample ones. Can be changed.
global.checkedbox = false;
global.checkedbox2 = true;
global.file = "";
global.fate = 1;
global.chosenone = [1, false];
global.slide = [200, false];

ds_menu_options = setup_menu([
	"OPTIONS", 450, 450, 4,
	[
	["Welcome to the options menu!\nThis some text...", menu_types.text],
	["checkbox?", menu_types.checkbox, "checkedbox"],
	["advanced?", menu_types.func, open_menu, menu_page.advanved, "advanced menu"],
	["checkbox!", menu_types.checkbox, "checkedbox2"],
	["choose one but fancy", menu_types.dropdown, ["op1", "half life 2: episode 3", "some other option who cares lol"], "chosenone"],
	["file moment", menu_types.func, open_file, "another file", "some_filter_text|*.file_extension", "starting_directory", "file"],
	["Choose one!!!!!!11!", menu_types.picker, ["mememan", "potato", "forget potatoes"], "fate"]
	]
]);

ds_menu_advanced = setup_menu([
	"ADVANCED", 450, 200, 4,
	[
	["checkbox?", menu_types.checkbox, "checkedbox"],
	["menu_hovered", menu_types.checkbox, "menu_hovered"],
	["this is the advanced menu.", menu_types.text],
	["normal?", menu_types.func, open_menu, menu_page.options, "dumb menu"],
	["checkbox!", menu_types.checkbox, "checkedbox2"],
	["choose one but fancy", menu_types.dropdown, ["op1", "half life 2: episode 3", "some other option who cares lol"], "chosenone"],
	["file moment", menu_types.func, open_file, "open file", ".txt|*.txt", "", "file"],
	["Choose one!!!!!!11!", menu_types.picker, ["mememan", "potato", "forget potatoes"], "fate"],
	["slidey boi", menu_types.slider, [0, 255], "slide"]
	]
]);

// List of all menus
ds_menu = [ds_menu_options, ds_menu_advanced];

// Menu position on screen
// X, Y, is being dragged, current menu (-1 = closed)
mpos = [200, 200, false, 1];

// Old position of mouse on screen (Used for draggability)
omx = 0; omy = 0;