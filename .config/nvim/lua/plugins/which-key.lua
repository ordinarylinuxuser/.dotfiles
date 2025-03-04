return {
    "folke/which-key.nvim",
    event = "VeryLazy",
    opts = {
        preset = "modern",
        spec = {
            { "<leader>w",  "<cmd>update!<CR>",                                     desc = "Save" },
            { "<leader>q",  "<cmd>q!<CR>",                                          desc = "Quit" },

            -- Buffers
            { "<leader>b",  group = "Buffers" },
            { "<leader>bc", "<cmd>bd!<CR>",                                         desc = "Close Current Buffer" },
            { "<leader>bD", "<Cmd>%bd|e#|bd#<CR>",                                  desc = "Delete All Buffers" },

            -- Find
            { "<leader>f",  group = "Find" },
            { "<leader>ff", "<cmd>lua require('plugins.fzf_lua').find_files()<CR>", desc = "Find Files" },
            { "<leader>fb", "<cmd>FzfLua buffers<CR>",                              desc = "Find Buffers" },
            { "<leader>fo", "<cmd>FzfLua oldfiles<CR>",                             desc = "Find Old Files" },
            { "<leader>fg", "<cmd>FzfLua live_grep<CR>",                            desc = "Live Grep" },
            { "<leader>fc", "<cmd>FzfLua commands<CR>",                             desc = "Find Commands" },
            { "<leader>fe", "<cmd>NvimTreeToggle<CR>",                              desc = "Explorer" },

            -- Git
            { "<leader>gs", "<cmd>Git<CR>",                                         desc = "Git Status" },

        }
    },
    keys = {
        {
            "<leader>?",
            function()
                require("which-key").show({ global = false })
            end,
            desc = "Buffer Local Keymaps (which-key)",
        },
    },
}
