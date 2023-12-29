return {
    { "nvim-tree/nvim-web-devicons" },
    {
        "NvChad/nvim-colorizer.lua",
        event = "BufRead",
        opts = {
            user_default_options = {
                tailwind = true,
            },
        },
        config = function()
            require("colorizer").setup({
                filetypes = { "*" },
                user_default_options = {
                    mode = "background",
                    RRGGBBAA = true,
                    AARRGGBB = true,
                    tailwind = true,
                    css = true,
                    css_fn = true,
                    sass = { enable = true, parsers = { "css" } },
                },
            })

            require("cmp").config.formatting = {
                format = require("tailwindcss-colorizer-cmp").formatter,
            }
        end

    },
    {
        "goolord/alpha-nvim",
        event = "VimEnter",
        opts = function()
            local dashboard = require("alpha.themes.dashboard")
            local logo = [[
   ___              _       (_)
  / __|     _ _    (_)      | |   __ _    _ _
  \__ \    | '_|   | |     _/ |  / _` |  | ' \
  |___/   _|_|_   _|_|_   |__/_  \__,_|  |_||_|
_|"""""|_|"""""|_|"""""|_|"""""|_|"""""|_|"""""|
"`-0-0-'"`-0-0-'"`-0-0-'"`-0-0-'"`-0-0-'"`-0-0-'
      ]]

            dashboard.section.header.val = vim.split(logo, "\n")
            dashboard.section.buttons.val = {
                dashboard.button("f", "󰱼 " .. " Find file", ":Telescope find_files <CR>"),
                dashboard.button("n", "󰣕 " .. " New file", ":ene <BAR> startinsert <CR>"),
                dashboard.button("r", " " .. " Recent files", ":Telescope oldfiles <CR>"),
                dashboard.button("e", " " .. " File Explorer", ":NvimTreeOpen <CR>"),
                dashboard.button("g", " " .. " Find text", ":Telescope live_grep <CR>"),
                dashboard.button("c", " " .. " Config", ":e $MYVIMRC <CR>"),
                dashboard.button("l", "󰒲 " .. " Lazy", ":Lazy<CR>"),
                dashboard.button("q", " " .. " Quit", ":qa<CR>"),
            }
            for _, button in ipairs(dashboard.section.buttons.val) do
                button.opts.hl = "AlphaButtons"
                button.opts.hl_shortcut = "AlphaShortcut"
            end
            dashboard.section.header.opts.hl = "AlphaHeader"
            dashboard.section.buttons.opts.hl = "AlphaButtons"
            dashboard.section.footer.opts.hl = "AlphaFooter"
            dashboard.opts.layout[1].val = 8
            return dashboard
        end,
        config = function(_, dashboard)
            -- close Lazy and re-open when the dashboard is ready
            if vim.o.filetype == "lazy" then
                vim.cmd.close()
                vim.api.nvim_create_autocmd("User", {
                    pattern = "AlphaReady",
                    callback = function()
                        require("lazy").show()
                    end,
                })
            end

            require("alpha").setup(dashboard.opts)

            vim.api.nvim_create_autocmd("User", {
                pattern = "LazyVimStarted",
                callback = function()
                    local stats = require("lazy").stats()
                    local ms = (math.floor(stats.startuptime * 100 + 0.5) / 100)
                    dashboard.section.footer.val = "⚡ Neovim loaded " .. stats.count .. " plugins in " .. ms .. "ms"
                    pcall(vim.cmd.AlphaRedraw)
                end,
            })
        end,
    },
    {
        "roobert/tailwindcss-colorizer-cmp.nvim",
        config = function()
            require("tailwindcss-colorizer-cmp").setup({
                color_square_width = 2,
            })
        end,
    },
    {
        "folke/trouble.nvim",
        dependencies = { "nvim-tree/nvim-web-devicons" },
        config = function()
            vim.keymap.set("n", "<leader>xx", function()
                require("trouble").toggle()
            end)
            vim.keymap.set("n", "<leader>xw", function()
                require("trouble").toggle("workspace_diagnostics")
            end)
            vim.keymap.set("n", "<leader>xd", function()
                require("trouble").toggle("document_diagnostics")
            end)
            vim.keymap.set("n", "<leader>xq", function()
                require("trouble").toggle("quickfix")
            end)
            vim.keymap.set("n", "<leader>xl", function()
                require("trouble").toggle("loclist")
            end)
            vim.keymap.set("n", "gR", function()
                require("trouble").toggle("lsp_references")
            end)
        end,
    },
    {
        "kdheepak/lazygit.nvim",
        event = "BufRead",
        dependencies = {
            "nvim-lua/plenary.nvim",
        },
        config = function()
            require("telescope").load_extension("lazygit")
            vim.keymap.set("n", "<leader>gs", [[:LazyGit<CR>]])
        end
    },
    {
        "utilyre/barbecue.nvim",
        name = "barbecue",
        version = "*",
        event = "BufRead",
        dependencies = {
            "SmiteshP/nvim-navic",
            "nvim-tree/nvim-web-devicons", -- optional dependency
        },
        opts = {
            -- configurations go here
        },
    }
}
