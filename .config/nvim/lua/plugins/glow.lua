return {
    "ellisonleao/glow.nvim",
    config = function()
        require('glow').setup({
            border = 'rounded'
        })
    end,
    cmd = "Glow"
}
