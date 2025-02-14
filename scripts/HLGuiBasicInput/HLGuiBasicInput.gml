
/**
 * A basic textual input.
 * 
 * @param {Function} get `() -> String` | Get the current backing value.
 * @param {Function} set `(String) -> undefined` | Set the current backing value.
 */
function HLGuiBasicInput(get, set) : HLGuiWidget() constructor {
	
	self.get = get;
	self.set = set;
	self.text = "";
	self.caretColumn = 0;
	
	static measureHeight = function(width) {
		return string_height_ext(self.text, -1, width);
	};
	
	static draw = function(x, y, width, height) {
		
		draw_text_ext(x, y, self.text, -1, width);
		
		if (!self.isFocused()) {
			return;
		}
		
		var textBeforeCaret = string_copy(self.text, 1, self.caretColumn);
		
		var lineHeight = string_height("0");
		var caretX = x + string_width_ext(textBeforeCaret, -1, width);
		var caretY = y + max(lineHeight, string_height_ext(textBeforeCaret, -1, width)) - lineHeight;
		
		draw_rectangle(caretX, caretY, caretX + 4, caretY + lineHeight, sin(current_time / 240) > 0);
		
	};
	
	static ensureLayoutValid = function() {
		
		var text = self.get();
		
		if (self.text != text) {
			self.text = text;
			self.invalidateLayout();
		}
		
	};
	
	static focusTick = function() {
		
		if (keyboard_check_pressed(vk_backspace)) {
			
			if (self.caretColumn < 1) {
				return;
			}
			
			self.set(string_delete(self.text, self.caretColumn, 1));
			self.caretColumn = max(0, self.caretColumn - 1);
			
			return;
			
		}
		
		if (keyboard_check_pressed(vk_delete)) {
			
			if (self.caretColumn == string_length(self.text)) {
				return;
			}
			
			self.set(string_delete(self.text, self.caretColumn + 1, 1));
			return;
			
		}
		
		// Hacky solution to user input. We should ideally not be messing with `keyboard_string` directly, but I'm already thinking
		// about re-writing this UI system anyway when UI layers come out (and/or flexpanels get powerful enough to do text measuring.)
		var input = keyboard_string;
		
		// Oh, the joys of OS-dependent key code shenanigans.
		input = string_replace_all(input, @"", "");
		
		var inputLength = string_length(input);
		keyboard_string = "";
		
		if (inputLength > 0) {
			self.set(string_insert(input, self.text, self.caretColumn + 1));
			self.caretColumn += inputLength;
			return;
		}
		
	};
	
	static onMouseUpdate = function(update) {
		
		if (update & HLGuiMouseData.LeftPress) {
			self.gui.requestFocus();
		}
		
	};
	
	static onHoverStop = function() {
		
	};
	
	static onFocusGained = function() {
		keyboard_string = "";
	};
	
	static onFocusLost = function() {
		keyboard_string = "";
	};
	
	static getTargetWidget = __getTargetWidgetPointInRect;
	
	static toString = function() {
		return $"{instanceof(self)}(get={get}, set={set})";
	};
	
}
