unit uEnderecoWSRepositoryViaCEP;

interface

uses
  System.SysUtils, System.Classes, System.Generics.Collections, ConsultaCEP,
  uConsultaEndereco, uEnderecoWS,
  uEnderecoWSRepositoryProtocol;

type
  TEnderecoWSRepositoryViaCEP = class(TInterfacedObject, IEnderecoWSRepository)
  private
    FTipoResposta: TWSTipoResposta;
    procedure SetTipoRespostaComponente(ConsultaCEP: TConsultaCEP);
    procedure EnderecoComponenteToEnderecoWS(EnderecoComponente
      : TConsultaEndereco; EnderecoWS: TEnderecoWS);
  public
    constructor Create;
    destructor Destroy; override;

    procedure SetTipoResposta(TipoResposta: TWSTipoResposta);
    function PesquisarCEP(const CEP: String; EnderecoWS: TEnderecoWS): Boolean;
    procedure PesquisarEndereco(const UF, Localidade, Logradouro: String;
      EnderecosWS: TList<TEnderecoWS>);
  end;

implementation

{ TEnderecoWSRepositoryViaCEP }

constructor TEnderecoWSRepositoryViaCEP.Create;
begin
  FTipoResposta := trJSON;
end;

destructor TEnderecoWSRepositoryViaCEP.Destroy;
begin

  inherited;
end;

procedure TEnderecoWSRepositoryViaCEP.EnderecoComponenteToEnderecoWS
  (EnderecoComponente: TConsultaEndereco; EnderecoWS: TEnderecoWS);
begin
  EnderecoWS.CEP := EnderecoComponente.CEP;
  EnderecoWS.Logradouro := EnderecoComponente.Logradouro;
  EnderecoWS.Complemento := EnderecoComponente.Complemento;
  EnderecoWS.Bairro := EnderecoComponente.Bairro;
  EnderecoWS.Localidade := EnderecoComponente.Localidade;
  EnderecoWS.UF := EnderecoComponente.UF;
end;

function TEnderecoWSRepositoryViaCEP.PesquisarCEP(const CEP: String;
  EnderecoWS: TEnderecoWS): Boolean;
var
  ConsultaCEP: TConsultaCEP;
begin
  Result := False;

  ConsultaCEP := TConsultaCEP.Create(nil);

  try
    SetTipoRespostaComponente(ConsultaCEP);

    if not ConsultaCEP.ConsultarCEP(CEP) then
    begin
      Exit;
    end;

    EnderecoComponenteToEnderecoWS(ConsultaCEP.Enderecos[0], EnderecoWS);

    Result := True;
  finally
    ConsultaCEP.Free;
  end;
end;

procedure TEnderecoWSRepositoryViaCEP.PesquisarEndereco(const UF, Localidade,
  Logradouro: String; EnderecosWS: TList<TEnderecoWS>);
var
  ConsultaCEP: TConsultaCEP;
  EnderecoWS: TEnderecoWS;
  i: Integer;
begin
  ConsultaCEP := TConsultaCEP.Create(nil);

  try
    SetTipoRespostaComponente(ConsultaCEP);

    ConsultaCEP.ConsultarEndereco(UF, Localidade, Logradouro);

    for i := 0 to Pred(ConsultaCEP.Enderecos.Count) do
    begin
      EnderecoWS := TEnderecoWS.Create;

      EnderecoComponenteToEnderecoWS(ConsultaCEP.Enderecos[i], EnderecoWS);

      EnderecosWS.Add(EnderecoWS);
    end;
  finally
    ConsultaCEP.Free;
  end;
end;

procedure TEnderecoWSRepositoryViaCEP.SetTipoResposta
  (TipoResposta: TWSTipoResposta);
begin
  FTipoResposta := TipoResposta;
end;

procedure TEnderecoWSRepositoryViaCEP.SetTipoRespostaComponente
  (ConsultaCEP: TConsultaCEP);
begin
  if FTipoResposta = trJSON then
  begin
    ConsultaCEP.TipoResposta := cctrJSON;
  end
  else
  begin
    ConsultaCEP.TipoResposta := cctrXML;
  end;
end;

end.
