local commands = {
  -- Buffers --
  {
    title = "Show Next Buffer",
    desc = "Show the next buffer in the current view.",
    mode = "n",
    alias = "bnext",
  },
  {
    title = "Show Previous Buffer",
    desc = "Show the previous buffer in the current view.",
    mode = "n",
    alias = "bprevious",
  },

  -- Paths --
  {
    title = "Copy Absolute Path",
    desc = "Copy the absolute path of the current file to the clipboard.",
    mode = "n",
    run = function()
      vim.cmd("let @+ = expand('%:p')")
      -- TODO: Figure out how to display this even when Telescope was in insert
      -- mode when this command was selected. (This comment applies to all
      -- commands that try to print messages.)
      print('Copied "' .. vim.fn.expand("%:p") .. '" to the clipboard.')
    end,
  },
  {
    title = "Copy Relative Path",
    desc = "Copy the relative path of the current file to the clipboard.",
    mode = "n",
    run = function()
      vim.cmd("let @+ = expand('%')")
      print('Copied "' .. vim.fn.expand("%") .. '" to the clipboard.')
    end,
  },
  {
    title = "Yank Absolute Path",
    desc = "Yank the absolute path of the current file.",
    mode = "n",
    run = function()
      vim.cmd('let @" = expand("%:p")')
      print('Yanked "' .. vim.fn.expand("%:p") .. '".')
    end,
  },
  {
    title = "Yank Relative Path",
    desc = "Yank the relative path of the current file.",
    mode = "n",
    run = function()
      vim.cmd('let @" = expand("%")')
      print('Yanked "' .. vim.fn.expand("%") .. '"')
    end,
  },

  -- Splits --
  {
    title = "Horizontal Split",
    desc = "Create a new horizontal split.",
    mode = "n",
    alias = "sp",
  },
  {
    title = "Vertical Split",
    desc = "Create a new vertical split.",
    mode = "n",
    alias = "vsp",
  },
  {
    title = "Close Split",
    desc = "Close the current split.",
    mode = "n",
    alias = "q",
  },
  {
    title = "Move to Left Split",
    desc = "Move the cursor to the left split.",
    mode = "n",
    run = "<C-W><C-H>",
  },
  {
    title = "Move to Lower Split",
    desc = "Move the cursor to the lower split.",
    mode = "n",
    run = "<C-W><C-J>",
  },
  {
    title = "Move to Upper Split",
    desc = "Move the cursor to the upper split.",
    mode = "n",
    run = "<C-W><C-K>",
  },
  {
    title = "Move to Right Split",
    desc = "Move the cursor to the right split.",
    mode = "n",
    run = "<C-W><C-L>",
  },
}

return commands
