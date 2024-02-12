#include "FiveWin.ch"
#include "Struct.ch"

#define WM_CAP_START             WM_USER
#define WM_CAP_DRIVER_CONNECT    WM_CAP_START + 10
#define WM_CAP_DRIVER_DISCONNECT WM_CAP_START + 11
#define WM_CAP_SET_PREVIEW       WM_CAP_START + 50
#define WM_CAP_SET_PREVIEWRATE   WM_CAP_START + 52
#define WM_CAP_SET_SCALE         WM_CAP_START + 53

#define WM_CAP_EDIT_COPY         WM_CAP_START + 30
#define WM_CAP_FILE_SAVEDIB      WM_CAP_START + 25

#define WM_CAP_DLG_VIDEOFORMAT   WM_CAP_START + 41
#define WM_CAP_DLG_VIDEOSOURCE   WM_CAP_START + 42
#define WM_CAP_GET_STATUS        WM_CAP_START + 54

#define WM_CAP_FILE_SAVEAS          WM_CAP_START + 23

#define WM_CAP_GET_VIDEOFORMAT  WM_CAP_START + 44
#define WM_CAP_SET_VIDEOFORMAT  WM_CAP_START + 45

#define HWND_BOTTOM   1
#define SWP_NOMOVE    2
#define SWP_NOSIZE    1
#define SWP_NOZORDER  4

// RESOLUTIONS
#define RES_QQCGA           {160,120}
#define RES_QCIF            {192,144}
#define RES_HQVGA           {240,160}
#define RES_QVGA            {320,240}
#define RES_VCD_NTSC        {352,240}
#define RES_VCD_PAL     {352,288}
#define RES_XCIF            {384,288}
#define RES_360P            {480,360}
#define RES_NHD         {640,360}
#define RES_VGA         {640,480}
#define RES_SD          {704,480}
#define RES_DVD_NTSC        {720,480}
#define RES_WGA         {800,480}
#define RES_SVGA            {800,600}
#define RES_DVCPRO_HD   {960,721}
#define RES_XGA         {1024,768}
#define RES_HD              {1280,720}
#define RES_WXGA            {1280,800}
#define RES_SXGA            {1280,960}
#define RES_SXGAB           {1280,1024}
#define RES_WXGAE           {1366,768}
#define RES_UXGA            {1600,1200}
#define RES_FHD         {1920,1080}
#define RES_QXGA            {2048,1536}
#define RES_QSXGA           {2560,2048}
#define RES_QUXGA           {3200,2400}
#define RES_DCI_4K      {4096,2160}
#define RES_HXGA            {4096,3072}
#define RES_UW5K            {5120,2160}
#define RES_5K              {5120,2880}
#define RES_WHXGA           {5120,3200}

// INTENSITY
#define INTENSITY_YUY2  16

//STATIC oWebcam

FUNCTION MAIN()

    WEB_CAM_FOTO()

