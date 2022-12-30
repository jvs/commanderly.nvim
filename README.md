# commanderly.nvim

Command palette plugin for Neovim.


## Installation

### Packer
```lua
  use {
    "jvs/commanderly.nvim",
    requires = { "nvim-telescope/telescope.nvim" },
    config = function()
      require("telescope").load_extension("commanderly")
    end,
  }
```

### Vim-Plug
```viml
Plug "nvim-telescope/telescope.nvim"
Plug "jvs/commanderly.nvim"
```


## Related Projects

- [command-center](https://github.com/FeiyouG/command_center.nvim)
- [nvim-mapper](https://github.com/lazytanuki/nvim-mapper)
- [telescope-command-palette](https://github.com/LinArcX/telescope-command-palette.nvim)
