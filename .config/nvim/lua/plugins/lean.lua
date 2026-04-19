-- Lean theorem prover support
return {
    'Julian/lean.nvim',
    event = { 'BufReadPre *.lean', 'BufNewFile *.lean' },
    ---@type lean.Config
    opts = {
        mappings = true,
    },
}
