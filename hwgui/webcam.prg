/*
 *   $Id: webcam.prg 48879 2019-11-17 18:04:01Z leonardo $
 */

#include "hwgui.ch"
#include 'hbclass.ch'

#IfDef __XHARBOUR__

#DEFINE WEBCAM_TITLE_ERROR "Error Webcam"

  Class HWebcam

      /* Handle of WebCam Conection*/
      DATA hWebcam
		/* Information about webcam*/
      DATA cName
      DATA cVersion

      DATA oWnd    AS OBJECT
      /* Coor of WebCam */
      DATA nTop    AS NUMERIC
      DATA nLeft   AS NUMERIC
      DATA nWidth  AS NUMERIC
      DATA nHeight AS NUMERIC
      /* When .t. adjust automatic to size (640x480)*/
      DATA isScale AS LOGICAL INIT .T.
      
      /* When is Started Preview */
      DATA isConnected AS LOGICAL INIT .F.
      
      /* Send error to codeblock */
      DATA bError
      /* Start method */
      Method New(oWnd,nTop,nLeft,nWidth,nHeight) Constructor
      /* Initialize Preview of WebCam*/
      Method Initialize()
      /* Finalize Preview of WebCam*/
      Method Finalize()		
      /* Save Picture */
      Method SaveFile(cFileName)
      Method SaveFileAs(cFileName) INLINE ::SaveFile(cFileName)
      /* Control of Image */
      Method VideoControl()		
      /* Video Format */
      Method VideoFormat()
      /* Intern method to get cName, and cVersion webcam */
      Method GetInfo()
      /* Finalize */
      Method End()		
      Method Destroy() INLINE ::End()
      /* Show about error cInfo */
      Method Error(cInfo)
		
  EndClass

//----------------------------------------------------------------------------//
  Method New(oWnd,nTop,nLeft,nWidth,nHeight,lInitialize) Class HWebcam
  
       DEFAULT nTop:=0, nLeft:=0, nWidth:=0, nHeight:=0
       DEFAULT lInitialize:=.f.

       ::oWnd   :=oWnd
       ::nTop   :=nTop
       ::nLeft  :=nLeft
       ::nWidth :=nWidth
       ::nHeight:=nHeight
       
       ::bError:={|cError|ShowMsg(cError,WEBCAM_TITLE_ERROR)}
       
       IF ( ::nWidth==0 .or. ::nHeight==0 )
            ::isScale := .F.
       ENDIF

       ::hWebCam := capCreateCaptureWindowA("WebCam", nOR(WS_CHILD,WS_VISIBLE), ::nTop, ::nLeft, ::nWidth, ::nHeight, ::oWnd:Handle, 1)
       
       If ::hWebCam <> 0
          //ShowMsg( str( ::hWebCam ) )
       EndIf   

       IF (::hWebCam==0)
           ::Error("Erro ao iniciar webcam, provavelmente o pc não tem webcam ou não está instalada !")
       ELSE
           ::GetInfo()
       ENDIF

       IF lInitialize
          ::Initialize()
       ENDIF

  Return SELF
//----------------------------------------------------------------------------//
  Method Initialize() Class HWebcam
  local nI, nHANDLE_OLD
  nHANDLE_OLD := getactivewindow() // salva o handle da janela atual

  FOR nI := 1 TO 10 // GAMBIA PARA TENTAR POR 3 VEZ ANTES DE DAR O ERRO.(LEONARDO MACHADO)
     IF (WebCam_DriverConnect( ::hWebCam ))
         HWG_BRINGWINDOWTOTOP(nHANDLE_OLD) // restaura o handle da janela anterior
         WebCam_PreviewScale( ::hWebCam, ::isScale )
         WebCam_PreviewRate( ::hWebCam, .t. )
         WebCam_Preview( ::hWebCam, .t. )
         ::isConnected:=.t.
         EXIT
     ELSE
         HWG_BRINGWINDOWTOTOP(nHANDLE_OLD) // restaura o handle da janela anterior
         IF nI >= 10
            ::Error("Erro ao tentar iniciar a webcam !")
         ENDIF
     ENDIF
  NEXT
  Return(.T.)
//----------------------------------------------------------------------------//
  Method Finalize() Class HWebcam
   IF(WebCam_DriverDisconnect( ::hWebCam ))
      ::isConnected:=.f.
   ELSE       
      ::Error("Erro ao tentar Pausar webcam !")
   ENDIF
  Return(.T.)
//----------------------------------------------------------------------------//
  Method End() Class HWebcam
   IF (::hWebCam<>0)
         DestroyWindow( ::hWebCam )
   ENDIF    
  Return SELF := Nil
//----------------------------------------------------------------------------//
  Method SaveFile(cFileName) Class HWebcam
  DEFAULT cFileName := "WebCam_D"+DTOS(date())+"T"+StrTran(time(),":")+".bmp"
   IF (LOWER(Right(cFileName,4))<>".bmp")
       cFileName += ".bmp"
   ENDIF
   IF (!WebCam_FileSaveDib(::hWebCam,cFileName))
       IF FILE(cFileName)
        FErase(cFileName)
       ENDIF  
       ::Error("Erro ao tentar salvar o arquivo "+cFileName+" !")
   ENDIF   
  Return(.T.)
