unit Options;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Dialogs, ComCtrls,
  StdCtrls, Buttons, ExtCtrls, GlobalVar;

type

  { TFrmOptions }

  TFrmOptions = class(TForm)
    BtnHelp: TBitBtn;
    BtnSave: TButton;
    BtnCancel: TButton;
    BtnReset: TButton;
    BtnDirectory: TButton;
    ChkBoxReset: TCheckBox;
    ChkBoxDisplay: TCheckBox;
    ImgOptions: TImage;
    EdtDirectory: TLabeledEdit;
    PgeCtrlOptions: TPageControl;
    GroupView: TRadioGroup;
    SelectDirectoryDialog: TSelectDirectoryDialog;
    TbShtGeneral: TTabSheet;
    TbShtReset: TTabSheet;
    procedure BtnCancelClick(Sender: TObject);
    procedure BtnDirectoryClick(Sender: TObject);
    procedure BtnHelpClick(Sender: TObject);
    procedure BtnResetClick(Sender: TObject);
    procedure BtnSaveClick(Sender: TObject);
    procedure ChkBoxResetChange(Sender: TObject);
    procedure FormShow(Sender: TObject);
  private
    { private declarations }
  public
    { public declarations }
  end;

var
  FrmOptions: TFrmOptions;
  TempSettings: TStringList;
  IRadius: real;
  ILength: real;
  IBrick: string;

implementation

uses Main;

{$R *.lfm}

{ TFrmOptions }

procedure TFrmOptions.FormShow(Sender: TObject);
begin
  MoveToDefaultPosition;
  ChkBoxDisplay.Checked := GlobalVar.Display;
  EdtDirectory.Text := GlobalVar.Directory;
  ChkBoxReset.Checked := False;
  BtnReset.Enabled := False;
  PgeCtrlOptions.ActivePage := TbShtGeneral;
  if GlobalVar.View then
    GroupView.ItemIndex := 1
  else
    GroupView.ItemIndex := 0;
end;

procedure TFrmOptions.BtnSaveClick(Sender: TObject);
begin
  GlobalVar.Display := ChkBoxDisplay.Checked;
  GlobalVar.Directory := EdtDirectory.Text;
  if GroupView.ItemIndex = 1 then
    GlobalVar.View := True
  else
    GlobalVar.View := False;
  GlobalVar.SaveSettings;
  Close;
end;

procedure TFrmOptions.ChkBoxResetChange(Sender: TObject);
begin
  if ChkBoxReset.Checked = True then
    BtnReset.Enabled := True
  else
    BtnReset.Enabled := False;
end;

procedure TFrmOptions.BtnCancelClick(Sender: TObject);
begin
  Close;
end;

procedure TFrmOptions.BtnDirectoryClick(Sender: TObject);
begin
  if SelectDirectoryDialog.Execute then
    EdtDirectory.Text := SelectDirectoryDialog.Filename;
end;

procedure TFrmOptions.BtnHelpClick(Sender: TObject);
begin
  FrmMain.Help('optionsform');
end;

procedure TFrmOptions.BtnResetClick(Sender: TObject);
begin
  if ChkBoxReset.Checked = True then
  begin
    if MessageDlg('Reset', 'This will reset all settings to default' +
      sLineBreak + 'Are you sure you want to reset settings?', mtWarning,
      [mbYes, mbCancel], 0) = mrYes then
    begin
      DeleteFile(ChangeFileExt(Application.ExeName, '.ini'));
      GlobalVar.CreateSettings;
      Close;
    end;
  end;
end;

end.