RETURN NIL
//---------------------------------------------------------------------------//
FUNCTION WEB_CAM_FOTO()
    LOCAL lc_oDlgWebCam , oImg, lc_oWebCam, lClick := .f., oBtn, cFile, oFont
    Local lc_cTitulo := "", lc_cSubTitulo := ""
    Local lc_oXImg_Foto
    Local lc_oBtn651_Confirmar, lc_oBtn659_Cancelar
    Local lc_oBtn652_Capturar, lc_oBtn655_Opcoes, lc_oBtn656_Formato
    Local lc_cFileFotoJpg := "WebCam.jpg"
    Local lc_aRetProc := {.F.,""} // se confirma a foto, file jpg da foto capturada

    //lc_cFileFotoJpg
    FErase(lc_cFileFotoJpg)

    lc_oWebCam           :=  tWebCamPhoto():New()

    If Len(lc_oWebCam:aDrivers) == 0
        MsgStop("Não há dispositivos de cameras instalados neste computador.",;
                    "Procedimento abortado.")
        Return lc_aRetProc
    EndIf

    Define Font oFont Name "Calibri" Size 0,-13

    DEFINE DIALOG lc_oDlgWebCam  SIZE 1200, 700 TITLE "Capturar Fotografia por WebCam"

        @ 25,350 XIMAGE lc_oXImg_Foto ;
            SIZE 200,160 ;
            OF lc_oDlgWebCam ;
            FILENAME lc_cFileFotoJpg
            lc_oXImg_Foto:lBmpTransparent := .F.

        @ 280,  25 BUTTON oBtn PROMPT "Capturar" OF lc_oDlgWebCam  SIZE 85, 22 PIXEL UPDATE FONT oFont ;
            ACTION ( lc_oWebCam:Clipboard( lc_oXImg_Foto, lc_cFileFotoJpg ), lClick := .t., lc_oDlgWebCam:Update())

        //@ 280, 120 BUTTON oBtn PROMPT "Traspasa" OF lc_oDlgWebCam  SIZE 85, 22 PIXEL UPDATE FONT oFont ;
        //  ACTION ( LeerClipBoard( oImg ), lc_oWebCam:End(), lc_oDlgWebCam:End() ) WHEN lClick

        @ 280, 215 BUTTON oBtn PROMPT "Salir"    OF lc_oDlgWebCam  SIZE 85, 22 PIXEL UPDATE FONT oFont ACTION ( lc_oWebCam:End()    , lc_oDlgWebCam:End())
        @ 200, 360 BUTTON oBtn PROMPT "Opciones" OF lc_oDlgWebCam  SIZE 85, 22 PIXEL UPDATE FONT oFont ACTION lc_oWebCam:Source()
        @ 200, 460 BUTTON oBtn PROMPT "Formato"  OF lc_oDlgWebCam  SIZE 85, 22 PIXEL UPDATE FONT oFont ACTION lc_oWebCam:Formato()


        lc_oDlgWebCam:bInit := <||
            lc_oWebCam:CreateWnd( lc_oDlgWebCam  , 25, 6, 563, 390 )
            lc_oWebCam:Connect(RES_HD)
            Return Nil
        >//cEnd

    ACTIVATE DIALOG lc_oDlgWebCam CENTERED

RETURN lc_aRetProc

//---------------------------------------------------------------------------//

FUNCTION LeerClipBoard( oImg )

    oImg:LoadFromClipboard()
    oImg:Refresh()

RETURN Nil

//---------------------------------------------------------------------------//
/*
EXIT Procedure WebcamDisconnect()

    if oWebcam  <>  nil
         oWebcam:Disconnect()
         oWebcam:=nil
    endif

return
*/
//---------------------------------------------------------------------------//

CLASS tWebCamPhoto

    DATA nFrameRate                    INIT 60 //66      // Velocidad de actualización de la WebCam
    DATA nJpgQuality                   INIT 75      // Calidad de los JPG

    DATA hWnd                                       // Handle de la centana de la imagen
    DATA aDrivers                                   // Drivers de captura disponibles
    DATA nDriver                                    // número del driver instalado + 1
    DATA lConnected                    INIT .F.     // ¿Está conectada>
    DATA cWebCamDriver                 INIT "Microsoft WDM Image Capture (Win32)"

    METHOD New( cDriver, lSelect )     CONSTRUCTOR  // Construye el objeto. cDriver es el nombre del driver a usar, recomendado guardar en ini. Si lSelect=.T. muestra la lista para escogerlo

    METHOD CreateWnd( oWnd1, nLeft, nTop, nWidth, nHeight, nStyle, cTitle )
                                                                                                    // Crea la ventana para la cámara en oWnd1.

    METHOD Connect(f_nOpcResolution)                // Conecta la cámara (f_nOpcResolution = RES_VGA(default))
    METHOD Disconnect                               // Desconecta la cámara
    METHOD Clipboard( oImg, cFile )                 // Captura la imagen en clipboard actualiza a oImg con la imagen capturada y guarda un archivo bmp
    METHOD Source()                                 // Configura la fuente de la webcam
    METHOD Formato()                                // Configura el formato de la imagen
    Method SetResolution(f_aTpResolution)               // Parameriza
    METHOD GetStatus()                              // Status de la imagen
    METHOD Resize()                                 // Redimensiona la ventana de la imagen
    METHOD End() INLINE ::Disconnect()              // Finaliza el objeto

