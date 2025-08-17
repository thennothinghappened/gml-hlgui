
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

self.mainMenu = new HLGuiWindow(100, 200, 300, [
	new HLGuiImage(sDemoMenuBg),
	new HLGuiPaddedBox(20, 20, [
		new HLGuiColumn([
			new HLGuiButton("Options", function() {
				self.optionsMenu.setVisible(!self.optionsMenu.getVisible());
			}),
			new HLGuiButton("Quit", function() {
				game_end();
			})
		], 20)
	])
]).setVisible(true);

self.optionsDropdown = new HLGuiDropdown("Choose an option...",
	["op1", "half life 2: episode 3", "some other option who cares lol"],
	function() { return self.chosenone },
	function(choice) { self.chosenone = choice }
);

self.optionsMenu = new HLGuiMenuWindow("OPTIONS", 200, 200, 350, true, [
	new HLGuiColumn([
		HLGuiLabel("Welcome to the options menu!\nThis is some text..."),
		new HLGuiCheckbox("checkbox?",
			function() { return self.checkboxA },
			function(checked) { self.checkboxA = checked }
		),
		HLGuiInput("Input Test",
			function() { return self.input },
			function(input) { self.input = input }
		),
		new HLGuiButton("Show Advanced Options", function() {
			self.advancedMenu.setVisible(!self.advancedMenu.getVisible());
		}),
		new HLGuiCheckbox("Show dropdown!",
			self.optionsDropdown.getVisible,
			self.optionsDropdown.setVisible
		),
		self.optionsDropdown,
		new HLGuiDropdown("Choose one!!!!!!11!",
			["mememan", "potato", "forget potatoes"],
			function() { return self.oldInsideJoke },
			function(choice) { self.oldInsideJoke = choice }
		)
	], 10)
]).setVisible(false);

self.advancedMenu = new HLGuiMenuWindow("ADVANCED", 200, 200, 450, true, [
	new HLGuiColumn([
		HLGuiLabel("This is the advanced menu."),
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
				11
			)
		], 10)
	], 10)
]).setVisible(false);

self.hlGui = new HLGui([
	self.mainMenu,
	self.optionsMenu,
	self.advancedMenu
]);

self.pollWindowSize();
