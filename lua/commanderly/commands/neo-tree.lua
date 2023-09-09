-- Commands to toggle Neo-tree.
-- Requires 'nvim-neo-tree/neo-tree.nvim'.
return {
  {
    title = "Toggle Filesystem Explorer",
    id = "neotree_filesystem",
    desc = "Open a file browser and reveal the current file.",
    run = "Neotree reveal toggle",
    keywords = "neo-tree",
  },
  {
    title = "Toggle Buffer Explorer",
    id = "neotree_buffers",
    desc = "Open a tree explorer of the current buffers.",
    run = "Neotree buffers toggle",
    keywords = "neo-tree",
  },
  {
    title = "Toggle Git Status Explorer",
    id = "neotree_git_status",
    desc = "Open a tree explorer of the current git status.",
    run = "Neotree git_status toggle",
    keywords = "neo-tree",
  },
}
