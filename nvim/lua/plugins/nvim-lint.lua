local eslint_configs = {
  ".eslintrc",
  ".eslintrc.js",
  ".eslintrc.cjs",
  ".eslintrc.json",
  ".eslintrc.yml",
  ".eslintrc.yaml",
  "eslint.config.js",
  "eslint.config.mjs",
  "eslint.config.cjs",
  "eslint.config.ts",
  "eslint.config.mts",
  "eslint.config.cts",
}

return {
  "mfussenegger/nvim-lint",
  event = { "BufReadPre", "BufNewFile" },
  config = function()
    local lint = require("lint")

    lint.linters_by_ft = {
      javascript = { "eslint_d" },
      javascriptreact = { "eslint_d" },
      typescript = { "eslint_d" },
      typescriptreact = { "eslint_d" },
    }

    lint.linters.eslint_d = require("lint.util").wrap(lint.linters.eslint_d, function(diagnostic)
      return diagnostic
    end)

    vim.api.nvim_create_autocmd({ "BufWritePost", "BufReadPost", "InsertLeave" }, {
      callback = function(ev)
        local buf_dir = vim.fs.dirname(vim.api.nvim_buf_get_name(ev.buf))
        local root = buf_dir and vim.fs.root(buf_dir, eslint_configs)
        if root then
          lint.try_lint(nil, { cwd = root })
        end
      end,
    })
  end,
}
