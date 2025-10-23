-- LLM integration
return {
    'frankroeder/parrot.nvim',
    dependencies = {
        'ibhagwan/fzf-lua',
        'nvim-lua/plenary.nvim',
        'folke/noice.nvim',
    },
    config = function()
        local secrets = require('secrets')

        require('parrot').setup({
            providers = {
                openai = {
                    name = 'openai',
                    api_key = secrets.openai_api_key,
                    endpoint = 'https://api.openai.com/v1/chat/completions',
                    model_endpoint = 'https://api.openai.com/v1/models',
                    params = {
                        chat = { temperature = 1, top_p = 1 },
                        command = { temperature = 1, top_p = 1 },
                    },
                    topic = {
                        model = 'gpt-5-nano',
                        params = { max_completion_tokens = 64 },
                    },
                    models = {
                        'gpt-4.1',
                        'gpt-5',
                    },
                },
                anthropic = {
                    name = 'anthropic',
                    endpoint = 'https://api.anthropic.com/v1/messages',
                    model_endpoint = 'https://api.anthropic.com/v1/models',
                    api_key = secrets.anthropic_api_key,
                    params = {
                        chat = { max_tokens = 4096 },
                        command = { max_tokens = 4096 },
                    },
                    topic = {
                        model = 'claude-haiku-4-5-20251001',
                        params = { max_tokens = 32 },
                    },
                    headers = function(self)
                        return {
                            ['Content-Type'] = 'application/json',
                            ['x-api-key'] = self.api_key,
                            ['anthropic-version'] = '2023-06-01',
                        }
                    end,
                    models = {
                        'claude-sonnet-4-5-20250929',
                        'claude-opus-4-1-20250805',
                    },
                    preprocess_payload = function(payload)
                        for _, message in ipairs(payload.messages) do
                            message.content = message.content:gsub('^%s*(.-)%s*$', '%1')
                        end
                        if payload.messages[1] and payload.messages[1].role == 'system' then
                            -- remove the first message that serves as the system prompt as anthropic
                            -- expects the system prompt to be part of the API call body and not the messages
                            payload.system = payload.messages[1].content
                            table.remove(payload.messages, 1)
                        end
                        return payload
                    end,
                },
            },
        })
        require('which-key').add({
            {
                mode = { 'v' },
                nowait = true,
                remap = false,
                { '<C-g>r', ":<C-u>'<,'>PrtRewrite<cr>", desc = 'Rewrite visual selection' },
            },
            {
                mode = { 'n' },
                nowait = true,
                remap = false,
                { '<C-g>n', '<cmd>PrtChatNew<cr>', desc = 'Open new chat' },
                { '<C-g>t', '<cmd>PrtChatToggle<cr>', desc = 'Toggle chat' },
                { '<C-g>p', '<cmd>PrtProvider<cr>', desc = 'Switch provider' },
                { '<C-g>m', '<cmd>PrtModel<cr>', desc = 'Switch model' },
            },
            {
                mode = { 'n', 'i', 'v', 'x' },
                nowait = true,
                remap = false,
                { '<C-g>s', '<cmd>PrtStop<cr>', desc = 'Stop' },
            },
        })
    end,
}
