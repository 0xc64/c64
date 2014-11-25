-- Program: sprite rle compressed exporter
-- Author: Andrew Burch
-- Site: www.0xc64.com
-- Notes: Command line tool to export sprite data from
--          SpritePad into rle compressed data ready
--          for an assembly file
--
--

-- optimisations
local lowercase = string.lower
local substr = string.sub
local tobyte = string.byte
local strfmt = string.format

-- options & default values
local showHelp = false
local quietMode = false
local includeOrigin = false
local exportCompressed = true
local bytesPerRow = 8
local outputMode = 'h'
local inputFile
local outputFile

-- option setter functions
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

local function setExportUncompressed()
    exportCompressed = false
end

-- option to function map
local optionsMap = {
    ['-h'] = setHelp,
    ['/h'] = setHelp,
    ['-q'] = setQuietMode,
    ['/q'] = setQuietMode,
    ['/r'] = setOrigin,
    ['-r'] = setOrigin,
    ['-o'] = setOutput,
    ['/o'] = setOutput,
    ['-i'] = setInput,
    ['/i'] = setInput,
    ['-b'] = setBytesPerRow,
    ['/b'] = setBytesPerRow,
    ['-m'] = setOutputMode,
    ['/m'] = setOutputMode,
    ['-e'] = setExportUncompressed,
    ['/e'] = setExportUncompressed,
}

-- console logging
local log = function(str)
    if quietMode then
        return
    end
    print(str)
end

-- parse arguments
local parseCommandline = function()
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
end


-- import sprite data
local importSpriteData = function(data, dataLength, startOffset, getByteFn)
    local readIndex = startOffset
    local outputIndex = 1
    local output = {}

    while true do
        local byte = getByteFn(data, readIndex)

        output[outputIndex] = byte

        outputIndex = outputIndex + 1

        readIndex = readIndex + 1

        if readIndex > dataLength then
            break
        end
    end

    return {
        data = output,
        totalBytes = #output,
    }
end


-- apply rle compression to data
local applyRLECompression = function(data)
    local output = {}
    local readIndex = 1
    local writeIndex = 1
    local maxReadIndex = #data

    while true do
        local byte = data[readIndex]
        local advByte1 = -1
        local advByte2 = -1

        if ((readIndex + 1) <= maxReadIndex) then
            advByte1 = data[readIndex + 1]
        end

        if ((readIndex + 2) <= maxReadIndex) then
            advByte2 = data[readIndex + 2]
        end

        -- detect final bytes of data
        if (advByte2 == -1) then
            output[writeIndex] = byte

            if (advByte1 ~= -1) then
                output[writeIndex + 1] = advByte1
            end
        end

        -- detect run
        if ((byte == advByte1) and (byte == advByte2)) then
            local runIndex = 3

            while true do
                local runByte = data[readIndex + runIndex]
                if runByte ~= byte then
                    break
                end

                -- limit runs to 255 bytes
                if runIndex == 255 then
                    break
                end
                runIndex = runIndex + 1

                if (readIndex + runIndex) > maxReadIndex then
                    break
                end

            end

            output[writeIndex] = 194
            output[writeIndex + 1] = runIndex
            output[writeIndex + 2] = byte

            writeIndex = writeIndex + 3
            readIndex = readIndex + runIndex
        else
            -- if the byte is the same as the encode value, output as a run
            if byte == 194 then
                output[writeIndex] = byte
                output[writeIndex + 1] = 01
                output[writeIndex + 2] = 194
                writeIndex = writeIndex + 3
            else
                output[writeIndex] = byte
                writeIndex = writeIndex + 1
            end

            readIndex = readIndex + 1
        end

        if readIndex > maxReadIndex then
            break
        end
    end    

    -- add eof bytes
    output[writeIndex] = 194
    output[writeIndex + 1] = 00

    return {
        data = output,
        totalBytes = #output,
    }
end



-- conversion function
local convertToASM = function(data, fmt)
    local rowByteCount = 0
    local sep = ''
    local output = ''

    for i = 1, #data do
        local c = data[i]
        
        -- prefix empty row
        if rowByteCount == 0 then
            output = strfmt("%s.byte ", output)
        end

        -- append next byte value
        output = strfmt('%s%s' .. fmt, output, sep, c)

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


-- begin exporter
parseCommandline()

-- display tool information
log('sprite2asm - Sprite Data Exporter (v0.1)')
log('Andrew Burch - www.0xc64.com')

-- display help and exit
if showHelp then
    log('  Usage:')
    log('    lua sprite2asm -iInputFile -oOutputFile [options]')
    log('')
    log('    -i : input file')
    log('    -o : output file')
    log('')
    log('    options:')
    log('      -h : show help')
    log('      -q : quiet mode')
    log('      -r : output origin')
    log('      -e : export uncompressed')
    log('      -m[h/d]  : output mode (hex/decimal)')
    log('                (default is h')
    log('      -b[1-10000] : bytes per line')
    log('                (default is 8)')
    log('')
    os.exit()
end

-- validate input file specified
if not inputFile then
    print('[ERR] - No input file specified')
    os.exit()
end

-- validate output file specified
if not outputFile then
    print('[ERR] - No output file specified')
    os.exit()
end

-- output options specified for export
log('')
log('[NFO] - Bytes per row: ' .. bytesPerRow)
log('[NFO] - Output origin: ' .. (includeOrigin and 'Yes' or 'No'))
log('[NFO] - Output mode: ' .. (outputMode == 'h' and 'Hex' or 'Decimal'))
log('[NFO] - RLE Compression: ' .. (exportCompressed and 'Yes' or 'No'))
log('')


-- open and validate input file exists
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

log('[NFO] - Filesize: ' .. filesize)


-- load origin
local olow = substr(data, 1, 1)
local ohigh = substr(data, 2, 2)
local origin = strfmt('$%02x%02x', tobyte(ohigh), tobyte(olow))
log('[NFO] - Origin detected: ' .. origin)


-- import sprite data
local spriteData = importSpriteData(data, string.len(data), 3, function(data, i) 
                        return tobyte(substr(data, i, i))
                    end)

log('[NFO] - Bytes extracted: ' .. spriteData.totalBytes)

local outputData = spriteData

-- perform RLE compression on data if required
if exportCompressed then
    outputData = applyRLECompression(spriteData.data)

    log('[NFO] - Bytes after RLE: ' .. outputData.totalBytes)
end

-- convert to output format
local fmt = outputMode == 'h' and '$%02x' or '#%02d'

local convertedData = convertToASM(outputData.data, fmt)


log('[NFO] - Data converted')

-- output result
local fp, err = io.open(outputFile, 'w')
if not fp then
    print('[ERR] - Unable to open output file: ' .. err)
    os.exit()
end

-- output origin line
if includeOrigin then
    fp:write('.org ' .. origin .. '\n\n')
end

-- output converted data
fp:write(convertedData)
fp:close()

-- done
log('[NFO] - Output to file: ' .. outputFile)