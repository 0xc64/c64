-- Program: bm2asm converter
-- Author: Andrew Burch
-- Site: www.0xc64.com
-- Notes: Command line tool to convert bitmap files
--			saved as *.prg files from Timanthes to
--			.asm ready data files
--

-- optimisations
local lowercase = string.lower
local substr = string.sub
local tobyte = string.byte
local strfmt = string.format

-- arguments & options
local showHelp = false
local quietMode = false
local includeOrigin = false
local bytesPerRow = 8
local outputMode = 'h'
local inputFile
local outputFile

local function setHelp()
    showHelp = true
end

local function setQuietMode()
    quietMode = true
end

local function setOrigin()
    includeOrigin = true
end

local function setInput(f)
    inputFile = f
end

local function setOutput(f)
    outputFile = f
end

local function setBytesPerRow(bpr)
    bytesPerRow = tonumber(bpr)
end

local function setOutputMode(m)
    outputMode = m
end

-- conversion function
local convertBlock = function(data, first, last, fmt)
    local rowByteCount = 0
    local sep = ''
    local output = ''

    for i = first, last do
        local c = substr(data, i, i)
        
        -- prefix empty row
        if rowByteCount == 0 then
            output = strfmt("%s.byte ", output)
        end

        -- append next byte value
        output = strfmt('%s%s' .. fmt, output, sep, tobyte(c))

        -- apply byte count to current row for formatting
        rowByteCount = rowByteCount + 1

        if rowByteCount == bytesPerRow then
            output = strfmt("%s\n", output)
            rowByteCount = 0
            sep = ''
        end

        -- update byte seperator
        if rowByteCount > 0 then
            sep = ', '
        end
    end

    return output
end

-- logging support
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
    ['-q'] = setQuietMode,
    ['/q'] = setQuietMode,
    ['/r'] = setOrigin,
    ['/r'] = setOrigin,
    ['-o'] = setOutput,
    ['/o'] = setOutput,
    ['-i'] = setInput,
    ['/i'] = setInputt,
    ['-b'] = setBytesPerRow,
    ['/b'] = setBytesPerRow,
    ['-m'] = setOutputMode,
    ['/m'] = setOutputMode,
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
log('bm2asm - Bitmap Converter (v0.1)')
log('Andrew Burch - www.0xc64.com')

-- display help and exit
if showHelp then
    log('  Usage:')
    log('    lua bm2c64 -iInputFile -oOutputFile [options]')
    log('')
    log('    -i : input file')
    log('    -o : output file')
    log('')
    log('    options:')
    log('      -h : show help')
    log('      -q : quiet mode')
    log('      -m[h/d] : output mode (hex/decimal)')
    log('                (default is h)')
    log('      -b[1-10000] : bytes per line')
    log('                (default is 8)')
    log('')
    os.exit()
end

if not inputFile then
    print('[ERR] - No input file specified')
    os.exit()
end

if not outputFile then
    print('[ERR] - No output file specified')
    os.exit()
end

log('')
log('[NFO] - Bytes per row: ' .. bytesPerRow)
log('[NFO] - Output origin: ' .. (includeOrigin and 'Yes' or 'No'))
log('[NFO] - Output mode: ' .. (outputMode == 'h' and 'Hex' or 'Decimal'))


local fmt = outputMode == 'h' and '$%02x' or '#%02d'

-- open and validate input file
local fp = io.open(inputFile, 'rb')
if not fp then
    print('[ERR] - Unable to open input file')
    os.exit()
end

-- read input file - single read
local data = fp:read('*a')
local filesize = string.len(data)
if filesize == 0 then
    print('[ERR] - Input file is empty')
    os.exit()
end

log('[NFO] - Data size: ' .. filesize)


-- load origin
local olow = substr(data, 1, 1)
local ohigh = substr(data, 2, 2)
local origin = strfmt('$%02x%02x', tobyte(ohigh), tobyte(olow))
log('[NFO] - Origin detected: ' .. origin)


-- convert bitmap
local imgdata = 'imagedata\n' .. convertBlock(data, 3, 8002, fmt)
local coldata = 'colourdata\n' .. convertBlock(data, 8195, filesize, fmt)
local output = imgdata .. '\n\n' .. coldata

-- log results
log('[NFO] - Conversion complete')

-- output result
local fp, err = io.open(outputFile, 'w')

if not fp then
    print('[ERR] - Unable to open file: ' .. err)
    os.exit()
end

-- output origin line
if includeOrigin then
    fp:write('.org ' .. origin .. '\n')
end

-- output converted data
fp:write(output)
fp:close()

-- done
log('[NFO] - Output to file: ' .. outputFile)
