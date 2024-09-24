unit uEnderecoWSControllerPesquisarCEP;

interface

uses
  System.SysUtils, System.Classes, System.JSON, uEnderecoWS,
  uEnderecoWSControllerJSONParser,
  uEnderecoWSServicePesquisarCEP;

type
  TEnderecoWSControllerPesquisarCEP = class
  private
    EnderecoWSServicePesquisarCEP: TEnderecoWSServicePesquisarCEP;
  public
    constructor Create(EnderecoWSServicePesquisarCEP
      : TEnderecoWSServicePesquisarCEP);
    destructor Destroy; override;

    function PesquisarCEP(const CEP: String;
      EnderecoWSJSON: TJSONObject): Boolean;
  end;

implementation

{ TEnderecoWSControllerPesquisarCEP }

constructor TEnderecoWSControllerPesquisarCEP.Create
  (EnderecoWSServicePesquisarCEP: TEnderecoWSServicePesquisarCEP);
begin
  Self.EnderecoWSServicePesquisarCEP := EnderecoWSServicePesquisarCEP;
end;

destructor TEnderecoWSControllerPesquisarCEP.Destroy;
begin

  inherited;
end;

function TEnderecoWSControllerPesquisarCEP.PesquisarCEP(const CEP: String;
  EnderecoWSJSON: TJSONObject): Boolean;
var
  EnderecoWS: TEnderecoWS;
begin
  Result := False;

  EnderecoWS := TEnderecoWS.Create;

  try
    if not EnderecoWSServicePesquisarCEP.PesquisarCEP(CEP, EnderecoWS) then
    begin
      Exit;
    end;

    TEnderecoWSControllerJSONParser.EnderecoWSToJsonObject(EnderecoWS,
      EnderecoWSJSON);

    Result := True;
  finally
    EnderecoWS.Free;
  end;
end;

end.
