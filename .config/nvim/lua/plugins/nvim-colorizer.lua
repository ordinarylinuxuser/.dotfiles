return {
    "catgoose/nvim-colorizer.lua",
    event = "BufReadPre",
    opts = {
        user_default_options = {
            names = false,        -- "Name" codes like Blue or red.  Added from `vim.api.nvim_get_color_map()`
            RGB = true,           -- #RGB hex codes
            RGBA = true,          -- #RGBA hex codes
            RRGGBB = true,        -- #RRGGBB hex codes
            RRGGBBAA = true,      -- #RRGGBBAA hex codes
            AARRGGBB = true,      -- 0xAARRGGBB hex codes,
            -- Highlighting mode.  'background'|'foreground'|'virtualtext'
            mode = "virtualtext", -- Set the display mode
        }
    },
}
