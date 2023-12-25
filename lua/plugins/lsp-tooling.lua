return {
    {
        "neovim/nvim-lspconfig",
        config = function()
            local lspconfig = require("lspconfig")
            vim.api.nvim_create_autocmd("LspAttach", {
                desc = "LSP actions",
                callback = function(event)
                    local opts = { buffer = event.buf }

                    vim.keymap.set("n", "K", function()
                        vim.lsp.buf.hover()
                    end, opts)
                    vim.keymap.set("n", "gd", function()
                        vim.lsp.buf.definition()
                    end, opts)
                    vim.keymap.set("n", "gD", function()
                        vim.lsp.buf.declaration()
                    end, opts)
                    vim.keymap.set("n", "gi", function()
                        vim.lsp.buf.implementation()
                    end, opts)
                    vim.keymap.set("n", "go", function()
                        vim.lsp.buf.type_definition()
                    end, opts)
                    vim.keymap.set("n", "<leader>vws", function()
                        vim.lsp.buf.workspace_symbol()
                    end, opts)
                    vim.keymap.set("n", "<leader>vd", function()
                        vim.diagnostic.open_float()
                    end, opts)
                    vim.keymap.set("n", "[d", function()
                        vim.diagnostic.goto_next()
                    end, opts)
                    vim.keymap.set("n", "]d", function()
                        vim.diagnostic.goto_prev()
                    end, opts)
                    vim.keymap.set("n", "<leader>vca", function()
                        vim.lsp.buf.code_action()
                    end, opts)
                    vim.keymap.set("n", "<leader>vrr", function()
                        vim.lsp.buf.references()
                    end, opts)
                    vim.keymap.set("n", "<leader>vrn", function()
                        vim.lsp.buf.rename()
                    end, opts)
                    vim.keymap.set("i", "c-x", function()
                        vim.lsp.buf.signature_help()
                    end, opts)
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
            lspconfig.tailwindcss.setup({
                filetypes = {
                    "html",
                    "css",
                    "javascript",
                    "javascriptreact",
                    "typescript",
                    "typescriptreact",
                    "svelte",
                },
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
            lspconfig.ltex.setup({
                filetypes = { "tex", "bib" },
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
                    "ltex",
                    "svelte",
                    "texlab",
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
                },
            })
        end,
    },
    { "onsails/lspkind.nvim" },
    { "hrsh7th/cmp-nvim-lsp" },
    { "hrsh7th/cmp-path" },
    { "hrsh7th/nvim-cmp" },
    {
        "L3MON4D3/LuaSnip",
        dependencies = { "rafamadriz/friendly-snippets" },
    },
    { "saadparwaiz1/cmp_luasnip" },
}
