
/**
 * A column, which contains a list of child nodes to be arranged vertically.
 *
 * @param {Array<Struct.HLGuiWidget>} children List of child widgets.
 * @param {Real} [spacing] The spacing between child elements vertically. Defaults to 0.
 */
function HLGuiColumn(children, spacing = 0) : HLGuiNodeWidget(children) constructor {
	
	self.spacing = spacing;
	
	static measureHeight = function(width) {
		
		var height = 0;
		
		for (var i = 0; i < self.__num_children; i ++) {
			
			var widget = self.children[i];
			
			if (!widget.getVisible()) {
				continue;
			}
			
			height += widget.getMeasuredHeight(width) + (spacing * (i != self.__num_children - 1));
			
		}
		
		return height;
		
	};
	
	static draw = function(x, y, width, height) {
		
		var childY = y;
		
		for (var i = 0; i < self.__num_children; i ++) {
			
			var widget = self.children[i];
			
			if (!widget.getVisible()) {
				continue;
			}
			
			var widgetHeight = widget.getMeasuredHeight(width);
			
			widget.drawInLayout(x, childY, width, widgetHeight);
			childY += widgetHeight + spacing;
			
		}
		
	};
	
}

new HLGuiColumn([]);
