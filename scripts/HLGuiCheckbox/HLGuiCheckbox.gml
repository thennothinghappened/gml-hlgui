
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
	
	static checkSize = 16;
	static checkTickWidth = 4;
	static checkTickWidthHalf = (checkTickWidth / 2);
	static textPaddingWidth = 16;
	static textLeft = checkSize + textPaddingWidth;
	
	static measureHeight = function(width) {
		return max(checkSize, string_height_ext(self.label, -1, width - textLeft));
	};
	
	static draw = function(x, y, width, height) {
		
		var checked = self.get();
		
		if (checked) {
			
			var tickStartX = x + checkTickWidthHalf;
			var tickStartY = y + (checkSize / 2);
			var tickBaseX = x + (checkSize / 2);
			var tickBaseY = y + checkSize - checkTickWidthHalf;
			var tickEndX = x + checkSize - checkTickWidthHalf;
			var tickEndY = y + checkTickWidthHalf;
			
			draw_line_width(tickStartX, tickStartY, tickBaseX, tickBaseY, checkTickWidth);
			draw_line_width(tickBaseX, tickBaseY, tickEndX, tickEndY, checkTickWidth);
			
		}
		
		HLGuiDraw.sourceButtonOutline(x, y, checkSize, checkSize, !self.isHovered());
		
		// TODO: multi-line text - put checkbox in middle to account for it.
		HLGuiDrawUtils.setVAlign(fa_middle);
		draw_text_ext(x + textLeft, y + (checkSize / 2), self.label, -1, width - textLeft);
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
	
	static toString = function() {
		return $"{instanceof(self)}(label=`{self.label}`, value={self.get()})";
	};
	
}
