
function HLGuiLabel(label) : HLGuiWidget() constructor {
	
	self.label = label;
	
	static measureHeight = function(width) {
		return string_height_ext(self.label, -1, width);
	};
	
	static draw = function(x, y, width, height) {
		draw_text_ext(x, y, self.label, -1, width);
	};
	
}
