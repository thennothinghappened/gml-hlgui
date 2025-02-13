
/**
 * Returns whether we're running on GMRT or not.
 * 
 * @returns {Bool}
 */
function __HLGuiIsGMRT() {
	
	static val = undefined;
	
	if (val == undefined) {
		// The current runtime still hasn't received `GM_runtime_type`, so it errors upon access. This sucks since we
		// thus cannot make this check compile-time.
		try {
			val = (GM_runtime_type == "gmrt");
		} catch (_) {
			val = false;
		}
	}
	
	return val;
	
}
__HLGuiIsGMRT();

#macro HLGuiIsGMRT (__HLGuiIsGMRT())
