
/**
 * A numerical slider between two values.
 * 
 * @param {String} label The text label for this slider.
 * @param {Real} minimum The minimum (leftmost) value.
 * @param {Real} maximum The maximum (rightmost) value.
 * @param {Function} get `() -> Real` | Get the current backing value.
 * @param {Function} set `(Real) -> undefined` | Set the current backing value.
 * @param {Real} [increments] The number of increments to show. Defaults to 10.
 */
function HLGuiSlider(label, minimum, maximum, get, set, increments = 10) : HLGuiWidget() constructor {
	
	self.label = label;
	self.minimum = minimum;
	self.maximum = maximum;
	self.range = (self.maximum - self.minimum);
	self.get = get;
	self.set = set;
	self.increments = increments;
	
	static grabberSize = 12;
	static grabberSizeHalf = (grabberSize / 2);
	
	static measureHeight = function(width) {
		return string_height_ext(self.label, -1, width) + grabberSize + max(string_height(string(self.minimum)), string_height(string(self.maximum)));
	};
	
	static draw = function(x, y, width, height) {
		
		var value = self.get();
		var drawY = y;
		
		// Label text.
		draw_text_ext(x, drawY, self.label, -1, width);
		drawY += string_height_ext(self.label, -1, width);
		
		HLGuiDrawUtils.setColour(HLGuiDraw.colHighlight);
		
		// Slider rail.
		draw_line(x, drawY + grabberSizeHalf, x + width, drawY + grabberSizeHalf);
		
		var incrementDistance = width / (self.increments - 1);
		
		// Rail increments.
		for (var i = 0; i < self.increments; i ++) {
			var incrementX = x + i * incrementDistance;
			draw_line(incrementX, drawY, incrementX, drawY + grabberSize);
		}
		
		HLGuiDrawUtils.resetColour();
		
		// Grabber that user moves.
		var grabberX = self.calcGrabberX(x);
		draw_circle(grabberX + grabberSizeHalf, drawY + grabberSizeHalf, grabberSizeHalf, false);
		
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
		return x + ((self.get() - self.minimum) / self.range) * self.layoutPos.width - grabberSizeHalf;
	};
	
	static toString = function() {
		return $"{instanceof(self)}()";
	};
	
}
