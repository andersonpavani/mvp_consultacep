unit uEnderecoWSRepositoryProtocol;

interface

uses
  System.SysUtils, System.Classes, System.Generics.Collections, uEnderecoWS;

type
  TWSTipoResposta = (trJSON, trXML);

  IEnderecoWSRepository = interface
    ['{EF912086-E313-43D8-8B5D-2B75D02F1A87}']
    procedure SetTipoResposta(TipoResposta: TWSTipoResposta);
    function PesquisarCEP(const CEP: String; EnderecoWS: TEnderecoWS): Boolean;
    procedure PesquisarEndereco(const UF, Localidade, Logradouro: String;
      EnderecosWS: TList<TEnderecoWS>);
  end;

implementation

end.
