unit About;

interface

uses Windows, SysUtils, Classes, Graphics, Forms, Controls, StdCtrls,
  Buttons, ExtCtrls, pngimage, ShellAPI;

type
  TAboutBox = class(TForm)
    Panel1: TPanel;
    ProgramIcon: TImage;
    ProductName: TLabel;
    Version: TLabel;
    Comments: TLabel;
    OKButton: TButton;
    blogLnl: TLinkLabel;
    LinkLabel1: TLinkLabel;
    procedure FormCreate(Sender: TObject);
    procedure blogLnlLinkClick(Sender: TObject; const Link: string;
      LinkType: TSysLinkType);
  private
    function Sto_GetFmtFileVersion(const FileName: string = '';
      const Fmt: string = '%d.%d.%d.%d'): string;
    { Private declarations }
  public
    { Public declarations }
  end;

var
  AboutBox: TAboutBox;

implementation

{$R *.dfm}

procedure TAboutBox.blogLnlLinkClick(Sender: TObject; const Link: string;
  LinkType: TSysLinkType);
begin
  ShellExecute(Handle, nil, PWideChar(Link), nil, nil, SW_NORMAL);
end;

procedure TAboutBox.FormCreate(Sender: TObject);
begin
  ProductName.Caption := Application.Title;
  Version.Caption := Version.Caption + ': ' + Sto_GetFmtFileVersion();
end;

/// <summary>
/// This function reads the file resource of "FileName" and returns
/// the version number as formatted text.</summary>
/// <example>
/// Sto_GetFmtFileVersion() = '4.13.128.0'
/// Sto_GetFmtFileVersion('', '%.2d-%.2d-%.2d') = '04-13-128'
/// </example>
/// <remarks>If "Fmt" is invalid, the function may raise an
/// EConvertError exception.</remarks>
/// <param name="FileName">Full path to exe or dll. If an empty
/// string is passed, the function uses the filename of the
/// running exe or dll.</param>
/// <param name="Fmt">Format string, you can use at most four integer
/// values.</param>
/// <returns>Formatted version number of file, '' if no version
/// resource found.</returns>
function TAboutBox.Sto_GetFmtFileVersion(const FileName: string = '';
  const Fmt: string = '%d.%d.%d.%d'): string;
var
  sFileName: string;
  iBufferSize: DWORD;
  iDummy: DWORD;
  pBuffer: Pointer;
  pFileInfo: Pointer;
  iVer: array [1 .. 4] of Word;
begin
  // set default value
  Result := '';
  // get filename of exe/dll if no filename is specified
  sFileName := FileName;
  if (sFileName = '') then
  begin
    // prepare buffer for path and terminating #0
    SetLength(sFileName, MAX_PATH + 1);
    SetLength(sFileName, GetModuleFileName(hInstance, PChar(sFileName),
        MAX_PATH + 1));
  end;
  // get size of version info (0 if no version info exists)
  iBufferSize := GetFileVersionInfoSize(PChar(sFileName), iDummy);
  if (iBufferSize > 0) then
  begin
    GetMem(pBuffer, iBufferSize);
    try
      // get fixed file info (language independent)
      GetFileVersionInfo(PChar(sFileName), 0, iBufferSize, pBuffer);
      VerQueryValue(pBuffer, '\', pFileInfo, iDummy);
      // read version blocks
      iVer[1] := HiWord(PVSFixedFileInfo(pFileInfo)^.dwFileVersionMS);
      iVer[2] := LoWord(PVSFixedFileInfo(pFileInfo)^.dwFileVersionMS);
      iVer[3] := HiWord(PVSFixedFileInfo(pFileInfo)^.dwFileVersionLS);
      iVer[4] := LoWord(PVSFixedFileInfo(pFileInfo)^.dwFileVersionLS);
    finally
      FreeMem(pBuffer);
    end;
    // format result string
    Result := Format(Fmt, [iVer[1], iVer[2], iVer[3], iVer[4]]);
  end;
end;

end.
