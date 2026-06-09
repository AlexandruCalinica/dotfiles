return {
  "zbirenbaum/copilot.lua",
  cmd = "Copilot",
  event = "InsertEnter",
  opts = {
    suggestion = {
      enabled = true,
      auto_trigger = true,
      keymap = {
        accept = "<Tab>",
        accept_word = "<C-j>",
        accept_line = "<C-l>",
        dismiss = "<C-]>",
        next = "<M-]>",
        prev = "<M-[>",
      },
    },
    panel = { enabled = false },
  },
}
