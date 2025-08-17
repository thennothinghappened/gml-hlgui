
/**
 * A box layout with a specified padding around children.
 *
 * @param {Real} [paddingX] The horizontal padding around children.
 * @param {Real} [paddingY] The vertical padding around children.
 * @param {Array<Struct.HLGuiWidget>} children List of child widgets.
 */
function HLGuiPaddedBox(paddingX, paddingY, children) : HLGuiBox(children) constructor {
	
	self.paddingX = paddingX;
	self.paddingY = paddingY;
	
	self.boxMeasureHeight = method(self, HLGuiBox.measureHeight);
	self.boxDraw = method(self, HLGuiBox.draw);
	
	static measureHeight = function(width) {
		return self.boxMeasureHeight(max(width - (self.paddingX * 2), 1)) + (self.paddingY * 2);
	};
	
	static draw = function(x, y, width, height) {
		return self.boxDraw(x + self.paddingX, y + self.paddingY, width - (self.paddingX * 2), height - (self.paddingY * 2));
	};
	
}

new HLGuiPaddedBox(0, 0, []);
