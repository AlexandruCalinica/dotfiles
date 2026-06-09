local prettier_configs = {
  ".prettierrc",
  ".prettierrc.json",
  ".prettierrc.yml",
  ".prettierrc.yaml",
  ".prettierrc.js",
  ".prettierrc.cjs",
  ".prettierrc.mjs",
  ".prettierrc.toml",
  "prettier.config.js",
  "prettier.config.cjs",
  "prettier.config.mjs",
}

local biome_configs = { "biome.json", "biome.jsonc" }

return {
  "stevearc/conform.nvim",
  event = "BufWritePre",
  keys = {
    { "<leader>cf", function() require("conform").format({ async = true }) end, desc = "Format" },
  },
  opts = {
    formatters_by_ft = {
      javascript = { "biome", "prettier", stop_after_first = true },
      javascriptreact = { "biome", "prettier", stop_after_first = true },
      typescript = { "biome", "prettier", stop_after_first = true },
      typescriptreact = { "biome", "prettier", stop_after_first = true },
      json = { "biome", "prettier", stop_after_first = true },
      css = { "prettier" },
      elixir = { "mix" },
      heex = { "mix" },
      eex = { "mix" },
    },
    formatters = {
      biome = {
        condition = function(_, ctx)
          return vim.fs.root(ctx.dirname, biome_configs) ~= nil
        end,
      },
      prettier = {
        condition = function(_, ctx)
          return vim.fs.root(ctx.dirname, prettier_configs) ~= nil
        end,
      },
    },
    format_on_save = {
      timeout_ms = 3000,
      lsp_format = "never",
    },
  },
}
