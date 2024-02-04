return {
    "lukas-reineke/indent-blankline.nvim",
    main = "ibl",
    config = function()
        require("ibl").setup()
        -- {

        --     char = "┊",
        --     --space_char_blankline = " ",
        --     show_trailing_blankline_indent = false,
        --     filetype_exclude = { "help", "packer" },
        --     buftype_exclude = { "terminal", "nofile" },
        --     show_current_context = true,
        --     show_current_context_start = true,

        -- }
    end,
}
