if vim.g.loaded_commanderly == 1 then
  return
end
vim.g.loaded_commanderly = 1


vim.api.nvim_create_user_command("Commanderly", function(...)
  local args = {...}
  local line1 = args[1]["line1"]
  local line2 = args[1]["line2"]

  require("commanderly").open(line1, line2)
end, { range = true })
