unit uItemFrame;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants, 
  FMX.Types, FMX.Graphics, FMX.Controls, FMX.Forms, FMX.Dialogs, FMX.StdCtrls,
  FMX.Objects, FMX.Controls.Presentation;

type
  TFrameItem = class(TFrame)
    Panel1: TPanel;
    TitleLabel: TLabel;
    Line1: TLine;
    DescriptionLabel: TLabel;
    EmojiLabel: TLabel;
    procedure Panel1Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

implementation

{$R *.fmx}

uses
  uMainForm;

procedure TFrameItem.Panel1Click(Sender: TObject);
begin
  MainForm.LoadTemplate(Self.Tag);
end;

end.
