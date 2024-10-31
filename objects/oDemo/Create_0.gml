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
self.slide2 = 5;

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
		function() { return self.checkedbox },
		function(checked) { self.checkedbox = checked }
	),
	new HLGuiButton("advanced?", function() {
		self.advancedMenu.visible = !self.advancedMenu.visible;
	}),
	new HLGuiCheckbox("checkbox!",
		function() { return self.checkedbox2 },
		function(checked) { self.checkedbox2 = checked }
	),
	new HLGuiDropdown("choose one but fancy",
		["op1", "half life 2: episode 3", "some other option who cares lol"],
		function() { return self.chosenone },
		function(choice) { self.chosenone = choice }
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
		function() { return self.fate },
		function(choice) { self.fate = choice }
	)
], 10)]);

self.advancedMenu = new HLGuiMenu("ADVANCED", 200, 200, 450, false, true, [new HLGuiColumn([
	new HLGuiCheckbox("checkbox?",
		function() { return self.checkedbox },
		function(checked) { self.checkedbox = checked }
	),
	new HLGuiCheckbox("menu_hovered",
		function() { return self.hlGui.hoveredWidget != undefined },
		function(checked) {}
	),
	new HLGuiLabel("this is the advanced menu."),
	new HLGuiButton("dumb menu", function() {
		self.optionsMenu.visible = true;
		self.advancedMenu.visible = false;
	}),
	new HLGuiCheckbox("checkbox!",
		function() { return self.checkedbox2 },
		function(checked) { self.checkedbox2 = checked }
	),
	new HLGuiDropdown("choose one but fancy",
		["op1", "half life 2: episode 3", "some other option who cares lol"],
		function() { return self.chosenone },
		function(choice) { self.chosenone = choice }
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
		function() { return self.fate },
		function(choice) { self.fate = choice }
	),
	new HLGuiRow([
		new HLGuiSlider("slidey boi", 0, 255,
			function() { return self.slide; },
			function(value) { self.slide = value; }
		),
		new HLGuiSlider("slidey boi the sequel", 0, 10,
			function() { return self.slide2; },
			function(value) { self.slide2 = round(value); },
			10
		)
	], 10)
], 10)]);

self.hlGui = new HLGui([
	self.optionsMenu,
	self.advancedMenu
]);

self.pollWindowSize();
