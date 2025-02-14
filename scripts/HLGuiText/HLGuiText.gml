
/**
 * A basic text display.
 * @param {Function} get `() -> String` | Get the text to be displayed.
 */
function HLGuiText(get) : HLGuiWidget() constructor {
	
	self.get = get;
	self.text = "";
	
	static measureHeight = function(width) {
		return string_height_ext(self.text, -1, width);
	};
	
	static draw = function(x, y, width, height) {
		draw_text_ext(x, y, self.text, -1, width);
	};
	
	static ensureLayoutValid = function() {
		
		var text = self.get();
		
		if (self.text != text) {
			self.text = text;
			self.invalidateLayout();
		}
		
	};
	
	static toString = function() {
		return $"{instanceof(self)}(label=`{self.label}`)";
	};
	
}
