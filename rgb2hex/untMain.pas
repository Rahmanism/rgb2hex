unit untMain;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls, Buttons, ActnList, ImgList, StdActns, Mask;

type
  TMainForm = class(TForm)
    dr: TEdit;
    dg: TEdit;
    db: TEdit;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Bevel1: TBevel;
    hr: TEdit;
    hg: TEdit;
    hb: TEdit;
    Label5: TLabel;
    Label6: TLabel;
    Label7: TLabel;
    Label8: TLabel;
    Bevel2: TBevel;
    hexRGB: TEdit;
    Label9: TLabel;
    bbnToHex: TBitBtn;
    bbnToRGB: TBitBtn;
    bbnHexToRGB: TBitBtn;
    ActionList1: TActionList;
    actToHex: TAction;
    actToRGB: TAction;
    actHexToRGB: TAction;
    bbnCopyHex: TBitBtn;
    bbnExit: TBitBtn;
    FileExit1: TFileExit;
    actCopyHexRGB: TAction;
    bbnAbout: TBitBtn;
    actAbout: TAction;
    ShowColorLbl: TLabel;
    ColorDialog1: TColorDialog;
    ImageList1: TImageList;
    Bevel3: TBevel;
    OnTopChb: TCheckBox;
    procedure drKeyPress(Sender: TObject; var Key: Char);
    procedure drExit(Sender: TObject);
    procedure hrKeyPress(Sender: TObject; var Key: Char);
    procedure hrExit(Sender: TObject);
    procedure hexRGBExit(Sender: TObject);
    procedure actToHexExecute(Sender: TObject);
    procedure actToRGBExecute(Sender: TObject);
    procedure actHexToRGBExecute(Sender: TObject);
    procedure actCopyHexRGBExecute(Sender: TObject);
    procedure actAboutExecute(Sender: TObject);
    procedure drChange(Sender: TObject);
    procedure hrChange(Sender: TObject);
    procedure hexRGBChange(Sender: TObject);
    procedure ShowColorLblClick(Sender: TObject);
    procedure OnTopChbClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  private
    function ZeroIfNull(n: string): string;
    function GetHex(n: string): Integer;
    { Private declarations }
  public
    { Public declarations }
  end;

  TBeforeAfter = (baBefore, baAfter);

function AddZero(c: string; n: Byte): string; overload;
function AddZero(c: string; n: Byte; AfterBefore: TBeforeAfter): string;
  overload;

var
  MainForm: TMainForm;

implementation

uses ABOUT;
{$R *.dfm}

function AddZero(c: string; n: Byte): string;
var
  i: Byte;
begin
  Result := c;
  if Length(c) < n then
  begin
    for i := 1 to n - Length(c) do
      Result := '0' + Result;
  end;
end;

function AddZero(c: string; n: Byte; AfterBefore: TBeforeAfter): string;
var
  i: Byte;
begin
  Result := c;
  if Length(c) < n then
  begin
    if AfterBefore = baAfter then
    begin
      for i := 1 to n - Length(c) do
        Result := Result + '0';
    end
    else if AfterBefore = baBefore then
    begin
      for i := 1 to n - Length(c) do
        Result := '0' + Result;
    end;
  end;
end;

procedure TMainForm.actHexToRGBExecute(Sender: TObject);
begin
  hr.Text := AddZero(Copy(hexRGB.Text, 1, 2), 2);
  hg.Text := AddZero(Copy(hexRGB.Text, 3, 2), 2);
  hb.Text := AddZero(Copy(hexRGB.Text, 5, 2), 2);
  actToRGB.Execute;
end;

procedure TMainForm.actAboutExecute(Sender: TObject);
begin
  AboutBox := TAboutBox.Create(Self);
  AboutBox.ShowModal;
  FreeAndNil(AboutBox);
end;

procedure TMainForm.actCopyHexRGBExecute(Sender: TObject);
begin
  with hexRGB do
  begin
    SelectAll;
    CopyToClipboard;
  end;
end;

procedure TMainForm.actToHexExecute(Sender: TObject);
begin
  hr.Text := AddZero(Format('%x', [StrToInt(AddZero(Trim(dr.Text), 2))]), 2);
  hg.Text := AddZero(Format('%x', [StrToInt(AddZero(Trim(dg.Text), 2))]), 2);
  hb.Text := AddZero(Format('%x', [StrToInt(AddZero(Trim(db.Text), 2))]), 2);
  hexRGB.Text := hr.Text + hg.Text + hb.Text;
end;

procedure TMainForm.actToRGBExecute(Sender: TObject);
var
  hexr, hexg, hexb: string;
  hexRGBCh: TNotifyEvent;
