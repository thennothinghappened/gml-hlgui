
/**
 * Drawing utilities for the Source Engine-inspired GUI styling.
 */
function HLGuiDraw() {
	
	static colHighlight = #BBBBBB;
	static colShadow = #444443
	static colBackground = #858481;
	static colInset = #62615E;
	
	/**
	 * Draw a Source-styled button outline.
	 * 
	 * @param {Real} x Left-most X position of the button.
	 * @param {Real} y Top-most Y position of the button.
	 * @param {Real} width Width of the button to be drawn.
	 * @param {Real} height Height of the button to be drawn.
	 * @param {Bool} inverted Whether to display as inset instead of outset.
	 */
	static sourceButtonOutline = function(x, y, width, height, inverted) {
		
		var colourTL = colHighlight;
		var colourBR = colShadow;
		
		if (inverted) {
			colourTL = colShadow;
			colourBR = colHighlight;
		}
		
		HLGuiDrawUtils.setColour(colourTL);
		draw_line(x - real(!HLGuiIsGMRT), y, x + width, y);
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
