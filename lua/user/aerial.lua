local status_ok, aerial = pcall(require, "aerial")
if not status_ok then
	return
end

aerial.setup({
  -- When true, aerial will automatically close after jumping to a symbol
  close_on_select = true,
  -- Show box drawing characters for the tree hierarchy
  show_guides = true,
  -- Highlight the symbol in the source buffer when cursor is in the aerial win
  highlight_on_hover = true,
  -- When true, don't load aerial until a command or function is called
  -- Defaults to true, unless `on_attach` is provided, then it defaults to false
  lazy_load = false,
  -- Determines the default direction to open the aerial window. The 'prefer'
  -- options will open the window in the other direction *if* there is a
  -- different buffer in the way of the preferred direction
  -- Enum: prefer_right, prefer_left, right, left, float
  default_direction = "left",
  -- Determines where the aerial window will be opened
  --   edge   - open aerial at the far right/left of the editor
  --   window - open aerial to the right/left of the current window
  placement = "edge",
  -- Options for opening aerial in a floating win
  float = {
    -- Controls border appearance. Passed to nvim_open_win
    border = "rounded",

    -- Determines location of floating window
    --   cursor - Opens float on top of the cursor
    --   editor - Opens float centered in the editor
    --   win    - Opens float centered in the window
    relative = "win",

    -- These control the height of the floating window.
    -- They can be integers or a float between 0 and 1 (e.g. 0.4 for 40%)
    -- min_height and max_height can be a list of mixed types.
    -- min_height = {8, 0.1} means "the greater of 8 rows or 10% of total"
    max_height = 0.9,
    height = nil,
    min_height = { 8, 0.1 },

    override = function(conf, source_winid)
      -- This is the config that will be passed to nvim_open_win.
      -- Change values here to customize the layout
      return conf
    end,
  },
})
