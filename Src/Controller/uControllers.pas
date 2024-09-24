unit uControllers;

interface

uses
  System.SysUtils, System.Classes, uEnderecoControllerPersistirEnderecos,
  uEnderecoControllerPesquisarCEP, uEnderecoControllerPesquisarEndereco,
  uEnderecoRepositoryFactory,
  uEnderecoRepositoryProtocol, uEnderecoServicePersistirEnderecos,
  uEnderecoServicePesquisarCEP,
  uEnderecoServicePesquisarEndereco, uEnderecoWSControllerPesquisarCEP,
  uEnderecoServicePesquisarTodos,
  uEnderecoWSControllerSetTipoResposta, uEnderecoWSRepositoryProtocol,
  uEnderecoWSRepositoryFactory,
  uEnderecoWSServicePesquisarCEP, uEnderecoWSServicePesquisarEndereco,
  uEnderecoControllerPesquisarTodos,
  uEnderecoWSServiceSetTipoResposta, uEnderecoWSControllerPesquisarEndereco;

type
  TControllers = class
  private
    EnderecoRepository: IEnderecoRepository;
    EnderecoServicePesquisarCEP: TEnderecoServicePesquisarCEP;
    EnderecoServicePesquisarEndereco: TEnderecoServicePesquisarEndereco;
    EnderecoServicePesquisarTodos: TEnderecoServicePesquisarTodos;
    EnderecoServicePersistirEnderecos: TEnderecoServicePersistirEnderecos;

    EnderecoWSRepository: IEnderecoWSRepository;
    EnderecoWSServiceSetTipoResposta: TEnderecoWSServiceSetTipoResposta;
    EnderecoWSServicePesquisarCEP: TEnderecoWSServicePesquisarCEP;
    EnderecoWSServicePesquisarEndereco: TEnderecoWSServicePesquisarEndereco;

  const
    TipoRepositorioEndereco = 'POSTGRES';

  const
    TipoRepositorioEnderecoWS = 'VIACEP';

    class var FInstance: TControllers;
    constructor Create;
  public
    EnderecoControllerPesquisarCEP: TEnderecoControllerPesquisarCEP;
    EnderecoControllerPesquisarEndereco: TEnderecoControllerPesquisarEndereco;
    EnderecoControllerPesquisarTodos: TEnderecoControllerPesquisarTodos;
    EnderecoControllerPersistirEnderecos: TEnderecoControllerPersistirEnderecos;

    EnderecoWSControllerSetTipoResposta: TEnderecoWSControllerSetTipoResposta;
    EnderecoWSControllerPesquisarCEP: TEnderecoWSControllerPesquisarCEP;
    EnderecoWSControllerPesquisarEndereco
      : TEnderecoWSControllerPesquisarEndereco;

    destructor Destroy; override;

    class function GetInstance: TControllers;
  end;

implementation

{ TControllers }

constructor TControllers.Create;
begin
  EnderecoRepository := TEnderecoRepositoryFactory.CreateEnderecoRepository
    (TipoRepositorioEndereco);

  EnderecoServicePesquisarCEP := TEnderecoServicePesquisarCEP.Create
    (EnderecoRepository);
  EnderecoServicePesquisarEndereco := TEnderecoServicePesquisarEndereco.Create
    (EnderecoRepository);
  EnderecoServicePesquisarTodos := TEnderecoServicePesquisarTodos.Create
    (EnderecoRepository);
  EnderecoServicePersistirEnderecos := TEnderecoServicePersistirEnderecos.Create
    (EnderecoRepository);

  EnderecoControllerPesquisarCEP := TEnderecoControllerPesquisarCEP.Create
    (EnderecoServicePesquisarCEP);
  EnderecoControllerPesquisarEndereco :=
    TEnderecoControllerPesquisarEndereco.Create
    (EnderecoServicePesquisarEndereco);
  EnderecoControllerPesquisarTodos := TEnderecoControllerPesquisarTodos.Create
    (EnderecoServicePesquisarTodos);
  EnderecoControllerPersistirEnderecos :=
    TEnderecoControllerPersistirEnderecos.Create
    (EnderecoServicePersistirEnderecos);

  EnderecoWSRepository := TEnderecoWSRepositoryFactory.
    CreateEnderecoWSRepository(TipoRepositorioEnderecoWS);

  EnderecoWSServiceSetTipoResposta := TEnderecoWSServiceSetTipoResposta.Create
    (EnderecoWSRepository);
  EnderecoWSServicePesquisarCEP := TEnderecoWSServicePesquisarCEP.Create
    (EnderecoWSRepository);
  EnderecoWSServicePesquisarEndereco :=
    TEnderecoWSServicePesquisarEndereco.Create(EnderecoWSRepository);

  EnderecoWSControllerSetTipoResposta :=
    TEnderecoWSControllerSetTipoResposta.Create
    (EnderecoWSServiceSetTipoResposta);
  EnderecoWSControllerPesquisarCEP := TEnderecoWSControllerPesquisarCEP.Create
    (EnderecoWSServicePesquisarCEP);
  EnderecoWSControllerPesquisarEndereco :=
    TEnderecoWSControllerPesquisarEndereco.Create
    (EnderecoWSServicePesquisarEndereco);
end;

destructor TControllers.Destroy;
begin
  EnderecoControllerPesquisarCEP.Free;
  EnderecoControllerPesquisarEndereco.Free;
  EnderecoControllerPesquisarTodos.Free;
  EnderecoControllerPersistirEnderecos.Free;

  EnderecoServicePesquisarCEP.Free;
  EnderecoServicePesquisarEndereco.Free;
  EnderecoServicePesquisarTodos.Free;
  EnderecoServicePersistirEnderecos.Free;

  EnderecoWSControllerSetTipoResposta.Free;
  EnderecoWSControllerPesquisarCEP.Free;
  EnderecoWSControllerPesquisarEndereco.Free;

  EnderecoWSServiceSetTipoResposta.Free;
  EnderecoWSServicePesquisarCEP.Free;
  EnderecoWSServicePesquisarEndereco.Free;

  inherited;
end;

class function TControllers.GetInstance: TControllers;
begin
  if not Assigned(FInstance) then
  begin
    FInstance := TControllers.Create;
  end;

  Result := FInstance;
end;

end.
