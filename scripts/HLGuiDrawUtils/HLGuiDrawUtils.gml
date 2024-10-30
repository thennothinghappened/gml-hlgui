
/**
 * Set of drawing utilities for HLGui widgets.
 */
function HLGuiDrawUtils() {
	
	static prevVAlign = ds_stack_create();
	static prevHAlign = ds_stack_create();
	static prevColour = ds_stack_create();
	static prevAlpha = ds_stack_create();
	
	/**
	 * Set the vertical alignment of text, saving the prior value.
	 * @param {Constant.VAlign} valign
	 */
	static setVAlign = function(valign) {
		ds_stack_push(prevVAlign, draw_get_valign());
		draw_set_valign(valign);
	};
	
	/**
	 * Reset the original vertical alignment value.
	 */
	static resetVAlign = function() {
		draw_set_valign(ds_stack_pop(prevVAlign));
	}
	
	/**
	 * Set the horizontal alignment of text, saving the prior value.
	 * @param {Constant.HAlign} halign
	 */
	static setHAlign = function(halign) {
		ds_stack_push(prevHAlign, draw_get_halign());
		draw_set_halign(halign);
	};
	
	/**
	 * Reset the original horizontal alignment value.
	 */
	static resetHAlign = function() {
		draw_set_halign(ds_stack_pop(prevHAlign));
	}
	
	/**
	 * Set the draw colour, saving the prior value.
	 * @param {Constant.Color|Real} colour
	 * @param {Real} [alpha]
	 */
	static setColour = function(colour, alpha = draw_get_alpha()) {
		
		ds_stack_push(prevColour, draw_get_colour());
		draw_set_colour(colour);
		
		ds_stack_push(prevAlpha, draw_get_alpha());
		draw_set_alpha(alpha);
		
	};
	
	/**
	 * Reset the original horizontal alignment value.
	 */
	static resetColour = function() {
		draw_set_colour(ds_stack_pop(prevColour));
		draw_set_alpha(ds_stack_pop(prevAlpha));
	}
	
}

HLGuiDrawUtils();
