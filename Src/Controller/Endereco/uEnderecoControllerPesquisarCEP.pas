unit uEnderecoControllerPesquisarCEP;

interface

uses
  System.SysUtils, System.Classes, System.JSON, System.Generics.Collections,
  uEndereco,
  uEnderecoServicePesquisarCEP, uEnderecoControllerJSONParser;

type
  TEnderecoControllerPesquisarCEP = class
  private
    EnderecoServicePesquisarCEP: TEnderecoServicePesquisarCEP;
  public
    constructor Create(EnderecoServicePesquisarCEP
      : TEnderecoServicePesquisarCEP);
    destructor Destroy; override;

    function PesquisarCEP(const CEP: String; EnderecoJSON: TJSONObject)
      : Boolean;
  end;

implementation

{ TEnderecoControllerPesquisarCEP }

constructor TEnderecoControllerPesquisarCEP.Create(EnderecoServicePesquisarCEP
  : TEnderecoServicePesquisarCEP);
begin
  Self.EnderecoServicePesquisarCEP := EnderecoServicePesquisarCEP;
end;

destructor TEnderecoControllerPesquisarCEP.Destroy;
begin

  inherited;
end;

function TEnderecoControllerPesquisarCEP.PesquisarCEP(const CEP: String;
  EnderecoJSON: TJSONObject): Boolean;
var
  Endereco: TEndereco;
begin
  Result := False;

  Endereco := TEndereco.Create;

  try
    if not EnderecoServicePesquisarCEP.PesquisarCEP(CEP, Endereco) then
    begin
      Exit;
    end;

    TEnderecoControllerJSONParser.EnderecoToJsonObject(Endereco, EnderecoJSON);

    Result := True;
  finally
    Endereco.Free;
  end;
end;

end.
