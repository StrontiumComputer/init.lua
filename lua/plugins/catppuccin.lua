return {
    "catppuccin/nvim",
    name = "catppuccin",
    priority = 1000,
    lazy = false,
    config = function()
        require("catppuccin").setup({
            cmp = true,
            telescope = {
                enabled = true,
            },
            alpha = true,
            mason = true,
            harpoon = true,
            treesitter_context = true,
            treesitter = true,
            nvimtree = true,
            fidget = true,
            rainbow_delimiters = true,
            noice = true,

            background = { -- :h background
                light = "latte",
                dark = "mocha",
            },

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
    end,
}
