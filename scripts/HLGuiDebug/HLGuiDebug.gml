
/**
 * Whether debug assertions should be enabled in code.
 */
#macro HLGuiAsserts true

/**
 * Whether a box should be drawn around each widget's bounding box.
 */
#macro HLGuiShowWidgetBounds false

/**
 * Debugging utilities for the HLGui.
 */
function HLGuiDebug() {
	
	/**
	 * Format the given binary `value` number as a string.
	 * 
	 * @param {Real} value The value to format.
	 * @param {Real} [size] The number of bits to display (laziness in coding.)
	 * @returns {String}
	 */
	static formatBinary = function(value, size = 16) {
		
		var str = "";
		
		for (var i = (size - 1); i >= 0; i --) {
			str += ((value >> i) & 1)
				? "1"
				: "0";
	    }
		
		return str;
		
	}
	
	/**
	 * Assert that the given `condition` is true, if debug assertions are enabled. If assertions are not enabled,
	 * no action is taken.
	 * 
	 * @param {Bool} condition The condition to assert true.
	 * @param {String} message The error message to display.
	 */
	static assert = function(condition, message) {
		
		gml_pragma("forceinline");
		
		if (HLGuiAsserts) {
			if (!condition) {
				throw $"Assertion failed!: {message}";
			}
		}
		
	}
	
	/**
	 * Assert that `lhs` is equal to `rhs`, if debug assertions are enabled. If assertions are not enabled,
	 * no action is taken.
	 * 
	 * @param {Any} lhs The left-side expression.
	 * @param {Any} rhs The right-side expression.
	 */
	static assertEq = function(lhs, rhs) {
		
		gml_pragma("forceinline");
		
		if (HLGuiAsserts) {
			assert(lhs == rhs, $"{lhs} == {rhs}");
		}
		
	}
	
	return self;
	
}

HLGuiDebug();
