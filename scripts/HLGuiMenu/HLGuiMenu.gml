
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
) : HLGuiNodeWidget(children) constructor {
	
	self.title = title;
	self.x = x;
	self.y = y;
	self.width = width;
	self.visible = visible;
	self.closable = closable;
	
	static titleBarHeight = 20;
	static paddingX = 20;
	
	static measureHeight = function(width) {
		
		var height = 0;
		height += titleBarHeight;
		
		for (var i = 0; i < self.__num_children; i ++) {
			var widget = self.children[i];
			height += widget.getMeasuredHeight(width);
		}
		
		return height;
		
	};
	
	static draw = function(x, y, width, height) {
		
		draw_set_colour(c_grey);
		draw_set_alpha(0.7);
		
		var childX = x + paddingX;
		var childY = y;
		childY += titleBarHeight;
		
		for (var i = 0; i < self.__num_children; i ++) {
			
			var widget = self.children[i];
			var widgetHeight = widget.getMeasuredHeight(width);
			
			widget.drawInLayout(x + paddingX, childY, width - paddingX, widgetHeight);
			childY += widgetHeight;
			
		}
		
	};
	
	static getTargetWidget = function(x, y, width, height, mouseX, mouseY) {
		
		if (!point_in_rectangle(mouseX, mouseY, x, y, x + width, y + height)) {
			return undefined;
		}
		
		if (mouseY - y < titleBarHeight) {
			return self;
		}
		
		var childX = x + paddingX;
		var childY = y;
		childY += titleBarHeight;
		
		for (var i = 0; i < self.__num_children; i ++) {
			
			var widget = self.children[i];
			var widgetHeight = widget.getMeasuredHeight(width);
			var target = widget.getTargetWidget(x + paddingX, childY, width - paddingX, widgetHeight, mouseX, mouseY);
			
			if (target != undefined) {
				return target;
			}
			
			childY += widgetHeight;
			
		}
		
		return undefined;
		
	}
	
}
