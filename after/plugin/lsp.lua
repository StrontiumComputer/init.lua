local M = {}

local lsp = require("lsp-zero").preset("recommended")

lsp.ensure_installed({
	"tsserver",
	"eslint",
	"pyright",
	"gopls",
	"clangd",
	"jdtls",
})

local cmp = require("cmp")
local cmp_select = { behavior = cmp.SelectBehavior.Select }

-- control p is previous item
-- control n is next item
-- control y is confirm
-- control space is mapping complete

lsp.set_sign_icons({
	error = "",
	warn = "",
	hint = "󰛨",
	info = "󰋼",
})

local function organize_imports()
	local params = {
		command = "_typescript.organizeImports",
		arguments = { vim.api.nvim_buf_get_name(0) },
	}
	vim.lsp.buf.execute_command(params)
end
-- stylua: ignore
M.on_attach = lsp.on_attach(function(client, bufnr)
    local opts = { buffer = bufnr, remap = false }

    vim.keymap.set("n", "gd", function() vim.lsp.buf.definition() end, opts)
    vim.keymap.set("n", "K", function() vim.lsp.buf.hover() end, opts)
    vim.keymap.set("n", "<leader>vws", function() vim.lsp.buf.workspace_symbol() end, opts)
    vim.keymap.set("n", "<leader>vd", function() vim.diagnostic.open_float() end, opts)
    vim.keymap.set("n", "[d", function() vim.diagnostic.goto_next() end, opts)
    vim.keymap.set("n", "]d", function() vim.diagnostic.goto_prev() end, opts)
    vim.keymap.set("n", "<leader>vca", function() vim.lsp.buf.code_action() end, opts)
    vim.keymap.set("n", "<leader>vrr", function() vim.lsp.buf.references() end, opts)
    vim.keymap.set("n", "<leader>vrn", function() vim.lsp.buf.rename() end, opts)
    vim.keymap.set("i", "c-x", function() vim.lsp.buf.signature_help() end, opts)
end)
-- stylua: ignore
M.java_on_attach = lsp.on_attach(function(client, bufnr)
    local opts = { buffer = bufnr, remap = false }

    vim.keymap.set("n", "gd", function() vim.lsp.buf.definition() end, opts)
    vim.keymap.set("n", "K", function() vim.lsp.buf.hover() end, opts)
    vim.keymap.set("n", "<leader>vws", function() vim.lsp.buf.workspace_symbol() end, opts)
    vim.keymap.set("n", "<leader>vd", function() vim.diagnostic.open_float() end, opts)
    vim.keymap.set("n", "[d", function() vim.diagnostic.goto_next() end, opts)
    vim.keymap.set("n", "]d", function() vim.diagnostic.goto_prev() end, opts)
    vim.keymap.set("n", "<leader>vca", function() vim.lsp.buf.code_action() end, opts)
    vim.keymap.set("n", "<leader>vrr", function() vim.lsp.buf.references() end, opts)
    vim.keymap.set("n", "<leader>vrn", function() vim.lsp.buf.rename() end, opts)
    vim.keymap.set("i", "<c-x>", function() vim.lsp.buf.signature_help() end, opts)

    --Java specific remaps
    vim.keymap.set("n", "<leader>co", function() require("jdtls").organize_imports() end, opts)
    vim.keymap.set("n", "<leader>cR", function() require("jdtls").rename_file() end, opts)
    vim.keymap.set("n", "<leader>cxv", function() require("jdtls").extract_variable() end, opts)
    vim.keymap.set("v", "<leader>cxv", function() require("jdtls").extract_variable() end, opts)
    vim.keymap.set("n", "<leader>cxc", function() require("jdtls").extract_constant() end, opts)
    vim.keymap.set("v", "<leader>cxc", function() require("jdtls").extract_constant() end, opts)
    vim.keymap.set("v", "<leader>cxm", function() require("jdtls").extract_constant() end, opts)
    vim.keymap.set("n", "<leader>cxm", function() require("jdtls").extract_constant() end, opts)
end)

M.capabilities = require("cmp_nvim_lsp").default_capabilities()

lsp.setup()

vim.diagnostic.config({
	virtual_text = true,
})

-- Svelte LSP server config

require("lspconfig").svelte.setup({
	on_attach = M.on_attach,
	capabilities = M.capabilities,
	filetypes = { "svelte" },
})

require("lspconfig").biome.setup({
	on_attach = M.on_attach,
	capabilities = M.capabilities,
})

require("lspconfig").tsserver.setup({
	on_attach = M.on_attach,
	capabilities = M.capabilities,
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
})

require("lspconfig").tailwindcss.setup({
	on_attach = M.on_attach,
	capabilities = M.capabilities,
	filetypes = { "html", "css", "javascript", "javascriptreact", "typescript", "typescriptreact", "svelte", "vue" },
})
-- Java LSP (jdtls) config

require("lspconfig").jdtls.setup({
	on_attach = M.on_attach,
	capabilities = M.capabilities,
	filetypes = { "java" },
})

-- Python LSP (pyright) config

require("lspconfig").pyright.setup({
	on_attach = M.on_attach,
	capabilities = M.capabilities,
	filetypes = { "python" },
})

-- Rust LSP (rust_analyzer) setup

require("lspconfig").rust_analyzer.setup({
	on_attach = M.on_attach,
	capabilities = M.capabilities,
	filetypes = { "rust" },
	cmd = {
		"rustup",
		"run",
		"stable",
		"rust-analyzer",
	},
})

-- Go LSP (gopls) setup

require("lspconfig").gopls.setup({
	on_attach = M.on_attach,
	capabilities = M.capabilities,
	filetypes = { "go" },
})

return M
