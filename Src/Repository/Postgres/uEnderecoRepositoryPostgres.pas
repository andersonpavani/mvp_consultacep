unit uEnderecoRepositoryPostgres;

interface

uses
  System.SysUtils, System.Classes, System.Generics.Collections,
  uConexaoPostgres, uEndereco, uEnderecoRepositoryProtocol,
  FireDAC.Stan.Intf, FireDAC.Stan.Option, FireDAC.Stan.Param,
  FireDAC.Stan.Error,
  FireDAC.DatS, FireDAC.Phys.Intf, FireDAC.DApt.Intf, FireDAC.Stan.Async,
  FireDAC.DApt, Data.DB,
  FireDAC.Comp.DataSet, FireDAC.Comp.Client;

type
  TEnderecoRepositoryPostgres = class(TInterfacedObject, IEnderecoRepository)
  private
    procedure QueryToEndereco(Query: TFDQuery; Endereco: TEndereco);
    procedure EnderecoToQueryParams(Endereco: TEndereco; Query: TFDQuery);
  public
    constructor Create;
    destructor Destroy; override;

    function PesquisarCEP(const CEP: String; Endereco: TEndereco): Boolean;
    procedure PesquisarEndereco(const UF, Localidade, Logradouro: String;
      Enderecos: TList<TEndereco>);
    procedure PersistirEnderecos(Enderecos: TList<TEndereco>);
    procedure PesquisarTodos(Enderecos: TList<TEndereco>);
  end;

implementation

{ TEnderecoRepositoryPostgres }

constructor TEnderecoRepositoryPostgres.Create;
begin

end;

destructor TEnderecoRepositoryPostgres.Destroy;
begin

  inherited;
end;

procedure TEnderecoRepositoryPostgres.EnderecoToQueryParams(Endereco: TEndereco;
  Query: TFDQuery);
begin
  Query.ParamByName('cep').AsString := Endereco.CEP;
  Query.ParamByName('logradouro').AsString := Endereco.Logradouro;
  Query.ParamByName('complemento').AsString := Endereco.Complemento;
  Query.ParamByName('bairro').AsString := Endereco.Bairro;
  Query.ParamByName('localidade').AsString := Endereco.Localidade;
  Query.ParamByName('uf').AsString := Endereco.UF;
end;

procedure TEnderecoRepositoryPostgres.PersistirEnderecos
  (Enderecos: TList<TEndereco>);
const
  UpsertSQL: String =
    'insert into endereco (cep, logradouro, complemento, bairro, localidade, uf) '
    + 'values (:cep, :logradouro, :complemento, :bairro, :localidade, :uf) ' +
    'on conflict (cep) ' +
    'do update set cep = excluded.cep, logradouro = excluded.logradouro, ' +
    '  complemento = excluded.complemento, bairro = excluded.bairro, ' +
    '  localidade = excluded.localidade, uf = excluded.uf ' +
    'returning codigo';

var
  Conexao: TFDConnection;
  Query: TFDQuery;
  Endereco: TEndereco;
begin
  Conexao := TConexaoPostgres.GetInstance.GetConexao;
  Query := TFDQuery.Create(nil);

  try
    Query.Connection := Conexao;
    Conexao.StartTransaction;

    try
      Query.SQL.Add(UpsertSQL);

      for Endereco in Enderecos do
      begin
        EnderecoToQueryParams(Endereco, Query);

        Query.Open;

        if Endereco.Codigo = 0 then
        begin
          Endereco.Codigo := Query.FieldByName('codigo').AsInteger;
        end;

        Query.Close;
      end;

      Conexao.Commit;
    except
      on E: Exception do
      begin
        Conexao.Rollback;
        raise;
      end;
    end;
  finally
    Query.Free;
    Conexao.Free;
  end;
end;

function TEnderecoRepositoryPostgres.PesquisarCEP(const CEP: String;
  Endereco: TEndereco): Boolean;
