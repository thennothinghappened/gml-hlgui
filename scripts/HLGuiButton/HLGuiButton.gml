
/**
 * A button that you can click.
 * 
 * @param {String} label Text label for the button.
 * @param {Function} onClick `() -> undefined` | Callback on clicking this button.
 */
function HLGuiButton(label, onClick) : HLGuiWidget() constructor {
	
	self.label = label;
	self.onClick = onClick;
	
	static minHeight = 20;
	
	static measureHeight = function(width) {
		return max(minHeight, string_height(self.label));
	};
	
	static draw = function(x, y, width, height) {
		
		legacy_source_highlight(x, y, width, height, self.isHovered());
		
		HLGuiDrawUtils.setHAlign(fa_center);
		HLGuiDrawUtils.setVAlign(fa_middle);
		HLGuiDrawUtils.setColour(c_white);
		
		draw_text(x + width / 2, y + height / 2, self.label);
		
		HLGuiDrawUtils.resetHAlign();
		HLGuiDrawUtils.resetVAlign();
		HLGuiDrawUtils.resetColour();
		
	};
	
	static onMouseUpdate = function(
		x,
		y,
		width,
		height,
		mouseX,
		mouseY,
		mouseDeltaX,
		mouseDeltaY,
		update
	) {
		if (update & HLGuiMouseData.LeftRelease) {
			self.onClick();
		}
	};
	
	static getTargetWidget = HLGuiWidget.__getTargetWidgetPointInRect;
	
}
