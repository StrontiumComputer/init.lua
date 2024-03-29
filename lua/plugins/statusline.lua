return {
    -- Set lualine as statusline
    "nvim-lualine/lualine.nvim",
    event = "VeryLazy",
    -- See `:help lualine.txt`
    opts = {
        options = {
            icons_enabled = true,
            theme = "catppuccin",
            component_separators = "|",
            section_separators = { left = "", right = "" },
        },
    },

    config = function()
        local function LSPINFO()
            local msg = "No Active Lsp"
            local buf_ft = vim.api.nvim_buf_get_option(0, "filetype")
            local clients = vim.lsp.get_active_clients()
            if next(clients) == nil then
                return msg
            end
            for _, client in ipairs(clients) do
                local filetypes = client.config.filetypes
                if filetypes and vim.fn.index(filetypes, buf_ft) ~= -1 then
                    return client.name
                end
            end
            return msg
        end

        local colors = {
            bg = "#24273A",
            fg = "#bbc2cf",
            yellow = "#ECBE7B",
            cyan = "#008080",
            darkblue = "#24273A",
            green = "#98be65",
            orange = "#fab387",
            violet = "#a9a1e1",
            magenta = "#c678dd",
            blue = "#51afef",
            red = "#ec5f67",
        }

        require("lualine").setup({
            options = {
                icons_enabled = true,
                theme = "auto",
                component_separators = { left = "|", right = "|" },
                section_separators = { left = '', right = '' },
                disabled_filetypes = {
                    statusline = {},
                    winbar = {},
                },
                ignore_focus = {},
                always_divide_middle = true,
                globalstatus = false,
                refresh = {
                    statusline = 1000,
                    tabline = 1000,
                    winbar = 1000,
                },
            },
            sections = {
                lualine_a = {
                    { "mode", separator = { left = '' }, right_padding = 2, icon = { "" } } },
                lualine_b = {
                    "branch",
                    {
                        "diff",
                        symbols = { added = ' ', modified = ' ', removed = ' ' },
                    },
                    {
                        "diagnostics",
                        sources = { "nvim_diagnostic" },
                        symbols = { error = " ", warn = " ", info = " " },
                        diagnostics_color = {
                            color_error = { fg = colors.red },
                            color_warn = { fg = colors.yellow },
                            color_info = { fg = colors.cyan },
                        },
                    },
                },
                lualine_c = {
                    { "filename", color = { fg = colors.violet, gui = "bold" } },
                    {
                        "filesize",
                        color = { fg = "#ffffff" },
                    },
                },
                lualine_x = {
                    { LSPINFO, color = { fg = colors.orange, gui = "bold" }, icon = " LSP:" },
                    "filetype",
                    {
                        require("noice").api.statusline.mode.get,
                        cond = require("noice").api.statusline.mode.has,
                        color = { fg = colors.violet, gui = "bold" },
                    }
                },
                lualine_y = { "progress" },
                lualine_z = {
                    { "location", separator = { right = '' }, left_padding = 2 } },
            },
            inactive_sections = {
                lualine_a = {},
                lualine_b = {},
                lualine_c = { "filename" },
                lualine_x = { "location" },
                lualine_y = {},
                lualine_z = {},
            },
            tabline = {},
            winbar = {},
            inactive_winbar = {},
            extensions = {},
        })
    end,
}
