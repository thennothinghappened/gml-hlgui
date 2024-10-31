
/**
 * An instance of a HLGUI menu window.
 * 
 * @param {String} title Displayed title.
 * @param {Real} x GUI X position.
 * @param {Real} y GUI Y position.
 * @param {Real} width GUI menu width.
 * @param {Real} visible Whether this window is currently visible.
 * @param {Bool} closable Whether this menu is closable.
 * @param {Array<Struct.HLGuiWidget>} children List of menu widgets, to be layed out in vertical order.
 */
function HLGuiMenu(
	title,
	x,
	y,
	width,
	visible,
	closable,
	children
) : HLGuiNodeWidget(children, visible) constructor {
	
	self.title = title;
	self.x = x;
	self.y = y;
	self.width = width;
	self.closable = closable;
	
	self.boxMeasureHeight = method(self, HLGuiBox.measureHeight);
	self.boxDraw = method(self, HLGuiBox.draw);
	self.boxGetTargetWidget = method(self, HLGuiBox.getTargetWidget);
	
	static titleBarHeight = 20;
	static paddingX = 20;
	static paddingY = 20;
	
	static measureHeight = function(width) {
		return titleBarHeight + (paddingY * 2) + self.boxMeasureHeight(width);
	};
	
	static draw = function(x, y, width, height) {
		
		HLGuiDrawUtils.setColour(HLGuiDraw.colBackground, 0.9);
		draw_roundrect(x, y, x + width, y + height, false);
		HLGuiDrawUtils.resetColour();
		
		HLGuiDrawUtils.setColour(HLGuiDraw.colBackground);
		draw_line(x, y + titleBarHeight, x + width, y + titleBarHeight);
		HLGuiDrawUtils.resetColour();
		
		draw_text(x + 4, y, self.title);
		
		self.boxDraw(x + paddingX, y + paddingY + titleBarHeight, width - (paddingX * 2), height - (paddingY * 2));
		
	};
	
	static onMouseUpdate = function(update) {
		
		if (
			(update & HLGuiMouseData.LeftPress) && 
			(self.isHovered()) && 
			(self.gui.mouseY - self.layoutPos.y < titleBarHeight)
		) {
			self.gui.requestFocus();
		}
		
		if (!self.isFocused()) {
			return;
		}
		
		if (update & HLGuiMouseData.LeftRelease) {
			return self.gui.releaseFocus();
		}
		
		self.x += self.gui.mouseDeltaX;
		self.y += self.gui.mouseDeltaY;
		
	};
	
	static getTargetWidget = function(x, y) {
		
		if (__getTargetWidgetPointInRect(x, y) == undefined) {
			return undefined;
		}
		
		return self.boxGetTargetWidget(x, y) ?? self;
		
	}
	
	static toString = function() {
		return $"{instanceof(self)}(title=`{self.title}`, children={self.children})";
	};
	
}
