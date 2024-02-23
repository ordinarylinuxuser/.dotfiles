return {
    "VonHeikemen/fine-cmdline.nvim",
    dependencies = { "MunifTanjim/nui.nvim" },
    config = function()
        require('fine-cmdline').setup({
            popup = {
                position = {
                    row = '80%',
                    col = '50%'
                }
            }
        })

        -- keybinding for show fine cmdline on enter
        vim.api.nvim_set_keymap('n', '<CR>', '<cmd>FineCmdline<CR>', { noremap = true })
    end
}
