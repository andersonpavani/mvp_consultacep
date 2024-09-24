unit uEnderecoServicePesquisarCEP;

interface

uses
  System.SysUtils, System.Classes, uEndereco, uEnderecoRepositoryProtocol,
  uRemoverCaracteresNaoNumericos;

type
  TEnderecoServicePesquisarCEP = class
  private
    EnderecoRepository: IEnderecoRepository;
    function ValidarCEP(const CEP: String): Boolean;
  public
    constructor Create(EnderecoRepository: IEnderecoRepository);
    destructor Destroy; override;

    function PesquisarCEP(const CEP: String; Endereco: TEndereco): Boolean;
  end;

implementation

{ TEnderecoServicePesquisarCEP }

constructor TEnderecoServicePesquisarCEP.Create(EnderecoRepository
  : IEnderecoRepository);
begin
  Self.EnderecoRepository := EnderecoRepository;
end;

destructor TEnderecoServicePesquisarCEP.Destroy;
begin

  inherited;
end;

function TEnderecoServicePesquisarCEP.PesquisarCEP(const CEP: String;
  Endereco: TEndereco): Boolean;
var
  CEPNumerico: String;
begin
  Result := False;
  CEPNumerico := RemoverCaracteresNaoNumericos(CEP);

  if not ValidarCEP(CEPNumerico) then
  begin
    Exit;
  end;

  Result := EnderecoRepository.PesquisarCEP(CEPNumerico, Endereco);
end;

function TEnderecoServicePesquisarCEP.ValidarCEP(const CEP: String): Boolean;
begin
  Result := (Length(CEP) = 8);
end;

end.
