local is_loaded, gitsigns = pcall(require, "gitsigns")
if not is_loaded then
  print "Failed to load gitsigns plugin"
  return
end

gitsigns.setup {
  current_line_blame = true
}
