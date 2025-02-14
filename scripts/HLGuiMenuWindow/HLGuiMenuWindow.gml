
/**
 * An instance of a HLGUI menu window.
 * 
 * @param {String} title Displayed title.
 * @param {Real} x GUI X position.
 * @param {Real} y GUI Y position.
 * @param {Real} width GUI menu width.
 * @param {Bool} visible Whether this window is currently visible.
 * @param {Bool} closable Whether this menu is closable.
 * @param {Array<Struct.HLGuiWidget>} children List of menu widgets, to be layed out in vertical order.
 */
function HLGuiMenuWindow(
	title,
	x,
	y,
	width,
	visible,
	closable,
	children
) : HLGuiWindow(x, y, width, visible, children) constructor {
	
	self.title = title;
	self.closable = closable;
	
	if (self.closable) {
		
		// This is pretty hacky unfortunately. hlgui is VERY close to being properly composition-based, but we kinda missed the mark a bit,
		// so doing composition hurts. No doubt I make *another* GUI system to replace it later, heh. But it serves its purpose as a debug UI well.
		self.closeButton = new HLGuiButton("X", function() {
			self.setVisible(false);
		});
		
		self.closeButton.parent = self;
		
	}
	
	self.boxMeasureHeight = method(self, HLGuiBox.measureHeight);
	self.boxDraw = method(self, HLGuiBox.draw);
	self.boxGetTargetWidget = method(self, HLGuiBox.getTargetWidget);
	
	static titleBarHeight = 20;
	static closeButtonWidth = 20;
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
		
		if (self.closable) {
			// Ensure the GUI gets set since the close button doesn't live in the proper heirarchy...
			self.closeButton.gui = self.gui;
			self.closeButton.drawInLayout(x + width - closeButtonWidth, y, closeButtonWidth, titleBarHeight);
		}
		 
		self.boxDraw(x + paddingX, y + paddingY + titleBarHeight, width - (paddingX * 2), height - (paddingY * 2));
		
	};
	
	static onMouseUpdate = function(update) {
		
		var localMouseY = self.gui.mouseY - self.layoutPos.y;
		
		if (self.isHovered() && (localMouseY < titleBarHeight) && (update & HLGuiMouseData.LeftPress)) {
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
		
		var localMouseX = x - self.layoutPos.x;
		var localMouseY = y - self.layoutPos.y;
		
		if (self.closable && (localMouseY < titleBarHeight) && (localMouseX >= self.width - closeButtonWidth)) {
			
			// Ensure the GUI gets set since the close button doesn't live in the proper heirarchy...
			self.closeButton.gui = self.gui;
			
			var target = self.closeButton.getTargetWidget(x, y);
			
			if (target != undefined) {
				return target;
			}
			
		}
		
		return self.boxGetTargetWidget(x, y) ?? self;
		
	}
	
	static toString = function() {
		return $"{instanceof(self)}(title=`{title}`, x={x}, y={y}, width={width}, visible={visible}, closable={closable}, children={children})";
	};
	
}
