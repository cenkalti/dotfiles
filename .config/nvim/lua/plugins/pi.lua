return {
    'carderne/pi-nvim',
    config = function()
        require('pi-nvim').setup({
            socket_path = nil, -- auto-discover
            set_default_keymaps = true,
        })
    end,
}
