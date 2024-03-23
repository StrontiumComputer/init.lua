return {
    { -- Autoformat
        "stevearc/conform.nvim",

        opts = {
            notify_on_error = false,
            format_on_save = function(bufnr)
                local disable_filetypes = { c = true, cpp = true }
                return {
                    timeout_ms = 500,
                    lsp_fallback = not disable_filetypes[vim.bo[bufnr].filetype],
                }
            end,
            formatters_by_ft = {
                lua = { "stylua" },
                python = { "black" },
                java = { "astyle" },
                latex = { "latexindent" },
                go = { "gofumpt", "goimports-reviser", "golines" },
                markdown = { "cbfmt" },
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
