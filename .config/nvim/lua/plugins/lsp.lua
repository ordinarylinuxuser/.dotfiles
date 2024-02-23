return { --- Uncomment these if you want to manage LSP servers from neovim
    { 'williamboman/mason.nvim' },
    { 'williamboman/mason-lspconfig.nvim' },
    {
        'VonHeikemen/lsp-zero.nvim',
        branch = 'v3.x',
        config = function()
            vim.g.lsp_zero_extend_lspconfig = 1
            vim.g.lsp_zero_extend_cmp = 1

            local lsp_zero = require('lsp-zero')

            lsp_zero.on_attach(function(client, bufnr)
                -- see :help lsp-zero-keybindings
                -- to learn the available actions
                lsp_zero.default_keymaps({ buffer = bufnr })
                lsp_zero.buffer_autoformat()
            end)
            -- sign icons
            lsp_zero.set_sign_icons({
                error = '',
                warn = '',
                hint = '',
                info = ''
            })
            require('mason').setup({})
            require('mason-lspconfig').setup({
                ensure_installed = { 'lua_ls' },
                handlers = {
                    lsp_zero.default_setup,
                },
            })


            -- Make sure you setup `cmp` after lsp-zero

            local cmp = require('cmp')

            cmp.setup({
                preselect = 'item',
                completion = {
                    completeopt = 'menu,menuone,noinsert'
                },
                mapping = {
                    ['<CR>'] = cmp.mapping.confirm({ select = false }),
                },
                window = {
                    completion = cmp.config.window.bordered({ side_padding = 0 }),
                    documentation = cmp.config.window.bordered({ side_padding = 0 }),
                },
                formatting = {
                    format = require('lspkind').cmp_format({
                        mode = 'symbol_text',  -- show only symbol annotations
                        maxwidth = 80,         -- prevent the popup from showing more than provided characters (e.g 50 will not show more than 50 characters)
                        ellipsis_char = '...', -- when popup menu exceed maxwidth, the truncated part would show ellipsis_char instead (must define maxwidth first)

                        -- The function below will be called before any actual modifications from lspkind
                        -- so that you can provide more controls on popup customization. (See [#30](https://github.com/onsails/lspkind-nvim/pull/30))
                        before = function(entry, vim_item)
                            return vim_item
                        end
                    })
                }
            })
        end
    },
    { 'neovim/nvim-lspconfig' },
    { 'hrsh7th/cmp-nvim-lsp' },
    { 'hrsh7th/nvim-cmp' },
    { 'L3MON4D3/LuaSnip' },
    { "onsails/lspkind.nvim" },
}
