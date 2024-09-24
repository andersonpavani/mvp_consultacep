unit uEnderecoWSControllerSetTipoResposta;

interface

uses
  System.SysUtils, System.Classes, System.Generics.Collections, uEndereco,
  uEnderecoWSServiceSetTipoResposta, uEnderecoWSRepositoryProtocol;

type
  TEnderecoWSControllerSetTipoResposta = class
  private
    EnderecoWSServiceSetTipoResposta: TEnderecoWSServiceSetTipoResposta;
  public
    constructor Create(EnderecoWSServiceSetTipoResposta
      : TEnderecoWSServiceSetTipoResposta);
    destructor Destroy; override;

    procedure SetTipoResposta(TipoRespostaStr: String);
  end;

implementation

{ TEnderecoWSControllerSetTipoResposta }

constructor TEnderecoWSControllerSetTipoResposta.Create
  (EnderecoWSServiceSetTipoResposta: TEnderecoWSServiceSetTipoResposta);
begin
  Self.EnderecoWSServiceSetTipoResposta := EnderecoWSServiceSetTipoResposta;
end;

destructor TEnderecoWSControllerSetTipoResposta.Destroy;
begin

  inherited;
end;

procedure TEnderecoWSControllerSetTipoResposta.SetTipoResposta
  (TipoRespostaStr: String);
var
  TipoResposta: TWSTipoResposta;
begin
  if UpperCase(TipoRespostaStr) = 'JSON' then
  begin
    TipoResposta := trJSON;
  end
  else if UpperCase(TipoRespostaStr) = 'XML' then
  begin
    TipoResposta := trXML;
  end
  else
  begin
    raise Exception.Create('Tipo de Resposta inválido');
  end;

  EnderecoWSServiceSetTipoResposta.SetTipoResposta(TipoResposta);
end;

end.
