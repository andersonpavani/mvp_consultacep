unit uEnderecoWSControllerJSONParser;

interface

uses
  System.SysUtils, System.Classes, System.JSON, uEnderecoWS;

type
  TEnderecoWSControllerJSONParser = class
  public
    class procedure EnderecoWSToJsonObject(EnderecoWS: TEnderecoWS;
      JSONObject: TJSONObject);
    class procedure JsonObjectToEnderecoWS(JSONObject: TJSONObject;
      EnderecoWS: TEnderecoWS);
  end;

implementation

{ TEnderecoWSControllerJSONParser }

class procedure TEnderecoWSControllerJSONParser.EnderecoWSToJsonObject
  (EnderecoWS: TEnderecoWS; JSONObject: TJSONObject);
begin
  JSONObject.AddPair('cep', EnderecoWS.CEP);
  JSONObject.AddPair('logradouro', EnderecoWS.Logradouro);
  JSONObject.AddPair('complemento', EnderecoWS.Complemento);
  JSONObject.AddPair('bairro', EnderecoWS.Bairro);
  JSONObject.AddPair('localidade', EnderecoWS.Localidade);
  JSONObject.AddPair('uf', EnderecoWS.UF);
end;

class procedure TEnderecoWSControllerJSONParser.JsonObjectToEnderecoWS
  (JSONObject: TJSONObject; EnderecoWS: TEnderecoWS);
begin
  EnderecoWS.CEP := JSONObject.GetValue<String>('cep');
  EnderecoWS.Logradouro := JSONObject.GetValue<String>('logradouro');
  EnderecoWS.Complemento := JSONObject.GetValue<String>('complemento');
  EnderecoWS.Bairro := JSONObject.GetValue<String>('bairro');
  EnderecoWS.Localidade := JSONObject.GetValue<String>('localidade');
  EnderecoWS.UF := JSONObject.GetValue<String>('uf');
end;

end.
