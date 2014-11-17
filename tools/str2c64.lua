-- Program: Str2C64 Converter
-- Author: Andrew Burch
-- Site: www.0xc64.com
-- Notes: Command line tool to convert a string to
--			C64 screen codes. Outputs results in 
--			series of .byte lines to paste into an
--			.asm file
--			Supports output to screen or file
--

-- optimisations
local sformat = string.format
local lowercase = string.lower
local substr = string.sub

-- screen code map
local map = {
	['@'] = 000,	['A'] = 001,	['B'] = 002,	['C'] = 003,	['D'] = 004,
	['E'] = 005,	['F'] = 006,	['G'] = 007,	['H'] = 008,	['I'] = 009,
	['J'] = 010,	['K'] = 011,	['L'] = 012,	['M'] = 013,	['N'] = 014,
	['O'] = 015,	['P'] = 016,	['Q'] = 017,	['R'] = 018,	['S'] = 019,
	['T'] = 020,	['U'] = 021,	['V'] = 022,	['W'] = 023,	['X'] = 024,
	['Y'] = 025,	['Z'] = 026,	['['] = 027,	['$'] = 028,	[']'] = 029,
	--['^030^'] = 030,	['^031^'] = 31,
	[' '] = 032,	['!'] = 033,	['"'] = 034,	['#'] = 035,	['$'] = 036,
	['%'] = 037,	['&'] = 038,	["'"] = 039,	['('] = 040,	[')'] = 041,
	['*'] = 042,	['+'] = 043,	[','] = 044,	['-'] = 045,	['.'] = 046,
	['/'] = 047,	['0'] = 048,	['1'] = 049,	['2'] = 050,	['3'] = 051,
	['4'] = 052,	['5'] = 053,	['6'] = 054,	['7'] = 055,	['8'] = 056,
	['9'] = 057,	[':'] = 058,	[';'] = 059,	['<'] = 060,	['='] = 061,
	['>'] = 062,	['?'] = 063,
}


local inverseMode = false
local quietMode = false
local showHelp = false
local bytesPerRow = 8
local message

local function setHelp()
	showHelp = true
end

local function setOutput(filename)
	outputFile = filename
end

local function setBytesPerRow(bpr)
	bytesPerRow = tonumber(bpr)
end

local function setMessage(msg)
	message = msg
end

local function setQuietMode()
	quietMode = true
end

local function setInverseMode()
	inverseMode = true
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
	['-o'] = setOutput,
	['/o'] = setOutput,
	['-b'] = setBytesPerRow,
	['/b'] = setBytesPerRow,
	['-m'] = setMessage,
	['/m'] = setMessage,
	['-q'] = setQuietMode,
	['/q'] = setQuietMode,
	['/i'] = setInverseMode,
	['-i'] = setInverseMode,
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
log('str2c64 - string converter (v0.2)')
log('Andrew Burch - www.0xc64.com')

if not message and not showHelp then
	print('[ERR] - No message specified')
	os.exit();
end

-- display help and exit
if showHelp then
	log('  Usage:')
	log('    lua str2c64 -mMessage [options]')
	log('')
	log('    -m : message')
	log('')
	log('    options:')
	log('      -h : show help')
	log('      -q : quiet mode')
	log('      -i: inverse characters')
	log('      -o : output filename')
	log('           (default is screen)')
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
for i = 1, #message do
    local c = message:sub(i,i)
    
    -- detect unsupported characters
    if not map[c] then 
    	log('[NFO] - Unsupported character found: ' .. c)
		print('[ERR] - Conversion failed')
    	os.exit();
   	end

   	-- prefix empty row
   	if rowByteCount == 0 then
    	output = sformat("%s.byte ", output)
   	end

   	-- extract the code
   	local characterCode = map[c]

   	-- output in inverse mode?
    if inverseMode then
    	characterCode = characterCode + 128
    end

   	-- append next byte value
    output = sformat("%s%s%03d", output, sep, characterCode)


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
log('[NFO] - Characters converted: ' .. byteCount)

-- output result
if outputFile then
	local fp, err = io.open(outputFile, 'w')

	if fp then
		fp:write(output)
		fp:close()
		log('[NFO] - Output to file: ' .. outputFile)
	else
		print('[ERR] - Unable to open file: ' .. err)
	end
else
	log('[NFO] - Converted string')
	print(output)	
end
