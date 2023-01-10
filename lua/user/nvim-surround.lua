local status_ok, nvim_surround = pcall(require, "nvim-surround")
if not status_ok then
  return
end

nvim_surround.setup({
    aliases = {
        ["1"] = '"',
        ["2"] = "`",
        ["3"] = "'",
        ["a"] = ">",
        ["b"] = ")",
        ["B"] = "}",
        ["r"] = "]",
        ["q"] = { '"', "'", "`" },
        ["s"] = { "}", "]", ")", ">", '"', "'", "`" },
    },
})

