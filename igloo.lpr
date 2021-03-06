program igloo;

{$mode objfpc}{$H+}

uses
  {$IFDEF UNIX}{$IFDEF UseCThreads}
  cthreads,
  {$ENDIF}{$ENDIF}
  Interfaces, // this includes the LCL widgetset
  Classes, Forms, SysUtils, FileUtil, StdCtrls, Process, Dialogs, LCLType,
  Controls, Splash, Main, GlobalVar, Options, New, Result, Info;

{$R *.res}

begin
  RequireDerivedFormResource := True;
  Application.Initialize;
  GlobalVar.SetEnabled := True;
  {Create Settings File}
  if not FileExists('igloo.ini') then
     GlobalVar.CreateSettings;

  {Load Settings from File}
     GlobalVar.LoadSettings;

  {Initiate Splash Screen}
  Application.CreateForm(TFrmSplash, FrmSplash);
  if GlobalVar.Display then
     begin
          FrmSplash.Show;
          sleep(1800);
     end;
  FrmSplash.Free;
  FrmSplash := nil;

  {Start Forms}
  Application.CreateForm(TFrmMain, FrmMain);
  Application.CreateForm(TFrmOptions, FrmOptions);
  Application.CreateForm(TFrmNew, FrmNew);
  Application.CreateForm(TFrmResult, FrmResult);
  Application.CreateForm(TFrmInfo, FrmInfo);
  Application.Run;

end.

