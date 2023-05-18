program MSHV_Config_Swapper;

uses
  Vcl.Forms,
  Main in 'Main.pas' {fmMain},
  Setup in 'Setup.pas' {fmSetup},
  Config in 'Config.pas' {fmConfig},
  Help in 'Help.pas' {fmHelp},
  Workers in 'Workers.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TfmMain, fmMain);
  Application.CreateForm(TfmSetup, fmSetup);
  Application.CreateForm(TfmConfig, fmConfig);
  Application.CreateForm(TfmHelp, fmHelp);
  Application.Run;
end.
