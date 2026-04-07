return {
    "catppuccin/nvim",
    name = "catppuccin",
    config = function()
        require("catppuccin").setup({
            flavour = "mocha", -- latte, frappe, macchiato, mocha
            term_colors = false,
            dim_inactive = {
                enabled = true,    -- dims the background color of inactive window
                shade = "dark",
                percentage = 0.15, -- percentage of the shade to apply to the inactive window
            },
            integrations = {
                alpha = true,
                cmp = true,
                gitsigns = true,
                nvimtree = true,
                leap = true,
                mason = true,
                which_key = true,
                -- treesitter = false,
                notify = true,
                fzf = true,
                noice = true,
                -- dap = {
                --     enabled = false,
                --     enable_ui = false, -- enable nvim-dap-ui
                -- },
                indent_blankline = {
                    enabled = true,
                    colored_indent_levels = false,
                },
                native_lsp = {
                    enabled = true,
                    virtual_text = {
                        errors = { "italic" },
                        hints = { "italic" },
                        warnings = { "italic" },
                        information = { "italic" },
                    },
                    underlines = {
                        errors = { "underline" },
                        hints = { "underline" },
                        warnings = { "underline" },
                        information = { "underline" },
                    },
                },
                -- In your catppuccin config (integrations):
                lualine = {
                    -- lualine color overrides in the following hierarchy: Catppuccin Flavor -> Mode -> Lualine Section
                    -- The Catppuccin flavor entry can be any Catpuccin flavor or "all" to apply to all flavors
                    -- The flavor entry can be either a table or a function which consumes the current Catppuccin palette, just like custom_highlights and color_overrides
                    all = function(C)
                        transparent_bg = false and "NONE" or C.mantle
                        ---@type CtpIntegrationLualineOverride
                        return {
                            -- Specifying a normal-mode status line override for section a's background and b's foreground to use lavender like the main Catppuccin theme
                            normal = {
                                a = { bg = C.blue, fg = C.mantle, gui = "bold" },
                                b = { bg = C.surface0, fg = C.blue },
                                c = { bg = transparent_bg, fg = C.text },
                            },

                            insert = {
                                a = { bg = C.green, fg = C.base, gui = "bold" },
                                b = { bg = C.surface0, fg = C.green },
                            },

                            terminal = {
                                a = { bg = C.green, fg = C.base, gui = "bold" },
                                b = { bg = C.surface0, fg = C.green },
                            },

                            command = {
                                a = { bg = C.peach, fg = C.base, gui = "bold" },
                                b = { bg = C.surface0, fg = C.peach },
                            },
                            visual = {
                                a = { bg = C.mauve, fg = C.base, gui = "bold" },
                                b = { bg = C.surface0, fg = C.mauve },
                            },
                            replace = {
                                a = { bg = C.red, fg = C.base, gui = "bold" },
                                b = { bg = C.surface0, fg = C.red },
                            },
                            inactive = {
                                a = { bg = transparent_bg, fg = C.blue },
                                b = { bg = transparent_bg, fg = C.surface1, gui = "bold" },
                                c = { bg = transparent_bg, fg = C.overlay0 },
                            },
                        }
                    end,
                    -- A macchiato-specific override, which takes priority over 'all'. Also using the direct table syntax instead of function in case you do not rely on dynamic palette colors
                    macchiato = {
                        normal = {
                            a = { bg = "#abcdef" },
                        }
                    },
                },
                vimwiki = true
                -- For more plugins integrations please scroll down (https://github.com/catppuccin/nvim#integrations)
            },
        })

        vim.cmd.colorscheme "catppuccin-nvim"
    end
}
