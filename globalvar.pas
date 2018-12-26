unit GlobalVar;

{$mode objfpc}{$H+}

interface

uses
  Classes, Forms, SysUtils, Process, Dialogs,
  Controls, inifiles, Math;

var
  Settings: TIniFile;
  SetEnabled: boolean;
  Display: boolean;
  View: boolean;
  Directory: string;
  IglRadius: real;
  IglLength: real;
  IglRows: array [0..2] of integer; {No. of Rows}
  IglTunnelLength: array [0..2] of integer; {Length of tunnel in bricks}
  IglTunnelBricks: array [0..2] of integer; {Total no. of bricks for entrance}
  IglTotal: array [0..2] of integer; {Total no. of bricks}
  BudBricks: TStringList; {No. of bricks per row}
  SupBricks: TStringList;
  LuxBricks: TStringList;
  DomeTotal: array [0..2] of integer; {Total no. of bricks for dome}
  BrickDimensions: array [0..2, 0..2] of real;
  {Brick Dimensions - Variable to support possible changes in sizes}
  Igloo: TIniFile;

procedure LoadSettings;
procedure CreateSettings;
procedure DefaultSettings;
procedure SaveSettings;
procedure IglClear;
procedure NewClear;
procedure Calculate;
procedure DomeRows;
procedure LoadBrickDimensions;
procedure BudRowBricks;
procedure SupRowBricks;
procedure LuxRowBricks;
procedure TunnelLength;
procedure TunnelBricks;
procedure IglBricks;
procedure IglSave(Filename: string);
procedure IglLoad(Filename: string);

implementation

uses Main;

procedure Calculate;
begin {Start Calculation}
  IglClear;
  LoadBrickDimensions;
  DomeRows;
  BudRowBricks;
  SupRowBricks;
  LuxRowBricks;
  TunnelLength;
  TunnelBricks;
  IglBricks;
end;

procedure IglClear;
begin {Clear Variables}
  FillChar(IglRows, SizeOf(IglRows), 0);
  FillChar(IglTunnelLength, SizeOf(IglTunnelLength), 0);
  FillChar(IglTunnelBricks, SizeOf(IglTunnelBricks), 0);
  FillChar(IglTotal, SizeOf(IglTotal), 0);
  BudBricks.Clear;
  SupBricks.Clear;
  LuxBricks.Clear;
  FillChar(DomeTotal, SizeOf(DomeTotal), 0);
end;

procedure LoadBrickDimensions;
begin {Load Brick Dimensions}
  BrickDimensions[0, 0] := 0.4;{W}
  BrickDimensions[0, 1] := 0.25;{H}
  BrickDimensions[0, 2] := 0.15;{D}
  BrickDimensions[1, 0] := 0.35;
  BrickDimensions[1, 1] := 0.25;
  BrickDimensions[1, 2] := 0.2;
  BrickDimensions[2, 0] := 0.3;
  BrickDimensions[2, 1] := 0.2;
  BrickDimensions[2, 2] := 0.2;
end;

procedure DomeRows; {Number of Domes}
var
  Rows: real;
  Count: integer;
begin
  Count := 0;
  repeat
    Rows := pi / (2 * pi - 4 * arctan((2 * IglRadius + BrickDimensions[Count, 2]) /
      BrickDimensions[Count, 1]));
    IglRows[Count] := Trunc(Rows) + 2;
    Count := Count + 1;
  until Count > 2;
end;

procedure BudRowBricks; {Bricks per Row}

//4862700026169387
// 07/15
//708

var
  Count: integer;
  A, B, C, D, E, F, K, L, M: real;
  Bricks: real;
  Amount: integer;
begin
  Count := 0;
  DomeTotal[0] := 0;
  repeat
    Bricks := 0;
    Amount := 0;

    F := BrickDimensions[0, 1] / (2 * (IglRadius + BrickDimensions[0, 2]));
    E := 2 * (Count) * arctan(F);
    D := sqr(IglRadius + BrickDimensions[0, 2]) + (sqr(BrickDimensions[0, 1]) / 4);
    C := sqrt(D) * cos(E);
    B := 2 * (C) / BrickDimensions[0, 0];
    A := pi - 2 * arctan(B);
    Bricks := 2 * pi / A;

    if C > sqrt(sqr(IglRadius + BrickDimensions[0, 2]) - 0.2025) then
    begin
      K := 0.2025 + sqr(C) - sqr(IglRadius + BrickDimensions[0, 2]);
      L := sqrt(K) / (IglRadius + BrickDimensions[0, 2]);
      M := 2 * arcsin(L) / (2 * pi);
      Bricks := Bricks * (1 - (M));
      Amount := Trunc(Bricks) + 1;
      DomeTotal[0] := DomeTotal[0] + Amount;
      BudBricks.add(IntToStr(Amount) + ' *');
    end
    else
    begin
      Amount := Trunc(Bricks) + 1;
      DomeTotal[0] := DomeTotal[0] + Amount;
      BudBricks.add(IntToStr(Amount));
    end;

    Count := Count + 1;
  until Count = (IglRows[0] - 1);
  BudBricks.add('1');
