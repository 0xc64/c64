-- Program: amica rle compressed bitmap exporter
-- Author: Andrew Burch
-- Site: www.0xc64.com
-- Notes: Command line tool to export amica paint rle
--          compressed bitmap files into formatted 
--          assembly files. Includes a number of export
--          options.
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
local includeBackground = false
local includeDataPointers = false
local exportCompressed = true
local bytesPerRow = 8
local exportLines = 25
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

local function setExportLines(l)
    exportLines = l
end

local function setBackground()
    includeBackground = true
end

local function setExportUncompressed()
    exportCompressed = false
end

local function setIncludeDataPointers()
    includeDataPointers = true
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
    ['-l'] = setExportLines,
    ['/l'] = setExportLines,
    ['-g'] = setBackground,
    ['/g'] = setBackground,
    ['-e'] = setExportUncompressed,
    ['/e'] = setExportUncompressed,
    ['-p'] = setIncludeDataPointers,
    ['/p'] = setIncludeDataPointers,
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


-- decompress run length encoded data
local decompressRLEData = function(data, dataLength, startOffset, getByteFn)
    local readIndex = startOffset
    local outputIndex = 1
    local totalExtracted = 0
    local encFound = 0
    local output = {}

    -- loop until EOF found ($c2, $00)
    while true do
        local byte = getByteFn(data, readIndex)

        -- detect literal byte
        if byte ~= 194 then
            output[outputIndex] = byte

            outputIndex = outputIndex + 1
        else
            -- rle byte found
            encFound = encFound + 1
            readIndex = readIndex + 1

            -- extract run byte
            local runByte = getByteFn(data, readIndex)

            -- eof?
            if (runByte == 0) then
                break
            end

            -- read write byte
            readIndex = readIndex + 1
            local writeByte = getByteFn(data, readIndex)

            -- write out run
            for i = 1, runByte do
                output[outputIndex] = writeByte

                outputIndex = outputIndex + 1
            end
        end

        readIndex = readIndex + 1
    end

    return {
        data = output,
        totalBytes = #output,
        encodedFlags = encFound,
    }
end


-- strip back uncompressed data to only required lines
local stripNonRequiredData = function(data)
    local output = {}

    local bitmapDataPointer = 1
    local screenRamDataPointer = 8001
    local colourRamDataPointer = 9001

    local bitmapDataSize = exportLines * 8 * 40
    local screenRamDataSize = exportLines * 40
    local colourRamDataSize = screenRamDataSize

    local bitmapEnd = bitmapDataPointer + bitmapDataSize - 1
    local screenStart = bitmapEnd + 1
    local screenEnd = screenStart + screenRamDataSize - 1
    local colourStart = screenEnd + 1
    local colourEnd = colourStart + colourRamDataSize - 1


    local offset = 0
    local outputOffset = 1
    for i = bitmapDataPointer, bitmapEnd do
        output[outputOffset] = data[bitmapDataPointer + offset]
        offset = offset + 1
        outputOffset = outputOffset + 1
    end

    local offset = 0
    for i = screenStart, screenEnd do
        output[outputOffset] = data[screenRamDataPointer + offset]
        offset = offset + 1
        outputOffset = outputOffset + 1
    end

    local offset = 0
    for i = colourStart, colourEnd do
        output[outputOffset] = data[colourRamDataPointer + offset]
        offset = offset + 1
        outputOffset = outputOffset + 1
    end

    return {
        data = output,
        totalBytes = #output,
        bgColour = data[10001],
    }
end


-- apple rle compression to data
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
log('amica2asm - Amica Bitmap Exporter (v0.1)')
log('Andrew Burch - www.0xc64.com')

-- display help and exit
if showHelp then
    log('  Usage:')
    log('    lua amica2asm -iInputFile -oOutputFile [options]')
    log('')
    log('    -i : input file')
    log('    -o : output file')
    log('')
    log('    options:')
    log('      -h : show help')
    log('      -q : quiet mode')
    log('      -r : output origin')
    log('      -p : output data pointers')
    log('      -g : output background value')
    log('      -e : export uncompressed')
    log('      -l[1-25] : export char line count')
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
log('[NFO] - Output bg colour: ' .. (includeBackground and 'Yes' or 'No'))
log('[NFO] - Output data pointers: ' .. (includeDataPointers and 'Yes' or 'No'))
log('[NFO] - Output mode: ' .. (outputMode == 'h' and 'Hex' or 'Decimal'))
log('[NFO] - Line strip: ' .. exportLines)
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


-- unpack bitmap
local inflatedData = decompressRLEData(data, string.len(data), 3, function(data, i) 
                        return tobyte(substr(data, i, i))
                    end)

log('[NFO] - Bytes extracted: ' .. inflatedData.totalBytes)
log('[NFO] - Encoded runs found: ' .. inflatedData.encodedFlags)

-- strip bitmap based on desired character lines to convert
local strippedData = stripNonRequiredData(inflatedData.data)

log('[NFO] - Bytes after strip: ' .. strippedData.totalBytes)


local outputData = strippedData

-- perform RLE compression on stripped data if required
if exportCompressed then
    outputData = applyRLECompression(strippedData.data)

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

-- output background colour
if includeBackground then
    fp:write('background_colour .byte ' .. strfmt(fmt, strippedData.bgColour) .. '\n\n')
end

-- output bitmap data pointers
if includeDataPointers then
    fp:write(strfmt('screen_ram_offset .byte $%04x\n', exportLines * 8 * 40))    
    fp:write(strfmt('colour_ram_offset .byte $%04x\n\n', (exportLines * 8 * 40) + (exportLines * 40)))
end

-- output converted data
fp:write(convertedData)
fp:close()

-- done
log('[NFO] - Output to file: ' .. outputFile)