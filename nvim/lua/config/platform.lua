-- Platform detection and per-OS overrides.
-- macOS keeps the original setup; Linux (headless box over SSH) gets
-- the tweaks needed for things to render as expected.
local M = {}

M.is_mac = vim.fn.has("mac") == 1
M.is_linux = not M.is_mac and vim.fn.has("linux") == 1

function M.setup()
  if M.is_mac then
    require("config.os.macos")
  elseif M.is_linux then
    require("config.os.linux")
  end
end

return M