begin
  hexr := AddZero(Trim(hr.Text), 2);
  hexg := AddZero(Trim(hg.Text), 2);
  hexb := AddZero(Trim(hb.Text), 2);
  hexRGBCh := hexRGB.OnChange;
  hexRGB.OnChange := nil;
  hexRGB.Text := hexr + hexg + hexb;
  hexRGB.OnChange := hexRGBCh;
  dr.Text := AddZero(Format('%d', [StrToInt(HexDisplayPrefix + hexr)]), 0);
  dg.Text := AddZero(Format('%d', [StrToInt(HexDisplayPrefix + hexg)]), 0);
  db.Text := AddZero(Format('%d', [StrToInt(HexDisplayPrefix + hexb)]), 0);
end;

procedure TMainForm.drChange(Sender: TObject);
begin
  ShowColorLbl.Color := rgb(StrToInt(AddZero(dr.Text, 2)), StrToInt
      (AddZero(dg.Text, 2)), StrToInt(AddZero(db.Text, 2)));
end;

procedure TMainForm.drExit(Sender: TObject);
var
  sText: string;
begin
  sText := AddZero(Trim((Sender as TEdit).Text), 1);
  if StrToInt(sText) > 255 then (Sender as TEdit)
    .Text := '255'
  else if StrToInt(sText) < 0 then (Sender as TEdit)
    .Text := '0';
end;

procedure TMainForm.drKeyPress(Sender: TObject; var Key: Char);
begin
  if not(Key in ['0' .. '9', #13, #8, #37, #32, #46, #39]) then
    Key := #0;
  if Key = #13 then
    Self.Perform(7388420, vk_Tab, 0);
end;

procedure TMainForm.FormCreate(Sender: TObject);
begin
  Screen.Cursors[1] := LoadCursor(0, IDC_HAND);
end;

procedure TMainForm.hexRGBChange(Sender: TObject);
var
  hexRGBCode: string;
begin
  hexRGBCode := Trim(hexRGB.Text);
  hexRGBCode := AddZero(hexRGBCode, 6, baAfter);
  ShowColorLbl.Color := rgb(GetHex(hexRGBCode[1] + hexRGBCode[2]), GetHex
      (hexRGBCode[3] + hexRGBCode[4]), GetHex(hexRGBCode[5] + hexRGBCode[6]));
end;

procedure TMainForm.hexRGBExit(Sender: TObject);
var
  sText: string;
begin
  sText := AddZero(Trim((Sender as TEdit).Text), 2);
  if StrToInt64(HexDisplayPrefix + sText) > 16777215 then (Sender as TEdit)
    .Text := 'FFFFFF'
  else if StrToInt(HexDisplayPrefix + sText) < 0 then (Sender as TEdit)
    .Text := '000000';
end;

function TMainForm.ZeroIfNull(n: string): string;
begin
  if Trim(n) = '' then
    Result := '00'
  else
    Result := n;
end;

function TMainForm.GetHex(n: string): Integer;
begin
  Result := StrToInt('0x' + ZeroIfNull(n));
end;

procedure TMainForm.hrChange(Sender: TObject);
begin
  ShowColorLbl.Color := rgb(GetHex(hr.Text), GetHex(hg.Text), GetHex(hb.Text));
end;

procedure TMainForm.hrExit(Sender: TObject);
var
  sText: string;
begin
  sText := AddZero(Trim((Sender as TEdit).Text), 2);
  if StrToInt(HexDisplayPrefix + sText) > 255 then (Sender as TEdit)
    .Text := 'FF'
  else if StrToInt(HexDisplayPrefix + sText) < 0 then (Sender as TEdit)
    .Text := '00';
end;

procedure TMainForm.hrKeyPress(Sender: TObject; var Key: Char);
begin
  if not(Key in ['0' .. '9', #13, #8, #37, #32, #46, #39, 'A' .. 'F',
    'a' .. 'f']) then
    Key := #0
  else if Key in ['a' .. 'f'] then
    Key := Chr(Ord(Key) - 32);
  if Key = #13 then
    Self.Perform(7388420, vk_Tab, 0);
end;

procedure TMainForm.OnTopChbClick(Sender: TObject);
begin
  if OnTopChb.Checked then
    Self.FormStyle := fsStayOnTop
  else
    Self.FormStyle := fsNormal;
end;

procedure TMainForm.ShowColorLblClick(Sender: TObject);
var
  selectedColor: string;
begin
  if ColorDialog1.Execute then
  begin
    ShowColorLbl.Color := ColorDialog1.Color;
    selectedColor := string(IntToHex(ColorToRGB(ColorDialog1.Color), 8));
    hr.Text := selectedColor[7] + selectedColor[8];
    hg.Text := selectedColor[5] + selectedColor[6];
    hb.Text := selectedColor[3] + selectedColor[4];
    actToRGBExecute(Sender);
  end;
end;

end.
