
/**
 * Controller instance for the GUI.
 * @param {Array<Struct.HLGuiMenu>} menus List of game menus.
 */
function HLGui(menus) constructor {
	
	self.menus = menus;
	self.__num_menus = array_length(self.menus);
	
	self.mouseX = 0;
	self.mouseY = 0;
	self.mouseDeltaX = 0;
	self.mouseDeltaY = 0;
	
	self.hoveredWidget = undefined;
	HLGUIFeatherHint { self.hoveredWidget = new HLGuiWidget(); }
	
	self.focusedWidget = undefined;
	HLGUIFeatherHint { self.focusedWidget = new HLGuiWidget(); }
	
	array_foreach(self.menus, self.__recurseWidgetSetGui);
	
	static update = function(x, y, width, height) {
		
		var oldMouseX = self.mouseX;
		var oldMouseY = self.mouseY;
		
		self.mouseX = device_mouse_x_to_gui(0);
		self.mouseY = device_mouse_y_to_gui(0);
		self.mouseDeltaX = self.mouseX - oldMouseX;
		self.mouseDeltaY = self.mouseY - oldMouseY;
		
		var mouseInput = self.__mouseInputUpdateData();
		
		if (self.mouseDeltaX != 0 || self.mouseDeltaY != 0) {
			
			mouseInput |= HLGuiMouseData.Move;
			
			var target = undefined;
			
			// Iterate menus from closest to furthest to find the new hover target.
			for (var i = self.__num_menus - 1; i >= 0; i --) {
			
				var menu = self.menus[i];
			
				if (!menu.visible) {
					continue;
				}
			
				target = menu.getTargetWidget(
					menu.x,
					menu.y,
					menu.width,
					menu.getMeasuredHeight(menu.width),
					self.mouseX,
					self.mouseY
				);
			
				if (target != undefined) {
					break;
				}
			
			}
		
			self.__setHovered(target);
			
		}
		
		if (self.hoveredWidget != undefined && mouseInput > 0) {
			self.hoveredWidget.onMouseUpdate(
				self.hoveredWidget.previousLayoutPos.x,
				self.hoveredWidget.previousLayoutPos.y,
				self.hoveredWidget.previousLayoutPos.width,
				self.hoveredWidget.previousLayoutPos.height,
				self.mouseX,
				self.mouseY,
				self.mouseDeltaX,
				self.mouseDeltaY,
				mouseInput
			);
		}
		
	};
	
	/**
	 * Draw the GUI to the given position and size.
	 * 
	 * @param {Real} x X position to draw to.
	 * @param {Real} y Y position to draw to.
	 * @param {Real} width Width of the drawing area.
	 * @param {Real} height Height of the drawing area.
	 */
	static draw = function(x, y, width, height) {
		
		for (var i = 0; i < self.__num_menus; i ++) {
			
			var menu = self.menus[i];
			
			if (!menu.visible) {
				break;
			}
			
			var menuHeight = menu.getMeasuredHeight(menu.width);
			menu.draw(x + menu.x, y + menu.y, menu.width, menuHeight);
			
		}
		
	};
	
	/**
	 * Request focus for the given widget. If none is specified, the call must come from a widget, as `other` is used.
	 * @param {Struct.HLGuiWidget} [widget] The widget to focus.
	 */
	static requestFocus = function(widget = other) {
		
		if (self.focusedWidget != undefined) {
			self.focusedWidget.onFocusLost();
		}
		
		self.focusedWidget = widget;
		self.focusedWidget.onFocusGained();
		
	};
	
	/**
	 * @ignore
	 * Set the hovered widget.
	 * @param {Struct.HLGuiWidget|undefined} widget The widget to hover.
	 */
	static __setHovered = function(widget) {
		
		if (self.hoveredWidget == widget) {
			return;
		}
			
		if (self.hoveredWidget != undefined) {
			self.hoveredWidget.onHoverStop();
		}
			
		if (widget != undefined) {
			widget.onHoverStart();
		}
		
		self.hoveredWidget = widget;
		
	}
	
	/**
	 * @ignore
	 * Append mouse input data to the given mouse event packet.
	 *
	 * @param {Real} [update] Existing update packet.
	 */
	static __mouseInputUpdateData = function(update = int64(0)) {
		
		if (mouse_check_button_pressed(mb_left)) {
			update |= HLGuiMouseData.LeftPress;
		}
		
		if (mouse_check_button_released(mb_left)) {
			update |= HLGuiMouseData.LeftRelease;
		}
		
		if (mouse_check_button_pressed(mb_right)) {
			update |= HLGuiMouseData.RightPress;
		}
		
		if (mouse_check_button_released(mb_right)) {
			update |= HLGuiMouseData.RightRelease;
		}
		
		return update;
		
	}
	
	/**
	 * @ignore
	 * Recursively take ownership of the given widget and its children.
	 * @param {Struct.HLGuiWidget} widget
	 */
	static __recurseWidgetSetGui = function(widget) {
		
		widget.gui = self;
		
		if (is_instanceof(widget, HLGuiNodeWidget)) {
			array_foreach(widget.children, self.__recurseWidgetSetGui);
		}
		
	}
	
}

enum HLGuiMouseData {
	Move		= 0b00001,
	LeftPress	= 0b00010,
	LeftRelease	= 0b00100,
	RightPress	= 0b01000,
	RightRelease= 0b10000,
}