local icons = {
  Error = " ",
  Warn = " ",
  Hint = " ",
  Info = " ",
}

return {
  "neovim/nvim-lspconfig",
  event = { "BufReadPre", "BufNewFile" },
  dependencies = {
    "mason.nvim",
    { "mason-org/mason-lspconfig.nvim", config = function() end },
  },
  opts = function()
    local ret = {
      diagnostics = {
        underline = true,
        update_in_insert = false,
        virtual_text = false,
        float = {
          border = "rounded",
          source = "if_many",
          max_width = 100,
          wrap = true,
          focusable = false,
        },
        severity_sort = true,
        signs = {
          text = {
            [vim.diagnostic.severity.ERROR] = icons.Error,
            [vim.diagnostic.severity.WARN] = icons.Warn,
            [vim.diagnostic.severity.HINT] = icons.Hint,
            [vim.diagnostic.severity.INFO] = icons.Info,
          },
        },
      },
      inlay_hints = {
        enabled = true,
        exclude = { "vue" },
      },
      codelens = {
        enabled = false,
      },
      folds = {
        enabled = true,
      },
      format = {
        formatting_options = nil,
        timeout_ms = nil,
      },
      servers = {
        ["*"] = {
          capabilities = {
            workspace = {
              fileOperations = {
                didRename = true,
                willRename = true,
              },
            },
          },
        },
        lexical = { enabled = false },
        tsgo = { enabled = false },
        ts_ls = {},
        stylua = { enabled = false },
        lua_ls = {
          settings = {
            Lua = {
              workspace = {
                checkThirdParty = false,
              },
              codeLens = {
                enable = true,
              },
              completion = {
                callSnippet = "Replace",
              },
              doc = {
                privateName = { "^_" },
              },
              hint = {
                enable = true,
                setType = false,
                paramType = true,
                paramName = "Disable",
                semicolon = "Disable",
                arrayIndex = "Disable",
              },
            },
          },
        },
      },
      setup = {},
    }
    return ret
  end,
  config = function(_, opts)
    -- LSP keymaps via LspAttach
    vim.api.nvim_create_autocmd("LspAttach", {
      callback = function(ev)
        local buf = ev.buf
        local function map(mode, lhs, rhs, desc)
          vim.keymap.set(mode, lhs, rhs, { buffer = buf, desc = desc })
        end

        local has_snacks = pcall(require, "snacks")

        if has_snacks then
          map("n", "<leader>cl", function() Snacks.picker.lsp_config() end, "Lsp Info")
          map("n", "<leader>cR", function() Snacks.rename.rename_file() end, "Rename File")
          map("n", "]]", function() Snacks.words.jump(vim.v.count1) end, "Next Reference")
          map("n", "[[", function() Snacks.words.jump(-vim.v.count1) end, "Prev Reference")
          map("n", "<a-n>", function() Snacks.words.jump(vim.v.count1, true) end, "Next Reference")
          map("n", "<a-p>", function() Snacks.words.jump(-vim.v.count1, true) end, "Prev Reference")
        end

        map("n", "gd", vim.lsp.buf.definition, "Goto Definition")
        map("n", "gr", vim.lsp.buf.references, "References")
        map("n", "gI", vim.lsp.buf.implementation, "Goto Implementation")
        map("n", "gy", vim.lsp.buf.type_definition, "Goto T[y]pe Definition")
        map("n", "gD", vim.lsp.buf.declaration, "Goto Declaration")
        map("n", "K", vim.lsp.buf.hover, "Hover")
        map("n", "gK", vim.lsp.buf.signature_help, "Signature Help")
        map("i", "<c-k>", vim.lsp.buf.signature_help, "Signature Help")
        map({ "n", "x" }, "<leader>ca", vim.lsp.buf.code_action, "Code Action")
        map({ "n", "x" }, "<leader>cc", vim.lsp.codelens.run, "Run Codelens")
        map("n", "<leader>cC", vim.lsp.codelens.refresh, "Refresh & Display Codelens")
        map("n", "<leader>cr", vim.lsp.buf.rename, "Rename")
        map("n", "<leader>cA", function()
          vim.lsp.buf.code_action({ context = { only = { "source" }, diagnostics = {} } })
        end, "Source Action")
      end,
    })

    -- inlay hints
    if opts.inlay_hints.enabled then
      local ok = pcall(require, "snacks")
      if ok then
        Snacks.util.lsp.on({ method = "textDocument/inlayHint" }, function(buffer)
          if
            vim.api.nvim_buf_is_valid(buffer)
            and vim.bo[buffer].buftype == ""
            and not vim.tbl_contains(opts.inlay_hints.exclude, vim.bo[buffer].filetype)
          then
            vim.lsp.inlay_hint.enable(true, { bufnr = buffer })
          end
        end)
      end
    end

    -- folds
    if opts.folds.enabled then
      local ok = pcall(require, "snacks")
      if ok then
        Snacks.util.lsp.on({ method = "textDocument/foldingRange" }, function()
          vim.o.foldmethod = "expr"
          vim.o.foldexpr = "v:lua.vim.lsp.foldexpr()"
        end)
      end
    end

    -- code lens
    if opts.codelens.enabled and vim.lsp.codelens then
      local ok = pcall(require, "snacks")
      if ok then
        Snacks.util.lsp.on({ method = "textDocument/codeLens" }, function(buffer)
          vim.lsp.codelens.refresh()
          vim.api.nvim_create_autocmd({ "BufEnter", "CursorHold", "InsertLeave" }, {
            buffer = buffer,
            callback = vim.lsp.codelens.refresh,
          })
        end)
      end
    end

    -- diagnostics
    if type(opts.diagnostics.virtual_text) == "table" and opts.diagnostics.virtual_text.prefix == "icons" then
      opts.diagnostics.virtual_text.prefix = function(diagnostic)
        for d, icon in pairs(icons) do
          if diagnostic.severity == vim.diagnostic.severity[d:upper()] then
            return icon
          end
        end
        return "●"
      end
    end
    vim.diagnostic.config(vim.deepcopy(opts.diagnostics))

    vim.keymap.set("n", "[d", vim.diagnostic.goto_prev, { desc = "Prev Diagnostic" })
    vim.keymap.set("n", "]d", vim.diagnostic.goto_next, { desc = "Next Diagnostic" })
    vim.keymap.set("n", "<leader>cd", function()
      vim.diagnostic.open_float(nil, { scope = "cursor" })
    end, { desc = "Line Diagnostics" })

    if opts.servers["*"] then
      vim.lsp.config("*", opts.servers["*"])
    end

    -- mason-lspconfig integration
    local have_mason, mason_lspconfig = pcall(require, "mason-lspconfig")
    local mason_all = have_mason
        and vim.tbl_keys(require("mason-lspconfig.mappings").get_mason_map().lspconfig_to_package)
      or {}
    local mason_exclude = {}

    local function configure(server)
      if server == "*" then
        return false
      end
      local sopts = opts.servers[server]
      sopts = sopts == true and {} or (not sopts) and { enabled = false } or sopts

      if sopts.enabled == false then
        mason_exclude[#mason_exclude + 1] = server
        return
      end

      local use_mason = sopts.mason ~= false and vim.tbl_contains(mason_all, server)
      local setup = opts.setup[server] or opts.setup["*"]
      if setup and setup(server, sopts) then
        mason_exclude[#mason_exclude + 1] = server
      else
        vim.lsp.config(server, sopts)
        if not use_mason then
          vim.lsp.enable(server)
        end
      end
      return use_mason
    end

    local install = vim.tbl_filter(configure, vim.tbl_keys(opts.servers))
    if have_mason then
      mason_lspconfig.setup({
        ensure_installed = install,
        automatic_enable = { exclude = mason_exclude },
      })
    end
  end,
}
