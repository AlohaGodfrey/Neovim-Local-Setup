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
})
