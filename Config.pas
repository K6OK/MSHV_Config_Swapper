// -----------------------------------------------------------------------------
//
//  MSHV Configuration Swapper         by Jim K6OK
//  Configuration -- Code for the Configuration window
//  Note: all global variables and most of the work in done
//  by TWorkers class in the workers.pas unit
// -----------------------------------------------------------------------------

unit Config;

interface

uses
  Setup, Workers,
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
  System.Classes, Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls;

type
  TfmConfig = class(TForm)
    Label1: TLabel;
    Label2: TLabel;
    Edit1: TEdit;
    Label3: TLabel;
    btnSave01: TButton;
    btnDelete01: TButton;
    Label4: TLabel;
    Edit2: TEdit;
    Label5: TLabel;
    btnSave02: TButton;
    btnDelete02: TButton;
    Label6: TLabel;
    Label7: TLabel;
    Edit3: TEdit;
    btnSave03: TButton;
    btnDelete03: TButton;
    Edit4: TEdit;
    btnSave04: TButton;
    btnDelete04: TButton;
    Label8: TLabel;
    Label9: TLabel;
    Edit5: TEdit;
    btnSave05: TButton;
    btnDelete05: TButton;
    Edit6: TEdit;
    btnSave06: TButton;
    btnDelete06: TButton;
    Label10: TLabel;
    btnConfigClose: TButton;
    Label11: TLabel;
    Label12: TLabel;
    Label13: TLabel;
    procedure btnConfigCloseClick(Sender: TObject);
    procedure errorSetupNotDone;
    procedure FormShow(Sender: TObject);
    procedure btnSaveClick(Sender: TObject);
    procedure btnDeleteClick(Sender: TObject);

  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  fmConfig: TfmConfig;

implementation

{$R *.dfm}

//-----------------------------------------
//   On Config form show populate descriptions
//-----------------------------------------
procedure TfmConfig.FormShow(Sender: TObject);
var
  indx: integer;
begin
  sleep(100);
  if MCS_ini_Exists then
  begin
    for indx := 0 to 5 do
    begin
      worker.ReadDescriptionsFromIniFile;
      case indx of
        0: Edit1.Text := MemoryDescr[indx];
        1: Edit2.Text := MemoryDescr[indx];
        2: Edit3.Text := MemoryDescr[indx];
        3: Edit4.Text := MemoryDescr[indx];
        4: Edit5.Text := MemoryDescr[indx];
        5: Edit6.Text := MemoryDescr[indx];
      end;
    end;
  end;
  Application.ProcessMessages;
end;

// -----------------------------------------
// Save Button 1 thru 6 Handlers
// -----------------------------------------

procedure TfmConfig.btnSaveClick(Sender: TObject);
var
  descr: string;
  btag: integer;     // 11..16 for Button tags
  indx: integer;  // 0..5 for TString array
begin
  btag := TButton(Sender).Tag;
  indx := btag - 11;
  worker.CopyConfigToMemory(indx + 1);
  case btag of
    11: descr := fmConfig.Edit1.Text;
    12: descr := fmConfig.Edit2.Text;
    13: descr := fmConfig.Edit3.Text;
    14: descr := fmConfig.Edit4.Text;
    15: descr := fmConfig.Edit5.Text;
    16: descr := fmConfig.Edit6.Text;
  end;
  worker.WriteDescriptionToIniFile(indx, descr);
  ShowMessage('Settings saved to Memory ' + inttostr(btag-10));
  worker.ReadDescriptionsFromIniFile;  // refresh the global variable
end;


// -----------------------------------------
// Delete Button 1 thru 6 Handlers
// -----------------------------------------

procedure TfmConfig.btnDeleteClick(Sender: TObject);
var
  indx: integer;
begin
  indx := TButton(Sender).Tag;
  case indx of
    21: fmConfig.Edit1.Text := '';
    22: fmConfig.Edit2.Text := '';
    23: fmConfig.Edit3.Text := '';
    24: fmConfig.Edit4.Text := '';
    25: fmConfig.Edit5.Text := '';
    26: fmConfig.Edit6.Text := '';
  end;
  worker.WriteDescriptionToIniFile(indx, '');
  //delete all files in AppData folder(indx)
  worker.DeleteAllFilesinConfig(indx-20);
  ShowMessage('Memory ' + inttostr(indx-20) + ' deleted');
end;


procedure TfmConfig.errorSetupNotDone;
begin
  ShowMessage('Please complete Setup before continuing.');
end;

procedure TfmConfig.btnConfigCloseClick(Sender: TObject);
begin
  fmConfig.Visible := False;
end;

end.
