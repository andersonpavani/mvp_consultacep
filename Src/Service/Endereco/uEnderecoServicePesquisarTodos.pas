unit uEnderecoServicePesquisarTodos;

interface

uses
  System.SysUtils, System.Classes, System.Generics.Collections, uEndereco,
  uEnderecoRepositoryProtocol;

type
  TEnderecoServicePesquisarTodos = class
  private
    EnderecoRepository: IEnderecoRepository;
  public
    constructor Create(EnderecoRepository: IEnderecoRepository);
    destructor Destroy; override;

    procedure PesquisarTodos(Enderecos: TList<TEndereco>);
  end;

implementation

{ TEnderecoServicePesquisarTodos }

constructor TEnderecoServicePesquisarTodos.Create(EnderecoRepository
  : IEnderecoRepository);
begin
  Self.EnderecoRepository := EnderecoRepository;
end;

destructor TEnderecoServicePesquisarTodos.Destroy;
begin

  inherited;
end;

procedure TEnderecoServicePesquisarTodos.PesquisarTodos
  (Enderecos: TList<TEndereco>);
begin
  EnderecoRepository.PesquisarTodos(Enderecos);
end;

end.
