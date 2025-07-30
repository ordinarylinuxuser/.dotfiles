return {
    "nvim-treesitter/nvim-treesitter",
    branch = "main",
    lazy = false,
    dependencies = { "nvim-tree/nvim-web-devicons" },
    build = ":TSUpdate",
    config = function()
        --require 'nvim-treesitter'.install { "c", "lua", "vim", "vimdoc", "query", "markdown", "markdown_inline" }
        vim.api.nvim_create_autocmd('FileType', {
            pattern = { 'rust', 'javascript', 'zig', 'markdown', 'c', 'lua' },
            callback = function()
                -- syntax highlighting, provided by Neovim
                vim.treesitter.start()
                -- folds, provided by Neovim
                vim.wo.foldexpr = 'v:lua.vim.treesitter.foldexpr()'
                -- indentation, provided by nvim-treesitter
                vim.bo.indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
            end,
        })
    end
}
