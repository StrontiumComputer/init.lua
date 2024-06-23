vim.cmd [[highlight CodeBlock guibg=#1e1e2e]]

return {
    {
        "iamcco/markdown-preview.nvim",
        cmd = { "MarkdownPreviewToggle", "MarkdownPreview", "MarkdownPreviewStop" },
        build = "cd app && npm install",
        init = function()
            vim.g.mkdp_filetypes = { "markdown" }
        end,
        ft = { "markdown" },
    },
    {
        "lervag/vimtex",
    },
    {
        'MeanderingProgrammer/markdown.nvim',
        name = 'render-markdown', -- Only needed if you have another plugin named markdown.nvim
        dependencies = { 'nvim-treesitter/nvim-treesitter' },
        config = function()
            require('render-markdown').setup({
                highlights = {
                    heading = {
                        backgrounds = { 'DiffChange', 'DiffChange', 'DiffChange' }
                    },
                    code = 'CodeBlock',
                }
            })
        end,
    }
}
