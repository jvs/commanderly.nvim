# commanderly.nvim

Command palette plugin for Neovim.


## Installation

### lazy.nvim
```lua
  {
    'jvs/commanderly.nvim',
    dependencies = {
      'nvim-telescope/telescope.nvim',
    },
    opts = {
      commands = {"comment", "lualine", "neo-tree", "undotree", "zen-mode"},
    },
  },
```

## Related Projects

- [cheatsheet](https://github.com/sudormrfbin/cheatsheet.nvim)
- [command-center](https://github.com/FeiyouG/command_center.nvim)
- [legendary](https://github.com/mrjones2014/legendary.nvim)
- [nvim-mapper](https://github.com/lazytanuki/nvim-mapper)
- [telescope-command-palette](https://github.com/LinArcX/telescope-command-palette.nvim)
