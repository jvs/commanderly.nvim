local has_lualine, lualine = pcall(require, "lualine")

if not has_lualine then
  return {}
end

local has_lualine_config, lualine_config = pcall(require, "lualine.config")

if not has_lualine_config then
  error("Unexpected error: Failed to load lualine config.")
  return {}
end

local default_config = vim.deepcopy(lualine_config.get_config())
local orig_config = nil


local function get_config()
  local result = lualine_config.get_config()

  if orig_config == nil then
    orig_config = vim.deepcopy(result)
  end

  return result
end


local function empty_sections()
  return {
    lualine_a = {},
    lualine_b = {},
    lualine_c = {},
    lualine_x = {},
    lualine_y = {},
    lualine_z = {},
  }
end


local function simple_sections()
  return {
    lualine_a = { "mode" },
    lualine_b = {},
    lualine_c = {},
    lualine_x = {},
    lualine_y = {},
    lualine_z = { "location" }
  }
end


-- Check --

local function is_statusline_visible()
  local current_config = get_config()
  local empty = empty_sections()

  return not (
    vim.deep_equal(current_config.sections, empty)
    and vim.deep_equal(current_config.inactive_sections, empty)
  )
end


local function is_winbar_visible()
  local current_config = get_config()
  local empty = empty_sections()

  return not (
    vim.deep_equal(current_config.winbar, empty)
    and vim.deep_equal(current_config.inactive_winbar, empty)
  )
end


local function is_lualine_visible()
  return is_statusline_visible() or is_winbar_visible()
end


-- Hide --

local function hide_statusline()
  local next_config = vim.deepcopy(get_config())
  next_config.sections = empty_sections()
  next_config.inactive_sections = empty_sections()
  lualine.setup(next_config)
end


local function hide_winbar()
  local next_config = vim.deepcopy(get_config())
  next_config.winbar = empty_sections()
  next_config.inactive_winbar = empty_sections()
  lualine.setup(next_config)
end


local function hide_lualine()
  hide_winbar()
  hide_statusline()
end


-- Show --

local function show_statusline()
  local next_config = vim.deepcopy(get_config())
  next_config.sections = vim.deepcopy(orig_config.sections)
  next_config.inactive_sections = vim.deepcopy(orig_config.inactive_sections)
  lualine.setup(next_config)
end


local function show_winbar()
  local next_config = vim.deepcopy(get_config())
  next_config.winbar = vim.deepcopy(orig_config.winbar)
  next_config.inactive_winbar = vim.deepcopy(orig_config.inactive_winbar)
  lualine.setup(next_config)
end


local function show_lualine()
  show_winbar()
  show_statusline()
end


-- statusline configuration --

local function has_same_statusline(config1, config2)
  return vim.deep_equal(config1.sections, config2.sections)
    and vim.deep_equal(config1.inactive_sections, config2.inactive_sections)
end

local function has_custom_statusline()
  return has_same_statusline(get_config(), orig_config)
end

local function has_default_statusline()
  return has_same_statusline(get_config(), default_config)
end

local function has_simple_statusline()
  return has_same_statusline(get_config(), {
    sections = simple_sections(),
    inactive_sections = simple_sections(),
  })
end

local function show_custom_statusline()
  show_statusline()
end

local function show_default_statusline()
  local next_config = vim.deepcopy(get_config())
  next_config.sections = vim.deepcopy(default_config.sections)
  next_config.inactive_sections = vim.deepcopy(default_config.inactive_sections)
  lualine.setup(next_config)
end

local function show_simple_statusline()
  local next_config = vim.deepcopy(get_config())
  next_config.sections = simple_sections()
  next_config.inactive_sections = simple_sections()
  lualine.setup(next_config)
end


M = {
  has_custom_statusline   = has_custom_statusline,
  has_default_statusline  = has_default_statusline,
  has_lualine             = has_lualine,
  has_simple_statusline   = has_simple_statusline,
  hide_lualine            = hide_lualine,
  hide_statusline         = hide_statusline,
  hide_winbar             = hide_winbar,
  is_lualine_visible      = is_lualine_visible,
  is_statusline_visible   = is_statusline_visible,
  is_winbar_visible       = is_winbar_visible,
  show_custom_statusline  = show_custom_statusline,
  show_default_statusline = show_default_statusline,
  show_lualine            = show_lualine,
  show_simple_statusline  = show_simple_statusline,
  show_statusline         = show_statusline,
  show_winbar             = show_winbar
}

return M
