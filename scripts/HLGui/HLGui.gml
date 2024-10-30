
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
	self.mousePrevTarget = undefined;
	
	self.hoveredWidget = undefined;
	self.focusedWidget = undefined;
	
	array_foreach(self.menus, self.__recurseWidgetSetGui);
	
	static update = function(x, y, width, height) {
		
		var oldMouseX = self.mouseX;
		var oldMouseY = self.mouseY;
		
		self.mouseX = device_mouse_x_to_gui(0);
		self.mouseY = device_mouse_y_to_gui(0);
		self.mouseDeltaX = self.mouseX - oldMouseX;
		self.mouseDeltaY = self.mouseY - oldMouseY;
		
		if (self.mouseDeltaX != 0 || self.mouseDeltaY != 0) {
			self.__mouseUpdate();
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
	 * Update the mouse state.
	 */
	static __mouseUpdate = function() {
		
		var target = undefined;
		var update = 0;
		
		// Iterate menus from closest to furthest to find 
		for (var i = self.__num_menus - 1; i > 0; i --) {
			
			var menu = self.menus[i];
			
			if (!menu.visible) {
				break;
			}
			
			if (point_in_rectangle(
				self.mouseX,
				self.mouseY,
				x + menu.x,
				y + menu.y,
				x + menu.x + menu.width,
				y + menu.y + menu.getMeasuredHeight(menu.width)
			)) {
				target = menu;
				break;
			}
			
		}
		
		if (target == undefined && self.mousePrevTarget == undefined) {
			return;
		}
		
		var update = self.__mouseInputUpdateData();
		
		if (self.mousePrevTarget != undefined && self.mousePrevTarget != target) {
			
			var menu = self.mousePrevTarget;
			
			if (!point_in_rectangle(
				self.mouseX,
				self.mouseY,
				x + menu.x,
				y + menu.y,
				x + menu.x + menu.width,
				y + menu.y + menu.getMeasuredHeight(menu.width)
			)) {
				menu.onMouseUpdate(
					x,
					y,
					width,
					height,
					mouseX,
					mouseY,
					mouseDeltaX,
					mouseDeltaY,
					update | HLGuiMouseData.Exit
				);
			}
			
		}
		
		if (target != undefined) {
			
			var posStateUpdate = HLGuiMouseData.Move;
			
			if (self.mousePrevTarget != target) {
				self.mousePrevTarget = target;
			}
			
			menu.onMouseUpdate(
				x,
				y,
				width,
				height,
				mouseX,
				mouseY,
				mouseDeltaX,
				mouseDeltaY,
				update | posStateUpdate
			);
			
		}
		
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
	Move		= 0b000000001,
	Enter		= 0b000000011,
	Exit		= 0b000000101,
	LeftPress	= 0b000001000,
	LeftRelease	= 0b000010000,
	RightPress	= 0b000100000,
	RightRelease= 0b001000000,
}
