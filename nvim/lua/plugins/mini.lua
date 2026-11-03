return {
  "echasnovski/mini.nvim",
  version = false,
  lazy = false,
  config = function()
    local starter = require("mini.starter")
    local platform = require("config.platform")

    require("mini.icons").setup()

    local files_opts = {
      mappings = {
        go_in = "l",
        go_in_plus = "L",
        go_out = "h",
        go_out_plus = "H",
      },
    }

    if platform.is_linux then
      -- Disable icons to avoid double-width rendering over SSH.
      files_opts.content = { prefix = function() end }
      files_opts.windows = { width_focus = 30, width_nofocus = 15, width_preview = 40 }
    else
      MiniIcons.mock_nvim_web_devicons()
    end

    require("mini.files").setup(files_opts)
    local function mini_files_target()
      local path = vim.api.nvim_buf_get_name(0)
      if vim.bo.buftype == "" and path ~= "" and vim.uv.fs_stat(path) ~= nil then
        return path
      end

      return vim.uv.cwd()
    end

    vim.keymap.set("n", "<leader>e", function()
      require("mini.files").open(mini_files_target(), true)
    end, { desc = "Explorer (current file)" })
    vim.keymap.set("n", "<leader>E", function()
      require("mini.files").open(vim.uv.cwd(), true)
    end, { desc = "Explorer (cwd)" })

    require("mini.pairs").setup()

    require("mini.surround").setup()

    require("mini.ai").setup({
      n_lines = 500,
      custom_textobjects = {
        o = require("mini.ai").gen_spec.treesitter({
          a = { "@block.outer", "@conditional.outer", "@loop.outer" },
          i = { "@block.inner", "@conditional.inner", "@loop.inner" },
        }),
        f = require("mini.ai").gen_spec.treesitter({ a = "@function.outer", i = "@function.inner" }),
        c = require("mini.ai").gen_spec.treesitter({ a = "@class.outer", i = "@class.inner" }),
        a = require("mini.ai").gen_spec.treesitter({ a = "@parameter.outer", i = "@parameter.inner" }),
      },
    })

    starter.setup({
      evaluate_single = true,
      header = table.concat({
        "███╗   ██╗██╗   ██╗██╗███╗   ███╗",
        "████╗  ██║██║   ██║██║████╗ ████║",
        "██╔██╗ ██║██║   ██║██║██╔████╔██║",
        "██║╚██╗██║╚██╗ ██╔╝██║██║╚██╔╝██║",
        "██║ ╚████║ ╚████╔╝ ██║██║ ╚═╝ ██║",
        "╚═╝  ╚═══╝  ╚═══╝  ╚═╝╚═╝     ╚═╝",
        "",
        os.date("%A, %B %d"),
      }, "\n"),
      items = {
        {
          { name = "Find files", action = "lua require('telescope.builtin').find_files()", section = "Actions" },
          { name = "Live grep", action = "lua require('telescope.builtin').live_grep()", section = "Actions" },
          { name = "Recent files", action = "lua require('telescope.builtin').oldfiles()", section = "Actions" },
          { name = "New file", action = "ene | startinsert", section = "Actions" },
          { name = "Config", action = "edit $MYVIMRC", section = "Actions" },
          { name = "Plugin manager", action = "Lazy", section = "Actions" },
          { name = "Quit", action = "qa", section = "Actions" },
        },
        starter.sections.recent_files(7, false),
      },
      footer = "",
      content_hooks = {
        starter.gen_hook.adding_bullet("  "),
        starter.gen_hook.indexing("all", { "Actions", "Recent files" }),
        starter.gen_hook.padding(3, 2),
      },
    })

    require("mini.statusline").setup()

    require("mini.tabline").setup()
  end,
}
