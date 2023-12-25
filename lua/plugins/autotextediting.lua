return {
    {
        "altermo/ultimate-autopair.nvim",
        event = { "InsertEnter", "CmdlineEnter" },
        branch = "v0.6", --recomended as each new version will have breaking changes
        opts = {
            --Config goes here
        },
    },
    {
        "windwp/nvim-ts-autotag",
        event = "VeryLazy",
    },
    {
        "kylechui/nvim-surround",
        version = "*", -- Use for stability; omit to use `main` branch for the latest features
        event = "VeryLazy",
        config = function()
            require("nvim-surround").setup({
                -- Configuration here, or leave empty to use defaults
            })
        end,
    },
    { "lukas-reineke/indent-blankline.nvim",
        config = function ()

            require("ibl").setup()
        end
    },
    { "tpope/vim-surround" },
    {
        "github/copilot.vim",
        config = function ()
            vim.g.copilot_assume_mapped = true
        end
    },
}
