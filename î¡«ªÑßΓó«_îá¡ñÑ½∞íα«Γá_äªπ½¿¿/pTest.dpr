program pTest;

uses
  Forms,
  uTest in 'uTest.pas' {Form1};

{$R *.res}

begin
  Application.Initialize;
  Application.Title := 'Множество Мандельброта => Множества Джулии';
  Application.CreateForm(TForm1, Form1);
  Application.Run;
end.
