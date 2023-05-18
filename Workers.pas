// -----------------------------------------------------------------------------
//
//  MSHV Configuration Swapper         by Jim K6OK
//  workers.pas -- Creates a TWorkers class that handles most of the
//  procedural stuff
//
// -----------------------------------------------------------------------------

unit Workers;

// --public-------------------------------
interface

uses inifiles, System.SysUtils, Vcl.Dialogs, System.Classes, System.StrUtils,
      System.IOUtils, Main;

type
  TWorkers = class
    procedure MCS_Dir_Exist;
    procedure MCS_ini_Exist;
    procedure WritePathToIniFile;
    procedure ReadPathIniFile;
    procedure WriteFileNamesToSaveToIni;
    procedure ReadFileNamesToSaveFromIni;
    procedure CopyConfigToMemory(memnum: integer);
    procedure CopyMemoryToConfig(memnum: integer);
    procedure WriteDescriptionToIniFile(indx: integer; descr: string);
    procedure ReadDescriptionsFromIniFile;
    procedure DeleteAllFilesinConfig(indx: integer);
    procedure WriteMainFormSizePosition;
    procedure ReadMainFormSizePosition;
  end;

var
  worker: TWorkers;

  // Global variables
  MCS_ini_Exists: boolean;        //does the .ini file exist?
  MCS_Dir_Exists: boolean;        //does the program directory exist?

  mshvPath: string;               //path to MSHV folder
  appPath: string;                //path to user/AppData/Local
  TopFolder: string;              //path to MSHV_Config_Mgr in AppData
  FolderName: string;             //name of MSHV_Config_Mgr folder

  iniSets: TIniFile;              // *.ini file object

  FileNamesToSave: TStringList;   //filenames found in MSHV/settings
  MemoryDescr: TStringList;       //descriptions for memory 1 thru 6

// -- private -----------------------------
implementation

// ----------------------------------------
//   Does {User}/AppData/Local/MSHV_Config_Mgr folder exist?
// ----------------------------------------

procedure TWorkers.MCS_Dir_Exist;
begin
   appPath := IncludeTrailingPathDelimiter(GetEnvironmentVariable('LOCALAPPDATA'));
   FolderName := 'MSHV_Config_Swpr';
   TopFolder := appPath + FolderName;
  If DirectoryExists(TopFolder) then
    MCS_Dir_Exists := True
  else
    MCS_Dir_Exists := False;
end;

// ----------------------------------------
//   Does /MSHV_Config_Mgr/MCS.ini file exist?
// ----------------------------------------

procedure TWorkers.MCS_ini_Exist;
begin
  If FileExists(TopFolder + '\MCS.ini') then
    MCS_ini_Exists := True
  else
    MCS_ini_Exists := False;
end;

// ----------------------------------------
//   Write names of MSHV settings files to the .ini file
// ----------------------------------------

procedure TWorkers.WriteFileNamesToSaveToIni;
var
  searchItem: TSearchRec;
  lft: string;
  i: Integer;
begin
  //use FindFirst loop to get filenames
  iniSets := TIniFile.Create(TopFolder + '\MCS.ini');
  FileNamesToSave := TStringList.Create;
  i := 0;
  if FindFirst(mshvPath + '\settings\*.*', faAnyFile, searchItem)=0 then
  begin
    repeat
      lft := LeftStr(searchItem.Name, 3);
      if (lft = 'aze') or (lft = 'ms_') then
      begin
        iniSets.WriteString('Files', 'File'+inttostr(i), searchItem.Name);
        FileNamesToSave.Add(searchItem.Name);
        inc(i,1);
      end;
    until FindNext(searchItem) <> 0;
    iniSets.WriteInteger('Files', 'Count', i);
    iniSets.Free;
    FileNamesToSave.Destroy;
  end;
end;

// ----------------------------------------
//   Read names of MSHV settings files from the .ini file
// ----------------------------------------

procedure TWorkers.ReadFileNamesToSaveFromIni;
var
  fCount: integer;
  i: integer;
begin
  FileNamesToSave := TStringList.Create;
  iniSets := TIniFile.Create(TopFolder + '\MCS.ini');
  fCount := iniSets.ReadInteger('Files','Count',0);
  for i := 0 to (fCount-1) do
  begin
    FileNamesToSave.Add(iniSets.ReadString('Files','File'+inttostr(i),''));
  end;
end;

// ----------------------------------------
//   Write path to .ini file
// ----------------------------------------

procedure TWorkers.WritePathToIniFile;
begin
  iniSets := TIniFile.Create(TopFolder + '\MCS.ini');
  iniSets.WriteString('Main', 'Path', mshvPath);
  iniSets.Free;
end;


// ----------------------------------------
//   Read path from .ini file
// ----------------------------------------

procedure TWorkers.ReadPathIniFile;
begin
  iniSets := TIniFile.Create(TopFolder + '\MCS.ini');
  mshvPath := iniSets.ReadString('Main', 'Path', mshvPath);
  iniSets.Free;
