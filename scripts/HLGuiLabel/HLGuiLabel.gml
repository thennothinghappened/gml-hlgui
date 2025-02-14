
/**
 * A basic text display that is expected to never change.
 * 
 * @param {String} text The text to be displayed.
 */
function HLGuiLabel(text) {
	
	var label = new HLGuiText(method({ text }, function() { 
		return text;
	}));
	
	label.ensureLayoutValid = function() {
		return;
	};
	
	label.text = label.get();
	return label;
	
}
