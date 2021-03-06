unit New;

{$mode objfpc}{$H+}

interface

uses
  SysUtils, Forms, Dialogs, StdCtrls, ComCtrls, GlobalVar, Result;

type

  { TFrmNew }

  TFrmNew = class(TForm)
    BtnCalculate: TButton;
    BtnCancel: TButton;
    EdtLength: TEdit;
    EdtRadius: TEdit;
    LblInfo: TLabel;
    LblLength: TLabel;
    LblM: TLabel;
    LblN: TLabel;
    LblRadius: TLabel;
    PrgBar: TProgressBar;
    procedure BtnCalculateClick(Sender: TObject);
    procedure BtnCancelClick(Sender: TObject);
    procedure EdtLengthEditingDone(Sender: TObject);
    procedure EdtLengthKeyPress(Sender: TObject; var Key: char);
    procedure EdtRadiusEditingDone(Sender: TObject);
    procedure EdtRadiusKeyPress(Sender: TObject; var Key: char);
    procedure FormClose(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure Load;
    procedure Next;
  private
    { private declarations }
  public
    { public declarations }
  end;

var
  FrmNew: TFrmNew;

implementation


{$R *.lfm}

{ TFrmNew }

procedure TFrmNew.FormShow(Sender: TObject);
begin  {Clear Variables before new calculation}
  GlobalVar.NewClear;
  Load;
  MoveToDefaultPosition;
  EdtRadius.Text := '';
  EdtLength.Text := '';
  EdtRadius.SetFocus;
end;

procedure TFrmNew.Load;
begin
  BtnCalculate.Visible := True;
  BtnCancel.Visible := True;
  Enabled := True;
  PrgBar.Visible := False;
end;

procedure TFrmNew.EdtRadiusEditingDone(Sender: TObject);
begin
  if EdtRadius.Text <> '' then
  begin {Convert to 2 d.p.}
    try
      EdtRadius.Text := FormatFloat('0.##', StrToFloat(EdtRadius.Text));
      GlobalVar.IglRadius := StrToFloat(EdtRadius.Text);
      if (GlobalVar.IglRadius > 1000) or (GlobalVar.IglRadius < 0.50) then
        raise Exception.Create('Invalid Number');
    except  {Invalid Number Error}
      begin
        MessageDlg('Invalid Number',
          'Please enter a radius between 0.50 and 1000 metres',
          mtInformation, [mbOK], 0);
        EdtRadius.Text := '';
        GlobalVar.IglRadius := 0;
        EdtRadius.SetFocus;
      end;
    end;
  end;
end;

procedure TFrmNew.EdtRadiusKeyPress(Sender: TObject; var Key: char);
begin {Goto next control}
  if key = #13 then
    EdtLength.SetFocus;
end;

procedure TFrmNew.FormClose(Sender: TObject);
begin {Clear var on exit}
  GlobalVar.IglClear;
  FrmNew.Enabled := True;
end;

procedure TFrmNew.BtnCancelClick(Sender: TObject);
begin
  Close;
end;

procedure TFrmNew.BtnCalculateClick(Sender: TObject);
begin {Check if fields entered}
  if (EdtLength.Text = '') or (EdtRadius.Text = '') then
  begin
    MessageDlg('Blank Fields',
      'Please enter the Internal Radius and Entrance Length',
      mtInformation, [mbOK], 0);
    EdtRadius.SetFocus;
  end
  else
  begin
    try
      Next;
      GlobalVar.Calculate;
      FrmResult.ShowModal;
    except
      MessageDlg('Error', 'Error: C01 - Calculation did not succeed.' +
        sLineBreak + 'Please check the entered values and try again.', mtError,
        [mbOK], 0);
    end;
  end;
end;

procedure TFrmNew.Next;
begin
  Enabled := False;
  BtnCalculate.Visible := False;
  BtnCancel.Visible := False;
  PrgBar.Visible := True;
  Update;
end;

procedure TFrmNew.EdtLengthEditingDone(Sender: TObject);
begin
  if EdtLength.Text <> '' then
  begin {Convert to 2 d.p.}
    try
      EdtLength.Text := FormatFloat('0.##', StrToFloat(EdtLength.Text));
      GlobalVar.IglLength := StrToFloat(EdtLength.Text);
      if (GlobalVar.IglLength > 100) or (GlobalVar.IglLength < 0.10) then
        raise Exception.Create('Invalid Number');
    except  {Invalid Number Error}
      begin
        MessageDlg('Invalid Number',
          'Please enter a length between 0.10 and 100 metres', mtInformation, [mbOK], 0);
        EdtLength.Text := '';
        GlobalVar.IglLength := 0;
        EdtLength.SetFocus;
      end;
    end;
  end;
end;

procedure TFrmNew.EdtLengthKeyPress(Sender: TObject; var Key: char);
begin {Goto next control}
  if key = #13 then
    BtnCalculate.SetFocus;
end;

end.