end;

procedure SupRowBricks;
var
  Count: integer;
  A, B, C, D, E, F, K, L, M: real;
  Bricks: real;
  Amount: integer;
begin
  Count := 0;
  repeat
    Bricks := 0;
    Amount := 0;

    F := BrickDimensions[1, 1] / (2 * (IglRadius + BrickDimensions[1, 2]));
    E := 2 * (Count) * arctan(F);
    D := sqr(IglRadius + BrickDimensions[1, 2]) + (sqr(BrickDimensions[1, 1]) / 4);
    C := sqrt(D) * cos(E);
    B := 2 * (C) / BrickDimensions[1, 0];
    A := pi - 2 * arctan(B);
    Bricks := 2 * pi / A;

    if C > sqrt(sqr(IglRadius + BrickDimensions[1, 2]) - 0.2025) then
    begin
      K := 0.2025 + sqr(C) - sqr(IglRadius + BrickDimensions[1, 2]);
      L := sqrt(K) / (IglRadius + BrickDimensions[1, 2]);
      M := 2 * arcsin(L) / (2 * pi);
      Bricks := Bricks * (1 - (M));
      Amount := Trunc(Bricks) + 1;
      DomeTotal[1] := DomeTotal[1] + Amount;
      SupBricks.add(IntToStr(Amount) + ' *');
    end
    else
    begin
      Amount := Trunc(Bricks) + 1;
      DomeTotal[1] := DomeTotal[1] + Amount;
      SupBricks.add(IntToStr(Amount));
    end;

    Count := Count + 1;
  until Count = (IglRows[1] - 1);
  SupBricks.add('1');
end;

procedure LuxRowBricks;
var
  Count: integer;
  A, B, C, D, E, F, K, L, M: real;
  Bricks: real;
  Amount: integer;
begin
  Count := 0;
  repeat
    Bricks := 0;
    Amount := 0;

    F := BrickDimensions[2, 1] / (2 * (IglRadius + BrickDimensions[2, 2]));
    E := 2 * (Count) * arctan(F);
    D := sqr(IglRadius + BrickDimensions[2, 2]) + (sqr(BrickDimensions[2, 1]) / 4);
    C := sqrt(D) * cos(E);
    B := 2 * (C) / BrickDimensions[2, 0];
    A := pi - 2 * arctan(B);
    Bricks := 2 * pi / A;

    if C > sqrt(sqr(IglRadius + BrickDimensions[2, 2]) - 0.2025) then
    begin
      K := 0.2025 + sqr(C) - sqr(IglRadius + BrickDimensions[2, 2]);
      L := sqrt(K) / (IglRadius + BrickDimensions[2, 2]);
      M := 2 * arcsin(L) / (2 * pi);
      Bricks := Bricks * (1 - (M));
      Amount := Trunc(Bricks) + 1;
      DomeTotal[2] := DomeTotal[2] + Amount;
      LuxBricks.add(IntToStr(Amount) + ' *');
    end
    else
    begin
      Amount := Trunc(Bricks) + 1;
      DomeTotal[2] := DomeTotal[2] + Amount;
      LuxBricks.add(IntToStr(Amount));
    end;

    Count := Count + 1;
  until Count = (IglRows[2] - 1);
  LuxBricks.add('1');
end;

procedure TunnelLength; {Tunnel Length}
var
  Length: real;
  Count: integer;
begin
  Count := 0;
  repeat
    Length := IglLength / BrickDimensions[Count, 0];
    IglTunnelLength[Count] := Round(Length);
    if IglTunnelLength[Count] < Length then
      IglTunnelLength[Count] := IglTunnelLength[Count] + 1;
    Count := Count + 1;
  until Count > 2;
end;

