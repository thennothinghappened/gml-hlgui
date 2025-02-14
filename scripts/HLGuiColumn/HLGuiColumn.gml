
/**
 * A column, which contains a list of child nodes to be arranged vertically.
 *
 * @param {Array<Struct.HLGuiWidget>} children List of child widgets.
 * @param {Real} [spacing] The spacing between child elements vertically. Defaults to 0.
 * @param {Bool} [visible] Whether this widget is initially visible.
 */
function HLGuiColumn(children, spacing = 0, visible) : HLGuiNodeWidget(children, visible) constructor {
	
	self.spacing = spacing;
	
	static measureHeight = function(width) {
		
		var height = 0;
		
		for (var i = 0; i < self.__num_children; i ++) {
			
			var widget = self.children[i];
			
			if (!widget.visible) {
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
			
			if (!widget.visible) {
				continue;
			}
			
			var widgetHeight = widget.getMeasuredHeight(width);
			
			widget.drawInLayout(x, childY, width, widgetHeight);
			childY += widgetHeight + spacing;
			
		}
		
	};
	
}

new HLGuiColumn([]);
