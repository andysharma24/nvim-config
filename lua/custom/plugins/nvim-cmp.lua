return {
  'hrsh7th/nvim-cmp',
  dependencies = {
    'hrsh7th/cmp-buffer', -- Required for buffer word completion
    'hrsh7th/cmp-path', -- Required for path completion
    'hrsh7th/cmp-buffer',
    'hrsh7th/cmp-cmdline',
    'hrsh7th/cmp-nvim-lsp',
    'L3MON4D3/LuaSnip', -- Or another snippet engine like `vsnip`
    'saadparwaiz1/cmp_luasnip', -- Connects nvim-cmp to LuaSnip
    -- Add other sources as needed, e.g., "hrsh7th/cmp-nvim-lsp" for LSP
  },
  config = function()
    -- Your nvim-cmp configuration goes here
  end,
}