const
  SelectSQL: String =
    'select e.codigo, e.cep, e.logradouro, e.complemento, e.bairro, e.localidade, e.uf'
    + '  from endereco e' +
    ' where regexp_replace(e.cep, ''[^0-9]'', '''', ''g'') = :cep';

var
  Conexao: TFDConnection;
  Query: TFDQuery;

begin
  Result := False;

  Conexao := TConexaoPostgres.GetInstance.GetConexao;
  Query := TFDQuery.Create(nil);

  try
    Query.Connection := Conexao;

    Query.SQL.Add(SelectSQL);
    Query.ParamByName('cep').AsString := CEP;
    Query.Open;

    if Query.IsEmpty then
    begin
      Query.Close;
      Exit;
    end;

    QueryToEndereco(Query, Endereco);

    Query.Close;

    Result := True;
  finally
    Query.Free;
    Conexao.Free;
  end;

end;

procedure TEnderecoRepositoryPostgres.PesquisarEndereco(const UF, Localidade,
  Logradouro: String; Enderecos: TList<TEndereco>);
const
  SelectSQL: String =
    'select e.codigo, e.cep, e.logradouro, e.complemento, e.bairro, e.localidade, e.uf'
    + '  from endereco e' + ' where e.uf ilike :uf' +
    '   and e.localidade ilike :localidade' +
    '   and e.logradouro ilike :logradouro' + ' order by e.codigo';

var
  Conexao: TFDConnection;
  Query: TFDQuery;
  Endereco: TEndereco;
begin
  Conexao := TConexaoPostgres.GetInstance.GetConexao;
  Query := TFDQuery.Create(nil);

  try
    Query.Connection := Conexao;

    Query.SQL.Add(SelectSQL);
    Query.ParamByName('uf').AsString := UF;
    Query.ParamByName('localidade').AsString := '%' + Localidade + '%';
    Query.ParamByName('logradouro').AsString := '%' + Logradouro + '%';
    Query.Open;

    while not Query.Eof do
    begin
      Endereco := TEndereco.Create;

      QueryToEndereco(Query, Endereco);

      Enderecos.Add(Endereco);

      Query.Next;
    end;

    Query.Close;
  finally
    Query.Free;
    Conexao.Free;
  end;

end;

procedure TEnderecoRepositoryPostgres.PesquisarTodos
  (Enderecos: TList<TEndereco>);
const
  SelectSQL: String =
    'select e.codigo, e.cep, e.logradouro, e.complemento, e.bairro, e.localidade, e.uf'
    + '  from endereco e' + ' order by e.codigo';

var
  Conexao: TFDConnection;
  Query: TFDQuery;
  Endereco: TEndereco;
begin
  Conexao := TConexaoPostgres.GetInstance.GetConexao;
  Query := TFDQuery.Create(nil);

  try
    Query.Connection := Conexao;

    Query.SQL.Add(SelectSQL);
    Query.Open;

    while not Query.Eof do
    begin
      Endereco := TEndereco.Create;

      QueryToEndereco(Query, Endereco);

      Enderecos.Add(Endereco);

      Query.Next;
    end;

    Query.Close;
  finally
    Query.Free;
    Conexao.Free;
  end;
end;

procedure TEnderecoRepositoryPostgres.QueryToEndereco(Query: TFDQuery;
  Endereco: TEndereco);
begin
  Endereco.Codigo := Query.FieldByName('codigo').AsInteger;
  Endereco.CEP := Query.FieldByName('cep').AsString;
  Endereco.Logradouro := Query.FieldByName('logradouro').AsString;
  Endereco.Complemento := Query.FieldByName('complemento').AsString;
  Endereco.Bairro := Query.FieldByName('bairro').AsString;
  Endereco.Localidade := Query.FieldByName('localidade').AsString;
  Endereco.UF := Query.FieldByName('uf').AsString;
end;

end.
