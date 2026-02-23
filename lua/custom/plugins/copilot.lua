return {
  'zbirenbaum/copilot.lua',
  event = 'VimEnter',
  config = function()
    require('copilot').setup {
      filetypes = {
        ['*'] = true,
      },
      suggestion = {
        enabled = true,
        auto_trigger = true,
        keymap = {
          accept = '<Tab>',
          accept_word = false,
          accept_line = false,
          next = '<M-]>',
          prev = '<M-[>',
          dismiss = '<C-]>',
        },
      },
      panel = { enabled = true },
      copilot_node_command = 'node',
    }
  end,
}
