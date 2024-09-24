unit uEnderecoWSServicePesquisarEndereco;

interface

uses
  System.SysUtils, System.Classes, System.Generics.Collections, uEnderecoWS,
  uEnderecoWSRepositoryProtocol;

type
  TEnderecoWSServicePesquisarEndereco = class
  private
    EnderecoWSRepository: IEnderecoWSRepository;
    procedure ValidarEndereco(const UF, Localidade, Logradouro: String);
  public
    constructor Create(EnderecoWSRepository: IEnderecoWSRepository);
    destructor Destroy; override;

    procedure PesquisarEndereco(const UF, Localidade, Logradouro: String;
      EnderecosWS: TList<TEnderecoWS>);
  end;

implementation

{ TEnderecoWSServicePesquisarEndereco }

constructor TEnderecoWSServicePesquisarEndereco.Create(EnderecoWSRepository
  : IEnderecoWSRepository);
begin
  Self.EnderecoWSRepository := EnderecoWSRepository;
end;

destructor TEnderecoWSServicePesquisarEndereco.Destroy;
begin

  inherited;
end;

procedure TEnderecoWSServicePesquisarEndereco.PesquisarEndereco(const UF,
  Localidade, Logradouro: String; EnderecosWS: TList<TEnderecoWS>);
begin
  ValidarEndereco(UF, Localidade, Logradouro);

  EnderecoWSRepository.PesquisarEndereco(UF, Localidade, Logradouro,
    EnderecosWS);
end;

procedure TEnderecoWSServicePesquisarEndereco.ValidarEndereco(const UF,
  Localidade, Logradouro: String);
begin
  if Length(Trim(UF)) <> 2 then
  begin
    raise Exception.Create('A UF deve conter 2 caracteres');
  end;

  if Length(Trim(Localidade)) < 3 then
  begin
    raise Exception.Create('A Localidade deve conter no mínimo 3 caracteres');
  end;

  if Length(Trim(Logradouro)) < 3 then
  begin
    raise Exception.Create('O Logradouro deve conter no mínimo 3 caracteres');
  end;
end;

end.