//----------------------------------------------------------------------------//
  Method VideoControl() Class HWebcam
   IF (!WebCam_DlgVideoSource(::hWebCam))
       ::Error("Erro ao tentar abrir o controle de video !")
   ENDIF
  Return(.T.)
//----------------------------------------------------------------------------//
  Method VideoFormat() Class HWebcam
   IF (!WebCam_DlgVideoFormat( ::hWebCam ))
       ::Error("Erro ao tentar abrir tela de formatação de video !")
   ENDIF    
  Return(.T.)
//----------------------------------------------------------------------------//
  Method GetInfo(nDriver) Class HWebcam
   Local cName, cVersion:= space(255)
   Local nName, nVersion:= 255
   DEFAULT nDriver := 0
   IF (WebCam_GetDriverDescription( nDriver, @cName, @nName, @cVersion, @nVersion ))
       ::cName    := cName
       ::cVersion := cVersion
   ELSE
       ::Error("Erro ao verificar informações da webcam !")    
   ENDIF

  Return(.T.)
//----------------------------------------------------------------------------//
  Method Error(cInfo) Class HWebcam
   IF (::bError<>Nil)
          Eval(::bError,cInfo)
   ENDIF
  Return(.T.)
//----------------------------------------------------------------------------//
  #PRAGMA BEGINDUMP
  
  #include "hbapi.h"
  #ifdef __XHARBOUR__
     #include "d:\devel\hwgui\include\hwingui.h"
  #else
     #include "d:\devel\harbour\contrib\hwgui\include\hwingui.h"
  #endif

  #include "windows.h"
  #include "vfw.h"
  
	HB_FUNC( WEBCAM_CAPTUREWINDOW ){
	   hb_retnl( (long) capCreateCaptureWindowA( (LPCSTR) "", (DWORD) 1342177280,hb_parni(1), hb_parni(2), hb_parni(3), hb_parni(4), (HWND) HB_PARHANDLE( 5 ), (DWORD) 1 ) );
	}

	HB_FUNC( WEBCAM_DRIVERCONNECT ){
	   hb_retl( capDriverConnect( (HWND) HB_PARHANDLE(1), hb_parni(2) ) );
	}

	HB_FUNC( WEBCAM_PREVIEW ){
	   hb_retl( capPreview( (HWND) HB_PARHANDLE(1), hb_parl(2) ) );
	}

	HB_FUNC( WEBCAM_PREVIEWRATE ){
	 hb_retl( capPreviewRate( (HWND) HB_PARHANDLE(1), (WORD) hb_parnl(2) ) );
	}

	HB_FUNC( WEBCAM_PREVIEWSCALE ){
	 hb_retl( capPreviewScale( (HWND) HB_PARHANDLE(1), hb_parl(2) ) );
	}

	HB_FUNC( WEBCAM_DRIVERDISCONNECT ){
	 hb_retl( capDriverDisconnect( (HWND) HB_PARHANDLE(1) ) );
	}

	HB_FUNC( WEBCAM_FILESAVEDIB ){
	 hb_retl( capFileSaveDIB( (HWND) HB_PARHANDLE(1), hb_parc(2) ) );
	}
	
	HB_FUNC( WEBCAM_DLGVIDEOSOURCE ){
	 hb_retl( capDlgVideoSource( (HWND) HB_PARHANDLE(1) ) );
	}
	
	HB_FUNC( WEBCAM_DLGVIDEOFORMAT ){
	 hb_retl( capDlgVideoFormat( (HWND) HB_PARHANDLE(1) ) );
	}

	HB_FUNC( WEBCAM_GETDRIVERDESCRIPTION ){
	
	   TCHAR cName [255];
	   int nName = 255;
	
	   TCHAR cVersion[255];
	   int nVersion=255;
	
	   BOOL bReturn;
	   
	   bReturn = capGetDriverDescriptionA( (WORD) hb_parnl(1), cName, nName, cVersion, nVersion );
	   
	   hb_storc( cName, 2 );
	   hb_storni( nName, 3 );
	   hb_storc( cVersion, 4 );
	   hb_storni( nVersion, 5 );
	
	   hb_retl(bReturn);
	   
	}
	
	HB_FUNC( NOR ){
   LONG lRet = 0;
   WORD i = 0;
   while( i < 2 ){
      lRet |= ( LONG ) hb_parnl( ++i );
   }
   hb_retnl( lRet );
  }
  #PRAGMA ENDDUMP
//----------------------------------------------------------------------------//
  #include "hbdll.ch"
//----------------------------------------------------------------------------//  
  DECLARE INTEGER capCreateCaptureWindowA IN avicap32;
    STRING lpszWindowName,;
    INTEGER dwStyle,;
    INTEGER x,;
    INTEGER y,;
    INTEGER nWidth,;
    INTEGER nHeight,;
    INTEGER hParent,;
    INTEGER nID
#ENDIF
