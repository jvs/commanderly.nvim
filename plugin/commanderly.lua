if vim.g.loaded_commanderly == 1 then
  return
end
vim.g.loaded_commanderly = 1


vim.api.nvim_create_user_command("Commanderly", function(arg)
  require("commanderly").run_user_command(arg)
end, { range = true })
