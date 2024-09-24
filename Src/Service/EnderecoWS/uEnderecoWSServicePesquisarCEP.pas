unit uEnderecoWSServicePesquisarCEP;

interface

uses
  System.SysUtils, System.Classes, uRemoverCaracteresNaoNumericos, uEnderecoWS,
  uEnderecoWSRepositoryProtocol;

type
  TEnderecoWSServicePesquisarCEP = class
  private
    EnderecoWSRepository: IEnderecoWSRepository;
    function ValidarCEP(const CEP: String): Boolean;
  public
    constructor Create(EnderecoWSRepository: IEnderecoWSRepository);
    destructor Destroy; override;

    function PesquisarCEP(const CEP: String; EnderecoWS: TEnderecoWS): Boolean;
  end;

implementation

{ TEnderecoWSServicePesquisarCEP }

constructor TEnderecoWSServicePesquisarCEP.Create(EnderecoWSRepository
  : IEnderecoWSRepository);
begin
  Self.EnderecoWSRepository := EnderecoWSRepository;
end;

destructor TEnderecoWSServicePesquisarCEP.Destroy;
begin

  inherited;
end;

function TEnderecoWSServicePesquisarCEP.PesquisarCEP(const CEP: String;
  EnderecoWS: TEnderecoWS): Boolean;
var
  CEPNumerico: String;
begin
  Result := False;
  CEPNumerico := RemoverCaracteresNaoNumericos(CEP);

  if not ValidarCEP(CEPNumerico) then
  begin
    Exit;
  end;

  Result := EnderecoWSRepository.PesquisarCEP(CEPNumerico, EnderecoWS);
end;

function TEnderecoWSServicePesquisarCEP.ValidarCEP(const CEP: String): Boolean;
begin
  Result := (Length(CEP) = 8);
end;

end.
