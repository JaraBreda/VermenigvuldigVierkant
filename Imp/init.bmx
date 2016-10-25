Strict

Import tricky_units.FilePicker
Import "intlanguage/langs.bmx"

Function init()
	Local show$
	AppTitle = StripAll(AppFile)
	 InstallLanguages()
	lang = FilePicker("Please select a language",LangDir)
	If Not lang exit_ 0
	LoadIni langdir+"/"+lang,langdata
	configfile = FilePicker(lng("Config.Choose"),configdir,1,1)
	If Not FileType(configdir+"/"+configfile) SaveString "[Rem]~nOh yeah",configdir+"/"+configfile
	LoadIni configdir+"/"+configfile,config
	While config.c("TYPE")<>"TIME" And config.c("TYPE")<>"TASKS"
		config.d "TYPE",Trim(Upper(MaxGUI_Input(lng("Config.type"))))
	Wend
	show = "Type~t= "+config.c("TYPE")
	Select config.c("TYPE")
		Case "TIME"
			While config.c("MAXTIME").toint()<60 
				config.d "MAXTIME",MaxGUI_Input(Lng("CONFIG.MaxTime"))
			Wend
			show:+"~nMaxTime~t= "+config.c("MaxTime")
		Case "TASKS"
			While config.c("MAXTASKS").toint()<5 Or config.c("MAXTASKS").toint()>100 
				config.d "MAXTASKS",MaxGUI_Input(Lng("CONFIG.MaxTasks"))
			Wend
			show:+"~nMaxTasks~t= "+config.C("MaxTasks")
	End Select
	SaveIni configdir+"/"+configfile,config
	Repeat
		Select Proceed(show+"~n~n"+lng("Config.Confirm"))
			Case -1 End
			Case 1	Exit
			Case 0
				?win32
				system_ "notepad "+configdir+"/"+configfile
				Notify lng("Config.wait4save")
				LoadIni configdir+"/"+configfile,config
				?macos
				Notify "No direct change yet set for Mac"
				?linux
				Notify "No direct change yet set for Linux"
				?
		End Select
	Forever
End Function
