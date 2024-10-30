
/**
 * A vertical spacer between GUI elements.
 * @param {Real} height Height of the spacer.
 */
function HLGuiSpacer(height) constructor {
	
	self.height = height;
	
	static measureHeight = function(width) {
		return self.height;
	};
	
}
