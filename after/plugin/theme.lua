require("catppuccin").setup({
	transparent_background = true,
	cmp = true,
	telescope = {
		enabled = true,
	},
	alpha = true,
	mason = true,
	harpoon = true,
	treesitter_context = true,
	treesitter = true,

	native_lsp = {
		enabled = true,
		virtual_text = {
			errors = { "italic" },
			hints = { "italic" },
			warnings = { "italic" },
			information = { "italic" },
		},
		underlines = {
			errors = { "underline" },
			hints = { "underline" },
			warnings = { "underline" },
			information = { "underline" },
		},
		inlay_hints = {
			background = true,
		},
	},
})

vim.cmd.colorscheme("catppuccin")
