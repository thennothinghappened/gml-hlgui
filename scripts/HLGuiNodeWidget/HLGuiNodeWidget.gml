
/**
 * A widget which represents a node, which can have child widgets.
 * @param {Array<Struct.HLGuiWidget>} children List of child widgets.
 * @param {Bool} [visible] Whether this widget is initially visible.
 */
function HLGuiNodeWidget(children, visible) : HLGuiWidget(visible) constructor {
	
	self.children = children;
	self.__num_children = array_length(self.children);
	
	array_foreach(self.children, function(child) {
		child.parent = self;
	});
	
}
