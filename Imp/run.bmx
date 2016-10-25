Strict
Import tricky_units.MaxGUI_Input
Import "globals.bmx"
Import brl.max2d

Incbin "caviardreams.ttf"


Private
Global font:TImageFont = LoadImageFont("incbin::caviardreams.ttf",15)
If Not font Notify "WARNING!~nFont not properly loaded! This may result into odd behavior"
Global done[101,101]
Global tx,ty,asw$
Function cleardone()
	Local x,y
	For x=1 To 100 For y=1 To 100 done[x,y]=False Next Next
End Function

Function NewTask()
	Local timeout=100000
	Repeat
		tx = Rand(1,100)
		ty = Rand(1,100)
		timeout:-1
		If timeout<0 Notify "ERROR: Timeout!"; End
	Until Not done[tx,ty]
	asw=""
End Function

Function Game(ln$)
	Notify Replace(lng("welcome"),"$PUPIL",ln)
	Local ll:tleerling = New tleerling
	MapInsert leerlingen,ln,ll
	Graphics 25*11,25*11
	SetImageFont font
	Local lc = 155 + Floor(Sin(MilliSecs()/100)*100)
	Local gw = GraphicsWidth()
	Local gh = GraphicsHeight()
	cleardone
	NewTask
	Repeat
		lc = 155 + Floor(Sin(MilliSecs()/100)*100)
		For Local i=1 To 10
			SetColor lc,lc,255-lc
			DrawLine 0,i*25,gw,i*25
			DrawLine i*25,0,i*25,gh
			If AppTerminate() Notify "Termination blocked"
			SetColor 255,180,0
			DrawText i,i*25,0
			DrawText i,0,i*25
		Next	
		Flip
		
	Forever
End Function

Function SaveResults(F$)
	Local bt:TStream = WriteFile(f)
	If Not bt 
		Notify lng("Failure.save")
		Return False
	EndIf
	WriteLine bt,"<html><body style='color:#ffb400; background-color:#100400; font-family: arial'>"
	WriteLine bt,"<table>"
	WriteLine bt,"<tr style='background-color:#ffb400; color: #100400'>"
	WriteLine bt,"~t<td>"+lng("table.name")+"</td>"
	WriteLine bt,"~t<td>"+lng("table.tasksdone")+"</td>"
	WriteLine bt,"~t<td>"+lng("table.correct")+"</td>"
	WriteLine bt,"~t<td>"+lng("table.wrong")+"</td>"
	WriteLine bt,"~t<td>"+lng("table.time")+"</td>"
	WriteLine bt,"</tr>~n~n"
	For Local l$=EachIn MapKeys(leerlingen)
		Local LL:tleerling = tleerling(MapValueForKey(leerlingen,L))
		WriteLine bt,"<tr valign=top align=right>"
		WriteLine bt,"~t<td align=left>"+l+"</td>"
		WriteLine bt,"~t<td>"+ll.tasks+"</td>"
		WriteLine bt,"~t<td>"+ll.correct+"</td>"
		WriteLine bt,"~t<td>"+ll.wrong+"</td>"
		WriteLine bt,"~t<td>"+ll.stime()+"</td>"
		WriteLine bt,"</tr>~n~n"
	Next
	WriteLine bt,"</table>"
	WriteLine bt,"Generated: "+CurrentDate()+"; "+CurrentTime()
	WriteLine bt,"</body>"
	WriteLine bt,"</html>"
	CloseFile bt
	If Proceed(lng("end.show"))=1 OpenURL(f)
End Function


Public
Function run()
	Local endchoice
	Repeat
		Repeat
			naamleerling = MaxGUI_Input(lng("Pupil.new"))
			If (Not Naamleerling) Or naamleerling.toupper()="BYE" Exit
			game naamleerling
		Forever
	endchoice = Proceed(lng("End.Result"))
	Select	endchoice
		Case 1 
			Local f$ = RequestFile(lng("end.rfc"),"HyperText Markup Language:html",True)
			If f 
				If saveresults( f )  Exit
			EndIf
		Case 0 Exit
	End Select
	Forever
End Function