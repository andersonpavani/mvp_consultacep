unit uEnderecoWSRepositoryFactory;

interface

uses
  System.SysUtils, System.Classes, uEnderecoWSRepositoryProtocol,
  uEnderecoWSRepositoryViaCEP;

type
  TEnderecoWSRepositoryFactory = class
  private
    constructor Create;
  public
    class function CreateEnderecoWSRepository(const TipoRepositorio: String)
      : IEnderecoWSRepository;
  end;

implementation

{ TEnderecoWSRepositoryFactory }

constructor TEnderecoWSRepositoryFactory.Create;
begin

end;

class function TEnderecoWSRepositoryFactory.CreateEnderecoWSRepository
  (const TipoRepositorio: String): IEnderecoWSRepository;
begin
  if UpperCase(TipoRepositorio) = 'VIACEP' then
  begin
    Result := TEnderecoWSRepositoryViaCEP.Create;
  end
  else
  begin
    raise Exception.Create('Tipo de Repositório não implementado');
  end;

end;

end.
