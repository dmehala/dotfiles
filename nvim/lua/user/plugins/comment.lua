local is_loaded, comment = pcall(require, 'Comment')
if not is_loaded then
  print "Failed to load Comment plugin"
end

comment.setup()
