
/**
 * A widget which represents a node, which can have child widgets.
 * @param {Array<Struct.HLGuiWidget>} children List of child widgets.
 */
function HLGuiNodeWidget(children) : HLGuiWidget() constructor {
	
	self.children = children;
	self.__num_children = array_length(self.children);
	
	array_foreach(self.children, function(child) {
		child.parent = self;
	});
	
	
}
