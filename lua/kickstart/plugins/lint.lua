return {

  { -- Linting
    'mfussenegger/nvim-lint',
    event = { 'BufReadPre', 'BufNewFile' },
    config = function()
      local lint = require 'lint'
      lint.linters_by_ft = {
        markdown = { 'markdownlint' },
        yaml = { 'yamllint' },
      }

      -- Configure yamllint to ignore line length and set comments to 1 space
      lint.linters.yamllint.args = {
        '-d',
        '{extends: default, rules: {line-length: disable, comments-indentation: {min-spaces-from-content: 1}}}',
        '--format',
        'parsable',
        '-',
      }

      -- To allow other plugins to add linters to require('lint').linters_by_ft,
      -- instead set linters_by_ft like this:
      -- lint.linters_by_ft = lint.linters_by_ft or {}
      -- lint.linters_by_ft['markdown'] = { 'markdownlint' }
      --
      -- However, note that this will enable a set of default linters,
      -- which will cause errors unless these tools are available:
      -- {
      --   clojure = { "clj-kondo" },
      --   dockerfile = { "hadolint" },
      --   inko = { "inko" },
      --   janet = { "janet" },
      --   json = { "jsonlint" },
      --   markdown = { "vale" },
      --   rst = { "vale" },
      --   ruby = { "ruby" },
      --   terraform = { "tflint" },
      --   text = { "vale" }
      -- }
      --
      -- You can disable the default linters by setting their filetypes to nil:
      -- lint.linters_by_ft['clojure'] = nil
      -- lint.linters_by_ft['dockerfile'] = nil
      -- lint.linters_by_ft['inko'] = nil
      -- lint.linters_by_ft['janet'] = nil
      -- lint.linters_by_ft['json'] = nil
      lint.linters_by_ft['markdown'] = nil
      -- lint.linters_by_ft['rst'] = nil
      -- lint.linters_by_ft['ruby'] = nil
      -- lint.linters_by_ft['terraform'] = nil
      -- lint.linters_by_ft['text'] = nil

      -- Only lint with tools that are actually installed. Without this a
      -- missing binary (e.g. yamllint) errors on every write:
      --   Error running yamllint: ENOENT: no such file or directory
      local function installed_linters()
        local names = lint.linters_by_ft[vim.bo.filetype] or {}
        local available = {}
        for _, name in ipairs(names) do
          local linter = lint.linters[name]
          local cmd = type(linter) == 'table' and linter.cmd or nil
          if type(cmd) == 'function' then
            cmd = cmd()
          end
          if cmd and vim.fn.executable(cmd) == 1 then
            table.insert(available, name)
          end
        end
        return available
      end

      -- Create autocommand which carries out the actual linting
      -- on the specified events.
      local lint_augroup = vim.api.nvim_create_augroup('lint', { clear = true })
      vim.api.nvim_create_autocmd({ 'BufEnter', 'BufWritePost', 'InsertLeave' }, {
        group = lint_augroup,
        callback = function()
          -- Only run the linter in buffers that you can modify in order to
          -- avoid superfluous noise, notably within the handy LSP pop-ups that
          -- describe the hovered symbol using Markdown.
          if vim.bo.modifiable then
            local available = installed_linters()
            if #available > 0 then
              lint.try_lint(available)
            end
          end
        end,
      })
    end,
  },
}
