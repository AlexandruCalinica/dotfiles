return {
  "yetone/avante.nvim",
  event = "VeryLazy",
  version = false, -- Never set this value to "*"! Never!
  build = vim.fn.has("win32") ~= 0
      and "powershell -ExecutionPolicy Bypass -File Build.ps1 -BuildFromSource false"
      or "make",
  ---@module 'avante'
  ---@type avante.Config
  opts = {
    provider = "claude",
    input = {
      provider = "snacks",
      provider_opts = {
        title = "Avante Input",
        icon = " ",
      },
    },
    providers = {
      claude = {
        endpoint = "https://api.anthropic.com",
        model = "claude-sonnet-4-20250514",
        timeout = 30000,
        extra_request_body = {
          temperature = 0.75,
          max_tokens = 20480,
        },
      },
    },
  },
  dependencies = {
    "nvim-lua/plenary.nvim",
    "MunifTanjim/nui.nvim",
    "nvim-telescope/telescope.nvim",
    "zbirenbaum/copilot.lua",
    {
      "folke/snacks.nvim",
      priority = 1000,
      lazy = false,
      opts = {
        input = { enabled = true },
      },
    },
    {
      "HakonHarnes/img-clip.nvim",
      event = "VeryLazy",
      opts = {
        default = {
          embed_image_as_base64 = false,
          prompt_for_file_name = false,
          drag_and_drop = {
            insert_mode = true,
          },
        },
        filetypes = {
          ministarter = { drag_and_drop = { enabled = false } },
        },
      },
    },
  },
}
