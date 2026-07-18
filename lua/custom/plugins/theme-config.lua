return {
  {
    'nyoom-engineering/oxocarbon.nvim',
    config = function()
      vim.cmd.colorscheme 'oxocarbon'

      -- Lighten comments for better readability
      vim.api.nvim_set_hl(0, 'Comment', { fg = '#a8a8a8', italic = false })

      -- Make .diff/.patch files render with clear red/green lines.
      -- Oxocarbon only tints these subtly, so we give added/removed lines a
      -- proper background. Re-applied on every colorscheme load so it sticks.
      local function diff_highlights()
        -- Full-line backgrounds with bright fg for the +/- content
        vim.api.nvim_set_hl(0, 'DiffAdd', { fg = '#b6f3b6', bg = '#16331f' })
        vim.api.nvim_set_hl(0, 'DiffDelete', { fg = '#f3b6b6', bg = '#3a1a1f' })
        vim.api.nvim_set_hl(0, 'DiffChange', { bg = '#2a2a16' })
        vim.api.nvim_set_hl(0, 'DiffText', { fg = '#f3e6b6', bg = '#4a4422' })

        -- Legacy `diff` syntax groups (used when Treesitter is unavailable)
        vim.api.nvim_set_hl(0, 'diffAdded', { fg = '#42be65', bg = '#16331f' })
        vim.api.nvim_set_hl(0, 'diffRemoved', { fg = '#fa4d56', bg = '#3a1a1f' })
        vim.api.nvim_set_hl(0, 'diffLine', { fg = '#78a9ff' })
        vim.api.nvim_set_hl(0, 'diffFile', { fg = '#be95ff' })
        vim.api.nvim_set_hl(0, 'diffIndexLine', { fg = '#a8a8a8' })

        -- Treesitter `diff` parser captures (the modern path)
        vim.api.nvim_set_hl(0, '@diff.plus', { fg = '#42be65', bg = '#16331f' })
        vim.api.nvim_set_hl(0, '@diff.minus', { fg = '#fa4d56', bg = '#3a1a1f' })
        vim.api.nvim_set_hl(0, '@diff.delta', { fg = '#f3e6b6', bg = '#4a4422' })
      end

      diff_highlights()
      vim.api.nvim_create_autocmd('ColorScheme', {
        group = vim.api.nvim_create_augroup('custom-diff-highlights', { clear = true }),
        callback = diff_highlights,
      })
    end,
  },
}
