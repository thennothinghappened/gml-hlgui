
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
	
	return self;
	
}

HLGuiDebug();