ENDCLASS

//---------------------------------------------------------------------------//

METHOD New( cDriver, lSelect ) CLASS tWebCamPhoto

    DEFAULT cDriver :=   ::cWebCamDriver
    DEFAULT lSelect :=   .f.

    LoadLibrary("avicap32.dll")

    ::aDrivers      :=   WebCamList()
    ::nDriver       :=   aScan(::aDrivers,{|u| Upper(StrTran(cDriver,' '))==Upper(StrTran(u,' '))})

    IF ::nDriver    ==   0 .or. lSelect
         ::nDriver    :=   WebCamSelect( ::nDriver, ::aDrivers )
    ENDIF

    //oWebcam       :=   Self

return Self

//---------------------------------------------------------------------------//

METHOD CreateWnd( oWnd1, nTop, nLeft, nWidth, nHeight, nStyle, cTitle ) CLASS tWebCamPhoto

    DEFAULT nTop    :=   0, ;
                nLeft   :=   0, ;
                nWidth  := 160, ;
                nHeight := 120
    DEFAULT nStyle  := nOr( WS_VISIBLE, WS_CHILD, WS_BORDER )

    IF ::nDriver  > 0
        ::hWnd    := wCamCreaWnd( ::aDrivers[ ::nDriver ], nStyle, nLeft, nTop, nWidth, nHeight, oWnd1:hWnd, 0 )
    ENDIF

return  ::hWnd

//---------------------------------------------------------------------------//

METHOD Connect(f_nOpcResolution) CLASS tWebCamPhoto

    Default f_nOpcResolution := RES_VGA

     if   ::hWnd    <>  nil
                if SendMessage( ::hWnd, WM_CAP_DRIVER_CONNECT, ::nDriver-1, 0) == 1

                    ::cWebCamDriver :=  ::aDrivers[ ::nDriver ]
                    SendMessage(::hWnd, WM_CAP_SET_SCALE, 2, 0)
                    ::SetResolution(f_nOpcResolution)
                    SendMessage(::hWnd, WM_CAP_SET_PREVIEWRATE, ::nFrameRate, 0)
                    SendMessage(::hWnd, WM_CAP_SET_PREVIEW, 1, 0)

                     ::lConnected    :=  .T.
                     //::Resize()

                else

                     ::lConnected    :=  .F.
                     ::hWnd          :=  Nil

                endif
     endif
return ::lConnected

//---------------------------------------------------------------------------//
METHOD Disconnect CLASS tWebCamPhoto

     IF  ::hWnd     <>  Nil .and. ::lConnected
             if SendMessage( ::hWnd, WM_CAP_DRIVER_DISCONNECT, 0, 0) = 1

                    ::lConnected     :=  .F.
                    //oWebcam        :=  nil
             endif
     ENDIF
return nil
//---------------------------------------------------------------------------//
METHOD Clipboard( oImg, cFile ) CLASS tWebCamPhoto
    Local lSucc     := .F.
    Local lc_cBmpTmp := "WebCamTmp.bmp"

    fErase(lc_cBmpTmp)

    if   ::hWnd <> nil
            lSucc       :=  (  SendMessage( ::hWnd, WM_CAP_EDIT_COPY, 0, 0) = 1 )
            IF lSucc .and. oImg <> nil
                SendMessage( ::hWnd, WM_CAP_FILE_SAVEDIB, 0, lc_cBmpTmp )
                FW_SaveImage(lc_cBmpTmp,cFile,::nJpgQuality)
                oImg:Refresh(.T.)
            ENDIF

    endif
return lSucc
//---------------------------------------------------------------------------//
METHOD Source() CLASS tWebCamPhoto

    if  ::hWnd<>nil .and. ::lConnected
                SendMessage( ::hWnd, WM_CAP_DLG_VIDEOSOURCE, 0, 0 )
    endif

return nil
//---------------------------------------------------------------------------//
METHOD Formato() CLASS tWebCamPhoto

    if  ::hWnd<>nil .and. ::lConnected
                SendMessage( ::hWnd, WM_CAP_DLG_VIDEOFORMAT, 0, 0 )
                ::Resize()
        //SendMessage( ::hWnd, WM_CAP_DLG_VIDEOFORMAT, 0, 0 )
    endif

