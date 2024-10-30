
/**
 * A checkbox for a boolean value.
 *
 * @param {String} label The label for this checkbox.
 * @param {Function} get `() -> Bool` | Get whether the checkbox is chcked.
 * @param {Function} set `(Bool) -> undefined` | Set whether the checkbox is checked.
 */
function HLGuiCheckbox(label, get, set) : HLGuiWidget() constructor {
	
	self.label = label;
	self.get = get;
	self.set = set;
	
	static checkboxSize = 16;
	static checkboxTickWidth = 4;
	static textPaddingWidth = 16;
	static textLeft = checkboxSize + textPaddingWidth;
	
	static measureHeight = function(width) {
		return max(checkboxSize, string_height_ext(self.label, -1, width - textLeft));
	};
	
	static draw = function(x, y, width, height) {
		
		var checked = self.get();
		
		if (checked) {
			draw_line_width(x, y + 10, x + (checkboxSize / 2), y + checkboxSize, checkboxTickWidth);
			draw_line_width(x + (checkboxSize / 2), y + checkboxSize, x + checkboxSize, y, checkboxTickWidth);
		}
		
		legacy_source_highlight(x, y, checkboxSize, checkboxSize, !self.isHovered());
		
		// TODO: multi-line text - put checkbox in middle to account for it.
		HLGuiDrawUtils.setVAlign(fa_middle);
		draw_text_ext(x + textLeft, y + (checkboxSize / 2), self.label, -1, width - textLeft);
		HLGuiDrawUtils.resetVAlign();
		
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
			self.set(!self.get());
		}
		
	};
	
	static getTargetWidget = HLGuiWidget.__getTargetWidgetPointInRect;
	
}
