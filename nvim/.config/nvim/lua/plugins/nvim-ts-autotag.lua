-- Before        Input         After
-- ------------------------------------
-- <div           >              <div></div>
-- <div></div>    ciwspan<esc>   <span></span>
-- ------------------------------------
return {
  'windwp/nvim-ts-autotag',
  event = 'InsertEnter',
  config = function() require('nvim-ts-autotag').setup() end,
}
