unit uRemoverCaracteresNaoNumericos;

interface

uses
  System.SysUtils;

function RemoverCaracteresNaoNumericos(const TextoOrigem: String): String;

implementation

function RemoverCaracteresNaoNumericos(const TextoOrigem: String): String;
var
  i: Integer;
  TextoNumerico: String;
begin
  TextoNumerico := EmptyStr;

  for i := 1 to Length(TextoOrigem) do
  begin
    if TextoOrigem[i] in ['0' .. '9'] then
      TextoNumerico := TextoNumerico + TextoOrigem[i];
  end;

  Result := TextoNumerico;
end;

end.
