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
  -- TODO: Figure out how to tell if the loclist is open for the current window.
  local winid = vim.fn.win_getid()
  local wininfo = vim.fn.getwininfo(winid)[1]
  local tabnr = wininfo.tabnr
  -- local wincol = vim.fn.wincol()
  local wincol = wininfo.wincol
  for _, info in pairs(vim.fn.getwininfo()) do
    if info.loclist == 1 and info.tabnr == tabnr and info.wincol == wincol then
      return true
    end
  end
  return false
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

return M
