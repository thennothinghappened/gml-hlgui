
/**
 * Populate an array called `args` with the arguments for the current function.
 */
#macro HLGuiArgsArray var args = array_create(argument_count);	\
	for (var i = 0; i < argument_count; i ++) {					\
		args[i] = argument[i];									\
	}
