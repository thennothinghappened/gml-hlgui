
/**
 * A row, which contains a list of child nodes to be arranged horizontally. Each node is given equal space.
 * 
 * @param {Array<Struct.HLGuiWidget>} children List of child widgets.
 * @param {Real} [spacing] The spacing between child elements horizontally. Defaults to 0.
 * @param {Bool} [visible] Whether this widget is initially visible.
 */
function HLGuiRow(children, spacing = 0, visible) : HLGuiNodeWidget(children, visible) constructor {
	
	self.spacing = spacing;
	
	static measureHeight = function(width) {
		return method(self, HLGuiBox.measureHeight)(width);
	};
	
	static draw = function(x, y, width, height) {
		
		var visibleChildCount = 0;
		
		for (var i = 0; i < self.__num_children; i ++) {
			
			var widget = self.children[i];
			
			if (widget.visible) {
				visibleChildCount ++;
			}
			
		}
		
		if (visibleChildCount == 0) {
			return;
		}
		
		var childWidth = (width - (self.spacing * (visibleChildCount - 1))) / visibleChildCount;
		var childX = x;
		
		HLGuiDebug.assertEq((childWidth * visibleChildCount + self.spacing * (visibleChildCount - 1)), width);
		
		for (var i = 0; i < self.__num_children; i ++) {
			
			var widget = self.children[i];
			
			if (!widget.visible) {
				continue;
			}
			
			var widgetHeight = widget.getMeasuredHeight(width);
			
			widget.drawInLayout(childX, y, childWidth, widgetHeight);
			childX += childWidth + self.spacing;
			
		}
		
	};
	
}

new HLGuiRow([]);
