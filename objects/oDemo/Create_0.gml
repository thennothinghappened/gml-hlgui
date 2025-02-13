
self.checkboxA = false;
self.checkboxB = true;
self.oldInsideJoke = "potato";
self.chosenone = "half life 2: episode 3";
self.slide = 200;
self.slide2 = 5;
self.input = "some text!";

/**
 * Poll the current game window size.
 */
self.pollWindowSize = function() {
	self.guiWidth = window_get_width();
	self.guiHeight = window_get_height();
};

self.mainMenu = new HLGuiWindow(100, 200, 300, true, [
	new HLGuiImage(sDemoMenuBg),
	new HLGuiPaddedBox(20, 20, [
		new HLGuiColumn([
			new HLGuiButton("Options", function() {
				self.optionsMenu.visible = !self.optionsMenu.visible;
			}),
			new HLGuiButton("Quit", function() {
				game_end();
			}),
			new HLGuiColumn([
				new HLGuiLabel("Input Test"),
				new HLGuiBorderBox(4, 4, [
					new HLGuiBasicInput(
						function() { return self.input },
						function(input) { self.input = input }
					)
				])
			])
		], 20)
	])
]);

self.optionsMenu = new HLGuiMenuWindow("OPTIONS", 200, 200, 350, false, true, [new HLGuiColumn([
	new HLGuiLabel("Welcome to the options menu!\nThis is some text..."),
	new HLGuiCheckbox("checkbox?",
		function() { return self.checkboxA },
		function(checked) { self.checkboxA = checked }
	),
	new HLGuiButton("Show Advanced Options", function() {
		self.advancedMenu.visible = !self.advancedMenu.visible;
	}),
	new HLGuiCheckbox("checkbox!",
		function() { return self.checkboxB },
		function(checked) { self.checkboxB = checked }
	),
	new HLGuiDropdown("Choose an option...",
		["op1", "half life 2: episode 3", "some other option who cares lol"],
		function() { return self.chosenone },
		function(choice) { self.chosenone = choice }
	),
	new HLGuiDropdown("Choose one!!!!!!11!",
		["mememan", "potato", "forget potatoes"],
		function() { return self.oldInsideJoke },
		function(choice) { self.oldInsideJoke = choice }
	)
], 10)]);

self.advancedMenu = new HLGuiMenuWindow("ADVANCED", 200, 200, 450, false, true, [new HLGuiColumn([
	new HLGuiLabel("This is the advanced menu."),
	new HLGuiRow([
		new HLGuiCheckbox("checkbox?",
			function() { return self.checkboxA },
			function(checked) { self.checkboxA = checked }
		),
		new HLGuiCheckbox("Are menus hovered?",
			function() { return self.hlGui.hoveredWidget != undefined },
			function(checked) {}
		),
	], 10),
	new HLGuiButton("Close advanced menu (temp)", function() {
		self.advancedMenu.visible = false;
	}),
	new HLGuiCheckbox("checkbox!",
		function() { return self.checkboxB },
		function(checked) { self.checkboxB = checked }
	),
	new HLGuiDropdown("choose one but fancy",
		["op1", "half life 2: episode 3", "some other option who cares lol"],
		function() { return self.chosenone },
		function(choice) { self.chosenone = choice }
	),
	new HLGuiButton("Choose File", function() {
		
		var path = get_open_filename(".txt|*.txt", "");
		
		if (string_length(path) == 0) {
			return;
		}
		
		show_debug_message(path);
		
	}),
	new HLGuiDropdown("Choose one!!!!!!11!",
		["mememan", "potato", "forget potatoes"],
		function() { return self.oldInsideJoke },
		function(choice) { self.oldInsideJoke = choice }
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
	self.mainMenu,
	self.optionsMenu,
	self.advancedMenu
]);

self.pollWindowSize();
