return {
    {
        "neovim/nvim-lspconfig",
        event = { 'BufReadPre', 'BufNewFile' },
        config = function()
            local lspconfig = require("lspconfig")
            vim.api.nvim_create_autocmd("LspAttach", {
                desc = "LSP actions",
                callback = function(event)
                    local opts = { buffer = event.buf }
                    local map = function(keys, func, desc)
                        vim.keymap.set('n', keys, func, { buffer = event.buf, desc = 'LSP: ' .. desc })
                    end

                    map('gd', require('telescope.builtin').lsp_definitions, '[G]oto [D]efinition')
                    map('gr', require('telescope.builtin').lsp_references, '[G]oto [R]eferences')
                    map('gI', require('telescope.builtin').lsp_implementations, '[G]oto [I]mplementation')
                    map('<leader>D', require('telescope.builtin').lsp_type_definitions, 'Type [D]efinition')
                    map('<leader>ds', require('telescope.builtin').lsp_document_symbols, '[D]ocument [S]ymbols')
                    map('<leader>ws', require('telescope.builtin').lsp_dynamic_workspace_symbols, '[W]orkspace [S]ymbols')
                    map('<leader>rn', vim.lsp.buf.rename, '[R]e[n]ame')
                    map('gD', vim.lsp.buf.declaration, '[G]oto [D]eclaration')
                    map('K', vim.lsp.buf.hover, 'Hover Documentation')
                    map('<leader>ca', vim.lsp.buf.code_action, '[C]ode [A]ction')

                    local client = vim.lsp.get_client_by_id(event.data.client_id)
                    if client and client.server_capabilities.documentHighlightProvider then
                        vim.api.nvim_create_autocmd({ 'CursorHold', 'CursorHoldI' }, {
                            buffer = event.buf,
                            callback = vim.lsp.buf.document_highlight,
                        })

                        vim.api.nvim_create_autocmd({ 'CursorMoved', 'CursorMovedI' }, {
                            buffer = event.buf,
                            callback = vim.lsp.buf.clear_references,
                        })
                    end
                end,
            })

            lspconfig.lua_ls.setup({})
            lspconfig.pyright.setup({
                filetypes = { "python" },
            })
            lspconfig.rust_analyzer.setup({
                filetypes = { "rust" },
            })
            lspconfig.gopls.setup({
                filetypes = { "go", "gomod", "gowork", "gotmpl" },
            })
            lspconfig.biome.setup({})
            lspconfig.astro.setup({})
            lspconfig.htmx.setup({
                filetypes = { "html", "astro" }
            })
            lspconfig.svelte.setup({
                filetypes = { "svelte" },
            })
            lspconfig.marksman.setup({
                filetypes = { "markdown" },
            })
            lspconfig.texlab.setup({
                filetypes = { "tex", "bib" },
            })
            lspconfig.tailwindcss.setup({
                filetypes = {
                    "html",
                    "css",
                    "javascript",
                    "javascriptreact",
                    "typescript",
                    "typescriptreact",
                    "svelte",
                    "astro",
                },
            })

            vim.diagnostic.config({
                virtual_text = true,
                signs = true,
            })
            local signs = { Error = "", Warn = "", Hint = "󰛨", Info = "󰋼" }
            for type, icon in pairs(signs) do
                local hl = "DiagnosticSign" .. type
                vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = hl })
            end

            -- Autoformatting from builtin LSP and Kickstarter.nvim

            -- Switch for controlling whether you want autoformatting.
            --  Use :KickstartFormatToggle to toggle autoformatting on or off
            local format_is_enabled = true
            vim.api.nvim_create_user_command('KickstartFormatToggle', function()
                format_is_enabled = not format_is_enabled
                print('Setting autoformatting to: ' .. tostring(format_is_enabled))
            end, {})

            -- Create an augroup that is used for managing our formatting autocmds.
            --      We need one augroup per client to make sure that multiple clients
            --      can attach to the same buffer without interfering with each other.
            local _augroups = {}
            local get_augroup = function(client)
                if not _augroups[client.id] then
                    local group_name = 'kickstart-lsp-format-' .. client.name
                    local id = vim.api.nvim_create_augroup(group_name, { clear = true })
                    _augroups[client.id] = id
                end

                return _augroups[client.id]
            end

            -- Whenever an LSP attaches to a buffer, we will run this function.
            --
            -- See `:help LspAttach` for more information about this autocmd event.
            vim.api.nvim_create_autocmd('LspAttach', {
                group = vim.api.nvim_create_augroup('kickstart-lsp-attach-format', { clear = true }),
                -- This is where we attach the autoformatting for reasonable clients
                callback = function(args)
                    local client_id = args.data.client_id
                    local client = vim.lsp.get_client_by_id(client_id)
                    local bufnr = args.buf

                    -- Only attach to clients that support document formatting
                    if not client.server_capabilities.documentFormattingProvider then
                        return
                    end

                    -- Tsserver usually works poorly. Sorry you work with bad languages
                    -- You can remove this line if you know what you're doing :)
                    if client.name == 'tsserver' then
                        return
                    end

                    -- Create an autocmd that will run *before* we save the buffer.
                    --  Run the formatting command for the LSP that has just attached.
                    vim.api.nvim_create_autocmd('BufWritePre', {
                        group = get_augroup(client),
                        buffer = bufnr,
                        callback = function()
                            if not format_is_enabled then
                                return
                            end

                            vim.lsp.buf.format {
                                async = false,
                                filter = function(c)
                                    return c.id == client.id
                                end,
                            }
                        end,
                    })
                end,
            })
        end,
    },
    {
        "williamboman/mason.nvim",
        config = function()
            require("mason").setup()
        end,
    },
    {
        "williamboman/mason-lspconfig.nvim",
        event = { 'BufReadPre', 'BufNewFile' },
        config = function()
            local lsp_capabilities = require("cmp_nvim_lsp").default_capabilities()
            local default_setup = function(server)
                require("lspconfig")[server].setup({
                    capabilities = lsp_capabilities,
                })
            end
            local function organize_imports()
                local params = {
                    command = "_typescript.organizeImports",
                    arguments = { vim.api.nvim_buf_get_name(0) },
                }
                vim.lsp.buf.execute_command(params)
            end
            require("mason-lspconfig").setup({
                ensure_installed = {
                    "lua_ls",
                    "pyright",
                    "rust_analyzer",
                    "biome",
                    "tsserver",
                    "gopls",
                    "tailwindcss",
                    "cssls",
                    "html",
                    "svelte",
                    "texlab",
                    "astro"
                },
                handlers = {
                    default_setup,
                    require("lspconfig").tsserver.setup({
                        capabilities = lsp_capabilities,
                        init_options = {
                            preferences = {
                                disableSuggestions = true,
                            },
                        },
                        commands = {
                            OrganizeImports = {
                                organize_imports,
                                description = "Organize Imports",
                            },
                        },
                    }),
                    require("lspconfig").rust_analyzer.setup({
                        capabilities = lsp_capabilities,
                        filetypes = { "rust" },
                        cmd = {
                            "rustup",
                            "run",
                            "stable",
                            "rust-analyzer",
                        },
                    }),
                    require("lspconfig").gopls.setup({
                        capabilities = lsp_capabilities,
                        cmd = { "gopls" },
                        filetypes = { "go", "gomod", "gowork", "gotmpl" },
                        root_dir = require("lspconfig/util").root_pattern(
                            "go.mod",
                            "go.work",
                            ".git"
                        ),
                        settings = {
                            gopls = {
                                completedUnimported = true,
                                usePlaceholders = true,
                                analyses = {
                                    unusedparams = true,
                                },
                            }
                        }
                    }),
                },
            })
        end,
    },
    {
        "folke/neodev.nvim",
        ft = { "lua", "vim" },
        config = function()
            require("neodev").setup({
                library = { plugins = { "nvim-dap-ui" }, types = true },
            })
        end
    },
}
