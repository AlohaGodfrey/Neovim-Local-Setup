local status_ok, drop = pcall(require, "drop")
if not status_ok then
	return
end

drop.setup({
  max = 2,
  interval = 150,
  filetypes = {},
})
