return {
  'nvim-tree/nvim-tree.lua',
  version = '*',
  lazy = false,
  dependencies = 'nvim-tree/nvim-web-devicons',
  keys = {
    { '\\', '<cmd>NvimTreeFindFile<CR>', desc = 'NvimTree find file', silent = true },
  },
  config = function()
    local nvimtree = require 'nvim-tree'
    local api = require 'nvim-tree.api'

    -- recommended settings
    vim.g.loaded_netrw = 1
    vim.g.loaded_netrwPlugin = 1

    -- Add number and relative number to nvim-tree (to match neo-tree)
    local function on_attach(bufnr)
      -- Enable number and relative number in nvim-tree buffer
      vim.wo.number = true
      vim.wo.relativenumber = true

      -- Custom mappings to match neo-tree
      local function opts(desc)
        return { desc = desc, buffer = bufnr, noremap = true, silent = true, nowait = true }
      end

      -- Set mappings exactly matching neo-tree
      vim.keymap.set('n', '\\', api.tree.close, opts 'Close Window')
      vim.keymap.set('n', '<c-f>', api.live_filter.start, opts 'Fuzzy Finder')
      vim.keymap.set('n', '<c-/>', api.live_filter.start, opts 'Filter On Submit')
      vim.keymap.set('n', 'gf', api.live_filter.start, opts 'Filter On Submit')
      vim.keymap.set('n', '<c-x>', api.live_filter.clear, opts 'Clear Filter')
      -- Custom implementation to match neo-tree's search_in_folder functionality
      vim.keymap.set('n', 'S', function()
        local node = api.tree.get_node_under_cursor()
        if node then
          local path = node.absolute_path or node.link_to
          require('telescope.builtin').live_grep { search_dirs = { path } }
        end
      end, opts 'Search In Folder')
      -- Custom implementation to match neo-tree's global_search functionality
      vim.keymap.set('n', 'gs', function()
        require('telescope.builtin').live_grep()
      end, opts 'Global Search')
      -- This sets the current directory as the root of the tree
      vim.keymap.set('n', '.', api.tree.change_root_to_node, opts 'Set Root')

      -- Default mappings
      vim.keymap.set('n', 'a', api.fs.create, opts 'Create')
      vim.keymap.set('n', 'd', api.fs.remove, opts 'Delete')
      vim.keymap.set('n', 'r', api.fs.rename, opts 'Rename')
      vim.keymap.set('n', 'y', api.fs.copy.node, opts 'Copy')
      vim.keymap.set('n', 'x', api.fs.cut, opts 'Cut')
      vim.keymap.set('n', 'p', api.fs.paste, opts 'Paste')
      vim.keymap.set('n', '<CR>', api.node.open.edit, opts 'Open')
    end

    -- Setup custom highlighting for git status files
    vim.api.nvim_create_autocmd('FileType', {
      pattern = 'NvimTree',
      callback = function()
        -- Yellow for changed files (both unstaged and staged)
        vim.api.nvim_set_hl(0, 'NvimTreeGitDirty', { fg = '#FFDB00' }) -- unstaged
        vim.api.nvim_set_hl(0, 'NvimTreeGitStaged', { fg = '#FFDB00' }) -- staged
        -- Purple for new/untracked files
        vim.api.nvim_set_hl(0, 'NvimTreeGitNew', { fg = '#BD93F9' })
        -- Apply same highlighting to folders with git status
        vim.api.nvim_set_hl(0, 'NvimTreeFolderDirty', { fg = '#FFDB00' }) -- for folders with modified content
        vim.api.nvim_set_hl(0, 'NvimTreeFolderNew', { fg = '#BD93F9' }) -- for folders with new content
      end,
    })

    nvimtree.setup {
      on_attach = on_attach,
      view = {
        width = 25, -- Default width when not focused
        relativenumber = true,
        signcolumn = 'yes',
        float = {
          enable = false,
        },
      },
      actions = {
        expand_all = {
          max_folder_discovery = 1000,
        },
        open_file = {
          quit_on_open = false,
          resize_window = false, -- This prevents resizing the tree window when opening files
          window_picker = {
            enable = false,
          },
        },
        use_system_clipboard = true,
      },
      filters = {
        dotfiles = false,
        git_ignored = false,
        custom = { '.DS_Store' },
        -- Match neo-tree's filtered_items configuration
        exclude = {},
      },
      git = {
        enable = true,
        ignore = false,
      },
      update_focused_file = {
        enable = true,
        update_root = false,
        ignore_list = {},
      },
      renderer = {
        indent_markers = {
          enable = true,
        },
        collapse_open_dirs = false,
        highlight_git = true,
        highlight_opened_files = 'name',
        icons = {
          show = {
            git = true,
            folder = true,
            file = true,
          },
          glyphs = {
            default = '',
            symlink = '',
            git = {
              unstaged = '~',
              staged = '+',
              unmerged = '',
              renamed = '➜',
              deleted = '✖',
              untracked = '★',
              ignored = '◌',
            },
            folder = {
              default = '',
              open = '',
              empty = '',
              empty_open = '',
              symlink = '',
            },
          },
        },
      },
    }

    -- Event handler to update git status when it changes (like neo-tree's git_status_changed handler)
    vim.api.nvim_create_autocmd('User', {
      pattern = 'GitSignsUpdate',
      callback = function()
        api.tree.reload()
      end,
    })

    -- Add buffer enter handler (like neo-tree's neo_tree_buffer_enter handler)
    vim.api.nvim_create_autocmd('BufEnter', {
      pattern = 'NvimTree_*',
      callback = function()
        vim.wo.number = true -- show absolute line numbers
        vim.wo.relativenumber = true -- show relative numbers
      end,
    })

    -- Always open nvim-tree on startup
    vim.api.nvim_create_autocmd('VimEnter', {
      callback = function()
        require('nvim-tree.api').tree.open()
      end,
    })

    -- Set up auto-resizing based on focus/unfocus
    local nvim_tree_resize = function(size)
      vim.cmd('NvimTreeResize ' .. size)
    end

    -- Create autocmd groups for tree focus/unfocus
    local resize_group = vim.api.nvim_create_augroup('NvimTreeResize', { clear = true })

    -- Resize tree to 35 columns when focused
    vim.api.nvim_create_autocmd('BufEnter', {
      pattern = 'NvimTree_*',
      callback = function()
        nvim_tree_resize(35)
      end,
      group = resize_group,
    })

    -- Resize tree to 20 columns when focus moves to a non-tree buffer
    vim.api.nvim_create_autocmd('BufLeave', {
      pattern = 'NvimTree_*',
      callback = function()
        nvim_tree_resize(30)
      end,
      group = resize_group,
    })

    -- keymaps
    local keymap = vim.keymap
    -- Keep existing keymaps
    keymap.set('n', '<leader>e', function()
      api.tree.focus()
      nvim_tree_resize(35) -- Ensure it's 35 when explicitly focused
    end, { desc = 'Focus file explorer' })

    keymap.set('n', '<leader>ef', function()
      api.tree.find_file { open = true, focus = true }
      nvim_tree_resize(35) -- Ensure it's 35 when finding file
    end, { desc = 'Focus file in explorer' })

    keymap.set('n', '<leader>ec', function()
      api.tree.collapse_all(true)
    end, { desc = 'Collapse file explorer' })

    keymap.set('n', '<leader>er', '<cmd>NvimTreeRefresh<CR>', { desc = 'Refresh file explorer' })
  end,
}
