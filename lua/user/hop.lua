local status_ok, hop = pcall(require, "hop")
if not status_ok then
	return
end

-- Keybinds have been defined in user.keymaps.lua

hop.setup {
  require'hop'.setup { keys = 'asdfjklqwertiop' }
}

