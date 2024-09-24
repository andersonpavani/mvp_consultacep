unit uEnderecoWSServiceSetTipoResposta;

interface

uses
  System.SysUtils, System.Classes, uEnderecoWSRepositoryProtocol;

type
  TEnderecoWSServiceSetTipoResposta = class
  private
    EnderecoWSRepository: IEnderecoWSRepository;
  public
    constructor Create(EnderecoWSRepository: IEnderecoWSRepository);
    destructor Destroy; override;

    procedure SetTipoResposta(TipoResposta: TWSTipoResposta);
  end;

implementation

{ TEnderecoWSServiceSetTipoResposta }

constructor TEnderecoWSServiceSetTipoResposta.Create(EnderecoWSRepository
  : IEnderecoWSRepository);
begin
  Self.EnderecoWSRepository := EnderecoWSRepository;
end;

destructor TEnderecoWSServiceSetTipoResposta.Destroy;
begin

  inherited;
end;

procedure TEnderecoWSServiceSetTipoResposta.SetTipoResposta
  (TipoResposta: TWSTipoResposta);
begin
  EnderecoWSRepository.SetTipoResposta(TipoResposta);
end;

end.
