-- Simple command to toggle undotree.
-- Requires 'mbbill/undotree'.
return {
  {
    title = "Toggle Undotree",
    id = "undotree",
    desc = "View or hide the undotree for the current file.",
    run = "UndotreeToggle",
  },
}
