vim.g.ruby_host_prog = '/opt/homebrew/lib/ruby/gems/4.0.0/bin/neovim-ruby-host'
vim.g.perl_host_prog = '/opt/homebrew/bin/perl'
vim.g.python3_host_prog = '/Library/Frameworks/Python.framework/Versions/3.14/bin/python3'

vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.clipboard = "unnamedplus"
vim.opt.tabstop = 2
vim.opt.softtabstop = 2
vim.opt.shiftwidth = 2
vim.opt.expandtab = true

vim.opt.foldlevel = 99
vim.opt.foldlevelstart = 99

require("config.lazy")

vim.keymap.set("n", "<S-h>", "<cmd>bp<cr>", { desc = "Prev buffer" })
vim.keymap.set("n", "<S-l>", "<cmd>bn<cr>", { desc = "Next buffer" })
vim.keymap.set("n", "<leader>bd", "<cmd>bd<cr>", { desc = "Close buffer" })

vim.keymap.set("n", "<C-h>", "<C-w>h", { desc = "Go to left split" })
vim.keymap.set("n", "<C-j>", "<C-w>j", { desc = "Go to below split" })
vim.keymap.set("n", "<C-k>", "<C-w>k", { desc = "Go to above split" })
vim.keymap.set("n", "<C-l>", "<C-w>l", { desc = "Go to right split" })
