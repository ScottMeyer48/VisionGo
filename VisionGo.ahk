#NoEnv 
#Persistent
#SingleInstance Force
#InstallMouseHook
SendMode Input  
SetWorkingDir %A_ScriptDir% 
CoordMode, Mouse, Client 	 
SetTitleMatchMode 2
SetBatchLines, -1
SetWinDelay,-1
SetKeyDelay,0

; __Files_et_Arborescence:
VG_Path_Ressource = %A_WorkingDir%\Ressource
VG_Path_Images    = %A_WorkingDir%\Images
FileCreateDir, Images
FileCreateDir, Ressource

; __Lecture_Fichier_INI:
  IfNotExist, VisionGo.ini
  {
VG_INIDEFAULT =
(
[VisionGo]
VisionGo_Version          =0.5

VisionGo_Couleur_Gui      =B8C88C
VisionGo_Couleur_Marquage =00A020
VisionGo_Taille_Text_Marq =16
VisionGo_Pierre_Texture   =yes

VisionGo_19x19            =
VisionGo_13x13            =
VisionGo_9x9              =

[Traduction]        
)

    FileAppend, %VG_INIDEFAULT%, VisionGo.ini
  }

  IniRead, VG_Couleur_Gui          , VisionGo.ini, VisionGo, VisionGo_Couleur_Gui
  IniRead, VG_Couleur_Marquage     , VisionGo.ini, VisionGo, VisionGo_Couleur_Marquage
  IniRead, VisionGo_Version        , VisionGo.ini, VisionGo, VisionGo_Version
  IniRead, VisionGo_Taille_Goban   , VisionGo.ini, VisionGo, VisionGo_19x19
  IniRead, VisionGo_Pierre_Texture , VisionGo.ini, VisionGo, VisionGo_Pierre_Texture
  