return nil
//---------------------------------------------------------------------------//
Method SetResolution(f_aTpResolution) Class tWebCamPhoto
    Local lc_oBitMapInfo, lc_cBuffer
    Local lc_nWidth := 1280, lc_nHeight := 720
    Local lc_lRetSetUpOk := .F.

    If !Hb_isNil(f_aTpResolution)
        lc_nWidth       := f_aTpResolution[1]
        lc_nHeight      := f_aTpResolution[2]
    EndIf

    STRUCT lc_oBitMapInfo
        MEMBER biSize                   AS DWORD
        MEMBER biWidth                  AS LONG  
        MEMBER biHeight             AS LONG  
        MEMBER biPlanes             AS WORD  
        MEMBER biBitCount               AS WORD  
        MEMBER biCompression            AS DWORD
        MEMBER biSizeImage          AS DWORD
        MEMBER biXPelsPerMeter      AS LONG  
        MEMBER biYPelsPerMeter      AS LONG  
        MEMBER biClrUsed                AS DWORD
        MEMBER biClrImportant       AS DWORD
    ENDSTRUCT

    if  ::hWnd<>nil //.and. ::lConnected
        lc_cBuffer  :=  lc_oBitMapInfo:cBuffer
        SendMessage( ::hWnd, WM_CAP_GET_VIDEOFORMAT, Len(lc_cBuffer), @lc_cBuffer)
        lc_oBitMapInfo:biWidth              := lc_nWidth
        lc_oBitMapInfo:biHeight             := lc_nHeight
        lc_oBitMapInfo:biBitCount           := INTENSITY_YUY2
        lc_oBitMapInfo:biCompression        := 844715353 //1196444237
        lc_oBitMapInfo:biSizeImage          := (lc_nWidth*lc_nHeight)*2
       
        lc_cBuffer  :=  lc_oBitMapInfo:cBuffer
       
        lc_lRetSetUpOk := (SendMessage( ::hWnd, WM_CAP_SET_VIDEOFORMAT, Len(lc_cBuffer), @lc_cBuffer) == 1)
        SendMessage(::hWnd, WM_CAP_SET_PREVIEW, 1, 0)
    endif

Return lc_lRetSetUpOk

//---------------------------------------------------------------------------//

METHOD GetStatus()
    Local oPoint, oStatus, cBuffer

    STRUCT oPoint
        MEMBER X AS LONG
        MEMBER Y AS LONG
    ENDSTRUCT

    STRUCT oStatus
        MEMBER nWidth         AS LONG                   // Width of the image
        MEMBER nHeight        AS LONG                   // Height of the image
        MEMBER lLive          AS LONG                   // Now Previewing video?
        MEMBER lOverlay       AS LONG                   // Now Overlaying video?
        MEMBER lScale         AS LONG                   // Scale image to client?
        MEMBER oXYScroll      AS STRING LEN 8           // AS POINTAPI     // Scroll position
        MEMBER lDefPalette    AS LONG                   // Using default driver palette?
        MEMBER lAudHardware   AS LONG                   // Audio hardware present?
        MEMBER lCapFile       AS LONG                   // Does capture file exist?
        MEMBER nCurVidFrm     AS LONG                   // # of video frames cap'td
        MEMBER nCurVidDropped AS LONG                   // # of video frames dropped
        MEMBER nCurWavSamples AS LONG                   // # of wave samples cap'td
        MEMBER nCurTimeEl     AS LONG                   // Elapsed capture duration
        MEMBER hPalCur        AS LONG                   // Current palette in use
        MEMBER lCapturing     AS LONG                   // Capture in progress?
        MEMBER nReturn        AS LONG                   // Error value after any operation
        MEMBER nVidAlloc      AS LONG                   // Actual number of video buffers
        MEMBER wAudAlloc      AS LONG                   // Actual number of audio buffers
    ENDSTRUCT

    oPoint:x           :=  0
    OPoint:y           :=  0
    oStatus:oXYScroll  :=  oPoint:cBuffer

    cBuffer            :=  oStatus:cBuffer

    SendMessage( ::hWnd, WM_CAP_GET_STATUS, Len(cBuffer), @cBuffer)

    oStatus:cBuffer    := cBuffer
