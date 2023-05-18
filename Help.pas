// -----------------------------------------------------------------------------
//
//  MSHV Configuration Swapper         by Jim K6OK
//  Help -- Code for the Help window
// -----------------------------------------------------------------------------


unit Help;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
  System.Classes, Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs,
  Vcl.StdCtrls, Vcl.ComCtrls;

type
  TfmHelp = class(TForm)
    btnHelpClose: TButton;
    RichEdit1: TRichEdit;
    procedure btnHelpCloseClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  fmHelp: TfmHelp;

implementation

{$R *.dfm}



procedure TfmHelp.btnHelpCloseClick(Sender: TObject);
begin
  fmHelp.Visible := False;
end;

end.