; __VisionGo_Variable:
ProgrammeName       = VisionGo
RET                 = `n
TailleGoban_19      = 19x19
TailleGoban_13      = 13x13
TailleGoban_9       = 9x9
Taille_Goban_Actuel = 19             ;Par défault
Url_VisionGo        = http://atelierludique.free.fr/index.php?title=VisionGo 

; Ne pas changer ces valeurs, pour detecter la roulette de la souris
EtatWheelDown       = 1
EtatWheelUp         = 1
Check_EtatWheelDown = 1
Check_EtatWheelUp   = 1

; Ne pas changer ces valeurs, Destroy control Gui (pour detruire les pierres, fonction Undo)
WM_DESTROY=0x02
WM_PAINT=0x0F
WM_CLOSE=0x10
WM_NCDESTROY=0x82
WM_PARENTNOTIFY=0x210

goto passe_maj  ; il n'y a plus de maintenance pour les mises à jour, cette partie est passée

; __Verif_Version_Recuperation_INI:
IfExist, VisionGo.tmp
	FileDelete, VisionGo.tmp
IfExist, VisionGo.New
	FileDelete, VisionGo.New

IfExist, VisionGo_INI.bak
{
  IniRead, VG_Couleur_Gui            , VisionGo_INI.bak, VisionGo, VisionGo_Couleur_Gui
  IniRead, VG_Couleur_Marquage       , VisionGo_INI.bak, VisionGo, VisionGo_Couleur_Marquage
  IniRead, VisionGo_Taille_Text_Marq , VisionGo_INI.bak, VisionGo, VisionGo_Taille_Text_Marq
  IniRead, VisionGo_Pierre_Texture   , VisionGo_INI.bak, VisionGo, VisionGo_Pierre_Texture
  IniRead, VisionGo_Taille_Goban     , VisionGo_INI.bak, VisionGo, VisionGo_19x19
  IniRead, VisionGo_Taille_Goban     , VisionGo_INI.bak, VisionGo, VisionGo_13x13
  IniRead, VisionGo_Taille_Goban     , VisionGo_INI.bak, VisionGo, VisionGo_9x9

  If not (VG_Couleur_Gui = "error" OR VG_Couleur_Gui ="" )
    IniWrite, %VG_Couleur_Gui%           , VisionGo.ini, VisionGo, VisionGo_Couleur_Gui 

  If not (VG_Couleur_Marquage = "error" OR VG_Couleur_Marquage ="" )
    IniWrite, %VG_Couleur_Marquage%      , VisionGo.ini, VisionGo, VisionGo_Couleur_Marquage 

  If not (VisionGo_Taille_Text_Marq = "error" OR VisionGo_Taille_Text_Marq ="" )
    IniWrite, %VisionGo_Taille_Text_Marq%, VisionGo.ini, VisionGo, VisionGo_Taille_Text_Marq

  If not (VisionGo_Pierre_Texture = "error" OR VisionGo_Pierre_Texture ="" )
    IniWrite, %VisionGo_Pierre_Texture%  , VisionGo.ini, VisionGo, VisionGo_Pierre_Texture 

  If not (VisionGo_19x19 = "error" OR VisionGo_19x19 ="" )
    IniWrite, %VisionGo_19x19%           , VisionGo.ini, VisionGo, VisionGo_19x19 

  If not (VisionGo_13x13 = "error" OR VisionGo_13x13 ="" )
    IniWrite, %VisionGo_13x13%           , VisionGo.ini, VisionGo, VisionGo_13x13 

  If not (VisionGo_9x9 = "error" OR VisionGo_9x9 ="" )
    IniWrite, %VisionGo_9x9%             , VisionGo.ini, VisionGo, VisionGo_9x9 

  IniRead, VisionGo_Version              , VisionGo.ini, VisionGo, VisionGo_Version
  
  TrayTip , VisionGo : Mise à jour, VisionGo version %VisionGo_Version% à était installée avec succés !, 10, 1 
  FileDelete, VisionGo_INI.bak 
}
Else
{
  UrlDownloadToFile, http://atelierludique.free.fr/000/VisionGo/VisionGo.ini, VisionGo.tmp 
  IniRead, VisionGo_Ver_Internet, VisionGo.tmp, VisionGo, VisionGo_Version
  IF VisionGo_Ver_Internet = ERROR
    {
       Msgbox,16,VisionGo :, Un problème est survenu lors de la mise à jour %RET%%RET% Veuillez S'il vous plait télécharger vous-même la dernière version sur l'Atelier Ludique. %RET%%RET% et si possible me faire parvenir le probléme à atelierludique@free.fr, Merci. 
       Run, http://atelierludique.free.fr
       ExitApp 
    }
  ELSE
  {
    IF VisionGo_Ver_Internet > %VisionGo_Version%
  	{
      MsgBox,64,VisionGo : Mise à jour, Une version plus récente de VisionGo existe. %RET%%RET%Cliquez sur OK pour l'installer
  
      IfNotExist, %VG_Path_Ressource%\7z.exe
        UrlDownloadToFile, http://atelierludique.free.fr/000/PratiqueAHK/Ressource/7z.exe, %VG_Path_Ressource%\7z.exe
  		
      FileMove, VisionGo.ini, VisionGo_INI.bak , 1
  		
      UrlDownloadToFile, http://atelierludique.free.fr/000/VisionGo/VisionGo.zip, VisionGo.zip
      Runwait, %VG_Path_Ressource%\7z.exe x -y %A_ScriptDir%\VisionGo.zip,%A_ScriptDir%\,hide UseErrorLevel
    	FileDelete, %A_ScriptDir%\VisionGo.zip
    	
  		IfExist, VisionGo.exe
      {
        Run, %A_ScriptDir%\VisionGo.exe
        FileCreateShortcut, %A_ScriptDir%\VisionGo.exe, %A_Desktop%\VisionGo.lnk, %A_ScriptDir%,, VisionGo v%VisionGo_Ver_Internet% - Atelier Ludique, %VG_Path_Images%\IconeGo.ICO,,1,1
      }  
  		Else IfExist, VisionGo.ahk
      {
        Run, %A_ScriptDir%\VisionGo.ahk
        FileCreateShortcut, %A_ScriptDir%\VisionGo.ahk, %A_Desktop%\VisionGo.lnk, %A_ScriptDir%,, VisionGo v%VisionGo_Ver_Internet% - Atelier Ludique, %VG_Path_Images%\IconeGo.ICO,,1,1
      }
  		ExitApp
    }
  }
  FileDelete, VisionGo.tmp
}

passe_maj:

; __Selectionne_les_preferences_utilisateur:

  If VisionGo_Pierre_Texture = Yes
  {
    VG_File_Pierre_Noir  =  %VG_Path_Images%\Go_Pierre_Noir_Texture.png
    VG_File_Pierre_Blanc =  %VG_Path_Images%\Go_Pierre_Blanc_Texture.png
  }
  Else 
  {
    VG_File_Pierre_Noir  =  %VG_Path_Images%\Go_Pierre_Noir.png
    VG_File_Pierre_Blanc =  %VG_Path_Images%\Go_Pierre_Blanc.png
  }

; __Timer_Principale:
SetTimer, VisionGoTimer_Gui_1, 100
;SetTimer, DEBUG, 100

; __VisionGo_Systray:
Menu, Tray, NoStandard
Menu, Tray, Color, %VG_Couleur_Gui%
Menu, Tray, Add, A propos de VisionGo,VisionGo_A_Propos
Menu, Tray, Add
Menu, Tray, Add, Recharger
Menu, Tray, Add, Pause
Menu, Tray, Add	
Menu, Tray, Default, A propos de VisionGo 
Menu, Tray, Add, Exit,SysTrayEXIT
Menu, Tray, Tip, %ProgrammeName% v%VisionGo_Version%
Menu, Tray, Icon, Images\IconeGo.ICO

; MESSAGE DE BIENVENUE
TrayTip , VisionGo v%VisionGo_Version%,Bienvenue et merci d'utiliser VisionGo ^^%RET%%RET%Pour consulter l'aide : SHIFT + F12, 10, 1
  
return
; ******************************************************************************
; ******************************************************************************
; __FIN_DE_SECTION_AUTOMATIQUE:                                                   
; ******************************************************************************
; ******************************************************************************


~*WheelDown::
EtatWheelDown += 1
return

~*WheelUp::
EtatWheelUp += 1
return

~^MButton::
IfWinExist,VisionGo GUI1 (KGS)
  If List_Coup_Jouer <> 
  {
    MouseClick, left
    send,^a
    send,%List_Coup_Jouer%
  }
Return

~LButton::
IfWinActive , VisionGo GUI1 (KGS)
{
  ControlGetFocus, Test_focus , VisionGo GUI1 (KGS) 
  
  If Test_Focus = Edit1
  {
    If Sequence_a_Afficher = Coller-ici une séquence
    {
      ControlSetText, Edit1,,VisionGo GUI1 (KGS)
      Sequence_a_Afficher = 
    }
  }
}
Return


~MButton::
IfWinActive , KGS
{
  Clip_Sauve := ClipBoardAll
  ClipBoard = 
  send,^c
  ClipWait 1, 1
  Sequence_a_Afficher = %Clipboard%
  ClipBoard = 
  ClipBoard = %Clip_Sauve%
  ControlSetText, Edit1,%Sequence_a_Afficher%,VisionGo GUI1 (KGS)
}
return

DEBUG:
tooltip, 
(
List_Coup_Jouer                  =%List_Coup_Jouer%
Liste_Undo                           =%Liste_Undo%
Gui1_Choix_Seq_Noir            =%Gui1_Choix_Seq_Noir%
Gui1_Choix_Seq_Blanc           =%Gui1_Choix_Seq_Blanc%
Sequence_a_Afficher            =%Sequence_a_Afficher%
Ligne_HORIZONTALE_Name    =%Ligne_HORIZONTALE_Name%
Ligne_VERTICALE_Name      =%Ligne_VERTICALE_Name%
Pass_Affiche_Sequence        =%Pass_Affiche_Sequence% 
Ligne_HORIZONTALE_Coord   =%Ligne_HORIZONTALE_Coord%
Ligne_VERTICALE_Coord       =%Ligne_VERTICALE_Coord%

VG_CapMouse_NO_X  =%VG_CapMouse_NO_X%
VG_CapMouse_NO_Y =%VG_CapMouse_NO_Y%

VG_CapMouse_NE_X  =%VG_CapMouse_NE_X%
VG_CapMouse_NE_Y  =%VG_CapMouse_NE_Y%

VG_MouseX_Cap     =%VG_MouseX_Cap%
VG_MouseY_Cap     =%VG_MouseY_Cap%

)
return

F5::      ; INTERRUPTEUR POUR DEBUG
if 1 =
{
  SetTimer, DEBUG,off
  ;Tooltip,
  1 = 1
}
Else
{
  SetTimer, DEBUG,on
  1=
}
Return

/*
F9::
RELOAD
return
*/

+F11::
WinSetTitle,A,,KGS
return

+F12::
MsgBox,64,VisionGo : Information, 
(    
                                          
                                                     Lancez CGOBAN et VisionGo apparaitera en haut.

Comment utilisez VisionGo ?
~~~~~~~~~~~~~~~
   1. Lancez VisionGo
   2. Lancez Cgoban
   3. Lancez une partie
   4. Pendant la partie enfoncé sans relâcher [CTRL de droite]
   5. Choisissez la couleur de départ avec [HAUT] pour Noir et [BAS] pour Blanc
   6. Faite vos séquences
   7. Relâchez CTRL pour enlever les pierres de VisionGo ou pour recommencer 

Voici les raccourci à utiliser :
~~~~~~~~~~~~~~~~
  [CTRL] + [Roulette souris BAS] : Enlève le dernier coup joué
  [CTRL] + [Roulette souris HAUT] : Remets le dernier coup enlevé
  [CTRL] + [Boutton du Milieu de la souris] : Mets en phrase la séquence que vous venez de jouer pour le t'chat. Avant de cliquer mettez votre curseur sur le champs "Causettes" !

  [Boutton du Milieu de la souris] : Copie une sélection du t'chat pour le mettre dans le champs "séquence", puis cliquez sur "Afficher"
  [SHIFT] + [F11] : Renommer la fenêtre en cours pour "KGS". Permet de faire apparait VisionGo pour d'autre logiciel que CGOBAN
  [SHIFT] + [F12] : Faire apparaitre cette fenêtre d'aide.
  

                        Pour toutes idées, suggestions, aide, commentaire, report de bug : atelierludique@free.fr
                                                                  http://atelierludique.free.fr

                                                                                                                                                                                Scott Meyer ^^ 
)
Return

; __GUI_1_MENU_TOP:
VisionGoTimer_Gui_1:
  IfWinActive,KGS
  {
    If VisionGo_Gui1_UneFois = 
    {
      Gui 1:+LastFound +AlwaysOnTop -Caption +ToolWindow 
      Gui, 1:Color, %VG_Couleur_Gui%
      Gui, 1:font, bold s8    , tahoma
      Gui, 1:Add , Picture    , y0 w25 h-1                                     ,%VG_Path_Images%\IconeGo.ICO 
      Gui, 1:Add , Text       , ys                                         ,VisionGo : %RET%Format -> 
      Gui, 1:Add , DropDownList,ys y2 gTaille_Goban vTaille_Goban_Valeur w70 ,%TailleGoban_19%||%TailleGoban_13%|%TailleGoban_9%
  	  Gui, 1:Add , Button	    , ys y1	h25 gVG_Gui1_Button_Calibrage            ,Calibrage

      Gui, 1:Add , Radio      , ys             vGui1_Choix_Seq_Noir            ,Black
      Gui, 1:Add , Radio      , yp+13          vGui1_Choix_Seq_Blanc           ,White
      Gui, 1:Add , Edit       , ys y2 R1 h25   vSequence_a_Afficher            ,Coller-ici une séquence
      Gui, 1:Add , DropDownList,ys y2  w70     vVitesse_Sequence               ,Lent|Moyen||Rapide
  	  Gui, 1:Add , Button	    , ys y1 h25      gAffiche_Sequence_Script        ,Afficher / Cacher

  	  Gui, 1:Add , Button	    , ys y1 h25 gVG_GUI_5_CONFIGURATION              ,Setup
      Gui, 1:Add , Text       , ys yp+7 cBlue gVisionGo_A_Propos               ,HELP 
  	  Gui, 1:Add , Button	    , x770 y1 h15 w15  gVG_Quitter                          ,X
      Gui, 1:Show             , y0 h27  NoActivate                              ,VisionGo GUI1 (KGS)  
      
      WinGetPos , Gui1_Pos_X,, Gui1_Width,,VisionGo GUI1 (KGS)
      VisionGo_Pos_X := A_ScreenWidth - Gui1_Width - 100
      WinMove, VisionGo GUI1 (KGS),, VisionGo_Pos_X,,
      GuiControl , , Gui1_Choix_Seq_Noir, 1
      
      VisionGo_Gui1_UneFois = Stop
      
      if Vitesse_Sequence_TMP = Lent    ; Mémorise le choix de la rapidité d'affichage 
        GuiControl, Choose, ComboBox2, |1
      Else if Vitesse_Sequence_TMP = Moyen
        GuiControl, Choose, ComboBox2, |2
      Else if Vitesse_Sequence_TMP = Rapide
        GuiControl, Choose, ComboBox2, |3
      
      If Sequence_TMP <> 
      {
        GuiControl ,1:text, Sequence_a_Afficher ,%Sequence_TMP%
        Sequence_TMP =
      }
        
      if Taille_Goban_Valeur_TMP = %TailleGoban_19%    ; Mémorise le choix de la taille du goban pour quand Gui1 sera détruit et relance le test si le calibrage est fait.
        GuiControl, Choose, ComboBox1, |1
      Else if Taille_Goban_Valeur_TMP = %TailleGoban_13%
        GuiControl, Choose, ComboBox1, |2
      Else if Taille_Goban_Valeur_TMP = %TailleGoban_9%
        GuiControl, Choose, ComboBox1, |3
      Else
        Goto, Taille_Goban                       ; test si le calibrage est fait
    }
                                                
  }
  IfWinNotActive,KGS
  {
    Gui, 1:Submit ,NoHide
    Taille_Goban_Valeur_TMP = %Taille_Goban_Valeur%
    
    If (Sequence_a_Afficher <> "" OR Sequence_a_Afficher <> "Coller-ici une séquence")
      Sequence_TMP = %Sequence_a_Afficher%
    
    Vitesse_Sequence_TMP = %Vitesse_Sequence%
    
    VisionGo_Gui1_UneFois=
    Gui, 1:Destroy
    Gui, 2:Destroy
    Gui, 4:Destroy
  } 
Return

Affiche_Sequence_Script:

IfWinNotExist, KGS Transparent
{
  Gui, 1:Submit ,NoHide

  If Taille_Goban_Valeur = %TailleGoban_19%
    IniRead, VisionGo_Taille_Goban , VisionGo.ini, VisionGo, VisionGo_19x19
  If Taille_Goban_Valeur = %TailleGoban_13%
    IniRead, VisionGo_Taille_Goban , VisionGo.ini, VisionGo, VisionGo_13x13
  If Taille_Goban_Valeur = %TailleGoban_9%
    IniRead, VisionGo_Taille_Goban , VisionGo.ini, VisionGo, VisionGo_9x9
    

  Loop, parse, VisionGo_Taille_Goban, |,   ; Mets en variable les coordonnées du calibrage
  {
    If A_index = 1
      Goban_Reference_X  = %A_LoopField%
    If A_index = 2
      Goban_Reference_Y  = %A_LoopField%
    If A_index = 3
      VG_Goban_Taille_Case= %A_LoopField%
  }
  
  If Vitesse_Sequence = Lent
  Sleep_ms = 2000
  Else if Vitesse_Sequence = Moyen
  Sleep_ms = 1000
  Else
  Sleep_ms = 0
  
  If (Sequence_a_Afficher = "" OR Sequence_a_Afficher = "Coller-ici une séquence")
  {
    MsgBox,64,VisionGo : Information,Veuillez entrée une séquence comme ci-dessous, Choisir la couleur de départ et cliquez sur le bouton "AFFICHER" :%RET%%RET%Exemple :%RET%d17 d15 c15 c14 c16 d13 f17 c10          <- Séquence donné par CGOBAN %RET%%RET%ou%RET%%RET%Exemple :%RET%B:L12 - W:L11 - B:K9 - W:M9 - B:O12 - W:N14          <- Séquence donné par VisionGo%RET%%RET%Merci 
    Return
  }
  Else
  {
    if List_Coup_Jouer <>
      List_Coup_Jouer = 
    
    if InStr(Sequence_a_Afficher,"b:") OR InStr(Sequence_a_Afficher,"w:")	   ; sequence de VisionGo a afficher
    {
      Loop, parse, Sequence_a_Afficher,-                     ; sépare les coups de la sequence grace au "-"
      {
        Find_1 = % InStr(A_LoopField,":", CaseSensitive = false, StartingPos = 1)  ; trouve l emplacement car il peut y avoir un espace en debut 
        StringLeft, Color_Sequence, A_LoopField, (Find_1 - 1)     ; prends la couleur

        If 1fois =
        {
          if Color_Sequence   = B
            Gosub, VisionGoChoixNoir
          Else
            Gosub, VisionGoChoixBlanc
          1fois = fin
        }
        StringTrimLeft, Coordonnee, A_LoopField, %Find_1%        ; enleve la couleur
        StringLeft, Ligne_VERTICALE_Name, Coordonnee, 1          ; prends la lettre
        StringTrimLeft, Ligne_HORIZONTALE_Name, Coordonnee, 1    ; prends le ou les chiffres
        Gosub, Restaure_Coord
        Gosub, Pose_Pierre
        Sleep, %Sleep_ms%
      }
    }
    Else                                                    ; Sequence de CGOBAN a afficher
    {
      if Gui1_Choix_Seq_Noir   = 1
        Gosub, VisionGoChoixNoir
      Else
        Gosub, VisionGoChoixBlanc

      Loop, parse, Sequence_a_Afficher,%A_Space%
      {
        StringLeft, Ligne_VERTICALE_Name, A_LoopField, 1        ; prends la lettre
        StringTrimLeft, Ligne_HORIZONTALE_Name, A_LoopField, 1  ; prends le ou les chiffres

        Gosub, Restaure_Coord
        Gosub, Pose_Pierre
        Sleep, %Sleep_ms%
      }
    }
  1fois =   
  }
}
Else
{
  Gui, 4:Destroy
  Incrementation = 0
}
return                             


VG_Gui1_Button_Calibrage:
  Gui, 1:Submit ,NoHide

  If Taille_Goban_Valeur = %TailleGoban_19%
  {
    NbLigne_Goban = 18
    Taille_Goban_Actuel = 19
    VG_Illus_Affiche_A = VG_Illustration_19_
    VG_Illus_Affiche_B = VG_Illustration_Repere_
  }
    
  If Taille_Goban_Valeur = %TailleGoban_13%
  {
    NbLigne_Goban = 12
    Taille_Goban_Actuel = 13
    VG_Illus_Affiche_A = VG_Illustration_13_
    VG_Illus_Affiche_B = VG_Illustration_Repere_
  }
  If Taille_Goban_Valeur = %TailleGoban_9%
  {
    NbLigne_Goban = 8
    Taille_Goban_Actuel = 9
    VG_Illus_Affiche_A = VG_Illustration_9_
    VG_Illus_Affiche_B = VG_Illustration_Repere_
  }
  Goto, GUI_2_CALIBRAGE
return

Taille_Goban:  ; test si le calibrage est fait et renseigne sur les paramétres de taille de goban selectionner par l'User
  Gui, 1:Submit ,NoHide
  
  If Taille_Goban_Valeur = %TailleGoban_19%
  {
    IniRead, VisionGo_Taille_Goban , VisionGo.ini, VisionGo, VisionGo_19x19
    If VisionGo_Taille_Goban = 
      Goto, VG_Gui1_Button_Calibrage
  }

  If Taille_Goban_Valeur = %TailleGoban_13%
  {
    IniRead, VisionGo_Taille_Goban , VisionGo.ini, VisionGo, VisionGo_13x13
    If VisionGo_Taille_Goban =
      Goto, VG_Gui1_Button_Calibrage
  }

  If Taille_Goban_Valeur = %TailleGoban_9%
  {
    IniRead, VisionGo_Taille_Goban , VisionGo.ini, VisionGo, VisionGo_9x9
    If VisionGo_Taille_Goban =
      Goto, VG_Gui1_Button_Calibrage
  }
return

GUI_2_CALIBRAGE:

  Gui 2:+LastFound +AlwaysOnTop ;-Caption ;+ToolWindow 
  Gui, 2:Color, %VG_Couleur_Gui%
  Gui, 2:font, bold s8, tahoma
  Gui, 2:Add , Text   , w720 Center cRed -background     ,CALIBRAGE
  Gui, 2:Add , Picture, section vVG_Cal_Illus            ,%VG_Path_Images%\Calibrage\%VG_Illus_Affiche_A%1.png
  Gui, 2:Add , Text   , section ys w350 Center           ,Merci de suivre les instructions ci-dessous %RET%pour fournir 2 points repéres: 
  Gui, 2:Add , Text   , w350 Center cRed  -background    ,AVEZ VOUS BIEN OUVERT UNE PARTIE DE LA TAILLE : %Taille_Goban_Actuel%x%Taille_Goban_Actuel% ?
  Gui, 2:Add , Text   , yp+20 Center w350                ,Positionnez le curseur de la souris le plus exactement possible à l'intersection des lignes ! ( au centre ) 
  Gui, 2:Add , Text   , w350 cRed center vVG_Cal_Info    ,Le coin NORD OUEST
  Gui, 2:Add , Picture, x520 y160 vVG_Cal_Repere         ,%VG_Path_Images%\Calibrage\%VG_Illus_Affiche_B%1.png
  Gui, 2:Add , Text   , xs yp+100 w360 center            ,Validez avec :
  Gui, 2:Add , Text   , cRed w350 center                 ,MAINTENEZ [CTRL] de droite ENFONCé%RET%%RET%+ CLIC GAUCHE DE LA SOURIS 
  Gui, 2:Add , Button	, w350 h25 yp+75 gVG_Gui_FermerTout,ANNULER
  Gui, 2:Show         , NoActivate                       ,VisionGo - Configuration (KGS)  
  
  WinGetPos , , , Win_Calibration_W, Win_Calibration_H,VisionGo - Configuration (KGS)  
  Gui2_x := A_ScreenWidth - Win_Calibration_W
  Gui2_y := A_ScreenHeight - Win_Calibration_H
  WinMove, VisionGo - Configuration (KGS), , %Gui2_x%, %Gui2_y% 
Return

2GuiClose:
  Gui, 2:Destroy
return

; __GUI_4_TRANSPARENT:
VisionGoChoixNoir:
  VisionGoChoix=%VG_File_Pierre_Noir%
  IniRead, VisionGo_Taille_Text_Marq , VisionGo.ini, VisionGo, VisionGo_Taille_Text_Marq
  Gui, 3:Destroy
  Gui 4: +LastFound +AlwaysOnTop -Caption +ToolWindow   
  Gui, 4:font, bold s%VisionGo_Taille_Text_Marq%  , tahoma
  Gui, 4:Color, 33CCCC
  WinSet, TransColor, 33CCCC
  Gui, 4:Show, x0 y0 w%A_ScreenWidth% h%A_ScreenHeight% ,KGS Transparent
Return

VisionGoChoixBlanc:
  VisionGoChoix=%VG_File_Pierre_Blanc%
  IniRead, VisionGo_Taille_Text_Marq , VisionGo.ini, VisionGo, VisionGo_Taille_Text_Marq
  Gui, 3:Destroy
  Gui 4: +LastFound +AlwaysOnTop -Caption +ToolWindow   
  Gui, 4:font, bold s%VisionGo_Taille_Text_Marq%  , tahoma
  Gui, 4:Color, 33CCCC
  WinSet, TransColor, 33CCCC
  Gui, 4:Show, x0 y0 w%A_ScreenWidth% h%A_ScreenHeight% ,KGS Transparent
Return

VG_GUI_5_CONFIGURATION:
  IniRead, VisionGo_Taille_Text_Marq  , VisionGo.ini, VisionGo, VisionGo_Taille_Text_Marq
  IniRead, VG_Couleur_Gui             , VisionGo.ini, VisionGo, VisionGo_Couleur_Gui
  IniRead, VG_Couleur_Marquage        , VisionGo.ini, VisionGo, VisionGo_Couleur_Marquage
  IniRead, VisionGo_Pierre_Texture    , VisionGo.ini, VisionGo, VisionGo_Pierre_Texture

  If VisionGo_Pierre_Texture = Yes
    String_Choix_Texture = YES||NO
  Else
    String_Choix_Texture = NO||YES
  
  Gui 5:+LastFound +AlwaysOnTop ;-Caption ;+ToolWindow 
  Gui, 5:Color, %VG_Couleur_Gui%
  Gui, 5:font, bold s8  , tahoma
  Gui, 5:Add , Picture  ,                                                ,%VG_Path_Images%\IconeGo.ICO 
  Gui, 5:Add , Text     , ys w325 yp+10 cRed  Center                     ,CONFIGURATION : 
  Gui, 5:Add , Picture  , ys                                             ,%VG_Path_Images%\IconeGo.ICO 

  Gui, 5:Add , Text     , xs yp+50 h20 section                           ,Couleur Principale de VisionGo :
  Gui, 5:Add , Edit     , ys r1 h20 x270 W100 vVG_Couleur_Gui Center     ,%VG_Couleur_Gui%  

  Gui, 5:Add , Text     , section xs                                     ,Couleur du marquage des pierres (1,2,3,...) :
  Gui, 5:Add , Edit     , ys r1 h25 x270 W100 vVG_Couleur_Marquage Center,%VG_Couleur_Marquage%  

  Gui, 5:Add , Text     , section xs                                     ,Taille de l'écriture du marquage (défaut 16) :
  Gui, 5:Add , Edit     , ys r1  x270 W100 vVisionGo_Taille_Text_Marq Center ,%VisionGo_Taille_Text_Marq%  

  Gui, 5:Add , Text     , section xs                                     ,Souhaitez vous des pierres texturé ? :
  Gui, 5:Add , DropDownList,ys   x270 w100 vVisionGo_Pierre_Texture      ,%String_Choix_Texture%

  Gui, 5:Add , Text     , section xs  w410                               ,Pour les couleurs vous pouvez mettre soit (Red, Navy, Black, Teal,...) ou leur correspondance en valeur HTML (ne pas mettre le # juste les chiffres, exemple : B8C88C).
  Gui, 5:Add , Button	  , section xs w200 h25 yp+50   gVG_Gui_FermerTout ,ANNULER
  Gui, 5:Add , Button	  , ys w200 h25    gVG_Gui5_Valider                ,VALIDER
  Gui, 5:Show           ,                                                ,VisionGo - Configuration (KGS) v%VisionGo_Version%  
return

5GuiClose:
Goto, VG_Gui_FermerTout
return

VG_Gui5_Valider:
  Gui, 5:Submit ,NoHide
  IniWrite, %VG_Couleur_Gui%            , VisionGo.ini, VisionGo, VisionGo_Couleur_Gui
  IniWrite, %VG_Couleur_Marquage%       , VisionGo.ini, VisionGo, VisionGo_Couleur_Marquage
  IniWrite, %VisionGo_Taille_Text_Marq% , VisionGo.ini, VisionGo, VisionGo_Taille_Text_Marq
  IniWrite, %VisionGo_Pierre_Texture%   , VisionGo.ini, VisionGo, VisionGo_Pierre_Texture
  reload
Return

; __SYSTRAY_Script:
Pause:
  ;Menu, Tray, Icon, Images\IconeRouge.ico
  Suspend
return

EditerScript:		 
  Edit 
return

Recharger:	 
  Reload
return

SysTrayEXIT:
ExitApp


VisionGoTimer:
GetKeyState, statusCTRL, RCTRL
if statusCTRL = D                                ; CTRL de droite enfoncé
{

  IfWinExist ,VisionGo - Configuration (KGS)
  {
    GetKeyState, statusLButton, LButton
    If statusLButton = D                      ; si touche enfoncé
    {
      KeyWait, LButton                       ; attends que la touche soit relacher

; __CALIBRATION:
      Incrementation +=1
  
      GuiControl ,2:, VG_Cal_Illus  , %VG_Path_Images%\Calibrage\%VG_Illus_Affiche_A%2.png
      GuiControl ,2:, VG_Cal_Repere , %VG_Path_Images%\Calibrage\%VG_Illus_Affiche_B%2.png 
    
      GuiControl ,2:text, VG_Cal_Info , Le coin NORD EST
  
      If Incrementation = 1
      {  
  		CoordMode, Mouse, Client
		MouseGetPos, VG_CapMouse_NO_X, VG_CapMouse_NO_Y, , , 3
      }  
      If Incrementation = 2
      {
  		CoordMode, Mouse, Client
		MouseGetPos, VG_CapMouse_NE_X, VG_CapMouse_NE_Y, , , 3
      
        Taille_Une_Case := (VG_CapMouse_NE_X - VG_CapMouse_NO_X) / NbLigne_Goban
        Incrementation =
        Gui, 2:Destroy
        IniWrite, %VG_CapMouse_NO_X%|%VG_CapMouse_NO_Y%|%Taille_Une_Case%, VisionGo.ini, VisionGo, VisionGo_%Taille_Goban_Valeur% 
      } 
    }
  }
; __GUI_3_CHOIX_COULEUR:    
    
  IfWinNotExist ,VisionGo - Configuration (KGS)
  {
    If VG_Gui3_Choix_Couleur_Un_Seul_Lancement = 
    {
      Gui 3:+LastFound +AlwaysOnTop -Caption +ToolWindow
      Gui, 3:Color, %VG_Couleur_Gui%
      Gui, 3:font, bold s8  , tahoma
      Gui, 3:Add , Picture  ,                        , %VG_Path_Images%\IconeGo.ICO
      Gui, 3:Add , Text     , x220 y15               , VisionGo
      Gui, 3:Add , Text     , w470 cRed   xs +center , GARDEZ TOUJOURS [CTRL] ENFONCE ! RELACHEZ POUR EFFACER OU RECOMMENCER%RET%%RET%1) Choisissez une couleur de départ %RET%2) Cliquez sur le Goban pour poser une pierre
      Gui, 3:Add , Text     , x250 y160 cBlack       , [CTRL]+ [HAUT] pour NOIR
      Gui, 3:Add , Text     , x250 y295 cWhite       , [CTRL]+ [BAS]  pour BLANC
      Gui, 3:Add , Picture  , x80 y105                , %VG_Path_Images%\Go_Pierre_BlancNoir.png
      Gui, 3:Show, NoActivate                        ,KGS  
      List_Coup_Jouer =
      Liste_Undo =      
      VG_Gui3_Choix_Couleur_Un_Seul_Lancement = Oui
    }
    
    If VisionGoChoix = 
    {
      if GetKeyState("UP", "D")         ; Fléche HAUT du curseur clavier enfoncé
        Gosub, VisionGoChoixNoir
      
      if GetKeyState("DOWN", "D")       ; Fléche BAS du curseur clavier enfoncé
        Gosub, VisionGoChoixBlanc
    }
    
; #######################  SIMULE LA ROULETTRE DE LA SOURIS POUR LA FONCTION UNDO

; __WHEEL_DOWN:
    If (VisionGoChoix <>"" AND List_Coup_Jouer <>"")       ; un choix Couleur à était fait + il y a eu au moins un coup de jouer
    {
      if EtatWheelDown <> %Check_EtatWheelDown%                ; La roulette de la souris BAS à était tournée
      {
        StaticDelete_IMG = Static%Last_Static%  
        StaticDelete_TXT = % "Static"Last_Static - 1 

        PostMessage, WM_CLOSE, , ,%StaticDelete_TXT%,KGS Transparent
        PostMessage, WM_CLOSE, , ,%StaticDelete_IMG%,KGS Transparent

        ;GuiControl, 4:Hide, % "Static" Last_Static             ; Cache le chiffre 
        ;GuiControl, 4:Hide, % "Static" Last_Static - 1         ; Cache l image de la pierre 
        
        Last_Static := Last_Static - 2                         ; Decompte la derniere pierre enlever
        Incrementation -= 1                                    ; Chiffre de la prochaine pierre posé diminué de 1  
        
        if Incrementation < 0
          Incrementation = 0
        
        If VisionGoChoix = %VG_File_Pierre_Blanc%              ; remise de la couleur de la pierre qui a etait enlever
          VisionGoChoix = %VG_File_Pierre_Noir%
        Else
          VisionGoChoix = %VG_File_Pierre_Blanc%
        
        IfNotInString, List_Coup_Jouer,-                     ; Si dans "coups mémorisé" il n'y a pas de "-" c'est qu'il n'y a eu qu'un seul coup de jouer
        {
          If Liste_Undo =
            Liste_Undo = %List_Coup_Jouer%
          Else
            Liste_Undo = %Liste_Undo% - %List_Coup_Jouer%  ; Remplie la liste Undo
          
          List_Coup_Jouer =                                  ; vide la liste des coups memoriser
        }  
        Else                                                 ; Sinon, c'est qu'il y a eu plusieurs coup de jouer
        {
          Loop, parse, List_Coup_Jouer,-                     ; sépare les coups jouer grace au "-"
            Nombre_de_Pierre = %A_index%

          Loop, parse, List_Coup_Jouer,-                     ; sépare les coups jouer grace au "-"
          {
            If 1fois = 
            {
              List_Coup_Jouer = 
              1fois = End
            }
            If A_Index = %Nombre_de_Pierre%
            {
              If Liste_Undo = 
                Liste_Undo = %A_LoopField%
              Else  
                Liste_Undo = %Liste_Undo% - %A_LoopField%    ; remplie la liste des undo avec le dernier coup retirer
              Break 
            }
            If List_Coup_Jouer = 
              List_Coup_Jouer =%A_LoopField% 
            Else
              List_Coup_Jouer = %List_Coup_Jouer% -%A_LoopField% 
          }
          1fois = 
        }
      }
    }

; __WHEELP_UP:
    If (VisionGoChoix <>"" AND Liste_Undo <>"")                  ; Si un choix de couleur a etait fait + pierre a restaurer "list undo pleine"
    {
      If EtatWheelUp <> %Check_EtatWheelUp%                      ; la roulettre vers le HAUT a etait tourner
      {
        IfNotInString,  Liste_Undo,-                             ; si il n y a qu une seule entree dans la liste undo
        {
          StringTrimLeft, Coordonnee, Liste_Undo, 2              ; enleve la couleur
          StringLeft, Ligne_VERTICALE_Name, Coordonnee, 1        ; prends la lettre
          StringTrimLeft, Ligne_HORIZONTALE_Name, Coordonnee, 1  ; prends le ou les chiffres
          Liste_Undo =
          Gosub, Restaure_Coord
          Gosub, Pose_Pierre
        }
        Else                                                     ; il y a plusieurs pierre a restaurer
        {
          Loop, parse, Liste_Undo,-            
            Nombre_de_Pierre = %A_Index%

          Loop, parse, Liste_Undo,-            
          {
            If 1fois=
            {
              Liste_Undo =
              1fois = End
            }
            If A_Index = %Nombre_de_Pierre%
            {
              Find_1 = % InStr(A_LoopField,":", CaseSensitive = false, StartingPos = 1)  ; trouve l emplacement car il peut y avoir un espace en debut 
              StringTrimLeft, Coordonnee, A_LoopField, %Find_1%        ; enleve la couleur
              StringLeft, Ligne_VERTICALE_Name, Coordonnee, 1          ; prends la lettre
              StringTrimLeft, Ligne_HORIZONTALE_Name, Coordonnee, 1    ; prends le ou les chiffres
              Gosub, Restaure_Coord
              Gosub, Pose_Pierre
            }
            Else
            {
              If Liste_Undo = 
                Liste_Undo =%A_LoopField% 
              Else
                Liste_Undo = %Liste_Undo% -%A_LoopField% 
            }
          }
          1fois = 
        }
      }
    }
    
    Check_EtatWheelDown = %EtatWheelDown%
    Check_EtatWheelUp = %EtatWheelUp%
    
; #######################  DEBUT : POSER UNE PIERRE

    If VisionGoChoix <>      ; verifie qu'il y a eu un choix de couleur
    {
      if GetKeyState("LButton", "D") 
      {
        KeyWait, LButton     ; attends que le bouon de la souris soit relacher
        
        If Liste_Undo <>  ; Si liste undo pleine, là vider quand c'est une nouvelle sequence de coup
          Liste_Undo =  
		  
		CoordMode, Mouse, Client
		MouseGetPos, VG_MouseX_Cap, VG_MouseY_Cap, , , 3

        Ligne_VERTICALE_Coord =
        Ligne_VERTICALE_Y =
        VG_A_Index =
        Ne_Pas_Poser =
        
        If Taille_Goban_Valeur = %TailleGoban_19%
          IniRead, VisionGo_Taille_Goban , VisionGo.ini, VisionGo, VisionGo_19x19
        If Taille_Goban_Valeur = %TailleGoban_13%
          IniRead, VisionGo_Taille_Goban , VisionGo.ini, VisionGo, VisionGo_13x13
        If Taille_Goban_Valeur = %TailleGoban_9%
          IniRead, VisionGo_Taille_Goban , VisionGo.ini, VisionGo, VisionGo_9x9
          
 
        Loop, parse, VisionGo_Taille_Goban, |,   ; Mets en variable les coordonnées du calibrage
        {
          If A_index = 1
            Goban_Reference_X  = %A_LoopField%
          If A_index = 2
            Goban_Reference_Y  = %A_LoopField%
          If A_index = 3
            VG_Goban_Taille_Case= %A_LoopField%
        }

; #######################  TROUVE LA LIGNE VERTICALE

        loop,                                
        {
          If (VG_MouseX_Cap > Goban_Reference_X + (Taille_Goban_Actuel * VG_Goban_Taille_Case) - (VG_Goban_Taille_Case / 2))
          {
            Ne_Pas_Poser = NON
            Break    ; Si la souris dépasse le goban à droite de + de la moitier de la dernière case alors RIEN
          }
          
          If (VG_MouseX_Cap < Goban_Reference_X  - (VG_Goban_Taille_Case / 2))
          {
            Ne_Pas_Poser = NON
            Break    ; Si la souris dépasse le goban à gauche de + de la moitier de la première case alors RIEN
          }
          
          If A_Index = %Taille_Goban_Actuel%  ; Trouve la dernière ligne a droite
          {
            Ligne_VERTICALE_Coord := Goban_Reference_X + ((Taille_Goban_Actuel - 1) * VG_Goban_Taille_Case) 
            VG_A_Index = %A_Index%
            Gosub , Defini_Coord_Verticale
            Break
          }  
          
          If VG_MouseX_Cap < %Goban_Reference_X%    ; Test si c'est la première ligne ?
          {
            Ligne_VERTICALE_Coord = %Goban_Reference_X%
            VG_A_Index = %A_Index%
            Gosub , Defini_Coord_Verticale
            Break
          }
          Else if (VG_MouseX_Cap < (Goban_Reference_X + (A_Index * VG_Goban_Taille_Case)))    ; test les lignes suivantes
          {
            Calc_Ligne := Goban_Reference_X + (A_Index * VG_Goban_Taille_Case) - (VG_Goban_Taille_Case / 2) 
            if VG_MouseX_Cap < %Calc_Ligne%  ; Quand les coordonnées du nb de case dépasse Capture souris, test pour si ligne précédente ou suivante
            {
              VG_A_Index := A_index - 1           
              Ligne_VERTICALE_Coord  := Goban_Reference_X + (VG_A_Index * VG_Goban_Taille_Case) ; ligne précédente
              VG_A_Index = %A_Index%
              Gosub , Defini_Coord_Verticale
              Break    
            }
            Else
            {
              Ligne_VERTICALE_Coord  := Goban_Reference_X + (A_index * VG_Goban_Taille_Case) ; ligne suivante
              VG_A_Index := A_Index + 1
              Gosub , Defini_Coord_Verticale
              Break                               
            }
          }
        }
      
; #######################  TROUVE LA LIGNE HORIZONTALE

        loop,                                
        {
          If (VG_MouseY_Cap > Goban_Reference_Y + (Taille_Goban_Actuel * VG_Goban_Taille_Case) - (VG_Goban_Taille_Case / 2))
          {
            Ne_Pas_Poser = NON
            Break    ; Si la souris dépasse le goban en bas de + de la moitier de la dernière case alors RIEN
          }  

          If (VG_MouseY_Cap < Goban_Reference_Y  - (VG_Goban_Taille_Case / 2))
          {
            Ne_Pas_Poser = NON
            Break    ; Si la souris dépasse le goban en haut de + de la moitier de la première case alors RIEN
          }
                    
          If A_Index = %Taille_Goban_Actuel%  ; Trouve la dernière ligne du bas
          {
            Ligne_HORIZONTALE_Coord := Goban_Reference_Y + ((Taille_Goban_Actuel - 1) * VG_Goban_Taille_Case) 
            VG_A_Index = %A_Index%
            Gosub , Defini_Coord_Horizontale
            Break
          }  
          
          If VG_MouseY_Cap < %Goban_Reference_Y%    ; Test si c'est la première ligne ?
          {
            Ligne_HORIZONTALE_Coord = %Goban_Reference_Y%
            VG_A_Index = %A_Index%
            Gosub , Defini_Coord_Horizontale
            Break
          }
          Else if (VG_MouseY_Cap < (Goban_Reference_Y + (A_Index * VG_Goban_Taille_Case)))    ; test les lignes suivantes
          {
            Calc_Ligne := Goban_Reference_Y + (A_Index * VG_Goban_Taille_Case) - (VG_Goban_Taille_Case / 2) 
            if VG_MouseY_Cap < %Calc_Ligne%  ; Quand les coordonnées du nb de case dépasse Capture souris, test pour si ligne précédente ou suivante
            {
              VG_A_Index := A_index - 1           
              Ligne_HORIZONTALE_Coord  := Goban_Reference_Y + (VG_A_Index * VG_Goban_Taille_Case) ; ligne précédente
              VG_A_Index = %A_Index%
              Gosub , Defini_Coord_Horizontale
              Break    
            }
            Else
            {
              Ligne_HORIZONTALE_Coord  := Goban_Reference_Y + (A_index * VG_Goban_Taille_Case) ; ligne suivante
              VG_A_Index := A_Index + 1
              Gosub , Defini_Coord_Horizontale
              Break                               
            }
          }
        }
        If Ne_Pas_Poser =              ; si Ne_Pas_Poser = vide alors OFF
          Gosub , Pose_Pierre
      }
    }
  }
}

IfWinNotExist ,VisionGo - Configuration (KGS)
{
  If statusCTRL = U        ; CTRL relacher
  {
    VG_Gui3_Choix_Couleur_Un_Seul_Lancement = 
    VisionGoChoix = 
    VisionGo_UneFois_Timer =
    dors_une_fois = 
    Memo_Rappel_Jouer =
    Dernier_Coup = 
    Separation =  
    SetTimer, VisionGoTimer, OFF
    Gosub, VG_Gui_FermerTout
  }
}
Return

Pose_Pierre:
  loop,
  {
            
    IfinString, List_Coup_Jouer,%Ligne_VERTICALE_Name%%Ligne_HORIZONTALE_Name%
      Break
    
    Incrementation +=1
    
    Past_Pierre_X     := Ligne_VERTICALE_Coord   - (VG_Goban_Taille_Case / 2) - 2 + 4
    Past_Pierre_Y     := Ligne_HORIZONTALE_Coord - (VG_Goban_Taille_Case / 2) - 2 + 23
    Past_Text_X       := Ligne_VERTICALE_Coord   - 3 - VisionGo_Taille_Text_Marq  + 4  
    Past_Text_Y       := Ligne_HORIZONTALE_Coord - 3 - ((VisionGo_Taille_Text_Marq / 2) * 1.5) + 23
    Gui4_Largeur_Text := VisionGo_Taille_Text_Marq * 2     

    If VisionGoChoix = %VG_File_Pierre_Noir%
    {
      Gui, 4:Add , Text   , x%Past_Text_X% y%Past_Text_Y% w%Gui4_Largeur_Text% c%VG_Couleur_Marquage% BackgroundTrans center,%Incrementation% 
      Gui, 4:Add , Picture, x%Past_Pierre_X% y%Past_Pierre_Y% w%VG_Goban_Taille_Case% h-1  , %VisionGoChoix%
      VisionGoChoix =  %VG_File_Pierre_Blanc%
      
      If List_Coup_Jouer =
        Separation =  
      Else 
        Separation = -  
      
      List_Coup_Jouer = %List_Coup_Jouer% %Separation% B:%Ligne_VERTICALE_Name%%Ligne_HORIZONTALE_Name%
      
      WinGet, ControlList_GUI1, ControlList, KGS Transparent

      Loop, parse, ControlList_GUI1, `n, `r 
      {
        IfInString, A_LoopField,Static                   
          Last_Static = %A_Index%
      }  
      Break
    }
    If VisionGoChoix = %VG_File_Pierre_Blanc%
    {
      Gui, 4:Add , Text   , x%Past_Text_X% y%Past_Text_Y% w%Gui4_Largeur_Text% c%VG_Couleur_Marquage% BackgroundTrans center,%Incrementation% 
      Gui, 4:Add , Picture, x%Past_Pierre_X% y%Past_Pierre_Y% w%VG_Goban_Taille_Case% h-1  , %VisionGoChoix%
      VisionGoChoix =  %VG_File_Pierre_Noir%

      If List_Coup_Jouer =
        Separation =  
      Else 
        Separation = -  
      
      List_Coup_Jouer = %List_Coup_Jouer% %Separation% W:%Ligne_VERTICALE_Name%%Ligne_HORIZONTALE_Name%

      WinGet, ControlList_GUI1, ControlList, KGS Transparent

      Loop, parse, ControlList_GUI1, `n, `r 
      {
        IfInString, A_LoopField,Static                   
          Last_Static = %A_Index%
      }
      Break
    }
  }
return

Defini_Coord_Horizontale:
If VG_A_Index = 1
  Ligne_HORIZONTALE_Name = 19 
If VG_A_Index = 2
  Ligne_HORIZONTALE_Name = 18 
If VG_A_Index = 3
  Ligne_HORIZONTALE_Name = 17 
If VG_A_Index = 4
  Ligne_HORIZONTALE_Name = 16 
If VG_A_Index = 5
  Ligne_HORIZONTALE_Name = 15 
If VG_A_Index = 6
  Ligne_HORIZONTALE_Name = 14 
If VG_A_Index = 7
  Ligne_HORIZONTALE_Name = 13 
If VG_A_Index = 8
  Ligne_HORIZONTALE_Name = 12 
If VG_A_Index = 9
  Ligne_HORIZONTALE_Name = 11 
If VG_A_Index = 10
  Ligne_HORIZONTALE_Name = 10 
If VG_A_Index = 11
  Ligne_HORIZONTALE_Name = 9 
If VG_A_Index = 12
  Ligne_HORIZONTALE_Name = 8 
If VG_A_Index = 13
  Ligne_HORIZONTALE_Name = 7 
If VG_A_Index = 14
  Ligne_HORIZONTALE_Name = 6 
If VG_A_Index = 15
  Ligne_HORIZONTALE_Name = 5 
If VG_A_Index = 16
  Ligne_HORIZONTALE_Name = 4 
If VG_A_Index = 17
  Ligne_HORIZONTALE_Name = 3 
If VG_A_Index = 18
  Ligne_HORIZONTALE_Name = 2 
If VG_A_Index = 19
  Ligne_HORIZONTALE_Name = 1 
return

Defini_Coord_Verticale:
If VG_A_Index = 1
  Ligne_VERTICALE_Name = A 
If VG_A_Index = 2
  Ligne_VERTICALE_Name = B 
If VG_A_Index = 3
  Ligne_VERTICALE_Name = C 
If VG_A_Index = 4
  Ligne_VERTICALE_Name = D 
If VG_A_Index = 5
  Ligne_VERTICALE_Name = E 
If VG_A_Index = 6
  Ligne_VERTICALE_Name = F 
If VG_A_Index = 7
  Ligne_VERTICALE_Name = G 
If VG_A_Index = 8
  Ligne_VERTICALE_Name = H 
If VG_A_Index = 9
  Ligne_VERTICALE_Name = J 
If VG_A_Index = 10
  Ligne_VERTICALE_Name = K 
If VG_A_Index = 11
  Ligne_VERTICALE_Name = L 
If VG_A_Index = 12
  Ligne_VERTICALE_Name = M 
If VG_A_Index = 13
  Ligne_VERTICALE_Name = N 
If VG_A_Index = 14
  Ligne_VERTICALE_Name = O 
If VG_A_Index = 15
  Ligne_VERTICALE_Name = P 
If VG_A_Index = 16
  Ligne_VERTICALE_Name = Q 
If VG_A_Index = 17
  Ligne_VERTICALE_Name = R 
If VG_A_Index = 18
  Ligne_VERTICALE_Name = S 
If VG_A_Index = 19
  Ligne_VERTICALE_Name = T 
return

Restaure_Coord:
If Ligne_VERTICALE_Name = A
  Ligne_VERTICALE_Coord := Goban_Reference_X
If Ligne_VERTICALE_Name = B
  Ligne_VERTICALE_Coord := Goban_Reference_X + VG_Goban_Taille_Case
If Ligne_VERTICALE_Name = C
  Ligne_VERTICALE_Coord := Goban_Reference_X + (VG_Goban_Taille_Case * 2)
If Ligne_VERTICALE_Name = D
  Ligne_VERTICALE_Coord := Goban_Reference_X + (VG_Goban_Taille_Case * 3)
If Ligne_VERTICALE_Name = E
  Ligne_VERTICALE_Coord := Goban_Reference_X + (VG_Goban_Taille_Case * 4)
If Ligne_VERTICALE_Name = F
  Ligne_VERTICALE_Coord := Goban_Reference_X + (VG_Goban_Taille_Case * 5)
If Ligne_VERTICALE_Name = G
  Ligne_VERTICALE_Coord := Goban_Reference_X + (VG_Goban_Taille_Case * 6)
If Ligne_VERTICALE_Name = H
  Ligne_VERTICALE_Coord := Goban_Reference_X + (VG_Goban_Taille_Case * 7)
If Ligne_VERTICALE_Name = J
  Ligne_VERTICALE_Coord := Goban_Reference_X + (VG_Goban_Taille_Case * 8)
If Ligne_VERTICALE_Name = K
  Ligne_VERTICALE_Coord := Goban_Reference_X + (VG_Goban_Taille_Case * 9)
If Ligne_VERTICALE_Name = L
  Ligne_VERTICALE_Coord := Goban_Reference_X + (VG_Goban_Taille_Case * 10)
If Ligne_VERTICALE_Name = M
  Ligne_VERTICALE_Coord := Goban_Reference_X + (VG_Goban_Taille_Case * 11)                    
If Ligne_VERTICALE_Name = N
  Ligne_VERTICALE_Coord := Goban_Reference_X + (VG_Goban_Taille_Case * 12)
If Ligne_VERTICALE_Name = O
  Ligne_VERTICALE_Coord := Goban_Reference_X + (VG_Goban_Taille_Case * 13)
If Ligne_VERTICALE_Name = P
  Ligne_VERTICALE_Coord := Goban_Reference_X + (VG_Goban_Taille_Case * 14)
If Ligne_VERTICALE_Name = Q
  Ligne_VERTICALE_Coord := Goban_Reference_X + (VG_Goban_Taille_Case * 15)
If Ligne_VERTICALE_Name = R
  Ligne_VERTICALE_Coord := Goban_Reference_X + (VG_Goban_Taille_Case * 16)
If Ligne_VERTICALE_Name = S
  Ligne_VERTICALE_Coord := Goban_Reference_X + (VG_Goban_Taille_Case * 17)
If Ligne_VERTICALE_Name = T
  Ligne_VERTICALE_Coord := Goban_Reference_X + (VG_Goban_Taille_Case * 18)

If Ligne_HORIZONTALE_Name = 1
  Ligne_HORIZONTALE_Coord := Goban_Reference_Y + (VG_Goban_Taille_Case * 18)
If Ligne_HORIZONTALE_Name = 2
  Ligne_HORIZONTALE_Coord := Goban_Reference_Y + (VG_Goban_Taille_Case * 17)
If Ligne_HORIZONTALE_Name = 3
  Ligne_HORIZONTALE_Coord := Goban_Reference_Y + (VG_Goban_Taille_Case * 16)
If Ligne_HORIZONTALE_Name = 4
  Ligne_HORIZONTALE_Coord := Goban_Reference_Y + (VG_Goban_Taille_Case * 15)
If Ligne_HORIZONTALE_Name = 5
  Ligne_HORIZONTALE_Coord := Goban_Reference_Y + (VG_Goban_Taille_Case * 14)
If Ligne_HORIZONTALE_Name = 6
  Ligne_HORIZONTALE_Coord := Goban_Reference_Y + (VG_Goban_Taille_Case * 13)
If Ligne_HORIZONTALE_Name = 7
  Ligne_HORIZONTALE_Coord := Goban_Reference_Y + (VG_Goban_Taille_Case * 12)
If Ligne_HORIZONTALE_Name = 8
  Ligne_HORIZONTALE_Coord := Goban_Reference_Y + (VG_Goban_Taille_Case * 11)
If Ligne_HORIZONTALE_Name = 9
  Ligne_HORIZONTALE_Coord := Goban_Reference_Y + (VG_Goban_Taille_Case * 10)
If Ligne_HORIZONTALE_Name = 10
  Ligne_HORIZONTALE_Coord := Goban_Reference_Y + (VG_Goban_Taille_Case * 9)
If Ligne_HORIZONTALE_Name = 11
  Ligne_HORIZONTALE_Coord := Goban_Reference_Y + (VG_Goban_Taille_Case * 8)
If Ligne_HORIZONTALE_Name = 12
  Ligne_HORIZONTALE_Coord := Goban_Reference_Y + (VG_Goban_Taille_Case * 7)
If Ligne_HORIZONTALE_Name = 13
  Ligne_HORIZONTALE_Coord := Goban_Reference_Y + (VG_Goban_Taille_Case * 6)
If Ligne_HORIZONTALE_Name = 14
  Ligne_HORIZONTALE_Coord := Goban_Reference_Y + (VG_Goban_Taille_Case * 5)
If Ligne_HORIZONTALE_Name = 15
  Ligne_HORIZONTALE_Coord := Goban_Reference_Y + (VG_Goban_Taille_Case * 4)
If Ligne_HORIZONTALE_Name = 16
  Ligne_HORIZONTALE_Coord := Goban_Reference_Y + (VG_Goban_Taille_Case * 3)
If Ligne_HORIZONTALE_Name = 17
  Ligne_HORIZONTALE_Coord := Goban_Reference_Y + (VG_Goban_Taille_Case * 2)
If Ligne_HORIZONTALE_Name = 18
  Ligne_HORIZONTALE_Coord := Goban_Reference_Y + VG_Goban_Taille_Case
If Ligne_HORIZONTALE_Name = 19
  Ligne_HORIZONTALE_Coord := Goban_Reference_Y 
Return

VisionGo_A_Propos:
run, %Url_VisionGo%
return

VG_Gui_FermerTout:
  Incrementation = 
	Gui, 2:Destroy
	Gui, 3:Destroy
	Gui, 4:Destroy
	Gui, 5:Destroy
return

VG_Quitter:
Exitapp
return

; __Vision_Go_HotKey_Persistant:
#IfWinActive,KGS
{
  ~CTRL::
  If VisionGo_UneFois_Timer = 
  {
      SetTimer, VisionGoTimer, 10
      VisionGo_UneFois_Timer  = NON 
  }
  Return
}

