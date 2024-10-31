
/**
 * A dropdown for selecting items from a list.
 * 
 * @param {String} label The label for this dropdown.
 * @param {Array<String>} choices List of choices in the dropdown.
 * @param {Function} getChoice `() -> String` | Get the current selected choice.
 * @param {Function} setChoice `(String) -> undefined` | Set the current selected choice.
 */
function HLGuiDropdown(label, choices, getChoice, setChoice) : HLGuiWidget() constructor {
	
	self.label = label;
	self.choices = choices;
	self.getChoice = getChoice;
	self.setChoice = setChoice;
	
	self.__num_choices = array_length(self.choices);
	self.hoveredOptionIndex = undefined;
	self.currentChoice = self.getChoice();
	
	static optionHeight = 20;
	
	static measureHeight = function(width) {
		// TODO: Text-Wrap
		
		var height = self.getLabelHeight(width);
		
		if (!self.isFocused()) {
			return height + optionHeight;
		}
		
		return height + (optionHeight * (self.__num_choices + 1));
		
	};
	
	static getLabelHeight = function(width) {
		return string_height_ext(self.label, -1, width);
	}
	
	static draw = function(x, y, width, height) {
		
		var drawY = y;
		
		draw_text_ext(x, drawY, self.label, -1, width);
		drawY += string_height_ext(self.label, -1, width);
		
		HLGuiDrawUtils.setHAlign(fa_center);
		HLGuiDrawUtils.setVAlign(fa_middle);
		
		HLGuiDraw.sourceButtonOutline(x, drawY, width, optionHeight, (self.hoveredOptionIndex == -1));
		draw_text(x + (width / 2), drawY + (optionHeight / 2), self.getChoice());
		drawY += optionHeight;
		
		if (self.isFocused()) {
			for (var i = 0; i < self.__num_choices; i ++) {
				
				HLGuiDraw.sourceButtonOutline(x, drawY, width, optionHeight, (self.hoveredOptionIndex == i));
				draw_text(x + (width / 2), drawY + (optionHeight / 2), self.choices[i]);
				
				drawY += optionHeight;
				
			}
		}
		
		HLGuiDrawUtils.resetHAlign();
		HLGuiDrawUtils.resetVAlign();
		
	};
	
	static ensureLayoutValid = function() {
		
		var currentChoice = self.getChoice();
		
		if (self.currentChoice != currentChoice) {
			self.currentChoice = currentChoice;
			self.invalidateLayout();
		}
		
	};
	
	static onMouseUpdate = function(update) {
		
		if (!self.isFocused()) {
			self.hoveredOptionIndex = undefined;
		}
		
		if (self.isHovered()) {
			
			var offsetY = (self.gui.mouseY - self.layoutPos.y - self.getLabelHeight(self.layoutPos.width));
			self.hoveredOptionIndex = floor(offsetY / optionHeight) - 1;
			
			if (update & HLGuiMouseData.LeftPress) {
				self.gui.requestFocus();
			}
			
		}
		
		if (self.isFocused() && (update & HLGuiMouseData.LeftRelease) && (self.hoveredOptionIndex >= 0)) {
			self.setChoice(self.choices[self.hoveredOptionIndex]);
			self.gui.releaseFocus();
		}
		
	};
	
	static onHoverStop = function() {
		if (!self.isFocused()) {
			self.hoveredOptionIndex = undefined;
		}
	};
	
	static onFocusGained = function() {
		self.invalidateLayout();
	};
	
	static onFocusLost = function() {
		self.invalidateLayout();
		self.hoveredOptionIndex = undefined;
	};
	
	static getTargetWidget = __getTargetWidgetPointInRect;
	
	static toString = function() {
		return $"{instanceof(self)}()";
	};
	
}
