require('lint').linters_by_ft = {
  markdown = {'checkstyle', 'mypy', 'ruff'}
}

vim.api.nvim_create_autocmd({ "BufWritePost" }, {
  callback = function()
    require("lint").try_lint()
  end,
})
