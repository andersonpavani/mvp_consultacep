unit uConexaoPostgres;

interface

uses
  System.SysUtils, System.Classes, Forms, FireDAC.Phys.PGDef, FireDAC.Stan.Intf,
  FireDAC.Phys, FireDAC.Phys.PG,
  FireDAC.Stan.Option, FireDAC.Stan.Error, FireDAC.UI.Intf, FireDAC.Phys.Intf,
  FireDAC.Stan.Def,
  FireDAC.Stan.Pool, FireDAC.Stan.Async, FireDAC.VCLUI.Wait, Data.DB,
  FireDAC.Comp.Client, IniFiles;

type
  TConexaoPostgres = class
  private
  class var
    FInstance: TConexaoPostgres;
    FDPhysPgDriverLink: TFDPhysPgDriverLink;

    FLibPath: String;
    FServer: String;
    FPort: Integer;
    FDatabase: String;
    FUserName: String;
    FPassword: String;

    constructor Create;

    procedure CarregarConfiguracoes;
  public
    destructor Destroy; override;
    class function GetInstance: TConexaoPostgres;
    function GetConexao: TFDConnection;
    procedure CriarEstruturaBase;
  end;

implementation

{ TConexaoPostgres }

procedure TConexaoPostgres.CarregarConfiguracoes;
var
  ArquivoINI: TIniFile;
begin
  // TODO - A senha deverá ser armazenada criptografada no arquivo de configuração

  ArquivoINI := TIniFile.Create(ExtractFilePath(Application.ExeName) +
    'Config.ini');

  try
    FLibPath := ArquivoINI.ReadString('POSTGRES', 'LIBPATH', 'libpq.dll');
    FServer := ArquivoINI.ReadString('POSTGRES', 'SERVER', '127.0.0.1');
    FPort := ArquivoINI.ReadInteger('POSTGRES', 'PORT', 5432);
    FDatabase := ArquivoINI.ReadString('POSTGRES', 'DATABASE', 'ConsultaCEP');
    FUserName := ArquivoINI.ReadString('POSTGRES', 'USERNAME', 'postgres');
    FPassword := ArquivoINI.ReadString('POSTGRES', 'PASSWORD', 'postgres');
  finally
    ArquivoINI.Free;
  end;
end;

constructor TConexaoPostgres.Create;
begin
  FDPhysPgDriverLink := TFDPhysPgDriverLink.Create(nil);

  CarregarConfiguracoes;

  FDPhysPgDriverLink.VendorLib := FLibPath;

  CriarEstruturaBase;
end;

procedure TConexaoPostgres.CriarEstruturaBase;
const
  ScriptBase: String = 'CREATE TABLE IF NOT EXISTS public.endereco (' +
    '  codigo bigserial NOT NULL,' + '  cep varchar(9) NOT NULL,' +
    '  logradouro text NOT NULL,' + '  complemento text NULL,' +
    '  bairro text NULL,' + '  localidade text NOT NULL,' +
    '  uf varchar(2) NOT NULL,' +
    '  CONSTRAINT endereco_cep_unique UNIQUE (cep),' +
    '  CONSTRAINT endereco_pk PRIMARY KEY (codigo)' + ');';

var
  Conexao: TFDConnection;
  Query: TFDQuery;
begin
  Conexao := GetConexao;
  Query := TFDQuery.Create(nil);

  try
    Query.Connection := Conexao;
    Query.SQL.Add(ScriptBase);
    Query.ExecSQL;
  finally
    Query.Free;
    Conexao.Free;
  end;
end;

destructor TConexaoPostgres.Destroy;
begin
  FDPhysPgDriverLink.Free;
  inherited;
end;

function TConexaoPostgres.GetConexao: TFDConnection;
var
  Conexao: TFDConnection;
begin
  Conexao := TFDConnection.Create(nil);
  Conexao.LoginPrompt := False;
  Conexao.DriverName := 'PG';

  Conexao.Params.Values['Server'] := FServer;
  Conexao.Params.Values['Port'] := IntToStr(FPort);
  Conexao.Params.Values['Database'] := FDatabase;
  Conexao.Params.Values['User_Name'] := FUserName;
  Conexao.Params.Values['Password'] := FPassword;

  try
    Conexao.Connected := True;
  except
    on E: Exception do
    begin
      Conexao.Free;
      raise Exception.Create
        ('Erro ao conectar-se a base de dados com a seguinte mensagem de erro: '
        + E.Message);
    end;
  end;

  Result := Conexao;
end;

class function TConexaoPostgres.GetInstance: TConexaoPostgres;
begin
  if not Assigned(FInstance) then
  begin
    FInstance := TConexaoPostgres.Create;
  end;

  Result := FInstance;
end;

end.
