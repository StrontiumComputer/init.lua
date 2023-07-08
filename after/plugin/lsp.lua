local M ={}

local lsp = require('lsp-zero').preset("recommended")

lsp.ensure_installed({
    'tsserver',
    'eslint',
    'rust_analyzer',
    'pyright',
    'gopls',
    'clangd',
    'jdtls',
})



local cmp = require('cmp')
local cmp_select = {behavior = cmp.SelectBehavior.Select}

-- control p is previous item
-- control n is next item
-- control y is confirm
-- control space is mapping complete

M.on_attach = lsp.on_attach(function(client, bufnr)
    local opts = {buffer = bufnr, remap = false}

    vim.keymap.set("n", "gd", function() vim.lsp.buf.definition() end, opts)
    vim.keymap.set("n", "K", function() vim.lsp.buf.hover() end, opts)
    vim.keymap.set("n", "<leader>vws", function() vim.lsp.buf.workspace_symbol() end, opts)
    vim.keymap.set("n", "<leader>vd", function() vim.diagnostic.open_float() end, opts)
    vim.keymap.set("n", "[d", function() vim.diagnostic.goto_next() end, opts)
    vim.keymap.set("n", "]d", function() vim.diagnostic.goto_prev() end, opts)
    vim.keymap.set("n", "<leader>vca", function() vim.lsp.buf.code_action() end, opts)
    vim.keymap.set("n", "<leader>vrr", function() vim.lsp.buf.references() end, opts)
    vim.keymap.set("n", "<leader>vrn", function() vim.lsp.buf.rename() end, opts)
    vim.keymap.set("i", "<C-h>", function() vim.lsp.buf.signature_help() end, opts)
end)

M.capabilities = vim.lsp.protocol.make_client_capabilities()

lsp.setup()

vim.diagnostic.config({
    virtual_text = true
})

-- Java LSP (jdtls) config

require("lspconfig").jdtls.setup({
	on_attach = M.on_attach,
	capabilities = M.capabilities,
	filetypes = {"java"}
})

-- Python LSP (pyright) config

require("lspconfig").pyright.setup({
	on_attach = M.on_attach,
	capabilities = M.capabilities,
	filetypes = {"python"},
})


return M
