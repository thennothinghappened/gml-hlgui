
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
	
	static sizing = {
		titleBarHeight: 20,
		paddingX: 20
	};
	
	static measureHeight = function(width) {
		
		var height = 0;
		height += HLGuiMenu.sizing.titleBarHeight;
		
		for (var i = 0; i < self.__num_children; i ++) {
			var widget = self.children[i];
			height += widget.getMeasuredHeight(width);
		}
		
		return height;
		
	};
	
	static draw = function(x, y, width, height) {
		
		draw_set_colour(c_grey);
		draw_set_alpha(0.7);
		
		var childX = x + HLGuiMenu.sizing.paddingX;
		var childY = y;
		childY += HLGuiMenu.sizing.titleBarHeight;
		
		for (var i = 0; i < self.__num_children; i ++) {
			
			var widget = self.children[i];
			var widgetHeight = widget.getMeasuredHeight(width);
			
			widget.draw(x + HLGuiMenu.sizing.paddingX, childY, width - HLGuiMenu.sizing.paddingX, widgetHeight);
			
		}
		
	};
	
}
