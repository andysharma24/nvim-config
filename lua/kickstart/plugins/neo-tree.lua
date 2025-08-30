return {
  'nvim-neo-tree/neo-tree.nvim',
  version = '*',
  dependencies = {
    'nvim-lua/plenary.nvim',
    'nvim-tree/nvim-web-devicons',
    'MunifTanjim/nui.nvim',
  },
  lazy = false,
  keys = {
    { '\\', ':Neotree reveal<CR>', desc = 'NeoTree reveal', silent = true },
  },
  opts = {
    filesystem = {
      window = {
        mappings = {
          ['\\'] = 'close_window',
          ['<c-f>'] = 'fuzzy_finder',
          ['<c-/>'] = 'filter_on_submit',
          ['gf'] = 'filter_on_submit',
          ['<c-x>'] = 'clear_filter',
          ['S'] = 'search_in_folder',
          ['gs'] = 'global_search',
        },
      },
      filtered_items = {
        visible = false,
        hide_dotfiles = false,
        hide_gitignored = false,
      },
    },
    commands = {
      search_in_folder = function(state)
        local node = state.tree:get_node()
        local path = node:get_id()
        require('telescope.builtin').live_grep { search_dirs = { path } }
      end,
      global_search = function()
        require('telescope.builtin').live_grep()
      end,
    },
    event_handlers = {
      {
        event = 'neo_tree_buffer_enter',
        handler = function()
          vim.wo.number = true -- show absolute line numbers
          vim.wo.relativenumber = true -- show relative numbers
        end,
      },
      {
        event = 'git_status_changed',
        handler = function()
          local events = require 'neo-tree.events'
          events.fire_event(events.GIT_EVENT)
        end,
      },
    },
  },
}
