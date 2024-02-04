return {
    "catppuccin/nvim",
    name = "catppuccin",
    config = function()
        require("catppuccin").setup({
            flavour = "mocha", -- latte, frappe, macchiato, mocha
            term_colors = false,
            integrations = {
                cmp = true,
                gitsigns = true,
                nvimtree = true,
                leap = true,
                mason = true,
                which_key = true,
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
                vimwiki = true
                -- For more plugins integrations please scroll down (https://github.com/catppuccin/nvim#integrations)
            },
        })

        vim.cmd.colorscheme "catppuccin"
    end
}
