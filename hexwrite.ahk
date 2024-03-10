#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
; #Warn  ; Enable warnings to assist with detecting common errors.
SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.
#Include %A_ScriptDir% 
#Include BinReadWrite.ahk
#Include DllCallStruct.ahk
 
;set variables
filepath := a_scriptdir
filename = writetest.ssd ;;;;;;;;;;
file:= filepath "\" filename
IfExist, %file%
	FileDelete, %file%

ofw := OpenFileForWrite(file)

MsgBox ofw: %ofw%

datah = f3

eh2b := Hex2Bin(data, datah)

MsgBox data: %data%

MsgBox eh2b: %eh2b%

wif := WriteInFile(ofw,data )

MsgBox wif: %wif%

ecf := CloseFile(ofw)

MsgBox ecf: %ecf%
