unit uEnderecoControllerPesquisarEndereco;

interface

uses
  System.SysUtils, System.Classes, System.JSON, System.Generics.Collections,
  uEndereco,
  uEnderecoServicePesquisarEndereco, uEnderecoControllerJSONParser;

type
  TEnderecoControllerPesquisarEndereco = class
  private
    EnderecoServicePesquisarEndereco: TEnderecoServicePesquisarEndereco;
  public
    constructor Create(EnderecoServicePesquisarEndereco
      : TEnderecoServicePesquisarEndereco);
    destructor Destroy; override;

    procedure PesquisarEndereco(const UF, Localidade, Logradouro: String;
      EnderecosJSON: TJSONArray);
  end;

implementation

{ TEnderecoControllerPesquisarEndereco }

constructor TEnderecoControllerPesquisarEndereco.Create
  (EnderecoServicePesquisarEndereco: TEnderecoServicePesquisarEndereco);
begin
  Self.EnderecoServicePesquisarEndereco := EnderecoServicePesquisarEndereco;
end;

destructor TEnderecoControllerPesquisarEndereco.Destroy;
begin

  inherited;
end;

procedure TEnderecoControllerPesquisarEndereco.PesquisarEndereco(const UF,
  Localidade, Logradouro: String; EnderecosJSON: TJSONArray);
var
  Enderecos: TList<TEndereco>;
  JSONObject: TJSONObject;
  i: Integer;
begin
  Enderecos := TList<TEndereco>.Create;

  try
    EnderecoServicePesquisarEndereco.PesquisarEndereco(UF, Localidade,
      Logradouro, Enderecos);

    for i := 0 to Pred(Enderecos.Count) do
    begin
      JSONObject := TJSONObject.Create;

      TEnderecoControllerJSONParser.EnderecoToJsonObject(Enderecos[i],
        JSONObject);

      EnderecosJSON.Add(JSONObject);
    end;
  finally
    Enderecos.Free;
  end;
end;

end.
