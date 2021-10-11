unit uTest;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms,
  Dialogs, OpenGL;

type
  TForm1 = class(TForm)
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure FormPaint(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure FormMouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
  private
    dc : HDC;
    glrc : HGLRC;
    Creal, Cimag : GLfloat;
    julia : Boolean;
    { Private declarations }
  public
    { Public declarations }
  end;
  
var
  Form1: TForm1;

implementation

{$R *.dfm}

procedure TForm1.FormCreate(Sender: TObject);
var
  pfd : TPixelFormatDescriptor;
  pf : Integer;
begin
  dc := GetDC(Handle);
  FillChar(pfd, SizeOf(pfd), 0);
  pfd.nSize := SizeOf(pfd);
  pfd.nVersion := 1;
  pfd.dwFlags := PFD_DOUBLEBUFFER or PFD_DRAW_TO_WINDOW or PFD_SUPPORT_OPENGL;
  pfd.iPixelType := PFD_TYPE_RGBA;
  pfd.cColorBits := 24;
  pfd.iLayerType := PFD_MAIN_PLANE;
  pf := ChoosePixelFormat(dc, @pfd);
  if pf <> 0 then SetPixelFormat(dc, pf, @pfd);
  glrc := wglCreateContext(dc);
  wglMakeCurrent(dc, glrc);
  glViewport(0, 0, 640, 640);
  glMatrixMode(GL_PROJECTION);
  glLoadIdentity;
  glOrtho(-2.0, 2.0, -2.0, 2.0, -1.0, 1.0);
  glMatrixMode(GL_MODELVIEW);
  glLoadIdentity;
end;

procedure TForm1.FormDestroy(Sender: TObject);
begin
  wglMakeCurrent(0, 0);
  wglDeleteContext(glrc);
  ReleaseDC(Handle, dc);
end;

procedure TForm1.FormPaint(Sender: TObject);
var
  x, y : Integer;
  a, b, cx, cy, temp : Real;
  iter : Integer;
  r2 : Real;
begin
  glClear(GL_COLOR_BUFFER_BIT or GL_DEPTH_BUFFER_BIT);
  Form1.Caption := 'Множество Мандельброта => Множества Джулии [состояние : визуализация]';
  glBegin(GL_POINTS);
  for x := -320 to 320 do begin
    for y := -320 to 320 do begin
      iter := 0;
      if not(julia) then begin
        cx := x / 160;
        cy := y / 160;
      end
      else begin
        cx := Creal;
        cy := Cimag;
      end;
      a := x / 160;
      b := y / 160;
      r2 := 0.0;
      while (iter < 255) and (r2 < 4.0) do begin
        iter := iter + 1;
        temp := a;
        a := (temp * temp) - (b * b) + cx;
        b := 2 * temp * b + cy;
        r2 := (a * a) + (b * b);
      end;
      glColor3f(iter / 255, iter / 255, iter / 255);
      glVertex3f(x / 160, y / 160, 0.0);
    end;
  end;
  glEnd;
  glFlush;
  SwapBuffers(dc);
  Form1.Caption := 'Множество Мандельброта => Множества Джулии [состояние : готово]';
end;

procedure TForm1.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
var
  b : TBitmap;
begin
  case Key of
    27 :
    begin
      Close;
    end;
    VK_SPACE :
    begin
      b := TBitmap.Create;
      b.Width := Form1.ClientWidth;
      b.Height := Form1.ClientHeight;
      b.Canvas.CopyRect(ClientRect, Form1.Canvas, ClientRect);
      b.SaveToFile('screenshot.bmp');
      b.Free;
    end;
  end;
end;

procedure TForm1.FormMouseUp(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  if (Button = mbLeft) then begin
    julia := True;
    Creal := (X - 320) / 160;
    Cimag := (320 - Y) / 160;
    Invalidate;
  end
  else begin
    julia := False;
    Invalidate;
  end;
end;

end.
