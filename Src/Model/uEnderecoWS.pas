unit uEnderecoWS;

interface

uses
  System.SysUtils, System.Classes;

type
  TEnderecoWS = class(TObject)
  private
    FCEP: String;
    FLogradouro: String;
    FComplemento: String;
    FBairro: String;
    FLocalidade: String;
    FUF: String;
  public
    constructor Create;
    destructor Destroy; override;

    property CEP: String read FCEP write FCEP;
    property Logradouro: String read FLogradouro write FLogradouro;
    property Complemento: String read FComplemento write FComplemento;
    property Bairro: String read FBairro write FBairro;
    property Localidade: String read FLocalidade write FLocalidade;
    property UF: String read FUF write FUF;
  end;

implementation

{ TEnderecoWS }

constructor TEnderecoWS.Create;
begin

end;

destructor TEnderecoWS.Destroy;
begin

  inherited;
end;

end.
