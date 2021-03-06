unit Result;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Forms, Dialogs, Buttons,
  StdCtrls, ExtCtrls, ComCtrls, ValEdit, GlobalVar, LCLType;

type

  { TFrmResult }

  TFrmResult = class(TForm)
    BtnAdvanced: TBitBtn;
    BtnStandard: TBitBtn;
    BtnClose: TBitBtn;
    BtnHelp: TBitBtn;
    BtnSave: TBitBtn;
    BtnBack: TBitBtn;
    BudEdtEntrance: TEdit;
    BudAst: TLabel;
    SupAst: TLabel;
    LuxAst: TLabel;
    SaveDialog: TSaveDialog;
    SupEdtEntrance: TEdit;
    LuxEdtEntrance: TEdit;
    BudEdtIgloo: TEdit;
    SupEdtIgloo: TEdit;
    LuxEdtIgloo: TEdit;
    SupEdtLength: TEdit;
    LuxEdtLength: TEdit;
    BudEdtRow: TEdit;
    SupEdtRow: TEdit;
    LuxEdtRow: TEdit;
    SupGroupBricks: TGroupBox;
    LuxGroupBricks: TGroupBox;
    SupGroupEntrance: TGroupBox;
    LuxGroupEntrance: TGroupBox;
    BudGroupIgloo: TGroupBox;
    SupGroupIgloo: TGroupBox;
    LuxGroupIgloo: TGroupBox;
    SupGroupLength: TGroupBox;
    LuxGroupLength: TGroupBox;
    SupGroupRow: TGroupBox;
    LuxGroupRow: TGroupBox;
    SupImgIgloo: TImage;
    LuxImgIgloo: TImage;
    BudLblEntrance: TLabel;
    SupLblEntrance: TLabel;
    LuxLblEntrance: TLabel;
    BudLblIgloo: TLabel;
    SupLblIgloo: TLabel;
    LuxLblIgloo: TLabel;
    SupLblInfo: TLabel;
    LuxLblInfo: TLabel;
    SupLblLength: TLabel;
    LuxLblLength: TLabel;
    BudLblR: TLabel;
    BudEdtLength: TEdit;
    SupLblR: TLabel;
    LuxLblR: TLabel;
    SupLstBricks: TValueListEditor;
    LuxLstBricks: TValueListEditor;
    EdtLength: TEdit;
    EdtSuperior: TEdit;
    EdtLuxury: TEdit;
    EdtRadius: TEdit;
    EdtBudget: TEdit;
    BudGroupRow: TGroupBox;
    BudGroupBricks: TGroupBox;
    BudGroupLength: TGroupBox;
    BudGroupEntrance: TGroupBox;
    GroupTotal: TGroupBox;
    GroupInput: TGroupBox;
    BudImgIgloo: TImage;
    BudLblLength: TLabel;
    BudLblInfo: TLabel;
    LblLength: TLabel;
    LblBricku: TLabel;
    LblSuperior: TLabel;
    LblM: TLabel;
    LblBricks: TLabel;
    LblN: TLabel;
    LblBrickt: TLabel;
    LblRadius: TLabel;
    LblBudget: TLabel;
    LblLuxury: TLabel;
    PgeCtrlResults: TPageControl;
    PnlUtils: TPanel;
    TabShtSuperior: TTabSheet;
    TabShtLuxury: TTabSheet;
    TabShtBudget: TTabSheet;
    BudLstBricks: TValueListEditor;
    procedure BtnAdvancedClick(Sender: TObject);
    procedure BtnBackClick(Sender: TObject);
    procedure BtnCloseClick(Sender: TObject);
    procedure BtnHelpClick(Sender: TObject);
    procedure BtnSaveClick(Sender: TObject);
    procedure BtnStandardClick(Sender: TObject);
    procedure FormCloseQuery(Sender: TObject; var CanClose: boolean);
    procedure FormKeyDown(Sender: TObject; var Key: word; Shift: TShiftState);
    procedure FormShow(Sender: TObject);
    procedure LoadBricks;
    procedure LoadValues;
  private
    { private declarations }
  public
    { public declarations }
  end;

var
  FrmResult: TFrmResult;
  C: boolean;
  L: boolean;
  LDirectory: string;

implementation

{$R *.lfm}

uses New, Main;

{ TFrmResult }

procedure TFrmResult.FormCloseQuery(Sender: TObject; var CanClose: boolean);
begin
  if not C then
  begin
    CanClose := True;
    FrmNew.Close;
  end;
  L := False;
  LDirectory := '';
end;

procedure TFrmResult.FormKeyDown(Sender: TObject; var Key: word; Shift: TShiftState);
begin
  if (Shift = [ssCtrl]) and (Key = VK_S) and (L = False) then
    BtnSaveClick(FrmResult);

end;

procedure TFrmResult.FormShow(Sender: TObject);
begin
  C := False;
  if GlobalVar.View then
    BtnAdvancedClick(FrmResult)
  else
    BtnStandardClick(FrmResult);
  if L then
  begin
    BtnSave.Enabled := False;
    Caption := LDirectory;
    BtnBack.Caption := 'Close';
  end
  else
  begin
    BtnSave.Enabled := True;
    Caption := 'Results';
    BtnBack.Caption := 'Back';
  end;
  MoveToDefaultPosition;
  PnlUtils.SetFocus;
  PgeCtrlResults.ActivePage := TabShtBudget;
  SaveDialog.InitialDir := GlobalVar.Directory;
  LoadValues;
  LoadBricks;
