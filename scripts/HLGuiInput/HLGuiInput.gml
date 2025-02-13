
/**
 * An input box with a label.
 * 
 * @param {String} label A label for this input.
 * @param {Function} get `() -> String` | Get the current backing value.
 * @param {Function} set `(String) -> undefined` | Set the current backing value.
 * @returns {Struct.HLGuiColumn}
 */
function HLGuiInput(label, get, set) {
	return new HLGuiColumn([
		HLGuiLabel(label),
		new HLGuiBorderBox(4, 4, [new HLGuiBasicInput(get, set)])
	]);
}
