require("colorizer").setup({
	filetypes = { "*" },
	user_default_options = {
		mode = "background",
		RRGGBBAA = true,
		AARRGGBB = true,
		tailwind = true,
		css = true,
		css_fn = true,
		sass = { enable = true, parsers = { "css" } },
	},
})
