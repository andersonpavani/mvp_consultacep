unit uEnderecoRepositoryFactory;

interface

uses
  System.SysUtils, System.Classes, uEnderecoRepositoryProtocol,
  uEnderecoRepositoryPostgres;

type
  TEnderecoRepositoryFactory = class
  private
    constructor Create;
  public
    class function CreateEnderecoRepository(const TipoRepositorio: String)
      : IEnderecoRepository;
  end;

implementation

{ TEnderecoRepositoryFactory }

constructor TEnderecoRepositoryFactory.Create;
begin

end;

class function TEnderecoRepositoryFactory.CreateEnderecoRepository
  (const TipoRepositorio: String): IEnderecoRepository;
begin
  if UpperCase(TipoRepositorio) = 'POSTGRES' then
  begin
    Result := TEnderecoRepositoryPostgres.Create;
  end
  else
  begin
    raise Exception.Create('Tipo de Repositório não implementado');
  end;

end;

end.
