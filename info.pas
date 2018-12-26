unit Info;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, StdCtrls,
  ExtCtrls;

type

  { TFrmInfo }

  TFrmInfo = class(TForm)
    ImgInfo: TImage;
    MemInfo: TMemo;
  private
    { private declarations }
  public
    { public declarations }
  end;

var
  FrmInfo: TFrmInfo;

implementation

{$R *.lfm}

end.

