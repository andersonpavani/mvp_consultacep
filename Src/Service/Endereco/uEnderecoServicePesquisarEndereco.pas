unit uEnderecoServicePesquisarEndereco;

interface

uses
  System.SysUtils, System.Classes, System.Generics.Collections, uEndereco,
  uEnderecoRepositoryProtocol;

type
  TEnderecoServicePesquisarEndereco = class
  private
    EnderecoRepository: IEnderecoRepository;

    procedure ValidarEndereco(const UF, Localidade, Logradouro: String);
  public
    constructor Create(EnderecoRepository: IEnderecoRepository);
    destructor Destroy; override;

    procedure PesquisarEndereco(const UF, Localidade, Logradouro: String;
      Enderecos: TList<TEndereco>);
  end;

implementation

{ TEnderecoServicePesquisarEndereco }

constructor TEnderecoServicePesquisarEndereco.Create(EnderecoRepository
  : IEnderecoRepository);
begin
  Self.EnderecoRepository := EnderecoRepository;
end;

destructor TEnderecoServicePesquisarEndereco.Destroy;
begin

  inherited;
end;

procedure TEnderecoServicePesquisarEndereco.PesquisarEndereco(const UF,
  Localidade, Logradouro: String; Enderecos: TList<TEndereco>);
begin
  ValidarEndereco(UF, Localidade, Logradouro);

  EnderecoRepository.PesquisarEndereco(UF, Localidade, Logradouro, Enderecos);
end;

procedure TEnderecoServicePesquisarEndereco.ValidarEndereco(const UF,
  Localidade, Logradouro: String);
begin
  if Length(Trim(UF)) <> 2 then
  begin
    raise Exception.Create('UF deve conter 2 caracteres');
  end;

  if Length(Trim(Localidade)) < 3 then
  begin
    raise Exception.Create('Localidade deve conter no mínimo 3 caracteres');
  end;

  if Length(Trim(Logradouro)) < 3 then
  begin
    raise Exception.Create('Logradouro deve conter no mínimo 3 caracteres');
  end;
end;

end.
