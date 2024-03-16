local is_loaded, wilder = pcall(require, "wilder")
if not is_loaded then
  print "Failed to load wilder"
  return
end

wilder.setup({
  modes = {':', '/', '?'}
})

wilder.set_option('pipeline', {
  wilder.branch(
    wilder.cmdline_pipeline(),
    wilder.search_pipeline()
  ),
})

wilder.set_option('renderer', wilder.renderer_mux({
  [':'] = wilder.popupmenu_renderer(
    wilder.popupmenu_border_theme({
      highlights = {
        border = 'Normal', -- highlight to use for the border
      },
      -- 'single', 'double', 'rounded' or 'solid'
      -- can also be a list of 8 characters, see :h wilder#popupmenu_border_theme() for more details
      border = 'rounded',
      max_height = '25%',
    })
  ),
  ['/'] = wilder.wildmenu_renderer({
    highlighter = wilder.basic_highlighter(),
  }),
}))

