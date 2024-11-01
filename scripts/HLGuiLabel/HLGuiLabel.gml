
/**
 * A basic text display that is expected to never change.
 * @param {String} text The text to be displayed.
 */
function HLGuiLabel(text) : HLGuiText(method({ text }, function() { return text; })) constructor {
	
	static ensureLayoutValid = function() {
		return;
	};
	
}
