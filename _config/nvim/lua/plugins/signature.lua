return {
  {
    "kshenoy/vim-signature",
    config = function()
      vim.cmd [[
        let g:SignatureMarkTextHLDynamic = 1
        let g:SignatureMarkerTextHLDynamic = 1
      ]]
    end,
  },
}