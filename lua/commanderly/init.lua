local library = require("commanderly.library")
local mapper = require("commanderly.mapper")
local renderer = require("commanderly.renderer")
local runner = require("commanderly.runner")

local M = {
  add_commands = library.add_commands,
  map = mapper.map,
  run = runner.run,
}

function M.get_commands()
  local results = {}

  for _, command in ipairs(library.get_commands()) do
    command = renderer.render(command)

    if runner.is_available(command) then
      table.insert(results, command)
    end
  end

  return results
end

local function open_command_palette()
  require("telescope").extensions.commanderly.commanderly()
end

function M.open()
  runner.record_initial_state()
  open_command_palette()
end

function M.run_user_command(arg)
  runner.record_initial_range(arg.line1, arg.line2)

  -- For some reason, the palette doesn't open without the schedule_wrap.
  vim.schedule_wrap(open_command_palette)()
end

function M.setup(opts)
  M.add_commands({ "core", "telescope" })
  M.add_commands(opts.commands)

  require("telescope").load_extension("commanderly")
end

return M
