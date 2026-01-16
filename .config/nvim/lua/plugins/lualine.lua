return {
    "nvim-lualine/lualine.nvim",
    dependencies = { "nvim-web-devicons" },
    config = function()
        -- 1. Setup global variable and autocommands
        _G.leap_active = false
        local leap_lualine_group = vim.api.nvim_create_augroup("LeapLualine", { clear = true })

        vim.api.nvim_create_autocmd("User", {
            pattern = "LeapEnter",
            group = leap_lualine_group,
            callback = function()
                _G.leap_active = true
                require('lualine').refresh()
                vim.cmd("redrawstatus")
            end,
        })

        vim.api.nvim_create_autocmd("User", {
            pattern = "LeapLeave",
            group = leap_lualine_group,
            callback = function()
                _G.leap_active = false
                require('lualine').refresh()
                vim.cmd("redrawstatus")
            end,
        })

        -- 2. Define the component
        local leap_component = {
            function() return "LEAP" end,
            cond = function() return _G.leap_active end,
            color = { fg = "#ffffff", bg = "#000000", gui = "bold" }, -- Using a Red/Pink from your Catppuccin palette
        }

        require("lualine").setup {
            options = {
                icons_enabled = true,
                theme = "catppuccin",
                component_separators = { left = "", right = "" },
                section_separators = { left = "", right = "" },
                disabled_filetypes = {},
                always_divide_middle = true,
                globalstatus = false,
            },
            sections = {
                lualine_a = { leap_component, "mode" },
                lualine_b = { "branch", "diff", "diagnostics" },
                lualine_c = { "filename" },
                lualine_x = { "encoding", "fileformat", "filetype" },
                lualine_y = { "progress" },
                lualine_z = { "location" },
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
            extensions = { "fzf", "man", "mason", "nvim-tree" },
        }
    end,
}
