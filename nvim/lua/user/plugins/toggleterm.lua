local is_loaded, toggleterm = pcall(require, "toggleterm")
if not is_loaded then
  print "Failed to load toggleterm"
  return
end

toggleterm.setup {
  size = 50,
  direction = "vertical",
  open_mapping = [[<c-t>]],
  start_in_insert = true
}
