return {
    {
        "neovim/nvim-lspconfig",
        dependencies = {
            {
                "folke/lazydev.nvim",
                ft = "lua", -- only load on lua files
                opts = {
                    library = {
                        -- See the configuration section for more details
                        -- Load luvit types when the `vim.uv` word is found
                        { path = "${3rd}/luv/library", words = { "vim%.uv" } },
                    },
                },
            },
            { "j-hui/fidget.nvim", opts = {} },
        },
        config = function ()
            -- Some UI edits
            vim.lsp.inlay_hint.enable()
            vim.diagnostic.config({
                virtual_lines = true,
                signs = {
                    text = {
                        [vim.diagnostic.severity.ERROR] = '',
                        [vim.diagnostic.severity.WARN] = '',
                        [vim.diagnostic.severity.HINT] = '󰛨',
                        [vim.diagnostic.severity.INFO] = '󰋼',
                    },
                    linehl = {
                        [vim.diagnostic.severity.ERROR] = 'ErrorMsg',
                    },
                    numhl = {
                        [vim.diagnostic.severity.WARN] = 'WarningMsg',
                    },
                },
            })

            -- Lua
            vim.lsp.enable('lua_ls')

            -- Python
            vim.lsp.config('pyright', {
                settings = {
                    pyright = {
                        -- Using Ruff's import organizer
                        disableOrganizeImports = true,
                    },
                    python = {
                        analysis = {
                            -- Ignore all files for analysis to exclusively use Ruff for linting
                            ignore = { '*' },
                        },
                    },
                },
            })
            vim.lsp.enable('pyright')
            vim.lsp.enable('ruff')

            -- JavaScript
            vim.lsp.enable('tailwindcss')
            vim.lsp.config('ts_ls', {
                init_options = {
                    plugins = {
                        {
                            name = "@vue/typescript-plugin",
                            location = "/usr/local/lib/node_modules/@vue/typescript-plugin",
                            languages = {"javascript", "typescript", "vue"},
                        },
                    },
                },
                filetypes = {
                    "javascript",
                    "typescript",
                    "vue",
                },
            })
            vim.lsp.enable('ts_ls')
            vim.lsp.enable('vue_ls')
            vim.lsp.enable('astro')

            -- Keymaps
            local fzf = require("fzf-lua")
            vim.keymap.set("n", '<leader>ca', fzf.lsp_code_actions, { desc = "[C]ode [A]ctions" })

        end
    }
}
