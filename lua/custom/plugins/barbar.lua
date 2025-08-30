return {
  {
    'romgrk/barbar.nvim',
    dependencies = {
      'lewis6991/gitsigns.nvim', -- OPTIONAL: for git status
      'nvim-tree/nvim-web-devicons', -- OPTIONAL: for file icons
    },
    init = function()
      -- disable auto-setup so lazy.nvim applies your opts to setup()
      vim.g.barbar_auto_setup = true
    end,
    opts = {
      -- put your options here; anything missing uses defaults
      animation = true,
      -- insert_at_start = true,
    },
    version = '^1.0.0', -- only update on new 1.x releases

    config = function(_, opts)
      require('barbar').setup(opts)

      -- Switch buffers like Chrome tabs
      vim.keymap.set('n', '<C-Tab>', '<Cmd>BufferNext<CR>', { desc = 'Next buffer' })
      vim.keymap.set('n', '<C-S-Tab>', '<Cmd>BufferPrevious<CR>', { desc = 'Previous buffer' })
      -- Close buffer with Ctrl+w
      vim.keymap.set('n', '<C-w>', '<Cmd>BufferClose<CR>', { desc = 'Close buffer' })
    end,
  },
}
