
/**
 * A numerical slider between two values.
 */
function HLGuiSlider(label, minimum, maximum, get, set) : HLGuiWidget() constructor {
	
	self.label = label;
	self.minimum = minimum;
	self.maximum = maximum;
	self.range = (self.maximum - self.minimum);
	self.get = get;
	self.set = set;
	
	static grabberSize = 10;
	static grabberSizeHalf = (grabberSize / 2);
	static increments = 11;
	
	static measureHeight = function(width) {
		return string_height_ext(self.label, -1, width) + grabberSize + max(string_height(string(self.minimum)), string_height(string(self.maximum)));
	};
	
	static draw = function(x, y, width, height) {
		
		var value = self.get();
		var drawY = y;
		
		// Label text.
		draw_text_ext(x, drawY, self.label, -1, width);
		drawY += string_height_ext(self.label, -1, width);
		
		// Slider rail.
		draw_line(x, drawY + grabberSizeHalf, x + width, drawY + grabberSizeHalf);
		
		// Rail increments.
		for (var i = 0; i < increments; i ++) {
			draw_line(x + i * width / 10, drawY, x + i * width / 10, drawY + grabberSize);
		}
		
		// Grabber that user moves.
		var grabberX = self.calcGrabberX(x);
		draw_rectangle(grabberX, drawY, grabberX + grabberSize, drawY + grabberSize, false);
		
		drawY += grabberSize;
		
		// Minimum and maximum text markers.
		draw_text(x, drawY, string(self.minimum));
	
		HLGuiDrawUtils.setHAlign(fa_right);
		draw_text(x + width, drawY, string(self.maximum));
		HLGuiDrawUtils.resetHAlign();
		
	};
	
	static onMouseUpdate = function(update) {
		
		if ((update & HLGuiMouseData.LeftPress) && self.isHovered()) {
			self.gui.requestFocus();
		}
		
		if (self.isFocused()) {
			
			if (update & HLGuiMouseData.LeftRelease) {
				return self.gui.releaseFocus();
			}
			
			var newValue = (self.gui.mouseX - self.layoutPos.x) / self.layoutPos.width * self.range + self.minimum;
			newValue = clamp(newValue, self.minimum, self.maximum);
			
			if (self.get() != newValue) {
				self.set(newValue);
			}
			
		}
		
	};
	
	static getTargetWidget = function(x, y) {
		
		var grabberX = self.calcGrabberX(self.layoutPos.x);
		var grabberY = self.layoutPos.y + string_height_ext(self.label, -1, self.layoutPos.width);
		
		if (point_in_rectangle(self.gui.mouseX, self.gui.mouseY, grabberX, grabberY, grabberX + grabberSize, grabberY + grabberSize)) {
			return self;
		}
		
	};
	
	/**
	 * Calculate the grabber's left X position.
	 * 
	 * @param {Real} x The reference left X position.
	 * @returns {Real}
	 */
	static calcGrabberX = function(x) {
		return x + (self.get() / self.range) * self.layoutPos.width - grabberSizeHalf;
	};
	
	static toString = function() {
		return $"{instanceof(self)}()";
	};
	
}
