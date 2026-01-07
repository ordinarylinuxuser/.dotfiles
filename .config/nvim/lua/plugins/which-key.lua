return {
    "folke/which-key.nvim",
    event = "VeryLazy",
    opts = {
        preset = "modern",
        spec = {
            { "<leader>w",  "<cmd>w<CR>",                                           desc = "[W]rite" },
            { "<leader>sw", "<cmd>SudaWrite<CR>",                                   desc = "[S]uda [W]rite" },
            { "<leader>q",  "<cmd>q<CR>",                                           desc = "[Q]uit" },

            -- Buffers
            { "<leader>b",  group = "Buffers" },
            { "<leader>bc", "<cmd>bd!<CR>",                                         desc = "[C]lose Current Buffer" },
            { "<leader>bd", "<Cmd>%bd|e#|bd#<CR>",                                  desc = "[D]elete All Buffers" },

            -- Find
            { "<leader>f",  group = "Find" },
            { "<leader>ff", "<cmd>lua require('plugins.fzf_lua').find_files()<CR>", desc = "Find [F]iles" },
            { "<leader>fb", "<cmd>FzfLua buffers<CR>",                              desc = "Find [B]uffers" },
            { "<leader>fo", "<cmd>FzfLua oldfiles<CR>",                             desc = "Find [O]ld Files" },
            { "<leader>fg", "<cmd>FzfLua live_grep<CR>",                            desc = "Live [G]rep" },
            { "<leader>fc", "<cmd>FzfLua commands<CR>",                             desc = "Find [C]ommands" },
            { "<leader>fe", "<cmd>NvimTreeToggle<CR>",                              desc = "[E]xplorer" },

            -- Lazy
            { "<leader>ls", "<cmd>Lazy sync<CR>",                                   desc = "[l]azy [s]ync" },

            -- Glow
            { "<leader>mp", "<cmd>Glow<CR>",                                        desc = "[M]arkdown [P]review" },
            { "<leader>mt", "<cmd>Mtoc<CR>",                                        desc = "[M]arkdown [T]able of Content" },

            -- Terminal
            { "<leader>tt", "<cmd>belowright terminal<CR>",                         desc = "[T]oggle [T]erminal" },

        }
    },
    keys = {
    },
}
