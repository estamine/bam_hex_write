/*
// Convert raw bytes stored in a variable to a string of hexa digit pairs.
// Convert either byteNb bytes or, if null, the whole content of the variable.
//
// Return the number of converted bytes, or -1 if error (memory allocation)
*/
Bin2Hex(ByRef @hex, ByRef @bin, _byteNb=0)
{
	local intFormat, dataSize, dataAddress, granted, x

	; Save original integer format
	intFormat = %A_FormatInteger%
	; For converting bytes to hex
	SetFormat Integer, Hex

	; Get size of data
	dataSize := VarSetCapacity(@bin)
	If (_byteNb < 1 or _byteNb > dataSize)
	{
		_byteNb := dataSize
	}
	dataAddress := &@bin
	; Make enough room (faster)
	granted := VarSetCapacity(@hex, _byteNb * 2)
	if (granted < _byteNb * 2)
	{
		; Cannot allocate enough memory
		ErrorLevel = Mem=%granted%
		Return -1
	}
	Loop %_byteNb%
	{
		; Get byte in hexa
		x := *dataAddress + 0x100
		StringRight x, x, 2	; 2 hex digits
		StringUpper x, x
		@hex = %@hex%%x%
		dataAddress++	; Next byte
	}
	; Restore original integer format
	SetFormat Integer, %intFormat%

	Return _byteNb
}

/*
// Convert a string of hexa digit pairs to raw bytes stored in a variable.
// Convert either byteNb bytes or, if null, the whole content of the variable.
//
// Return the number of converted bytes, or -1 if error (memory allocation)
*/
Hex2Bin(ByRef @bin, _hex, _byteNb=0)
{
	local dataSize, granted, dataAddress, x

	; Get size of data
	x := StrLen(_hex)
	dataSize := Ceil(x / 2)
	if (x = 0 or dataSize * 2 != x)
	{
		; Invalid string, empty or odd number of digits
		ErrorLevel = Param
		Return -1
	}
	If (_byteNb < 1 or _byteNb > dataSize)
	{
		_byteNb := dataSize
	}
	; Make enough room
	granted := VarSetCapacity(@bin, _byteNb, 0)
	if (granted < _byteNb)
	{
		; Cannot allocate enough memory
		ErrorLevel = Mem=%granted%
		Return -1
	}
	dataAddress := &@bin

	Loop Parse, _hex
	{
		if (A_Index & 1)	; Odd
		{
			x = %A_LoopField%	; Odd digit
		}
		else
		{
			; Concatenate previous x and even digit, converted to hex
			x := "0x" . x . A_LoopField
			; Store integer in memory
			DllCall("RtlFillMemory"
					, "UInt", dataAddress
					, "UInt", 1
					, "UChar", x)
			dataAddress++
		}
	}

	Return _byteNb
}