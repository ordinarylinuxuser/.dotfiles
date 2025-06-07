return {
    'MeanderingProgrammer/render-markdown.nvim',
    dependencies = { 'nvim-treesitter/nvim-treesitter', 'nvim-tree/nvim-web-devicons' }, -- if you prefer nvim-web-devicons
    opts = {
    },
    config = function()
        require('render-markdown').setup({
            render_modes = { 'n', 'c', 't' },
            preset = 'lazy',
            file_types = { 'markdown', 'vimwiki' },
            completions = { lsp = { enabled = true } },
        })
    end
}
