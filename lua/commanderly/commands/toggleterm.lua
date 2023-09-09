-- Commands to toggle terminals.
-- Requires 'akinsho/toggleterm.nvim'.

local function switch_terminals(target_terminal)
  local mode = vim.api.nvim_get_mode().mode

  if mode == 't' then
    local current_buf = vim.api.nvim_get_current_buf()
    local current_terminal = vim.api.nvim_buf_get_var(current_buf, 'toggle_number')
    vim.cmd('ToggleTerm')

    if current_terminal ~= target_terminal then
      vim.schedule_wrap(vim.cmd)(target_terminal .. 'ToggleTerm')
    end
  else
    local command = '<CMD>' .. target_terminal .. 'ToggleTerm<CR>'
    local keys = vim.api.nvim_replace_termcodes(command, true, false, true)
    vim.api.nvim_feedkeys(keys, "n", false)
  end
end

local commands = {}

for num = 1, 9 do
  local command = {
    title = "Toggle Terminal-" .. num,
    id = "toggle_terminal_" .. num,
    desc = "Toggle terminal-" .. num .. ", same as :" .. num .. "ToggleTerm",
    run = function()
      switch_terminals(num)
    end,
    keywords = "toggleterm",

    -- Only show the first terminal in the command palette.
    hidden = (num ~= 1),
  }
  table.insert(commands, command)
end

return commands
