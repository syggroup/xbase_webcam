/*
 *   $Id: webcam.prg 2147 2012-04-07 02:15:31Z leonardo $
 */

#include "hwgui.ch"

***************
FUNCTION MAIN()
***************
Local vARQ_WEBCAM := "teste.bmp"

MsgRun( 'Iniciando Webcam...', {|| BUSCA_IMAGEM_WEBCAM2(vARQ_WEBCAM) } )

IF FILE(vARQ_WEBCAM)
  Abre_arquivo( vARQ_WEBCAM )
ENDIF
Return NIL

***********************************************
STATIC FUNCTION BUSCA_IMAGEM_WEBCAM2(cNAMEFILE)
***********************************************
Local oDlgwebcam, oWebCam, oButtonex1, oButtonex2

DEFAULT cNAMEFILE:=SYG_GERAFILE()+".bmp"

INIT DIALOG oDlgwebcam TITLE "Captura de Imagem Webcam";
AT 0,0 SIZE 640,520 ;
FONT HFont():Add( '',0,-13,400,,,) CLIPPER NOEXIT NOEXITESC;
ON INIT{|| INICA_WEBCAM(oDlgwebcam,@oWebCam) };
ON EXIT {|| NOSAIDAF4() };
STYLE DS_CENTER +WS_VISIBLE

@ 0,2 BUTTONEX oButtonex1 CAPTION "&Capturar"  SIZE 100,38 ;
STYLE WS_TABSTOP   ;
BITMAP (HBitmap():AddResource(1002)):handle  ;
BSTYLE 0;
TOOLTIP 'Clique aqui para capturar a Imagem da Webcam';
ON CLICK {|| (oWebCam:SaveFile(cNAMEFILE),oWebCam:Finalize(),oWebCam:Destroy()),oDlgwebcam:close() }

@ 110,2 BUTTONEX oButtonex2 CAPTION "&Cancelar"  SIZE 100,38 ;
STYLE WS_TABSTOP   ;
BITMAP (HBitmap():AddResource(1003)):handle  ;
BSTYLE 0;
TOOLTIP 'Clique aqui para cancelar e voltar ao módulo anterior' ;
ON CLICK {|| (oWebCam:Finalize(),oWebCam:Destroy()),oDlgwebcam:close() }   
  
@ 420,2 BUTTONEX "&Formato"  SIZE 100,38 ;
STYLE WS_TABSTOP   ;
BITMAP (HBitmap():AddResource(1002)):handle  ;
BSTYLE 0;
TOOLTIP 'Clique aqui para formatar o video' ;
ON CLICK {|| oWebCam:VideoFormat() }   

@ 530,2 BUTTONEX "&Controles"  SIZE 100,38 ;
STYLE WS_TABSTOP   ;
BITMAP (HBitmap():AddResource(1002)):handle  ;
BSTYLE 0;
TOOLTIP 'Clique aqui para formatar o video' ;
ON CLICK {|| oWebCam:VideoControl() }   

ACTIVATE DIALOG oDlgwebcam

RETURN(.t.)

STATIC FUNCTION INICA_WEBCAM(oDlg,oWebCam)
#IfDef __XHARBOUR__
oWebCam:=HWebcam():New(oDlg,0,45,640,520,.T.)
#ENDIF
RETURN(.T.)

********************************************************************************
***************INCIO DA FUNCAO DE ABRIR ARQUIVOS********************************
********************************************************************************
STATIC FUNCTION ABRE_ARQUIVO( cHelpFile )
   LOCAL nRet, cPath, cFileName, cFileExt
   IF !FILE(cHelpFile)
      MsgStop('Arquivo não localizado, Favor revisar')
      RETURN(0)
   ENDIF

   HB_FNameSplit( cHelpFile, @cPath, @cFileName, @cFileExt )
   nRet := _OpenHelpFile( cPath, cHelpFile )
RETURN nRet

#pragma BEGINDUMP

   #pragma comment( lib, "shell32.lib" )
   #include "hbapi.h"
   #include <windows.h>
   HB_FUNC( _OPENHELPFILE )
   {
     HINSTANCE hInst;
     LPCTSTR lpPath = (LPTSTR) hb_parc( 1 );
     LPCTSTR lpHelpFile = (LPTSTR) hb_parc( 2 );
     hInst = ShellExecute( 0, "open", lpHelpFile, 0, lpPath, SW_SHOW );
     hb_retnl( (LONG) hInst );
     return;
   }
#pragma ENDDUMP

function SYG_TRANSLATOR(p1,p2)
return(p1)
