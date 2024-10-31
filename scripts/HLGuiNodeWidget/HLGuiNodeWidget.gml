
/**
 * A widget which represents a node, which can have child widgets.
 * 
 * @param {Array<Struct.HLGuiWidget>} children List of child widgets.
 * @param {Bool} [visible] Whether this widget is initially visible.
 */
function HLGuiNodeWidget(children, visible) : HLGuiWidget(visible) constructor {
	
	self.children = children;
	self.__num_children = array_length(self.children);
	
	array_foreach(self.children, function(child) {
		child.parent = self;
	});
	
	/**
	 * Basic implementation that iterates over child positions and returns the first matching.
	 * 
	 * This implementation is suitable for elements that are not themselves focusable and are merely containers.
	 * This implementation is **not** suitable for layouts that overlap elements.
	 */
	static getTargetWidget = function(x, y) {
		
		if (__getTargetWidgetPointInRect(x, y) == undefined) {
			return undefined;
		}
		
		for (var i = 0; i < self.__num_children; i ++) {
			
			var widget = self.children[i];
			var target = widget.getTargetWidget(x, y);
			
			if (target != undefined) {
				return target;
			}
			
		}
		
		return undefined;
		
	};
	
}
