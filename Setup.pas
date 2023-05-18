// -----------------------------------------------------------------------------
//
//  MSHV Configuration Swapper         by Jim K6OK
//  Setup -- Code for the Setup window
//  Note: all global variables and most of the work is done
//  by TWorkers class in the workers.pas unit
// -----------------------------------------------------------------------------

unit Setup;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
  System.Classes, Vcl.Graphics,   Vcl.Controls, Vcl.Forms, Vcl.Dialogs,
  Vcl.StdCtrls, inifiles, System.StrUtils, Workers;

type
  TfmSetup = class(TForm)
    btnGetPath: TButton;
    Label1: TLabel;
    lblShowPath: TLabel;
    btnSetupClose: TButton;
    OpenDialog1: TOpenDialog;
    Label3: TLabel;
    Label4: TLabel;
    btnProceed: TButton;
    Label2: TLabel;
    editFolderStatus: TEdit;
    editPathStatus: TEdit;
    editPathToMSHV: TEdit;
    listboxFileNames: TListBox;
    Label5: TLabel;
    procedure btnGetPathClick(Sender: TObject);
    procedure btnProceedClick(Sender: TObject);
    procedure btnSetupCloseClick(Sender: TObject);
    procedure FormShow(Sender: TObject);

  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  fmSetup: TfmSetup;


implementation

{$R *.dfm}


// ----------------------------------------
// On form show, set the directory and path status
// ----------------------------------------
procedure TfmSetup.FormShow(Sender: TObject);
var
  i: integer;
begin
  sleep(100);
  if MCS_Dir_Exists then editFolderStatus.Text := 'OK'
    else editFolderStatus.Text := 'Not_Set';
  if MCS_ini_Exists then
    begin
      editPathStatus.Text := 'OK';
      worker.ReadPathIniFile;
      editPathtoMSHV.Text := mshvPath;
     // Get the names of the MSHV settings files
      worker.ReadFileNamesToSaveFromIni;
      // Populate the Setup filenames list box
      fmSetup.listboxFileNames.Clear();
      for i := 0 to (FileNamesToSave.Count - 1) do
      begin
        fmSetup.listboxFileNames.Items.Add(FileNamesToSave[i]);
      end;
    end
    else
    begin
        editPathStatus.Text := 'Not Set';
        editPathtoMSHV.Text := 'Not Set';
    end;
  Application.ProcessMessages;
end;



// ----------------------------------------
// Step 1 Proceed
// Create folders in {User}/AppData/Local
// ----------------------------------------

procedure TfmSetup.btnProceedClick(Sender: TObject);
var
  SubFolder: string;
  SubPath: string;
  i: integer;
begin
  if not MCS_Dir_Exists then
    CreateDir(TopFolder);
    SubPath := TopFolder + '\Config';
    for i:= 1 to 6 do
    begin
     SubFolder :=  SubPath + inttostr(i);
     if not DirectoryExists(SubFolder) then
        CreateDir(SubFolder);
     end;
    worker.MCS_Dir_Exist;
    fmSetup.editFolderStatus.Text := 'OK';
end;

// ----------------------------------------
//   Step 2 Get Path
//   Get the path to MSHV executable
// ----------------------------------------

procedure TfmSetup.btnGetPathClick(Sender: TObject);
var
  i: integer;
  indx: integer;
begin
  if not MCS_ini_Exists then
    with TFileOpenDialog.Create(nil) do
    try
      Title := 'Select the MSHV Folder';
      Options := [fdoPickFolders, fdoPathMustExist, fdoForceFileSystem];
      OkButtonLabel := 'Select';
      DefaultFolder := 'C:\';
    if Execute then
      begin
        if not ContainsText(FileName,'MSHV') then
        begin
          ShowMessage('MSHV not found. Please try again.');
          DeleteFile(TopFolder + '\MCM.ini');
          exit;
        end;
        mshvPath := FileName;
        worker.WritePathToIniFile;
        fmSetup.editPathStatus.Text := 'OK';
        fmSetup.editPathToMSHV.Text := mshvPath;
        worker.MCS_ini_Exist;
        // Get the names of the MSHV settings files
        worker.WriteFileNamesToSaveToIni;
        // Populate the Setup filenames list box
        fmSetup.listboxFileNames.Clear();
        for i := 0 to (FileNamesToSave.Count - 1) do
        begin
          fmSetup.listboxFileNames.Items.Add(FileNamesToSave[i]);
        end;
        // Populate the Descriptions with "unused" and load the global var
        for indx := 0 to 5 do
        begin
          worker.WriteDescriptionToIniFile(indx, 'Unused');
        end;
        worker.ReadDescriptionsFromIniFile;
      end;
    finally
      if MCS_Dir_Exists then
      begin
        ShowMessage('Setup Complete');
        fmSetup.Visible := false;
      end;

      Free;
  end;

end;

procedure TfmSetup.btnSetupCloseClick(Sender: TObject);
begin
  fmSetup.Visible := False;
end;


// --------------------------------------
// At startup, see if .ini file and AppData folder exists
//---------------------------------------
initialization
begin
  worker.MCS_Dir_Exist;
  worker.MCS_ini_Exist;
end;

end.

