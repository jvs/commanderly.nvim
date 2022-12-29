local commands = {
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
