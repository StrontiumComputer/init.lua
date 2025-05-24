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
    -- { -- LSP Configuration & Plugins
    -- 	"neovim/nvim-lspconfig",
    -- 	dependencies = {
    -- 		{ "williamboman/mason.nvim", config = true },
    -- 		"williamboman/mason-lspconfig.nvim",
    -- 		"WhoIsSethDaniel/mason-tool-installer.nvim",
    -- 		{ "folke/neodev.nvim", opts = {} },
    -- 		{ "saghen/blink.cmp", opts = {} },
    -- 	},
    --
    -- 	config = function()
    -- 		vim.api.nvim_create_autocmd("LspAttach", {
    -- 			group = vim.api.nvim_create_augroup("kickstart-lsp-attach", { clear = true }),
    -- 			callback = function(event)
    -- 				local map = function(keys, func, desc, mode)
    -- 					mode = mode or "n"
    -- 					vim.keymap.set(mode, keys, func, { buffer = event.buf, desc = "LSP: " .. desc })
    -- 				end
    --
    -- 				map("gd", require("telescope.builtin").lsp_definitions, "[G]oto [D]efinition")
    --
    -- 				map("gr", require("telescope.builtin").lsp_references, "[G]oto [R]eferences")
    --
    -- 				map("gI", require("telescope.builtin").lsp_implementations, "[G]oto [I]mplementation")
    --
    -- 				map("<leader>D", require("telescope.builtin").lsp_type_definitions, "Type [D]efinition")
    --
    -- 				map("<leader>ds", require("telescope.builtin").lsp_document_symbols, "[D]ocument [S]ymbols")
    --
    -- 				map(
    -- 					"<leader>ws",
    -- 					require("telescope.builtin").lsp_dynamic_workspace_symbols,
    -- 					"[W]orkspace [S]ymbols"
    -- 				)
    --
    -- 				map("<leader>rn", vim.lsp.buf.rename, "[R]e[n]ame")
    --
    -- 				map("<leader>ca", vim.lsp.buf.code_action, "[C]ode [A]ction", { "n", "x" })
    --
    -- 				map("gD", vim.lsp.buf.declaration, "[G]oto [D]eclaration")
    --
    -- 				local client = vim.lsp.get_client_by_id(event.data.client_id)
    -- 				if client and client.supports_method(vim.lsp.protocol.Methods.textDocument_documentHighlight) then
    -- 					local highlight_augroup =
    -- 						vim.api.nvim_create_augroup("kickstart-lsp-highlight", { clear = false })
    -- 					vim.api.nvim_create_autocmd({ "CursorHold", "CursorHoldI" }, {
    -- 						buffer = event.buf,
    -- 						group = highlight_augroup,
    -- 						callback = vim.lsp.buf.document_highlight,
    -- 					})
    --
    -- 					vim.api.nvim_create_autocmd({ "CursorMoved", "CursorMovedI" }, {
    -- 						buffer = event.buf,
    -- 						group = highlight_augroup,
    -- 						callback = vim.lsp.buf.clear_references,
    -- 					})
    --
    -- 					vim.api.nvim_create_autocmd("LspDetach", {
    -- 						group = vim.api.nvim_create_augroup("kickstart-lsp-detach", { clear = true }),
    -- 						callback = function(event2)
    -- 							vim.lsp.buf.clear_references()
    -- 							vim.api.nvim_clear_autocmds({ group = "kickstart-lsp-highlight", buffer = event2.buf })
    -- 						end,
    -- 					})
    -- 				end
    --
    -- 				if client and client.supports_method(vim.lsp.protocol.Methods.textDocument_inlayHint) then
    -- 					map("<leader>th", function()
    -- 						vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled({ bufnr = event.buf }))
    -- 					end, "[T]oggle Inlay [H]ints")
    -- 				end
    -- 			end,
    -- 		})
    --
    -- 		local capabilities = vim.lsp.protocol.make_client_capabilities()
    -- 		capabilities = vim.tbl_deep_extend("force", capabilities, require("blink.cmp").get_lsp_capabilities())
    --
    -- 		local servers = {
    -- 			clangd = {
    -- 				filetypes = { "c", "cpp" },
    -- 			},
    -- 			gopls = {
    -- 				filetypes = { "go" },
    -- 			},
    -- 			pyright = {},
    -- 			rust_analyzer = {},
    -- 			ts_ls = {
    -- 				filetypes = {
    -- 					"typescript",
    -- 				},
    -- 			},
    -- 			htmx = { filetypes = "html", "astro" },
    -- 			astro = {},
    -- 			biome = {},
    -- 			svelte = {},
    -- 			marksman = {},
    -- 			texlab = {},
    -- 			volar = {},
    -- 			tailwindcss = {
    -- 				filetypes = {
    -- 					"html",
    -- 					"javascript",
    -- 					"svelte",
    -- 					"astro",
    -- 					"vue",
    -- 					"typescript",
    -- 				},
    -- 			},
    --
    -- 			lua_ls = {
    -- 				-- cmd = {...},
    -- 				-- filetypes = { ...},
    -- 				-- capabilities = {},
    -- 				settings = {
    -- 					Lua = {
    -- 						completion = {
    -- 							callSnippet = "Replace",
    -- 						},
    -- 						-- diagnostics = { disable = { 'missing-fields' } },
    -- 					},
    -- 				},
    -- 			},
    -- 		}
    --
    -- 		vim.diagnostic.config({
    -- 			virtual_text = true,
    -- 			signs = true,
    -- 		})
    -- 		local signs = { Error = "", Warn = "", Hint = "󰛨", Info = "󰋼" }
    -- 		for type, icon in pairs(signs) do
    -- 			local hl = "DiagnosticSign" .. type
    -- 			vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = hl })
    -- 		end
    --
    -- 		require("mason").setup()
    --
    -- 		local ensure_installed = vim.tbl_keys(servers or {})
    -- 		vim.list_extend(ensure_installed, {
    -- 			"stylua",
    -- 		})
    -- 		require("mason-tool-installer").setup({ ensure_installed = ensure_installed })
    --
    -- 		require("mason-lspconfig").setup({
    -- 			handlers = {
    -- 				function(server_name)
    -- 					local server = servers[server_name] or {}
    -- 					server.capabilities = vim.tbl_deep_extend("force", {}, capabilities, server.capabilities or {})
    -- 					require("lspconfig")[server_name].setup(server)
    -- 				end,
    -- 			},
    -- 		})
    -- 	end,
    -- },
}
