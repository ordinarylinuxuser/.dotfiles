return { --- Uncomment these if you want to manage LSP servers from neovim
    { 'williamboman/mason.nvim' },
    { 'williamboman/mason-lspconfig.nvim' },
    { "Hoffs/omnisharp-extended-lsp.nvim", },
    {
        'VonHeikemen/lsp-zero.nvim',
        branch = 'v3.x',
        config = function()
            vim.g.lsp_zero_extend_lspconfig = 1
            vim.g.lsp_zero_extend_cmp = 1
            local pid = vim.fn.getpid()
            local mason_path = vim.fn.expand('$HOME/.local/share/nvim/mason/')
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

            -- mason setup
            require('mason').setup({})
            require('mason-lspconfig').setup({
                ensure_installed = { 'lua_ls', 'omnisharp' },
                handlers = {
                    lsp_zero.default_setup,
                    omnisharp = function()
                        require('lspconfig').omnisharp.setup {
                            cmd = { mason_path .. "bin/omnisharp", '--languageserver', '--hostPID', tostring(pid) },

                            -- Enables support for reading code style, naming convention and analyzer
                            -- settings from .editorconfig.
                            enable_editorconfig_support = true,

                            -- If true, MSBuild project system will only load projects for files that
                            -- were opened in the editor. This setting is useful for big C# codebases
                            -- and allows for faster initialization of code navigation features only
                            -- for projects that are relevant to code that is being edited. With this
                            -- setting enabled OmniSharp may load fewer projects and may thus display
                            -- incomplete reference lists for symbols.
                            enable_ms_build_load_projects_on_demand = false,

                            -- Enables support for roslyn analyzers, code fixes and rulesets.
                            enable_roslyn_analyzers = false,

                            -- Specifies whether 'using' directives should be grouped and sorted during
                            -- document formatting.
                            organize_imports_on_format = false,

                            -- Enables support for showing unimported types and unimported extension
                            -- methods in completion lists. When committed, the appropriate using
                            -- directive will be added at the top of the current file. This option can
                            -- have a negative impact on initial completion responsiveness,
                            -- particularly for the first few completion sessions after opening a
                            -- solution.
                            enable_import_completion = false,

                            -- Specifies whether to include preview versions of the .NET SDK when
                            -- determining which version to use for project loading.
                            sdk_include_prereleases = true,

                            -- Only run analyzers against open files when 'enableRoslynAnalyzers' is
                            -- true
                            analyze_open_documents_only = false,
                            handlers = {
                                ["textDocument/definition"] = require('omnisharp_extended').handler
                            }
                        }
                    end
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
