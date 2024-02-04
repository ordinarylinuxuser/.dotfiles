return {
    "nvim-treesitter/nvim-treesitter",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    run = ":TSUpdate",
    config = function()
        require("nvim-treesitter.configs").setup {
            -- A list of parser names, or "all" (the five listed parsers should always be installed)
            ensure_installed = { "c", "lua", "vim", "vimdoc", "query" },

            -- Install languages synchronously (only applied to `ensure_installed`)
            sync_install = false,

            -- Automatically install missing parsers when entering buffer
            -- Recommendation: set to false if you don't have `tree-sitter` CLI installed locally
            auto_install = true,
            -- Or use a function for more flexibility, e.g. to disable slow treesitter highlight for large files
            disable = function(lang, buf)
                local max_filesize = 3 * 1024 * 1024 -- 3 MB
                local ok, stats = pcall(vim.loop.fs_stat, vim.api.nvim_buf_get_name(buf))
                if ok and stats and stats.size > max_filesize then
                    return true
                end
            end,
            highlight = {
                -- `false` will disable the whole extension
                enable = true,
            },
            indent = {
                enable = true
            }
        }
    end,
}
