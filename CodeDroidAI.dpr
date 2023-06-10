program CodeDroidAI;

uses
  System.StartUpCopy,
  FMX.Forms,
  Skia.FMX,
  uMainForm in 'uMainForm.pas' {MainForm},
  uItemFrame in 'uItemFrame.pas' {FrameItem: TFrame};

{$R *.res}

begin
  GlobalUseSkia := True;
  Application.Initialize;
  Application.CreateForm(TMainForm, MainForm);
  Application.Run;
end.
