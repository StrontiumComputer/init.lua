return {
    {
        "mhartington/formatter.nvim",
        ft = "java",
        config = function()
            -- Utilities for creating configurations
            local util = require("formatter.util")

            -- Provides the Format, FormatWrite, FormatLock, and FormatWriteLock commands
            require("formatter").setup({
                -- Enable or disable logging
                logging = true,
                -- Set the log level
                log_level = vim.log.levels.WARN,
                -- All formatter configurations are opt-in
                filetype = {
                    -- Formatter configurations for filetype "lua" go here
                    -- and will be executed in order
                    java = {
                        function()
                            return {
                                exe = "clang-format",
                                args = { "--style=chromium", "--assume-filename=.java" },
                                stdin = true,
                            }
                        end,
                    },
                    -- Use the special "*" filetype for defining formatter configurations on
                    -- any filetype
                    ["*"] = {
                        -- "formatter.filetypes.any" defines default configurations for any
                        -- filetype
                        require("formatter.filetypes.any").remove_trailing_whitespace,
                    },
                },
            })

            vim.api.nvim_exec(
                [[augroup FormatAutogroup
    autocmd!
    autocmd BufWritePost * FormatWrite
    augroup END]],
                true
            )
        end
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
                    null_ls.builtins.diagnostics.ruff,
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
