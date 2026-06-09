return {
  "OXY2DEV/markview.nvim",
  lazy = false,
  ft = { "markdown", "quarto", "rmd", "norg", "org", "vimwiki", "Avante" },
  dependencies = {
    "nvim-treesitter/nvim-treesitter",
  },
  opts = {
    preview = {
      ignore_buftypes = { "nofile", "prompt", "help", "terminal" },
      filetypes = { "markdown", "quarto", "rmd", "typst", "asciidoc", "Avante" },
      condition = function(buffer)
        local bufname = vim.api.nvim_buf_get_name(buffer)
        if bufname:match("://") then
          return false
        end
        return nil
      end,
    },
  },
}
