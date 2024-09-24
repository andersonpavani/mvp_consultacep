unit uEnderecoRepositoryProtocol;

interface

uses
  System.SysUtils, System.Classes, System.Generics.Collections, uEndereco;

type
  IEnderecoRepository = interface
    ['{3C0B633C-F0D0-4EB4-843D-9D68BF101CA6}']
    function PesquisarCEP(const CEP: String; Endereco: TEndereco): Boolean;
    procedure PesquisarEndereco(const UF, Localidade, Logradouro: String;
      Enderecos: TList<TEndereco>);
    procedure PersistirEnderecos(Enderecos: TList<TEndereco>);
    procedure PesquisarTodos(Enderecos: TList<TEndereco>);
  end;

implementation

end.
