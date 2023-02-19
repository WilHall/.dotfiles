return {
  {
    "haya14busa/vim-asterisk",
    config = function()
      vim.cmd [[
        map *   <plug>(asterisk-*)
        map #   <plug>(asterisk-#)
        map g*  <plug>(asterisk-g*)
        map g#  <plug>(asterisk-g#)
        map z*  <plug>(asterisk-z*)
        map gz* <plug>(asterisk-gz*)
        map z#  <plug>(asterisk-z#)
        map gz# <plug>(asterisk-gz#)

        let g:asterisk#keeppos = 1
      ]]
    end,
  },
}