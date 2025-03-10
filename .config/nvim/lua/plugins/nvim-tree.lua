return {
    "nvim-tree/nvim-tree.lua",
    version = "*",
    lazy = false,
    dependencies = {
        "nvim-tree/nvim-web-devicons",
    },
    config = function()
        local open_nvim_tree = function()
            -- open the tree
            require("nvim-tree.api").tree.open()
        end

        local auto_close = function()
            local invalid_win = {}
            local wins = vim.api.nvim_list_wins()
            for _, w in ipairs(wins) do
                local bufname = vim.api.nvim_buf_get_name(vim.api.nvim_win_get_buf(w))
                if bufname:match("NvimTree_") ~= nil then
                    table.insert(invalid_win, w)
                end
            end
            if #invalid_win == #wins - 1 then
                -- Should quit, so we close all invalid windows.
                for _, w in ipairs(invalid_win) do vim.api.nvim_win_close(w, true) end
            end
        end

        require("nvim-tree").setup {
            view = {
                number = true,
                relativenumber = true,
                width = 40
            },
            filters = {
                custom = { ".git" },
            },
            sync_root_with_cwd = true,
            respect_buf_cwd = true,
            update_focused_file = {
                enable = true,
                update_root = true
            },
        }

        vim.api.nvim_create_autocmd({ "VimEnter" }, { callback = open_nvim_tree })
        vim.api.nvim_create_autocmd({ "QuitPre" }, { callback = auto_close })
    end,
}
