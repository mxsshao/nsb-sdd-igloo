unit Main;

{$mode objfpc}{$H+}

interface

uses
  Forms, Dialogs, ExtCtrls, Menus, Buttons, GlobalVar, Options, New,
  LazHelpHTML, HelpIntfs, Result, Info, Classes;

type

  { TFrmMain }

  TFrmMain = class(TForm)
    BtnClose: TBitBtn;
    BtnInfo: TBitBtn;
    BtnHelp: TBitBtn;
    BtnLoad: TBitBtn;
    BtnNew: TBitBtn;
    BtnOptions: TBitBtn;
    HTMLBrowserHelpViewer: THTMLBrowserHelpViewer;
    HTMLHelpDatabase: THTMLHelpDatabase;
    ImgBack: TImage;
    MnuItemBreal: TMenuItem;
    MnuItemHelp: TMenuItem;
    MnuItemBreak: TMenuItem;
    MnuItemNew: TMenuItem;
    MnuItmLoad: TMenuItem;
    MnuItmOptions: TMenuItem;
    MnuItmClose: TMenuItem;
    MnuItmFile: TMenuItem;
    MnuMain: TMainMenu;
    OpenDialog: TOpenDialog;
    PnlMain: TPanel;
    procedure BtnCloseClick(Sender: TObject);
    procedure BtnHelpClick(Sender: TObject);
    procedure BtnInfoClick(Sender: TObject);
    procedure BtnLoadClick(Sender: TObject);
    procedure BtnNewClick(Sender: TObject);
    procedure BtnOptionsClick(Sender: TObject);
    procedure FormResize(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure MnuItemHelpClick(Sender: TObject);
    procedure MnuItemNewClick(Sender: TObject);
    procedure MnuItmCloseClick(Sender: TObject);
    procedure MnuItmLoadClick(Sender: TObject);
    procedure MnuItmOptionsClick(Sender: TObject);
    procedure Help(URL: String);
  private
    { private declarations }
  public
    { public declarations }
  end;

var
  FrmMain: TFrmMain;


implementation

{$R *.lfm}

{ TFrmMain }

procedure TFrmMain.MnuItmOptionsClick(Sender: TObject);
begin
  BtnOptionsClick(MnuItmOptions);
end;

procedure TFrmMain.MnuItmCloseClick(Sender: TObject);
begin
  Close;
end;

procedure TFrmMain.MnuItmLoadClick(Sender: TObject);
begin
  BtnLoadClick(MnuItmLoad);
end;

procedure TFrmMain.BtnNewClick(Sender: TObject);
begin
  FrmNew.ShowModal;
end;

procedure TFrmMain.BtnHelpClick(Sender: TObject);
begin
  Help('index');
end;

procedure TFrmMain.BtnInfoClick(Sender: TObject);
begin
  FrmInfo.ShowModal;
end;

procedure TFrmMain.BtnLoadClick(Sender: TObject);
begin
  OpenDialog.InitialDir := GlobalVar.Directory;
  OpenDialog.FileName := '';
  if OpenDialog.Execute then
  begin
    try
    GlobalVar.IglLoad(OpenDialog.Filename);
    Result.L := True;
    Result.LDirectory := OpenDialog.Filename;
    FrmResult.ShowModal;
    except

    end;
  end;
end;

procedure TFrmMain.BtnCloseClick(Sender: TObject);
begin
  Close;
end;

procedure TFrmMain.Help(URL: String);
begin
  ShowHelpOrErrorForKeyword('','HTML/' + URL + '.html');
end;

procedure TFrmMain.BtnOptionsClick(Sender: TObject);
begin
  FrmOptions.ShowModal;
end;

procedure TFrmMain.FormResize(Sender: TObject);
begin
  PnlMain.Top := (Trunc(FrmMain.Height/2) - 200);
  PnlMain.Left := (Trunc(FrmMain.Width/2) - 230);
  ImgBack.Top := (Trunc(FrmMain.Height/2) - 540);
  ImgBack.Left := (Trunc(FrmMain.Width/2) - 960);
end;

procedure TFrmMain.FormShow(Sender: TObject);
begin
  GlobalVar.BudBricks := TStringList.Create;
  GlobalVar.SupBricks := TStringList.Create;
  GlobalVar.LuxBricks := TStringList.Create;

  if GlobalVar.SetEnabled = False then
  begin
    MnuItmOptions.Enabled := False;
    BtnOptions.Enabled := False;
  end;
  FormResize(FrmMain);
  PnlMain.SetFocus;
end;

procedure TFrmMain.MnuItemHelpClick(Sender: TObject);
begin
  BtnHelpClick(MnuItemHelp);
end;

procedure TFrmMain.MnuItemNewClick(Sender: TObject);
begin
  BtnNewClick(MnuItemNew);
end;

end.

