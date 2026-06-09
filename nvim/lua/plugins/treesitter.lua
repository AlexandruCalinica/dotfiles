local parsers = {
  "typescript",
  "tsx",
  "javascript",
  "lua",
  "json",
  "html",
  "css",
  "yaml",
  "markdown",
  "markdown_inline",
  "bash",
  "elixir",
  "heex",
  "eex",
}

return {
  {
    "nvim-treesitter/nvim-treesitter",
    build = function()
      require("nvim-treesitter").install(parsers)
    end,
    event = { "BufReadPre", "BufNewFile" },
    config = function()
      require("nvim-treesitter").setup()
      require("nvim-treesitter").install(parsers)

      vim.api.nvim_create_autocmd("FileType", {
        callback = function(ev)
          pcall(vim.treesitter.start, ev.buf)
        end,
      })
    end,
  },
  {
    "nvim-treesitter/nvim-treesitter-textobjects",
    event = { "BufReadPre", "BufNewFile" },
    dependencies = { "nvim-treesitter/nvim-treesitter" },
    config = function()
      vim.keymap.set("n", "]m", function()
        require("nvim-treesitter-textobjects.move").goto_next_start("@function.outer")
      end, { desc = "Next function" })
      vim.keymap.set("n", "[m", function()
        require("nvim-treesitter-textobjects.move").goto_previous_start("@function.outer")
      end, { desc = "Prev function" })
      vim.keymap.set("n", "]c", function()
        require("nvim-treesitter-textobjects.move").goto_next_start("@class.outer")
      end, { desc = "Next class" })
      vim.keymap.set("n", "[c", function()
        require("nvim-treesitter-textobjects.move").goto_previous_start("@class.outer")
      end, { desc = "Prev class" })
      vim.keymap.set("n", "]a", function()
        require("nvim-treesitter-textobjects.move").goto_next_start("@parameter.inner")
      end, { desc = "Next parameter" })
      vim.keymap.set("n", "[a", function()
        require("nvim-treesitter-textobjects.move").goto_previous_start("@parameter.inner")
      end, { desc = "Prev parameter" })
    end,
  },
}
