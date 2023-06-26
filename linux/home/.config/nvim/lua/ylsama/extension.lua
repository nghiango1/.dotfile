local api = vim.api
local extension = {}

function extension.operator_get_text(type)
    if 'char' == type then
        return extension.getTextBetweenMarks('\'[', '\']')
    end
end

function extension.getRangeBetweenMarks(mark1, mark2)
    local start = vim.fn.getpos(mark1)
    local finish = vim.fn.getpos(mark2)
    local startLine, startCol = start[2], start[3]
    local finishLine, finishCol = finish[2], finish[3]
    if vim.fn.mode() == 'V' then
        startCol = 1
        finishCol = 2 ^ 31 - 1
    end
    if startLine > finishLine or (startLine == finishLine and startCol > finishCol) then
        return finishLine, finishCol, startLine, startCol
    end

    return startLine, startCol, finishLine, finishCol
end

function extension.getTextBetweenMarks(mark1, mark2)
    local startLine, startCol, finishLine, finishCol = extension.getRangeBetweenMarks(mark1, mark2)

    local lines = api.nvim_buf_get_text(0, startLine - 1, startCol - 1, finishLine - 1, finishCol, {})

    return table.concat(lines, '\n')
end

function extension.getVisualSelectionRange()
    if not vim.tbl_contains({ 'v', 'V' }, vim.fn.mode()) then
        return
    end

    local startLine, startCol, finishLine, finishCol = extension.getRangeBetweenMarks('v', '.')

    return {
        ['start'] = { startLine, startCol - 1 },
        ['end'] = { finishLine, finishCol - 1 },
    }
end

function extension.getVisualSelection()
    if not vim.tbl_contains({ 'v', 'V' }, vim.fn.mode()) then
        return
    end

    return extension.getTextBetweenMarks('v', '.')
end

return extension
