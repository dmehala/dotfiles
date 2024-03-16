local is_loaded, mini_bracketed = pcall(require, "mini.bracketed")
if not is_loaded then
  print "Failed to load mini-bracketed"
  return
end

mini_bracketed.setup()