procedure TunnelBricks; {Total for Tunnel}
var
  Count: integer;
  A: integer;
  B, C, D, E: real;
  Bricks: integer;
begin
  Count := 0;
  repeat
    E := 0.45 + BrickDimensions[Count, 2];
    D := 2 * (E / BrickDimensions[Count, 1]);
    C := pi - 2 * arctan(D);
    B := pi / C;
    A := Round(B);
    if A < B then
      A := A + 1;
    Bricks := A * IglTunnelLength[Count];
    IglTunnelBricks[Count] := Bricks;
    Count := Count + 1;
  until Count > 2;
end;

procedure IglBricks; {Total Bricks}
var
  Count: integer;
begin
  Count := 0;
  repeat
    IglTotal[Count] := IglTunnelBricks[Count] + DomeTotal[Count];
    Count := Count + 1;
  until Count > 2;
end;

procedure LoadSettings; {Load Settings from ini}
var
  SetError: integer;
  Restart: TProcess;
begin
  try
    Settings := TIniFile.Create(ChangeFileExt(Application.ExeName, '.ini'));
    Display := Settings.ReadBool('General', 'Display', True);
    Directory := Settings.ReadString('General', 'Directory', '');
    View := Settings.ReadBool('General', 'View', False);
  except {If Setting Error}
    begin
      SetError := MessageDlg('Error', 'Error: A02 - Settings cannot be loaded.' +
        sLineBreak + 'Would you like to reset settings?', mtError,
        [mbYes, mbIgnore, mbAbort], 0);
      case SetError of
        mrYes:
        begin {Delete corrupt settings and restart}
          DeleteFile(ChangeFileExt(Application.ExeName, '.ini'));
          Restart := TProcess.Create(nil);
          Restart.Executable := Application.ExeName;
          Restart.Execute;
          Restart.Free;
          Halt;
        end;
        mrIgnore:
        begin {Ignore}
          MessageDlg('Settings',
            'The application will run with settings disabled.',
            mtWarning, [mbOK], 0);
          SetEnabled := False;
          DefaultSettings;
        end;
        else
          Halt;
      end;
    end;
  end;
end;

procedure CreateSettings;  {Create new Settings file}
begin
  DefaultSettings;
  SaveSettings;
end;

procedure DefaultSettings; {Define default settings}
begin
  Display := True;
  Directory := '';
  View := False;
end;

procedure SaveSettings;  {Save Settings}
begin
  try
    begin
      Settings := TIniFile.Create(ChangeFileExt(Application.ExeName, '.ini'));
      with Settings do
        try
          WriteBool('General', 'Display', Display);
          WriteString('General', 'Directory', Directory);
          WriteBool('General', 'View', View);
        finally
          Free;
        end;
    end;
  except;
    begin
      MessageDlg('Error', 'Error: A01 - Settings file cannot be created.' +
        sLineBreak +
        'Please check that your Antivirus or User Account Control is not preventing saving of files.',
        mtError, [mbOK], 0);
      MessageDlg('Settings', 'The application will run with settings disabled.',
        mtWarning, [mbOK], 0);
      SetEnabled := False;
      FrmMain.MnuItmOptions.Enabled := False;
      FrmMain.BtnOptions.Enabled := False;
      DefaultSettings;
    end;
  end;
end;

procedure NewClear;  {Clear Variables}
begin
  IglRadius := 0;
  IglLength := 0;
end;

procedure IglSave(Filename: string); {Save File}
var
  SaveRows: TStringList;
  SaveTunnelLength: TStringList;
  SaveTunnelBricks: TStringList;
  SaveTotal: TStringList;
  SaveDome: TStringList;
  Count: integer;
