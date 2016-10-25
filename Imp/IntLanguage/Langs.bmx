Strict

Import "../globals.bmx"

Incbin "Dutch"
incnin "English"

Private
Global langs:TList = New TList 
ListAddLast langs , "Dutch"
ListAddLast langs , "English"
Const alwaysask = False 'Must be false in final version

Public

Function InstallLanguages()
	For Local L$ = EachIn langs
		If Alwaysask Or (Not(FileType(langdir+"/"+l) And Not(mainconfig.c("Lang.Asked."+L))))
			Select Proceed("Language file ~q"+l+"~q not installed.~nInstall it now?")
				Case -1 exit_ 0
				Case 1 CopyFile "incbin::"+l,langdir+"/"+l
			End Select	
		EndIf	
	Next 
	SaveIni mainconfigfile,mainconfig
End Function
