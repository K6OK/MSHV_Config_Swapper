// ----------------------------------------------------------------------------
//
// MSHV Configuration Swapper         by Jim K6OK
//
// Simple companion program to MSHV digital mode program by LZ2HV
// Saves and loads MSHV configuration settings files
//
// This software is open source pursuant to the
// Mozilla Public License Version 2 (https://www.mozilla.org/en-US/MPL/2.0/)
//
// ----------------------------------------------------------------------------


unit Main;

// public ---------------------------------------------------------------------
//
// Note: all global variables are declared in the Workers unit
//

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
  System.Classes, Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs,
  Vcl.StdCtrls, Vcl.Menus, Vcl.ExtCtrls, System.StrUtils;

type
  TfmMain = class(TForm)
    MainMenu1: TMainMenu;
    menuSetup: TMenuItem;
    btnConfig1: TButton;
    btnConfig2: TButton;
    btnConfig3: TButton;
    btnConfig4: TButton;
    btnConfig5: TButton;
    btnConfig6: TButton;
    menuConfig: TMenuItem;
    menuHelp: TMenuItem;
    panelStatus: TPanel;
    Shape1: TShape;
    Label1: TLabel;
    procedure menuSetupClick(Sender: TObject);
    procedure menuConfigClick(Sender: TObject);
    procedure menuHelpClick(Sender: TObject);
    procedure btnMemoryClick(Sender: TObject);
    procedure btnMouseEnter(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure FormCreate(Sender: TObject);

  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  fmMain: TfmMain;

// private --------------------------------------------------------------------

implementation

{$R *.dfm}

uses Setup, Help, Config, Workers;

// --------------------------------------
// Menu click handlers
//---------------------------------------

procedure TfmMain.menuConfigClick(Sender: TObject);
begin
  if MCS_Dir_Exists and MCS_ini_Exists then
  begin
    Config.fmConfig.Visible := True;
  end
  else fmConfig.errorSetupNotDone;
end;

procedure TfmMain.menuHelpClick(Sender: TObject);
begin
  Help.fmHelp.Visible := True;
end;

procedure TfmMain.menuSetupClick(Sender: TObject);
begin
  Setup.fmSetup.Visible := True;
end;


// --------------------------------------
// Handle clicks for Buttons 1 thru 6
// note: Buttons have .Tag set to 1-6
//---------------------------------------

procedure TfmMain.btnMemoryClick(Sender: TObject);
var
  indx: integer;
begin
  indx := TButton(Sender).Tag;
  worker.CopyMemoryToConfig(indx);
end;


// --------------------------------------
// On mouse enter over Memory button handler
// Mouse hover displays description on panel
//---------------------------------------

procedure TfmMain.btnMouseEnter(Sender: TObject);
var
  indx: integer;
begin
  if MCS_ini_Exists then
  begin
    indx := TButton(Sender).Tag - 1;
    panelStatus.Caption := MemoryDescr[indx];
  end;
end;

// --------------------------------------
// At form creation set the main form position
// --------------------------------------

procedure TfmMain.FormCreate(Sender: TObject);
begin
  worker.ReadMainFormSizePosition;
end;

// --------------------------------------
// At shutdown store the main form position
// --------------------------------------
procedure TfmMain.FormDestroy(Sender: TObject);
begin
  worker.WriteMainFormSizePosition;
end;


// --------------------------------------
// At startup, see if .ini file and AppData folder exists
// If .ini exists, load global variables from .ini
//---------------------------------------

initialization
begin
  worker.MCS_Dir_Exist;
  worker.MCS_ini_Exist;
  if MCS_ini_Exists then
    begin
      worker.ReadPathIniFile;
      worker.ReadFileNamesToSaveFromIni;
      worker.ReadDescriptionsFromIniFile;
    end
  else
    fmConfig.errorSetupNotDone;
end;

end.
