unit uEnderecoControllerPersistirEnderecos;

interface

uses
  System.SysUtils, System.Classes, System.Generics.Collections, System.JSON,
  uEndereco,
  uEnderecoServicePersistirEnderecos, uEnderecoControllerJSONParser;

type
  TEnderecoControllerPersistirEnderecos = class
  private
    EnderecoServicePersistirEnderecos: TEnderecoServicePersistirEnderecos;
  public
    constructor Create(EnderecoServicePersistirEnderecos
      : TEnderecoServicePersistirEnderecos);
    destructor Destroy; override;

    procedure PersistirEnderecos(EnderecosJSON: TJSONArray);
  end;

implementation

{ TEnderecoControllerPersistirEnderecos }

constructor TEnderecoControllerPersistirEnderecos.Create
  (EnderecoServicePersistirEnderecos: TEnderecoServicePersistirEnderecos);
begin
  Self.EnderecoServicePersistirEnderecos := EnderecoServicePersistirEnderecos;
end;

destructor TEnderecoControllerPersistirEnderecos.Destroy;
begin

  inherited;
end;

procedure TEnderecoControllerPersistirEnderecos.PersistirEnderecos
  (EnderecosJSON: TJSONArray);
var
  Enderecos: TList<TEndereco>;
  Endereco: TEndereco;
  EnderecoJSON: TJSONObject;
  i: Integer;
begin
  Enderecos := TList<TEndereco>.Create;

  try
    for i := 0 to Pred(EnderecosJSON.Count) do
    begin
      Endereco := TEndereco.Create;

      TEnderecoControllerJSONParser.JsonObjectToEndereco
        (EnderecosJSON[i] as TJSONObject, Endereco);

      Enderecos.Add(Endereco);
    end;

    EnderecoServicePersistirEnderecos.PersistirEnderecos(Enderecos);

    while EnderecosJSON.Count > 0 do
    begin
      EnderecosJSON.Remove(0);
    end;

    for i := 0 to Pred(Enderecos.Count) do
    begin
      EnderecoJSON := TJSONObject.Create;

      TEnderecoControllerJSONParser.EnderecoToJsonObject(Enderecos[i],
        EnderecoJSON);

      EnderecosJSON.Add(EnderecoJSON);
    end;
  finally
    Enderecos.Free;
  end;
end;

end.
