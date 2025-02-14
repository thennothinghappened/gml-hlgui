
/**
 * A box layout, which simply displays child elements and takes the size of the largest one.
 *
 * @param {Array<Struct.HLGuiWidget>} children List of child widgets.
 * @param {Bool} [visible] Whether this widget is initially visible.
 */
function HLGuiBox(children, visible) : HLGuiNodeWidget(children, visible) constructor {
	
	static measureHeight = function(width) {
		
		var height = 0;
		
		for (var i = 0; i < self.__num_children; i ++) {
			
			var widget = self.children[i];
			
			if (widget.visible) {
				height = max(height, widget.getMeasuredHeight(width));
			}
			
		}
		
		return height;
		
	};
	
	static draw = function(x, y, width, height) {
		
		for (var i = 0; i < self.__num_children; i ++) {
			
			var widget = self.children[i];
			
			if (!widget.visible) {
				continue;
			}
			
			var widgetHeight = widget.getMeasuredHeight(width);
			
			widget.drawInLayout(x, y, width, widgetHeight);
			
		}
		
	};
	
	static getTargetWidget = function(x, y) {
		
		if (__getTargetWidgetPointInRect(x, y) == undefined) {
			return undefined;
		}
		
		// Recurse backwards over children from top-down to find intersection.
		for (var i = (self.__num_children - 1); i >= 0; i --) {
			
			var widget = self.children[i];
			
			if (!widget.visible) {
				continue;
			}
			
			var target = widget.getTargetWidget(x, y);
			
			if (target != undefined) {
				return target;
			}
			
		}
		
		return undefined;
		
	};
	
}

new HLGuiBox([]);