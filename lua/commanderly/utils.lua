local M = {}

function M.is_quickfix_open()
  for _, info in pairs(vim.fn.getwininfo()) do
    if info.quickfix == 1 then
      return true
    end
  end
  return false
end

function M.is_loclist_open()
  -- When the first argument is zero, it uses the current window.
  local winid = vim.fn.getloclist(0, { winid = 0 }).winid
  return winid ~= 0
end

function M.has_attached_lsp()
  local filter = { bufnr = vim.fn.bufnr() }
  local clients = vim.lsp.get_active_clients(filter)
  local num_clients = #vim.tbl_keys(clients)
  return num_clients > 0
end

-- For now, assume diagnostics start out enabled.
-- TODO: Figure out how to detect if diagnostics are enabled.
local diagnostics_enabled = true

function M.are_diagnostics_enabled()
  return diagnostics_enabled
end

function M.disable_diagnostics()
  diagnostics_enabled = false
  vim.diagnostic.disable()
end

function M.enable_diagnostics()
  diagnostics_enabled = true
  vim.diagnostic.enable()
end

function M.set_for_all_normal_windows(name, value)
  for _, info in pairs(vim.fn.getwininfo()) do
    if info.loclist ~= 1 and info.quickfix ~= 1 and info.terminal ~= 1 then
      vim.api.nvim_win_set_option(info.winid, name, value)
    end
  end
end

-- When pasting over selected text, don't put the deleted text in the register.
function M.paste_over_selected_text(keys)
  -- Get the value of the yank register.
  local yanked = vim.fn.getreg('"')

  -- Execute the paste operation as normal.
  vim.api.nvim_feedkeys(keys or "p", "n", false)

  -- Resore the value of the yank register immediately after this action
  -- is finished.
  vim.schedule_wrap(vim.fn.setreg)("", yanked)

  -- Note:
  -- There's a keymapping some people use to accomplish this:
  -- `vim.keymap.set("v", "p", '"_dP', {})`
  -- The problem is that this key mapping does not work correctly when you're
  -- pasting over the last word on a line. It removes the space before the
  -- word. (Basically, in that case it should use "p" instead of "P".)
end

return M