begin
  try
    SaveRows := TStringList.Create;
    SaveTunnelLength := TStringList.Create;
    SaveTunnelBricks := TStringList.Create;
    SaveTotal := TStringList.Create;
    SaveDome := TStringList.Create;
    Count := 0;
    repeat
      SaveRows.Add(IntToStr(IglRows[Count]));
      Count := Count + 1;
    until Count > 2;
    Count := 0;
    repeat
      SaveTunnelLength.Add(IntToStr(IglTunnelLength[Count]));
      Count := Count + 1;
    until Count > 2;
    Count := 0;
    repeat
      SaveTunnelBricks.Add(IntToStr(IglTunnelBricks[Count]));
      Count := Count + 1;
    until Count > 2;
    Count := 0;
    repeat
      SaveTotal.Add(IntToStr(IglTotal[Count]));
      Count := Count + 1;
    until Count > 2;
    Count := 0;
    repeat
      SaveDome.Add(IntToStr(DomeTotal[Count]));
      Count := Count + 1;
    until Count > 2;
    Igloo := TIniFile.Create(Filename);
    with Igloo do
      try
        WriteFloat('Input', 'IglRadius', IglRadius);
        WriteFloat('Input', 'IglLength', IglLength);
        WriteString('Values', 'IglRows', SaveRows.commaText);
        WriteString('Values', 'IglTunnelLength', SaveTunnelLength.commaText);
        WriteString('Values', 'IglTunnelBricks', SaveTunnelBricks.commaText);
        WriteString('Values', 'IglTotal', SaveTotal.commaText);
        WriteString('Values', 'BudBricks', BudBricks.commaText);
        WriteString('Values', 'SupBricks', SupBricks.commaText);
        WriteString('Values', 'LuxBricks', LuxBricks.commaText);
        WriteString('Values', 'DomeTotal', SaveDome.commaText);
      finally
        Free;
      end;
    SaveRows.Free;
    SaveTunnelLength.Free;
    SaveTunnelBricks.Free;
    SaveTotal.Free;
    SaveDome.Free;
    MessageDlg('Saved', 'File saved as: ' + Filename, mtInformation, [mbOK], 0);
  except
    MessageDlg('Error', 'Error: L01 - Save file cannot be created.' +
      sLineBreak +
      'Please check that your Antivirus or User Account Control is not preventing saving of files',
      mtError,
      [mbOK], 0);
  end;
end;

procedure IglLoad(Filename: string);{Load File}
var
  SaveRows: TStringList;
  SaveTunnelLength: TStringList;
  SaveTunnelBricks: TStringList;
  SaveTotal: TStringList;
  SaveDome: TStringList;
  Count: integer;
begin
  try
    IglClear;
    SaveRows := TStringList.Create;
    SaveTunnelLength := TStringList.Create;
    SaveTunnelBricks := TStringList.Create;
    SaveTotal := TStringList.Create;
    SaveDome := TStringList.Create;
    BudBricks := TStringList.Create;
    SupBricks := TStringList.Create;
    LuxBricks := TStringList.Create;

    Igloo := TIniFile.Create(Filename);
    try
      IglRadius := Igloo.ReadFloat('Input', 'IglRadius', 0);
      IglLength := Igloo.ReadFloat('Input', 'IglLength', 0);
      SaveRows.commaText := Igloo.ReadString('Values', 'IglRows', '');
      SaveTunnelLength.commaText := Igloo.ReadString('Values', 'IglTunnelLength', '');
      SaveTunnelBricks.commaText := Igloo.ReadString('Values', 'IglTunnelBricks', '');
      SaveTotal.commaText := Igloo.ReadString('Values', 'IglTotal', '');
      BudBricks.commaText := Igloo.ReadString('Values', 'BudBricks', '');
      SupBricks.commaText := Igloo.ReadString('Values', 'SupBricks', '');
      LuxBricks.commaText := Igloo.ReadString('Values', 'LuxBricks', '');
      SaveDome.commaText := Igloo.ReadString('Values', 'DomeTotal', '');
    finally
      Igloo.Free;
    end;
    Count := 0;
    repeat
      IglRows[Count] := StrToInt(SaveRows[Count]);
      Count := Count + 1;
    until Count > 2;
    Count := 0;
    repeat
      IglTunnelLength[Count] := StrToInt(SaveTunnelLength[Count]);
      Count := Count + 1;
    until Count > 2;
    Count := 0;
    repeat
      IglTunnelBricks[Count] := StrToInt(SaveTunnelBricks[Count]);
      Count := Count + 1;
    until Count > 2;
    Count := 0;
    repeat
      IglTotal[Count] := StrToInt(SaveTotal[Count]);
      Count := Count + 1;
    until Count > 2;
    Count := 0;
    repeat
      DomeTotal[Count] := StrToInt(SaveDome[Count]);
      Count := Count + 1;
    until Count > 2;
    SaveRows.Free;
    SaveTunnelLength.Free;
    SaveTunnelBricks.Free;
    SaveTotal.Free;
    SaveDome.Free;
  except
    MessageDlg('Error', 'Error: L02 - Save file cannot be loaded.' +
      sLineBreak +
      'Please check that your Antivirus or User Account Control is not preventing the loading of files',
      mtError,
      [mbOK], 0);
  end;
end;

end.
