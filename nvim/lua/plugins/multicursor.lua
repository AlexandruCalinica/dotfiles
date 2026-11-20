return {
  "jake-stewart/multicursor.nvim",
  branch = "1.0",
  keys = function()
    local mc = require("multicursor-nvim")
    return {
      { "<A-j>", function() mc.lineAddCursor(1) end, mode = { "n", "x" }, desc = "Add cursor below" },
      { "<A-k>", function() mc.lineAddCursor(-1) end, mode = { "n", "x" }, desc = "Add cursor above" },
      { "<A-LeftMouse>", mc.handleMouse, mode = { "n", "x" }, desc = "Add cursor at click" },

      { "<c-n>", function() mc.matchAddCursor(1) end, mode = { "n", "x" }, desc = "Add cursor on next match" },
      { "<c-s-n>", function() mc.matchAddCursor(-1) end, mode = { "n", "x" }, desc = "Add cursor on prev match" },
      { "<c-x>", function() mc.matchSkipCursor(1) end, mode = { "n", "x" }, desc = "Skip to next match" },
      { "<c-s-x>", function() mc.matchSkipCursor(-1) end, mode = { "n", "x" }, desc = "Skip to prev match" },

      { "<leader>a", function() mc.matchAllAddCursors() end, mode = { "n", "x" }, desc = "Add cursor on all matches" },

      { "<Tab>", function() mc.nextCursor() end, mode = { "n", "x" }, desc = "Next cursor" },
      { "<s-Tab>", function() mc.prevCursor() end, mode = { "n", "x" }, desc = "Prev cursor" },
      { "<leader>x", function() mc.deleteCursor() end, mode = { "n", "x" }, desc = "Delete cursor" },

      { "<c-q>", function() mc.toggleCursor() end, mode = { "n", "x" }, desc = "Toggle cursor" },
      { "<esc>", function()
        if not mc.cursorsEnabled() then
          mc.enableCursors()
        elseif mc.hasCursors() then
          mc.clearCursors()
        else
          vim.cmd("noh")
        end
      end, desc = "Clear cursors / search highlight" },
    }
  end,
  opts = {},
  config = function(_, opts)
    local mc = require("multicursor-nvim")
    mc.setup()

    local hl = vim.api.nvim_set_hl
    hl(0, "MultiCursorCursor", { link = "Cursor" })
    hl(0, "MultiCursorVisual", { link = "Visual" })
    hl(0, "MultiCursorSign", { link = "SignColumn" })
    hl(0, "MultiCursorMatchPreview", { link = "Search" })
    hl(0, "MultiCursorDisabledCursor", { link = "Visual" })
    hl(0, "MultiCursorDisabledVisual", { link = "Visual" })
    hl(0, "MultiCursorDisabledSign", { link = "SignColumn" })
  end,
}
