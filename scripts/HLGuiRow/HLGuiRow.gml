
/**
 * A row, which contains a list of child nodes to be arranged horizontally. Each node is given equal space.
 * 
 * @param {Array<Struct.HLGuiWidget>} children List of child widgets.
 * @param {Real} [spacing] The spacing between child elements horizontally. Defaults to 0.
 * @param {Bool} [visible] Whether this widget is initially visible.
 */
function HLGuiRow(children, spacing = 0, visible) : HLGuiNodeWidget(children, visible) constructor {
	
	self.spacing = spacing;
	self.childWidth = 0;
	
	static measureHeight = function(width) {
	
		var visibleChildCount = 0;
		
		for (var i = 0; i < self.__num_children; i ++) {
			
			var widget = self.children[i];
			
			if (widget.visible) {
				visibleChildCount ++;
			}
			
		}
		
		if (visibleChildCount == 0) {
			return 0;
		}
		
		self.childWidth = (width - (self.spacing * (visibleChildCount - 1))) / visibleChildCount;
		HLGuiDebug.assertEq(self.childWidth * visibleChildCount + self.spacing * (visibleChildCount - 1), width);
		
		var height = 0;
		
		for (var i = 0; i < self.__num_children; i ++) {
			
			var child = self.children[i];
			
			if (!child.visible) {
				continue;
			}
			
			var childHeight = child.getMeasuredHeight(self.childWidth);
			
			if (childHeight > height) {
				height = childHeight;
			}
			
			
		}
		
		return height;
		
	};
	
	static draw = function(x, y, width, height) {
		
		var childX = x;
		
		for (var i = 0; i < self.__num_children; i ++) {
			
			var child = self.children[i];
			
			if (!child.visible) {
				continue;
			}
			
			var childHeight = child.getMeasuredHeight(self.childWidth);
			child.drawInLayout(childX, y, self.childWidth, childHeight);
			childX += self.childWidth + self.spacing;
			
		}
		
	};
	
}

new HLGuiRow([]);
