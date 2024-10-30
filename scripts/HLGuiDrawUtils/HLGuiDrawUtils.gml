
/**
 * Set of drawing utilities for HLGui widgets.
 */
function HLGuiDrawUtils() {
	
	static prevVAlign = fa_top;
	static prevHAlign = fa_left;
	static prevColour = c_white;
	
	/**
	 * Set the vertical alignment of text, saving the prior value.
	 * @param {Constant.VAlign} valign
	 */
	static setVAlign = function(valign) {
		prevVAlign = draw_get_valign();
		draw_set_valign(valign);
	};
	
	/**
	 * Reset the original vertical alignment value.
	 */
	static resetVAlign = function() {
		draw_set_valign(prevVAlign);
	}
	
	/**
	 * Set the horizontal alignment of text, saving the prior value.
	 * @param {Constant.HAlign} halign
	 */
	static setHAlign = function(halign) {
		prevHAlign = draw_get_halign();
		draw_set_halign(halign);
	};
	
	/**
	 * Reset the original horizontal alignment value.
	 */
	static resetHAlign = function() {
		draw_set_halign(prevHAlign);
	}
	
	/**
	 * Set the draw colour, saving the prior value.
	 * @param {Constant.Color|Real} colour
	 */
	static setColour = function(colour) {
		prevColour = draw_get_colour();
		draw_set_colour(colour);
	};
	
	/**
	 * Reset the original horizontal alignment value.
	 */
	static resetColour = function() {
		draw_set_colour(prevColour);
	}
	
	
}

HLGuiDrawUtils();