end;


// ----------------------------------------
//   Copy the MSHV files to memory slot at AppData
// ----------------------------------------

procedure TWorkers.CopyConfigToMemory(memnum: integer);
var
  i: integer;
  numfiles: integer;
  fidx: string;
  fname: string;
  sourcePath: string;
  destPath: string;
begin
  sourcePath := mshvPath + '\settings\';
  destPath := TopFolder + ('\Config' + inttostr(memnum) + '\');
  iniSets := TIniFile.Create(TopFolder + '\MCS.ini');
  // Get how many files
  numfiles := iniSets.ReadInteger('Files', 'Count', 0); // default is zero
  // copy files from MSHV/settings to AppData
  for i := 0 to (numfiles - 1) do
  begin
    fidx := 'File' + inttostr(i);
    fname := iniSets.ReadString('Files', fidx, 'error');
    TFile.Copy(sourcePath + fname, destPath + fname, True);
  end;
  iniSets.Free;
end;


// ----------------------------------------
//   Copy files from AppData memory slot to the MSHV Settings folder
// ----------------------------------------
procedure TWorkers.CopyMemoryToConfig(memnum: integer);
var
  numfiles: integer;
  i: integer;
  fidx: string;
  fname: string;
  sourcePath: string;
  destPath: string;
begin
  sourcePath := TopFolder + ('\Config' + inttostr(memnum) + '\');
  // check to see if sourcePath is empty
  if not TDirectory.IsEmpty(sourcePath) then
  begin
    destPath := mshvPath + '\settings\';
    iniSets := TIniFile.Create(TopFolder + '\MCS.ini');
    // get how many files
    numfiles := iniSets.ReadInteger('Files', 'Count', 0); // default is zero
    // copy files from MSHV/settings to AppData
    for i := 0 to (numfiles - 1) do
    begin
      fidx := 'File' + inttostr(i);
      fname := iniSets.ReadString('Files', fidx, 'error');
      TFile.Copy(sourcePath + fname, destPath + fname, True);
    end;
    // update the status bar on the main form
    fmMain.panelStatus.Caption := 'Memory '+ inttostr(memnum) + ' loaded into MSHV';
    iniSets.Free;
  end
  else ShowMessage('Memory ' + inttostr(memnum) + ' folder is empty.');
end;


// ----------------------------------------
//   Write Description text to .ini file
// ----------------------------------------

procedure TWorkers.WriteDescriptionToIniFile(indx: integer; descr: string);
begin
  iniSets := TIniFile.Create(TopFolder + '\MCS.ini');
  iniSets.WriteString('Descr', 'Descr' + inttostr(indx), descr);
  iniSets.Free;
end;


// ----------------------------------------
//   Load all description texts from .ini file
// ----------------------------------------

procedure TWorkers.ReadDescriptionsFromIniFile;
var
  indx : integer;
begin
  MemoryDescr := TStringList.Create;
  iniSets := TIniFile.Create(TopFolder + '\MCS.ini');
  for indx := 0 to 5 do
    begin
      MemoryDescr.Add(iniSets.ReadString('Descr', 'Descr' + inttostr(indx), 'Unused'));
    end;
  iniSets.Free;
end;


// ---------------------------------------
//  Delete all files in AppData Config directory
// ---------------------------------------

procedure TWorkers.DeleteAllFilesinConfig(indx: integer);
var
  FindRec: TSearchRec;
  thePath: string;
begin
  thePath := TopFolder + ('\Config' + inttostr(indx) + '\');
  if FindFirst(thePath + '*.*', faAnyFile, FindRec) = 0 then
  begin
    try
      repeat
        DeleteFile(thePath + FindRec.Name);
      until FindNext(FindRec) <> 0;
    finally
      FindClose(FindRec);
    end;
  end;
end;


// ---------------------------------------
//  Write main form size and position to .ini
// ---------------------------------------

procedure TWorkers.WriteMainFormSizePosition;
begin
  if MCS_ini_Exists then
  begin
    iniSets := TIniFile.Create(TopFolder + '\MCS.ini');
    with iniSets do
      begin
      WriteInteger('Position','Top',fmMain.Top);
      WriteInteger('Position','Left',fmMain.Left);
      WriteInteger('Position','Height',fmMain.Height);
     WriteInteger('Position','Width',fmMain.Width);
    end;
    iniSets.Free;
  end;
end;


// --------------------------------------
//  Read main form size and position from .ini
// --------------------------------------
procedure TWorkers.ReadMainFormSizePosition;
begin
  if MCS_ini_Exists then
  begin
    iniSets := TIniFile.Create(TopFolder + '\MCS.ini');
    fmMain.Top := iniSets.ReadInteger('Position','Top',100);
    fmMain.Left := iniSets.ReadInteger('Position','Left',100);
    fmMain.Height := 147; fmMain.Width := 268;
  end;
end;

end.
