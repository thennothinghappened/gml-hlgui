//////////////////////////////
//         HL_MENU          //
//////////////////////////////

// This can be used to tell other parts of our game that we are interacting with the menu.
self.menu_hovered = false;

// These are some sample ones. Can be changed.
self.checkedbox = false;
self.checkedbox2 = true;
self.file = "";
self.fate = "potato";
self.chosenone = "half life 2: episode 3";
self.slide = 200;

/**
 * Poll the current game window size.
 */
self.pollWindowSize = function() {
	self.guiWidth = window_get_width();
	self.guiHeight = window_get_height();
};

var checkboxA = new HLGuiCheckbox("checkbox?",
	function() { return oDemo.checkedbox },
	function(checked) { oDemo.checkedbox = checked }
);

var checkboxB = new HLGuiCheckbox("checkbox!",
	function() { return oDemo.checkedbox2 },
	function(checked) { oDemo.checkedbox2 = checked }
);

var dropdownA = new HLGuiDropdown("choose one but fancy",
	["op1", "half life 2: episode 3", "some other option who cares lol"],
	function() { return oDemo.chosenone },
	function(choice) { oDemo.chosenone = choice }
);

var dropdownB = new HLGuiDropdown("Choose one!!!!!!11!",
	["mememan", "potato", "forget potatoes"],
	function() { return oDemo.fate },
	function(choice) { oDemo.fate = choice }
);

var filePicker = new HLGuiButton("file moment", function() {
		
	var path = get_open_filename(".txt|*.txt", "");
		
	if (string_length(path) == 0) {
		return;
	}
		
	show_debug_message(path);
		
});

self.optionsMenu = new HLGuiMenu("OPTIONS", 200, 200, 450, true, false, [
	new HLGuiLabel("Welcome to the options menu!\nThis some text..."),
	checkboxA,
	new HLGuiButton("advanced?", function() {
		oDemo.optionsMenu.visible = false;
		oDemo.advancedMenu.visible = true;
	}),
	checkboxB,
	dropdownA,
	filePicker,
	dropdownB
]);

self.advancedMenu = new HLGuiMenu("ADVANCED", 200, 200, 450, false, false, [
	checkboxA,
	new HLGuiCheckbox("menu_hovered",
		function() { return oDemo.menu_hovered },
		function(checked) {}
	),
	new HLGuiLabel("this is the advanced menu."),
	new HLGuiButton("dumb menu", function() {
		oDemo.optionsMenu.visible = true;
		oDemo.advancedMenu.visible = false;
	}),
	checkboxB,
	dropdownA,
	filePicker,
	dropdownB,
	new HLGuiSlider("slidey boi", 0, 255,
		function() { return oDemo.slide; },
		function(value) { oDemo.slide = value; }
	)
]);

self.hlGui = new HLGui([
	self.optionsMenu,
	self.advancedMenu
]);

self.pollWindowSize();
