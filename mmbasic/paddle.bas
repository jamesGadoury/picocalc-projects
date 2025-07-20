OPTION EXPLICIT
OPTION DEFAULT NONE

CONST ScreenW=320
CONST ScreenH=320
CONST FontW=8
CONST FontH=12
CONST PaddleW=ScreenW/8
CONST PaddleH=3
CONST PaddleSpeed=400
CONST BallR=3
CONST BoundaryL=0
CONST BoundaryR=ScreenW
CONST KeyLeft=130
CONST KeyRight=131
CONST ColorW=RGB(255,255,255)
CONST ColorB=RGB(0,0,0)
CONST ColorBG=ColorB
CONST ColorDF=ColorW
CONST CeilingH=ScreenH/4
CONST FPS=30
CONST FrameDur=1.0/FPS

DIM FLOAT paddleX,paddleY
DIM FLOAT ballX,ballY,ballVX,ballVY
DIM FLOAT paddleVX
DIM INTEGER score
DIM FLOAT tLast,tDelta

SUB InitGame()
  paddleX=ScreenW/2-PaddleW/2
  paddleY=ScreenH-PaddleH*3
  ballX=ScreenW/2
  ballY=CeilingH+BallR
  paddleVX=0
  ballVX=0
  ballVY=30
  tLast=0
  tDelta=0
  score=0
END SUB

SUB DrawPaddle(fill AS INTEGER)
  LOCAL FLOAT x2,y2
  x2=paddleX+PaddleW
  y2=paddleY
  Line paddleX,paddleY,x2,y2,PaddleH,fill
END SUB

SUB DrawBall(fill AS INTEGER)
  Circle ballX,ballY,BallR,,,fill,fill
END SUB

FUNCTION Time() AS FLOAT
  Time=Timer/1000.0
END FUNCTION

SUB UpdateTime()
  LOCAL FLOAT nowT
  nowT=Time()
  IF tLast THEN tDelta=nowT-tLast
  tLast=nowT
END SUB

SUB ClearFrame()
  DrawPaddle(ColorBG)
  DrawBall(ColorBG)
END SUB

SUB DrawFrame()
  LOCAL INTEGER tx
  LOCAL STRING fps$
  tx=ScreenW-FontW*9
  Text 0,0,"score:"+Str$(score)
  IF tDelta THEN
    fps$="fps:"+Str$(1.0/tDelta)
    Text tx,0,fps$
  END IF
  DrawPaddle(ColorDF)
  DrawBall(ColorDF)
END SUB

SUB BoundPaddle()
  IF paddleX<BoundaryL THEN
    paddleX=BoundaryL
  ELSEIF paddleX+PaddleW>BoundaryR THEN
    paddleX=BoundaryR-PaddleW
  END IF
END SUB

SUB UpdatePaddle(k$ AS STRING)
  LOCAL INTEGER kc
  paddleVX=0
  IF k$<>"" THEN
    kc=ASC(k$)
    SELECT CASE kc
      CASE KeyLeft:paddleVX=-PaddleSpeed
      CASE KeyRight:paddleVX=PaddleSpeed
    END SELECT
  END IF
  paddleX=paddleX+paddleVX*tDelta
  BoundPaddle
END SUB

FUNCTION WallBounce() AS INTEGER
  IF ballX-BallR<BoundaryL THEN
    WallBounce=-1
  ELSEIF ballX+BallR>BoundaryR THEN
    WallBounce=1
  ELSE
    WallBounce=0
  END IF
END FUNCTION

FUNCTION BallAtCeil() AS INTEGER
  BallAtCeil=(ballY-BallR)<=CeilingH
END FUNCTION

FUNCTION BallAtPaddleY() AS INTEGER
    LOCAL FLOAT bb, bp
    bb=ballY+BallR
    bp=paddleY-PaddleH
    BallAtPaddleY=bb>=bp
END FUNCTION

FUNCTION BallOutsidePaddleX() AS INTEGER
  LOCAL INTEGER missL,missR
  missL=ballX+BallR<paddleX
  missR=ballX-BallR>paddleX+PaddleW
  BallOutsidePaddleX=missL OR missR
END FUNCTION

SUB StartFall()
  IF ballVY<0 THEN ballVY=-ballVY

  ballVX=ballVX*1.05
END SUB

SUB StartRise()
  ballVX=50+Rnd*50*Choice(Rnd<0.6,1,-1)
  IF ballVY>0 THEN ballVY=-ballVY
END SUB

SUB IncreaseFall()
  ballVY=ballVY+10*tDelta
END SUB

SUB UpdateBall()
  ballX=ballX+ballVX*tDelta
  ballY=ballY+ballVY*tDelta
  IF BallAtCeil() THEN
    StartFall
  ELSEIF BallAtPaddleY() THEN
    StartRise
  ELSE
    IncreaseFall
  END IF
  IF WallBounce() THEN ballVX=-ballVX
END SUB

SUB BoundBall()
  LOCAL INTEGER w
  w=WallBounce()
  IF w>0 THEN ballX=BoundaryR-BallR
  IF w<0 THEN ballX=BoundaryL+BallR
  IF BallAtCeil() THEN
    ballY=CeilingH+BallR+1
  ELSEIF BallAtPaddleY() THEN
    ballY=paddleY-BallR-1
  END IF
END SUB

SUB DrawGameOver()
  LOCAL INTEGER tx,ty
  tx=ScreenW/2-(6*FontW)
  ty=ScreenH/2
  Text tx,ty,"game over"
END SUB

SUB Main()
  LOCAL FLOAT pauseTime
  CLS
  Timer=0
  Pause 1
  InitGame()
  LOCAL FLOAT l,r,py
  l=BoundaryL
  r=BoundaryR
  py=CeilingH-PaddleH
  Line l,py,r,py,PaddleH,ColorDF
  DO
    UpdateTime()
    ClearFrame()
    UpdatePaddle(Inkey$)
    IF BallAtPaddleY() THEN
      IF BallOutsidePaddleX() THEN
        DrawGameOver()
        EXIT DO
      ELSE
        score=score+1
      END IF
    END IF
    UpdateBall()
    BoundBall()
    DrawFrame()
    pauseTime=FrameDur-(Time()-tLast)
    IF pauseTime>0 THEN
      Pause pauseTime*1000
    END IF
  LOOP
END SUB

Main()
