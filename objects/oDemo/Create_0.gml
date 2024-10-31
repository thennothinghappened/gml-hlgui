//////////////////////////////
//         HL_MENU          //
//////////////////////////////

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

self.optionsMenu = new HLGuiMenu("OPTIONS", 200, 200, 450, true, false, [new HLGuiColumn([
	new HLGuiLabel("Welcome to the options menu!\nThis some text..."),
	new HLGuiCheckbox("checkbox?",
		function() { return oDemo.checkedbox },
		function(checked) { oDemo.checkedbox = checked }
	),
	new HLGuiButton("advanced?", function() {
		oDemo.optionsMenu.visible = false;
		oDemo.advancedMenu.visible = true;
	}),
	new HLGuiCheckbox("checkbox!",
		function() { return oDemo.checkedbox2 },
		function(checked) { oDemo.checkedbox2 = checked }
	),
	new HLGuiDropdown("choose one but fancy",
		["op1", "half life 2: episode 3", "some other option who cares lol"],
		function() { return oDemo.chosenone },
		function(choice) { oDemo.chosenone = choice }
	),
	new HLGuiButton("file moment", function() {
		
		var path = get_open_filename(".txt|*.txt", "");
		
		if (string_length(path) == 0) {
			return;
		}
		
		show_debug_message(path);
		
	}),
	new HLGuiDropdown("Choose one!!!!!!11!",
		["mememan", "potato", "forget potatoes"],
		function() { return oDemo.fate },
		function(choice) { oDemo.fate = choice }
	)
], 10)]);

self.advancedMenu = new HLGuiMenu("ADVANCED", 200, 200, 450, false, false, [new HLGuiColumn([
	new HLGuiCheckbox("checkbox?",
		function() { return oDemo.checkedbox },
		function(checked) { oDemo.checkedbox = checked }
	),
	new HLGuiCheckbox("menu_hovered",
		function() { return oDemo.hlGui.hoveredWidget != undefined },
		function(checked) {}
	),
	new HLGuiLabel("this is the advanced menu."),
	new HLGuiButton("dumb menu", function() {
		oDemo.optionsMenu.visible = true;
		oDemo.advancedMenu.visible = false;
	}),
	new HLGuiCheckbox("checkbox!",
		function() { return oDemo.checkedbox2 },
		function(checked) { oDemo.checkedbox2 = checked }
	),
	new HLGuiDropdown("choose one but fancy",
		["op1", "half life 2: episode 3", "some other option who cares lol"],
		function() { return oDemo.chosenone },
		function(choice) { oDemo.chosenone = choice }
	),
	new HLGuiButton("file moment", function() {
		
		var path = get_open_filename(".txt|*.txt", "");
		
		if (string_length(path) == 0) {
			return;
		}
		
		show_debug_message(path);
		
	}),
	new HLGuiDropdown("Choose one!!!!!!11!",
		["mememan", "potato", "forget potatoes"],
		function() { return oDemo.fate },
		function(choice) { oDemo.fate = choice }
	),
	new HLGuiSlider("slidey boi", 0, 255,
		function() { return oDemo.slide; },
		function(value) { oDemo.slide = value; }
	)
], 10)]);

self.hlGui = new HLGui([
	self.optionsMenu,
	self.advancedMenu
]);

self.pollWindowSize();
