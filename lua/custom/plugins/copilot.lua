return {
  'zbirenbaum/copilot.lua',
  event = 'VimEnter',
  config = function()
    require('copilot').setup {
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
    
    -- Enable Copilot by default for all filetypes
    vim.g.copilot_enabled = true
    
    -- Auto-attach Copilot for all buffers
    vim.api.nvim_create_autocmd({'BufEnter', 'BufNewFile'}, {
      pattern = '*',
      callback = function()
        vim.cmd('Copilot! attach')
      end,
    })
  end,
}
