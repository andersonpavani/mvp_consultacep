unit uEnderecoControllerJSONParser;

interface

uses
  System.SysUtils, System.Classes, System.JSON, uEndereco;

type
  TEnderecoControllerJSONParser = class
  public
    class procedure EnderecoToJsonObject(Endereco: TEndereco;
      JSONObject: TJSONObject);
    class procedure JsonObjectToEndereco(JSONObject: TJSONObject;
      Endereco: TEndereco);
  end;

implementation

{ TEnderecoControllerJSONParser }

class procedure TEnderecoControllerJSONParser.EnderecoToJsonObject
  (Endereco: TEndereco; JSONObject: TJSONObject);
begin
  JSONObject.AddPair('cep', Endereco.CEP);
  JSONObject.AddPair('logradouro', Endereco.Logradouro);
  JSONObject.AddPair('complemento', Endereco.Complemento);
  JSONObject.AddPair('bairro', Endereco.Bairro);
  JSONObject.AddPair('localidade', Endereco.Localidade);
  JSONObject.AddPair('uf', Endereco.UF);
end;

class procedure TEnderecoControllerJSONParser.JsonObjectToEndereco
  (JSONObject: TJSONObject; Endereco: TEndereco);
begin
  Endereco.CEP := JSONObject.GetValue<String>('cep');
  Endereco.Logradouro := JSONObject.GetValue<String>('logradouro');
  Endereco.Complemento := JSONObject.GetValue<String>('complemento');
  Endereco.Bairro := JSONObject.GetValue<String>('bairro');
  Endereco.Localidade := JSONObject.GetValue<String>('localidade');
  Endereco.UF := JSONObject.GetValue<String>('uf');
end;

end.
