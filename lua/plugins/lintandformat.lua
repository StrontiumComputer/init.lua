return {
    { -- Autoformat
        "stevearc/conform.nvim",

        opts = {
            notify_on_error = false,
            format_on_save = function(bufnr)
                -- Disable "format_on_save lsp_fallback" for languages that don't
                -- have a well standardized coding style. You can add additional
                -- languages here or re-enable it for the disabled ones.
                local disable_filetypes = { c = true, cpp = true }
                return {
                    timeout_ms = 500,
                    lsp_fallback = not disable_filetypes[vim.bo[bufnr].filetype],
                }
            end,
            formatters_by_ft = {
                lua = { "stylua" },
                -- Conform can also run multiple formatters sequentially
                python = { "black" },
                java = { "astyle" },
                latex = { "latexindent" },
                go = { "gofumpt", "goimports-reviser", "golines" },
                markdown = { "cbfmt" },
                -- You can use a sub-list to tell conform to run *until* a formatter
                -- is found.
                javascript = { { "biome", "prettierd", "prettier" } },
            },
        },
    },
    {
        "nvimtools/none-ls.nvim",
        event = "VeryLazy",
        requires = { "nvim-lua/plenary.nvim" },
        config = function()
            require("null-ls").setup()

            local augroup = vim.api.nvim_create_augroup("LspFormatting", {})
            local null_ls = require("null-ls")

            null_ls.setup({
                sources = {
                    null_ls.builtins.formatting.stylua,
                    null_ls.builtins.formatting.prettierd,
                    null_ls.builtins.formatting.black,
                    null_ls.builtins.formatting.gofumpt,
                    null_ls.builtins.formatting.golines,
                    null_ls.builtins.formatting.goimports_reviser,
                    null_ls.builtins.diagnostics.mypy,
                },
                on_attach = function(client, bufnr)
                    if client.supports_method("textDocument/formatting") then
                        vim.api.nvim_clear_autocmds({
                            group = augroup,
                            buffer = bufnr,
                        })
                        vim.api.nvim_create_autocmd("BufWritePre", {
                            group = augroup,
                            buffer = bufnr,
                            callback = function()
                                vim.lsp.buf.format({ bufnr = bufnr })
                            end,
                        })
                    end
                end,
            })
        end,
    },
}
