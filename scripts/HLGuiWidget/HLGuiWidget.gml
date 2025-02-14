
/**
 * Generic GUI widget, effectively an interface describing what widgets should look like.
 * @param {Bool} [visible] Whether this widget is initially visible.
 */
function HLGuiWidget(visible = true) constructor {
	
	/**
	 * The cached height value from previously measuring this widget.
	 * @type {Real|undefined}
	 */
	self.cachedHeight = undefined;
	HLGUIFeatherHint self.cachedHeight = 0;
	
	/**
	 * The width value for which the cached height value was defined.
	 * If this value is `undefined` or otherwise does not match the current `width`, a `measureHeight` call will be made.
	 * @type {Real|undefined}
	 */
	self.cachedHeightWasFor = undefined;
	HLGUIFeatherHint self.cachedHeightWasFor = 0;
	
	/**
	 * The parent widget that owns this widget.
	 * @type {Struct.HLGuiWidget|undefined}
	 */
	self.parent = undefined;
	HLGUIFeatherHint self.parent = new HLGuiWidget();
	
	/**
	 * The GUI instance that owns this widget.
	 * @type {Struct.HLGui|undefined}
	 */
	self.gui = undefined;
	HLGUIFeatherHint self.gui = new HLGui([]);
	
	/**
	 * The measured position of this widget in the layout.
	 */
	self.layoutPos = {
		x: 0,
		y: 0,
		width: 0,
		height: 0
	};
	
	/**
	 * Whether this widget is visible.
	 * @type {Bool}
	 */
	self.visible = visible;
	
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
		
		self.ensureLayoutValid();
		
		if (self.cachedHeightWasFor == width) {
			return self.cachedHeight;
		}
		
		self.cachedHeight = self.measureHeight(width);
		self.cachedHeightWasFor = width;
		
		return self.cachedHeight;
		
	};
	
	/**
	 * Invalidate the current layout, prompting a re-measure. This bubbles upward to affect all parents.
	 */
	static invalidateLayout = function() {
		
		self.cachedHeightWasFor = undefined;
		
		if (self.parent != undefined) {
			self.parent.invalidateLayout();
		}
		
	};
	
	/**
	 * Set whether this widget is visible. Changes to the visibility of a widget bubble upwards and invalidate the layout
	 * of parent widgets.
	 * 
	 * @param {Bool} visible Whether this widget should be visible.
	 */
	static setVisible = function(visible) {
		
		if (self.visible == visible) {
			return;
		}
		
		self.visible = visible;
		self.invalidateLayout();
		
		if (!is_undefined(self.gui)) {
			self.gui.__notifyVisibilityChange();
		}
		
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
		
		self.layoutPos.x = x;
		self.layoutPos.y = y;
		self.layoutPos.width = width;
		self.layoutPos.height = height;
		
		if (HLGuiShowWidgetBounds) {
			
			var parentDepth = 0;
			var parent = self.parent;
			
			while (!is_undefined(parent)) {
				parent = parent.parent;
				parentDepth ++;
			}
			
			HLGuiDrawUtils.setColour(make_colour_hsv((parentDepth * 64) % 255, 255, 255), 0.8);
			draw_rectangle(x, y, x + width, y + height, true);
			HLGuiDrawUtils.resetColour();
			
		}
		
		self.draw(x, y, width, height);
		
	}
	
	/**
	 * Ensure that the layout of this widget is still valid. If it is no longer valid, `invalidateLayout()` must be called.
	 * accordingly. This method should be overridden for widgets that have backing data that may change unexpectedly.
	 * 
	 * Widgets for which this is not applicable to should not use this method.
	 */
	static ensureLayoutValid = function() {
		return;
	};
	
	/**
	 * Execute any logic that must run every UI update whilst the widget is in focus.
	 */
	static focusTick = function() {
		return;
	};
	
	/**
	 * Callback to run whenever the mouse interacts with this widget in some way.
	 * @param {Real} update The update that has occurred.
	 */
	static onMouseUpdate = function(update) {
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
	 * @param {Real} x Query X position.
	 * @param {Real} y Query Y position.
	 * @returns {Struct.HLGuiWidget|undefined}
	 */
	static getTargetWidget = function(x, y) {
		return undefined;
	};
	
	/**
	 * Basic `point_in_rectangle` implementation of `getTargetWidget`, for use in basic leaf elements that consume their entire space.
	 * 
	 * @param {Real} x Query X position.
	 * @param {Real} y Query Y position.
	 * @returns {Struct.HLGuiWidget|undefined}
	 */
	static __getTargetWidgetPointInRect = method(undefined, function(x, y) {
		
		if (point_in_rectangle(x, y, self.layoutPos.x, self.layoutPos.y, self.layoutPos.x + self.layoutPos.width, self.layoutPos.y + self.layoutPos.height)) {
			return self;
		}
		
	});
	
}