return oStatus

//---------------------------------------------------------------------------//

METHOD Resize() CLASS tWebCamPhoto
    Local oStatus

    if ::hWnd<>nil .and. ::lConnected
        SysRefresh()
        oStatus   := ::GetStatus()
        //SetWindowPos(::hWnd,HWND_BOTTOM,0,0,oStatus:nWidth,oStatus:nHeight,;
        //                       nOr(SWP_NOMOVE,SWP_NOZORDER ) )
        SysRefresh()
    endif

return nil
//---------------------------------------------------------------------------//
Function WebcamList()
     Local aDrivers    := {}, ;
                 nDriver     := 0 , ;
                 cName            , ;
                 cVersion         , ;
                 nLen        := 255

     DO WHILE .T.
            cName     :=  space(nLen)
            cVersion  :=  space(nLen)
            IF !wCamGetDrvDesc(nDriver, @cName, nLen, @cVersion, nLen)
                 EXIT
            ENDIF
            if chr(0)$cName
                 cName       :=  Left(cName,At(chr(0),cName)-1)
            endif
            if chr(0)$cVersion
                 cVersion    :=  Left(cVersion,At(chr(0),cVersion)-1)
            endif
            aAdd( aDrivers ,  cName)
            nDriver++
     ENDDO

return aDrivers
//---------------------------------------------------------------------------//
STATIC Function WebcamSelect( nDriver, aDrivers )
    Local oDlg, oCbx
    Local cDriver
    Local lSelect    := .F.

    DEFAULT nDriver  := 0 , aDrivers  :=  WebcamList()
    IF Empty(aDrivers)
        MsgAlert('Não há dispositivos WebCams')
        return 0
    ELSE
        cDriver  :=  aDrivers[Max(1,nDriver)]
        DEFINE DIALOG oDlg FROM 0,0 to 6,40 TITLE "Select webcam"
                @ 0,0 COMBOBOX oCbx VAR cDriver OF oDlg ITEMS aDrivers;
                    SIZE 160,50 PIXEL
                @ 1.5, 4 BUTTON "Select" OF oDlg SIZE 40,12;
                     ACTION (nDriver:=oCbx:nAt ,oDlg:End())
                @ 1.5,16 BUTTON "Cancel" OF oDlg SIZE 40,12;
                     ACTION oDlg:End()
        ACTIVATE DIALOG oDlg CENTERED
    ENDIF

return nDriver
//---------------------------------------------------------------------------//
Function WebCamVersion(nDriver)
    Local cName, cVersion, nLen:=255
    DEFAULT nDriver:=0
    IF nDriver>0
        cName:=space(nLen); cVersion:=space(nLen)
        IF wCamGetDrvDesc(nDriver-1, @cName, nLen, @cVersion, nLen)
            if chr(0)$cVersion
                cVersion:=Left(cVersion,At(chr(0),cVersion)-1)
            endif
        ELSE
            cVersion:=nil
        ENDIF
    ENDIF
return cVersion

//---------------------------------------------------------------------------//

DLL32 STATIC FUNCTION wCamGetDrvDesc( nDriver AS _INT, cName AS STRING, nName AS LONG, cVersion AS STRING, nVersion AS LONG) AS BOOL PASCAL FROM "capGetDriverDescriptionA" LIB "avicap32.dll"

//---------------------------------------------------------------------------//

DLL32 STATIC FUNCTION wCamCreaWnd   ( cTitle AS STRING, nStyle AS LONG, x AS LONG, y AS LONG, nWidth AS LONG, nHeight AS LONG, hWndParent AS LONG, nID AS LONG) AS LONG PASCAL FROM "capCreateCaptureWindowA" LIB "avicap32.dll"

//---------------------------------------------------------------------------//
/*
// esse codigo abaixo serve para poder linkar LIB de PCODE diferente da versão do xHarbour que usamos.
#pragma BEGINDUMP

void hb_errInternal( ULONG ulIntCode, const char * szText, const char * szPar1, const char * szPar2 )
{
}

#pragma ENDDUMP
*/