
/**
 * Drawing utilities for the Source Engine-inspired GUI styling.
 */
function HLGuiDraw() {
	
	/**
	 * Draw a Source-styled button outline.
	 * 
	 * @param {Real} x Left-most X position of the button.
	 * @param {Real} y Top-most Y position of the button.
	 * @param {Real} width Width of the button to be drawn.
	 * @param {Real} height Height of the button to be drawn.
	 * @param {Bool} pressed Whether the item is pressed.
	 */
	static sourceButtonOutline = function(x, y, width, height, pressed) {
		
		var colourTL = c_white;
		var colourBR = c_black;
		
		if (pressed) {
			var temp = colourTL;
			colourTL = colourBR;
			colourBR = temp;
		}
		
		HLGuiDrawUtils.setColour(colourTL);
		draw_line(x, y, x + width, y);
		draw_line(x, y, x, y + height);
		HLGuiDrawUtils.resetColour();
		
		HLGuiDrawUtils.setColour(colourBR);
		draw_line(x, y + height, x + width, y + height);
		draw_line(x + width, y, x + width, y + height);
		HLGuiDrawUtils.resetColour();
		
	}
	
	return HLGuiDraw;
	
}

HLGuiDraw();