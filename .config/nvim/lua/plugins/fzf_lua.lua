return {
    "ibhagwan/fzf-lua",
    -- optional for icon support
    dependencies = { "nvim-tree/nvim-web-devicons" },
    config = function()
        -- calling `setup` is optional for customization
        require("fzf-lua").setup({})
    end,
    find_files = function()
        local fzf = require "fzf-lua"
        if vim.fn.system "git rev-parse --is-inside-work-tree" == true then
            fzf.git_files()
        else
            fzf.files({
                fd_opts = "--type file --hidden --follow --color='always' " ..
                    "--exclude='.git' " ..
                    "--exclude='node_modules' " ..
                    "--exclude='.gradle' " ..
                    "--exclude='.settings' " ..
                    "--exclude='bin'"
            })
        end
    end
}
