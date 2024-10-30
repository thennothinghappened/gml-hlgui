
/**
 * Generic GUI widget, effectively an interface describing what widgets should look like.
 */
function HLGuiWidget() constructor {
	
	/**
	 * The cached height value from previously measuring this widget.
	 * @type {Real|undefined}
	 */
	self.cachedHeight = undefined;
	HLGUIFeatherHint { self.cachedHeight = 0; }
	
	/**
	 * The width value for which the cached height value was defined.
	 * If this value is `undefined` or otherwise does not match the current `width`, a `measureHeight` call will be made.
	 * @type {Real|undefined}
	 */
	self.cachedHeightWasFor = undefined;
	HLGUIFeatherHint { self.cachedHeightWasFor = 0; }
	
	/**
	 * The parent widget that owns this widget.
	 * @type {Struct.HLGuiWidget|undefined}
	 */
	self.parent = undefined;
	HLGUIFeatherHint { self.parent = new HLGuiWidget(); }
	
	/**
	 * The GUI instance that owns this widget.
	 * @type {Struct.HLGui|undefined}
	 */
	self.gui = undefined;
	HLGUIFeatherHint { self.gui = new HLGui([]); }
	
	/**
	 * The previous position this widget was drawn to in the layout.
	 */
	self.previousLayoutPos = {
		x: 0,
		y: 0,
		width: 0,
		height: 0
	};
	
	/**
	 * Return whether this widget is currently focused in the GUI.
	 * @returns {Bool}
	 */
	static isFocused = function() {
		return self.gui.focusedWidget == self;
	}
	
	/**
	 * Return whether this widget is currently hovered in the GUI.
	 * @returns {Bool}
	 */
	static isHovered = function() {
		return self.gui.hoveredWidget == self;
	}
	
	/**
	 * Return the measured height of this widget for the given size.
	 * If the cached value does not exist, or is in-applicable, then this widget is re-measured.
	 * 
	 * @param {Real} width The width of the menu containing this widget.
	 * @returns {Real} The height required by this widget.
	 */
	static getMeasuredHeight = function(width) {
		
		if (self.cachedHeightWasFor == width) {
			return self.cachedHeight;
		}
		
		self.cachedHeight = self.measureHeight(width);
		self.cachedHeightWasFor = width;
		
		return self.cachedHeight;
		
	};
	
	/**
	 * Clear the cached measure height.
	 */
	static clearMeasuredHeight = function() {
		self.cachedHeightWasFor = undefined;
	};
	
	/**
	 * The function used to measure the height of this widget.
	 * This is called by `getMeasuredHeight` where no cached value exists.
	 * 
	 * @param {Real} width The width of the menu containing this widget.
	 * @returns {Real} The height required by this widget.
	 */
	static measureHeight = function(width) {
		return 0;
	};
	
	/**
	 * The customisable draw function for drawing this widget to the screen.
	 * 
	 * @param {Real} x Leftmost position of widget bounds.
	 * @param {Real} y Topmost position of widget bounds.
	 * @param {Real} width Width of widget bounds.
	 * @param {Real} height Height of widget bounds, obtained from measuring.
	 */
	static draw = function(x, y, width, height) {
		return;
	};
	
	/**
	 * Draw this widget at the given position and size, obtained from measuring earlier.
	 * This is the correct function to call when drawing the widget to the GUI, as it correctly caches positional values needed by the GUI.
	 * 
	 * @param {Real} x Leftmost position of widget bounds.
	 * @param {Real} y Topmost position of widget bounds.
	 * @param {Real} width Width of widget bounds.
	 * @param {Real} height Height of widget bounds, obtained from measuring.
	 */
	static drawInLayout = function(x, y, width, height) {
		
		self.previousLayoutPos.x = x;
		self.previousLayoutPos.y = y;
		self.previousLayoutPos.width = width;
		self.previousLayoutPos.height = height;
		
		self.draw(x, y, width, height);
		
	}
	
	/**
	 * Callback to run whenever the mouse interacts with this widget in some way.
	 * 
	 * @param {Real} x Leftmost position of widget bounds.
	 * @param {Real} y Topmost position of widget bounds.
	 * @param {Real} width Width of widget bounds.
	 * @param {Real} height Height of widget bounds, obtained from measuring.
	 * @param {Real} mouseX Mouse X position on screen.
	 * @param {Real} mouseY Mouse Y position on screen.
	 * @param {Real} mouseDeltaX Mouse X movement.
	 * @param {Real} mouseDeltaY Mouse Y movement.
	 * @param {Real} update The update that has occurred.
	 */
	static onMouseUpdate = function(
		x,
		y,
		width,
		height,
		mouseX,
		mouseY,
		mouseDeltaX,
		mouseDeltaY,
		update
	) {
		return;
	};
	
	/**
	 * Code to run on gaining focus on this widget.
	 */
	static onFocusGained = function() {
		return;
	};
	
	/**
	 * Code to run on losing focus on this widget.
	 */
	static onFocusLost = function() {
		return;
	};
	
	/**
	 * Code to run on beginning to hover over this widget.
	 */
	static onHoverStart = function() {
		return;
	};
	
	/**
	 * Code to run on ceasing to hover over this widget.
	 */
	static onHoverStop = function() {
		return;
	};
	
	/**
	 * Get the target widget the mouse is hovering over within this widget, if any apply that should take focus.
	 * 
	 * @param {Real} x Leftmost position of widget bounds.
	 * @param {Real} y Topmost position of widget bounds.
	 * @param {Real} width Width of widget bounds.
	 * @param {Real} height Height of widget bounds, obtained from measuring.
	 * @param {Real} mouseX Mouse X position on screen.
	 * @param {Real} mouseY Mouse Y position on screen.
	 * @returns {Struct.HLGuiWidget|undefined}
	 */
	static getTargetWidget = function(x, y, width, height, mouseX, mouseY) {
		return undefined;
	};
	
	/**
	 * Basic `point_in_rectangle` implementation of `getTargetWidget`, for use in basic leaf elements that consume their entire space.
	 * 
	 * @param {Real} x Leftmost position of widget bounds.
	 * @param {Real} y Topmost position of widget bounds.
	 * @param {Real} width Width of widget bounds.
	 * @param {Real} height Height of widget bounds, obtained from measuring.
	 * @param {Real} mouseX Mouse X position on screen.
	 * @param {Real} mouseY Mouse Y position on screen.
	 * @returns {Struct.HLGuiWidget|undefined}
	 */
	static __getTargetWidgetPointInRect = function(x, y, width, height, mouseX, mouseY) {
		if (point_in_rectangle(mouseX, mouseY, x, y, x + width, y + height)) {
			return self;
		}
	};
	
}
