local status_ok, telescope = pcall(require, "telescope")
if not status_ok then
  return
end

local actions = require "telescope.actions"

telescope.setup {
  defaults = {

    prompt_prefix = " ",
    selection_caret = " ",
    path_display = { "smart" },

    mappings = {
      i = {
        ["<C-n>"] = actions.cycle_history_next,
        ["<C-p>"] = actions.cycle_history_prev,

        ["<C-j>"] = actions.move_selection_next,
        ["<C-k>"] = actions.move_selection_previous,

        ["<C-c>"] = actions.close,
        ["<leader>q"] = actions.close,

        ["<Down>"] = actions.move_selection_next,
        ["<Up>"] = actions.move_selection_previous,

        ["<CR>"] = actions.select_default,
        ["<C-x>"] = actions.select_horizontal,
        ["<C-v>"] = actions.select_vertical,
        ["<C-t>"] = actions.select_tab,

        ["<C-u>"] = actions.preview_scrolling_up,
        ["<C-d>"] = actions.preview_scrolling_down,

        ["<PageUp>"] = actions.results_scrolling_up,
        ["<PageDown>"] = actions.results_scrolling_down,

        ["<Tab>"] = actions.toggle_selection + actions.move_selection_worse,
        ["<S-Tab>"] = actions.toggle_selection + actions.move_selection_better,
        ["<C-q>"] = actions.send_to_qflist + actions.open_qflist,
        ["<M-q>"] = actions.send_selected_to_qflist + actions.open_qflist,
        ["<C-l>"] = actions.complete_tag,
        ["<C-_>"] = actions.which_key, -- keys from pressing <C-/>
      },

      n = {
        ["<esc>"] = actions.close,
        ["<leader>q"] = actions.close,
        ["<CR>"] = actions.select_default,
        ["<C-x>"] = actions.select_horizontal,
        ["<C-v>"] = actions.select_vertical,
        ["<C-t>"] = actions.select_tab,

        ["<Tab>"] = actions.toggle_selection + actions.move_selection_worse,
        ["<S-Tab>"] = actions.toggle_selection + actions.move_selection_better,
        ["<C-q>"] = actions.send_to_qflist + actions.open_qflist,
        ["<M-q>"] = actions.send_selected_to_qflist + actions.open_qflist,

        ["j"] = actions.move_selection_next,
        ["k"] = actions.move_selection_previous,
        ["H"] = actions.move_to_top,
        ["M"] = actions.move_to_middle,
        ["L"] = actions.move_to_bottom,

        ["<Down>"] = actions.move_selection_next,
        ["<Up>"] = actions.move_selection_previous,
        ["gg"] = actions.move_to_top,
        ["G"] = actions.move_to_bottom,

        ["<C-u>"] = actions.preview_scrolling_up,
        ["<C-d>"] = actions.preview_scrolling_down,

        ["<PageUp>"] = actions.results_scrolling_up,
        ["<PageDown>"] = actions.results_scrolling_down,

        ["?"] = actions.which_key,
      },
    },
  },
  pickers = {
    -- Default configuration for builtin pickers goes here:
    -- picker_name = {
    --   picker_config_key = value,
    --   ...
    -- }
    -- Now the picker_config_key will be applied every time you call this
    -- builtin picker
  },
  extensions = {
    -- Your extension configuration goes here:
    -- extension_name = {
    --   extension_config_key = value,
    -- }
    -- please take a look at the readme of the extension you want to configure
    frecency = {
      -- db_root = "home/my_username/path/to/db_root",
      show_scores = true,
      show_unindexed = true,
      default_workspace = "CWD",
      show_filter_column = { "conf", "aws", "cplace", "nvim"},
      -- ignore_patterns = {"*.git/*", "*/tmp/*"},
      -- disable_devicons = false,
      workspaces = {
        -- ["conf"]    = "Users/imangodf/.config",
        -- ["data"]    = "/Users/imangodf/.local/share",
        ["commonplace"]  = "/Users/imangodf/Documents/Obsidian/CommonPlace",
        ["workplace"]  = "/Users/imangodf/workplace",
        ["aws"]  = "/Users/imangodf/Documents/Obsidian/AWS",
        ["nvim"] = "/Users/imangodf/.config/nvim",
        -- ["project"] = "/home/my_username/projects",
        -- ["wiki"]    = "/home/my_username/wiki"
        -- aws
        -- wiki/personal/crankshaft/grab name from tiago forte video on ancient people
        -- and their books with partial information, think it was the video about garden notes...
        -- nvim
        -- '.' always mean personal directory
      }
    },
  },
}


telescope.load_extension("frecency")

-- Better Frecency navigation with autocmd
-- if workspace = x, then set the keymap to x, use grep to sort
vim.cmd([[autocmd BufEnter * lua Switch_Frecency_Working_Directory()]])


function Calculate_frecency_cwd()
  local current_dir = vim.fn.expand('%:p:h')
  local workspace = ""
  local workspaces = {
    ["commonplace"]  = "/Users/imangodf/Documents/Obsidian/CommonPlace",
    ["workplace"]  = "/Users/imangodf/workplace",
    ["aws"]  = "/Users/imangodf/Documents/Obsidian/AWS",
    ["nvim"] = "/Users/imangodf/.config/nvim",
  }

  if string.match(current_dir, "AWS") then
    workspace = "aws"
  elseif string.match(current_dir, "CommonPlace") then
    workspace = "commonplace"
  elseif string.match(current_dir, "nvim") then
    workspace = "nvim"
  elseif string.match(current_dir, "workplace") then
    workspace = "workplace"
  else
    workspace = "CWD"
  end

  return workspace
end

function Switch_Frecency_Working_Directory()  -- local update_keymap = string.format("<Cmd>lua require('telescope').extensions.frecency.frecency({ workspace = '%s' })<CR>", workspace)
  local workspace = Calculate_frecency_cwd()
  local update_keymap = string.format("<cmd>Telescope frecency theme=get_dropdown previewer=false workspace=%s<cr>", workspace)
  vim.api.nvim_set_keymap("n", "<Space>o", update_keymap , {noremap = true, silent = true})
end

function Open_Frecency_Working_Directory()
  local workspace = Calculate_frecency_cwd()
  -- Update command for alpha plugin
  local frecency_vim_api_command = string.format("Telescope frecency theme=get_dropdown previewer=false workspace=%s", workspace)
  -- ALPHA_FRECENCY_KEYMAP = string.format("vim.api.nvim_command(%s)", frecency_vim_api_command)
  vim.api.nvim_command(frecency_vim_api_command)
end
