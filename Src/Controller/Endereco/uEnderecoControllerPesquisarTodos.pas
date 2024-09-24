unit uEnderecoControllerPesquisarTodos;

interface

uses
  System.SysUtils, System.Classes, System.JSON, System.Generics.Collections,
  uEndereco,
  uEnderecoServicePesquisarTodos, uEnderecoControllerJSONParser;

type
  TEnderecoControllerPesquisarTodos = class
  private
    EnderecoServicePesquisarTodos: TEnderecoServicePesquisarTodos;
  public
    constructor Create(EnderecoServicePesquisarTodos
      : TEnderecoServicePesquisarTodos);
    destructor Destroy; override;

    procedure PesquisarTodos(EnderecosJSON: TJSONArray);
  end;

implementation

{ TEnderecoControllerPesquisarTodos }

constructor TEnderecoControllerPesquisarTodos.Create
  (EnderecoServicePesquisarTodos: TEnderecoServicePesquisarTodos);
begin
  Self.EnderecoServicePesquisarTodos := EnderecoServicePesquisarTodos;
end;

destructor TEnderecoControllerPesquisarTodos.Destroy;
begin

  inherited;
end;

procedure TEnderecoControllerPesquisarTodos.PesquisarTodos
  (EnderecosJSON: TJSONArray);
var
  Enderecos: TList<TEndereco>;
  JSONObject: TJSONObject;
  i: Integer;
begin
  Enderecos := TList<TEndereco>.Create;

  try
    EnderecoServicePesquisarTodos.PesquisarTodos(Enderecos);

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
