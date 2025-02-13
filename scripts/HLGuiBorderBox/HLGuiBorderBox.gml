
/**
 * A box layout with a specified border around children.
 *
 * @param {Real} [width] The width of the border.
 * @param {Real} [height] The height of the border.
 * @param {Array<Struct.HLGuiWidget>} children List of child widgets.
 * @param {Bool} [inverted] Whether the border is inverted.
 * @param {Bool} [visible] Whether this widget is initially visible.
 */
function HLGuiBorderBox(width, height, children, inverted = true, visible = true) : HLGuiPaddedBox(width, height, children, visible) constructor {
	
	self.inverted = inverted;
	
	self.paddedBoxMeasureHeight = method(self, HLGuiPaddedBox.measureHeight);
	self.paddedBoxDraw = method(self, HLGuiPaddedBox.draw);
	
	static draw = function(x, y, width, height) {
		self.paddedBoxDraw(x, y, width, height);
		HLGuiDraw.sourceButtonOutline(x, y, width, height, self.inverted);
	};
	
}

new HLGuiBorderBox(0, 0, []);