end;

procedure TFrmResult.LoadValues;
begin
  EdtRadius.Text := FloatToStr(GlobalVar.IglRadius);
  EdtLength.Text := FloatToStr(GlobalVar.IglLength);
  BudEdtRow.Text := IntToStr(GlobalVar.IglRows[0]);
  SupEdtRow.Text := IntToStr(GlobalVar.IglRows[1]);
  LuxEdtRow.Text := IntToStr(GlobalVar.IglRows[2]);
  BudEdtLength.Text := IntToStr(GlobalVar.IglTunnelLength[0]);
  SupEdtLength.Text := IntToStr(GlobalVar.IglTunnelLength[1]);
  LuxEdtLength.Text := IntToStr(GlobalVar.IglTunnelLength[2]);
  BudEdtEntrance.Text := IntToStr(GlobalVar.IglTunnelBricks[0]);
  SupEdtEntrance.Text := IntToStr(GlobalVar.IglTunnelBricks[1]);
  LuxEdtEntrance.Text := IntToStr(GlobalVar.IglTunnelBricks[2]);
  BudEdtIgloo.Text := IntToStr(GlobalVar.DomeTotal[0]);
  SupEdtIgloo.Text := IntToStr(GlobalVar.DomeTotal[1]);
  LuxEdtIgloo.Text := IntToStr(GlobalVar.DomeTotal[2]);
  EdtBudget.Text := IntToStr(GlobalVar.IglTotal[0]);
  EdtSuperior.Text := IntToStr(GlobalVar.IglTotal[1]);
  EdtLuxury.Text := IntToStr(GlobalVar.IglTotal[2]);
end;

procedure TFrmResult.LoadBricks;
var
  Count: integer;
begin
  {Bud}
  Count := 0;
  BudLstBricks.Strings.Clear;
  BudLstBricks.Strings.add('Top=' +
    (GlobalVar.BudBricks[GlobalVar.IglRows[0] - 1 - Count]));
  Count := Count + 1;
  repeat
    BudLstBricks.Strings.add(IntToStr(Count + 1) + '=' +
      (GlobalVar.BudBricks[GlobalVar.IglRows[0] - 1 - Count]));
    Count := Count + 1;
  until Count = GlobalVar.IglRows[0] - 1;
  BudLstBricks.Strings.add('Bottom=' +
    (GlobalVar.BudBricks[GlobalVar.IglRows[0] - 1 - Count]));
  BudLstBricks.RowCount := BudLstBricks.Strings.Count + 1;
  {Sup}
  Count := 0;
  SupLstBricks.Strings.Clear;
  SupLstBricks.Strings.add('Top=' +
    (GlobalVar.SupBricks[GlobalVar.IglRows[1] - 1 - Count]));
  Count := Count + 1;
  repeat
    SupLstBricks.Strings.add(IntToStr(Count + 1) + '=' +
      (GlobalVar.SupBricks[GlobalVar.IglRows[1] - 1 - Count]));
    Count := Count + 1;
  until Count = GlobalVar.IglRows[1] - 1;
  SupLstBricks.Strings.add('Bottom=' +
    (GlobalVar.SupBricks[GlobalVar.IglRows[1] - 1 - Count]));
  SupLstBricks.RowCount := SupLstBricks.Strings.Count + 1;
  {Lux}
  Count := 0;
  LuxLstBricks.Strings.Clear;
  LuxLstBricks.Strings.add('Top=' +
    (GlobalVar.LuxBricks[GlobalVar.IglRows[2] - 1 - Count]));
  Count := Count + 1;
  repeat
    LuxLstBricks.Strings.add(IntToStr(Count + 1) + '=' +
      (GlobalVar.LuxBricks[GlobalVar.IglRows[2] - 1 - Count]));
    Count := Count + 1;
  until Count = GlobalVar.IglRows[2] - 1;
  LuxLstBricks.Strings.add('Bottom=' +
    (GlobalVar.LuxBricks[GlobalVar.IglRows[2] - 1 - Count]));
  LuxLstBricks.RowCount := LuxLstBricks.Strings.Count + 1;
end;

procedure TFrmResult.BtnBackClick(Sender: TObject);
begin
  C := True;
  Close;
  FrmNew.Load;
end;

procedure TFrmResult.BtnCloseClick(Sender: TObject);
begin
  Close;
end;

procedure TFrmResult.BtnHelpClick(Sender: TObject);
begin
  FrmMain.Help('resultsform');
end;

procedure TFrmResult.BtnSaveClick(Sender: TObject);
begin
  SaveDialog.Filename := '';
  if SaveDialog.Execute then
    GlobalVar.IglSave(SaveDialog.FileName);
end;

procedure TFrmResult.BtnStandardClick(Sender: TObject);
begin
  Width := 506;
  Left := Left + 422;
  BtnAdvanced.Enabled := True;
  BtnStandard.Enabled := False;
end;

procedure TFrmResult.BtnAdvancedClick(Sender: TObject);
begin
  Width := 1350;
  Left := Left - 422;
  BtnStandard.Enabled := True;
  BtnAdvanced.Enabled := False;
end;

end.
