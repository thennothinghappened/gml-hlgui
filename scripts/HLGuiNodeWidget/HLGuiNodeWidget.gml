
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
	static __getTargetWidgetOfChildren = method(undefined, function(x, y) {
		
		for (var i = 0; i < self.__num_children; i ++) {
			
			var widget = self.children[i];
			var target = widget.getTargetWidget(x, y);
			
			if (target != undefined) {
				return target;
			}
			
		}
		
		return undefined;
		
	});
	
	/**
	 * Insert a new child to this node.
	 * Calls to this method will invalidate the layout.
	 * 
	 * @param {Real} index The index at which to insert the child elements.
	 * @param {Struct.HLGuiWidget} ... List of children to be inserted.
	 */
	static insert = function(index) {
		
		var count = argument_count - 1;
		
		self.__num_children += count;
		self.invalidateLayout();
		
		// Avoid allocating an array if there's only one element.
		if (count == 1) {
			array_insert(self.children, index, argument[1]);
			return;
		}
		
		var argsArray = array_create(count + 2);
		argsArray[0] = self.children;
		argsArray[1] = index;
		
		for (var i = 1; i < argument_count; i ++) {
			
			var child = argument[i];
			child.parent = self;
			child.gui = self.gui;
			
			argsArray[i + 1] = child;
			
		}
		
		script_execute_ext(array_insert, argsArray);
		
	};
	
	/**
	 * Insert a new child to this node.
	 * Calls to this method will invalidate the layout.
	 * 
	 * @param {Struct.HLGuiWidget} ... List of children to be appended.
	 */
	static append = function() {
		
		HLGuiArgsArray;
		
		array_insert(args, 0, array_length(self.children));
		method_call(self.insert, args);
		
	};
	
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
		
		return __getTargetWidgetOfChildren(x, y);
		
	};
	
	static toString = function() {
		return $"{instanceof(self)}(visible={visible}, children={children})";
	};
	
}
