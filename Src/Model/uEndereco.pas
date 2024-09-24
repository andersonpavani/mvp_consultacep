unit uEndereco;

interface

uses
  System.SysUtils, System.Classes;

type
  TEndereco = class(TObject)
  private
    FCodigo: Integer;
    FCEP: String;
    FLogradouro: String;
    FComplemento: String;
    FBairro: String;
    FLocalidade: String;
    FUF: String;
  public
    constructor Create;
    destructor Destroy; override;

    property Codigo: Integer read FCodigo write FCodigo;
    property CEP: String read FCEP write FCEP;
    property Logradouro: String read FLogradouro write FLogradouro;
    property Complemento: String read FComplemento write FComplemento;
    property Bairro: String read FBairro write FBairro;
    property Localidade: String read FLocalidade write FLocalidade;
    property UF: String read FUF write FUF;
  end;

implementation

{ TEndereco }

constructor TEndereco.Create;
begin
  FCodigo := 0;
end;

destructor TEndereco.Destroy;
begin

  inherited;
end;

end.
