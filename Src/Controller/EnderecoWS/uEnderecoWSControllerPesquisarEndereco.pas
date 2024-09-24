unit uEnderecoWSControllerPesquisarEndereco;

interface

uses
  System.SysUtils, System.Classes, System.JSON, System.Generics.Collections,
  uEnderecoWS,
  uEnderecoWSControllerJSONParser, uEnderecoWSServicePesquisarEndereco;

type
  TEnderecoWSControllerPesquisarEndereco = class
  private
    EnderecoWSServicePesquisarEndereco: TEnderecoWSServicePesquisarEndereco;
  public
    constructor Create(EnderecoWSServicePesquisarEndereco
      : TEnderecoWSServicePesquisarEndereco);
    destructor Destroy; override;

    procedure PesquisarEndereco(const UF, Localidade, Logradouro: String;
      EnderecosWSJSON: TJSONArray);
  end;

implementation

{ TEnderecoWSControllerPesquisarEndereco }

constructor TEnderecoWSControllerPesquisarEndereco.Create
  (EnderecoWSServicePesquisarEndereco: TEnderecoWSServicePesquisarEndereco);
begin
  Self.EnderecoWSServicePesquisarEndereco := EnderecoWSServicePesquisarEndereco;
end;

destructor TEnderecoWSControllerPesquisarEndereco.Destroy;
begin

  inherited;
end;

procedure TEnderecoWSControllerPesquisarEndereco.PesquisarEndereco(const UF,
  Localidade, Logradouro: String; EnderecosWSJSON: TJSONArray);
var
  EnderecosWS: TList<TEnderecoWS>;
  JSONObject: TJSONObject;
  i: Integer;
begin
  EnderecosWS := TList<TEnderecoWS>.Create;

  try
    EnderecoWSServicePesquisarEndereco.PesquisarEndereco(UF, Localidade,
      Logradouro, EnderecosWS);

    for i := 0 to Pred(EnderecosWS.Count) do
    begin
      JSONObject := TJSONObject.Create;

      TEnderecoWSControllerJSONParser.EnderecoWSToJsonObject(EnderecosWS[i],
        JSONObject);

      EnderecosWSJSON.Add(JSONObject);
    end;
  finally
    EnderecosWS.Free;
  end;
end;

end.
