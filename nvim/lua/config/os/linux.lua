vim.opt.termguicolors = true
vim.opt.background = "dark"

-- Over SSH there is no system clipboard; use OSC 52 through the terminal.
if vim.env.SSH_TTY then
  local osc52 = require("vim.ui.clipboard.osc52")

  vim.g.clipboard = {
    name = "OSC 52",
    copy = {
      ["+"] = osc52.copy("+"),
      ["*"] = osc52.copy("*"),
    },
    paste = {
      ["+"] = osc52.paste("+"),
      ["*"] = osc52.paste("*"),
    },
  }
end
