
/**
 * A vertical spacer between GUI elements.
 * @param {Real} height Height of the spacer.
 */
function HLGuiSpacer(height) : HLGuiWidget() constructor {
	
	self.height = height;
	
	static measureHeight = function(width) {
		return self.height;
	};
	
	static toString = function() {
		return $"{instanceof(self)}(height={self.height})";
	};
	
}
