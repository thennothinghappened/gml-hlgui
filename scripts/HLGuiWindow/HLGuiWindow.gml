
/**
 * A window widget, which is a special top-level widget which defines a position and size on-screen.
 * 
 * @param {Real} x GUI X position.
 * @param {Real} y GUI Y position.
 * @param {Real} width GUI menu width.
 * @param {Bool} visible Whether this window is currently visible.
 * @param {Array<Struct.HLGuiWidget>} children List of menu widgets, to be layed out in vertical order.
 */
function HLGuiWindow(
	x,
	y,
	width,
	visible,
	children,
) : HLGuiBox(children, visible) constructor {
	 
	self.x = x;
	self.y = y;
	self.width = width;
	
	static toString = function() {
		return $"{instanceof(self)}(x={x}, y={y}, width={width}, visible={visible}, children={children})";
	};
	
}
