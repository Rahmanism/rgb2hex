program rgb2hex;

uses
  Forms,
  untMain in 'untMain.pas' {MainForm},
  ABOUT in 'ABOUT.pas' {AboutBox};

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.Title := 'RGB to Hex and Vice Versa';
  Application.CreateForm(TMainForm, MainForm);
  Application.Run;
end.
