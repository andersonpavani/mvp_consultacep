unit uEnderecoServicePersistirEnderecos;

interface

uses
  System.SysUtils, System.Classes, System.Generics.Collections, uEndereco,
  uEnderecoRepositoryProtocol;

type
  TEnderecoServicePersistirEnderecos = class
  private
    EnderecoRepository: IEnderecoRepository;

    procedure ValidarEnderecos(Enderecos: TList<TEndereco>);
  public
    constructor Create(EnderecoRepository: IEnderecoRepository);
    destructor Destroy; override;

    procedure PersistirEnderecos(Enderecos: TList<TEndereco>);
  end;

implementation

{ TEnderecoServicePersistirEnderecos }

constructor TEnderecoServicePersistirEnderecos.Create(EnderecoRepository
  : IEnderecoRepository);
begin
  Self.EnderecoRepository := EnderecoRepository;
end;

destructor TEnderecoServicePersistirEnderecos.Destroy;
begin

  inherited;
end;

procedure TEnderecoServicePersistirEnderecos.PersistirEnderecos
  (Enderecos: TList<TEndereco>);
begin
  ValidarEnderecos(Enderecos);

  EnderecoRepository.PersistirEnderecos(Enderecos);
end;

procedure TEnderecoServicePersistirEnderecos.ValidarEnderecos
  (Enderecos: TList<TEndereco>);
var
  i: Integer;
begin
  for i := 0 to Pred(Enderecos.Count) do
  begin
    if Length(Trim(Enderecos[i].UF)) <> 2 then
    begin
      raise Exception.Create('UF deve conter 2 caracteres');
    end;

    if Trim(Enderecos[i].Localidade) = EmptyStr then
    begin
      raise Exception.Create('Localidade não informado');
    end;

    if Length(Trim(Enderecos[i].Localidade)) < 3 then
    begin
      raise Exception.Create('Localidade deve conter no mínimo 3 caracteres');
    end;

    if Trim(Enderecos[i].Logradouro) = EmptyStr then
    begin
      raise Exception.Create('Logradouro não informado');
    end;

    if Length(Trim(Enderecos[i].Logradouro)) < 3 then
    begin
      raise Exception.Create('Logradouro deve conter no mínimo 3 caracteres');
    end;
  end;
end;

end.
