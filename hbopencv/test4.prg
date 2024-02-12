#include "opencv.ch"
#include "inkey.ch"

REQUEST hb_gt_win_default

PROCEDURE Main()

   CLS

   capture := cvCreateCameraCapture( 0 )

   IF empty( capture )
      QUIT
   ENDIF

   frame := NIL

   width       := cvGetCaptureProperty( capture, CV_CAP_PROP_FRAME_WIDTH )
   height      := cvGetCaptureProperty( capture, CV_CAP_PROP_FRAME_HEIGHT )
   fps         := cvGetCaptureProperty( capture, CV_CAP_PROP_FPS )
   frame_count := cvGetCaptureProperty( capture, CV_CAP_PROP_FRAME_COUNT )

   ? "Camera Size = " + alltrim( str( width ) ) + " x " + alltrim( str( height ) )
   ? "FPS = " + alltrim( str( fps ) )
   ? "Total Frames = " + alltrim( str( frame_count ) )

   cvNamedWindow( "camera" )

   cvMoveWindow( "camera", 1024 - width, 0 )

   DO WHILE .T.

      frame := cvQueryFrame( capture )

      IF empty( frame )
         EXIT
      ENDIF

      cvShowImage( "camera", frame )

      tecla := cvWaitKey( 10 )

      IF tecla == K_ESC
         EXIT
      ENDIF

      IF tecla == asc("g") .OR. tecla == asc("G")
         cvSaveImage( "teste4.jpg", frame )
      ENDIF

   ENDDO

   cvReleaseCapture( capture )
   cvReleaseImage( frame )
   cvDestroyWindow( "camera" )

RETURN
