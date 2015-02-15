-- Program: Str2C64 Converter
-- Author: Andrew Burch
-- Site: www.0xc64.com
-- Notes: Command line tool to convert a string to
--          C64 screen codes. Outputs results in 
--          series of .byte lines to paste into an
--          .asm file
--          Supports output to screen or file
--

-- optimisations
local sformat = string.format
local lowercase = string.lower
local substr = string.sub

-- screen code map
local map = {
    ['black']  = 000,
    ['white']  = 001,
    ['red']    = 002,
    ['cyan']   = 003,
    ['purple'] = 004,
    ['green']  = 005,
    ['blue']   = 006,
    ['yellow'] = 007,
    ['orange'] = 008,
    ['brown']  = 009,
    ['pink']   = 010,
    ['dgrey']  = 011,
    ['grey']   = 012,
    ['lgreen'] = 013,
    ['lblue']  = 014,
    ['lgrey']  = 015,

    -- short versions
    ['bk']     = 000,
    ['wh']     = 001,
    ['rd']     = 002,
    ['cy']     = 003,
    ['pu']     = 004,
    ['ge']     = 005,
    ['bl']     = 006,
    ['ye']     = 007,
    ['or']     = 008,
    ['br']     = 009,
    ['pi']     = 010,
    ['dg']     = 011,
    ['gr']     = 012,
    ['lge']    = 013,
    ['lbl']    = 014,
    ['lg']     = 015,
}


local quietMode = false
local showHelp = false
local bytesPerRow = 8
local colourstring

local function setHelp()
    showHelp = true
end

local function setBytesPerRow(bpr)
    bytesPerRow = tonumber(bpr)
end

local function setColourString(str)
    colourstring = str
end

local function setQuietMode()
    quietMode = true
end

local log = function(str)
    if quietMode then
        return
    end
    print(str)
end


-- options table
local optionsMap = {
    ['-h'] = setHelp,
    ['/h'] = setHelp,
    ['-b'] = setBytesPerRow,
    ['/b'] = setBytesPerRow,
    ['-c'] = setColourString,
    ['/c'] = setColourString,
    ['-q'] = setQuietMode,
    ['/q'] = setQuietMode,
}

-- parse arguments
for i = 1, #arg do
    local param = arg[i]
    local switch = lowercase(substr(param, 1, 2))

    local fn = optionsMap[switch]
    if fn then
        fn(substr(param, 3))
    else
        log('[NFO] - Unsupported switch: ' .. switch)
    end
end

-- display tool info
log('c64col - colour string converter (v0.1)')
log('Andrew Burch - www.0xc64.com')

if not colourstring and not showHelp then
    print('[ERR] - No colour string specified')
    os.exit();
end

-- display help and exit
if showHelp then
    log('  Usage:')
    log('    lua c64col -cred,blue,green [options]')
    log('')
    log('    -c : colour string')
    log('')
    log('    options:')
    log('      -h : show help')
    log('      -q : quiet mode')
    log('      -b[1-10000] : bytes per line')
    log('                    (default is 8)')
    log('');
    os.exit();
end

log('')
log('[NFO] - Bytes per row: ' .. bytesPerRow)

local output = ''
local byteCount = 0
local rowByteCount = 0
local sep = ''

for col in string.gmatch(colourstring, '([^,]+)') do
    col = col:gsub("%s+", "")

    -- detect unsupported colours
    if not map[col] then 
        log('[NFO] - Unsupported colour found: ' .. col)
        print('[ERR] - Conversion failed')
        os.exit();
    end

    -- prefix empty row
    if rowByteCount == 0 then
        output = sformat("%s.byte ", output)
    end

    -- extract the code
    local colourCode = map[col]

    -- append next byte value
    output = sformat("%s%s%03d", output, sep, colourCode)


    -- apply byte count to current row for formatting
    rowByteCount = rowByteCount + 1

    if rowByteCount == bytesPerRow then
        output = sformat("%s\n", output)
        rowByteCount = 0
        sep = ''
    end

    -- track bytes converted
    byteCount = byteCount + 1

    -- update byte seperator
    if rowByteCount > 0 then
        sep = ', '
    end
end


-- log results
log('[NFO] - Conversion complete')
log('[NFO] - Colours converted: ' .. byteCount)

log('[NFO] - Converted string')
print(output)   
