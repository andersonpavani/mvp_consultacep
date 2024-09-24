unit uEstados;

interface

uses
  System.SysUtils, System.Classes;

type
  TEstado = record
    Sigla: String;
    Nome: String;
  end;

  TEstados = class
  private
    constructor Create;
  public const
    ListaEstados: Array [0 .. 26] of TEstado = ((Sigla: 'AC'; Nome: 'Acre'),
      (Sigla: 'AL'; Nome: 'Alagoas'), (Sigla: 'AP'; Nome: 'Amap�'),
      (Sigla: 'AM'; Nome: 'Amazonas'), (Sigla: 'BA'; Nome: 'Bahia'),
      (Sigla: 'CE'; Nome: 'Cear�'), (Sigla: 'DF'; Nome: 'Distrito Federal'),
      (Sigla: 'ES'; Nome: 'Esp�rito Santo'), (Sigla: 'GO'; Nome: 'Goi�s'),
      (Sigla: 'MA'; Nome: 'Maranh�o'), (Sigla: 'MT'; Nome: 'Mato Grosso'),
      (Sigla: 'MS'; Nome: 'Mato Grosso do Sul'), (Sigla: 'MG';
      Nome: 'Minas Gerais'), (Sigla: 'PA'; Nome: 'Par�'), (Sigla: 'PB';
      Nome: 'Para�ba'), (Sigla: 'PR'; Nome: 'Paran�'), (Sigla: 'PE';
      Nome: 'Pernambuco'), (Sigla: 'PI'; Nome: 'Piau�'), (Sigla: 'RJ';
      Nome: 'Rio de Janeiro'), (Sigla: 'RN'; Nome: 'Rio Grande do Norte'),
      (Sigla: 'RS'; Nome: 'Rio Grande do Sul'), (Sigla: 'RO'; Nome: 'Rond�nia'),
      (Sigla: 'RR'; Nome: 'Roraima'), (Sigla: 'SC'; Nome: 'Santa Catarina'),
      (Sigla: 'SP'; Nome: 'S�o Paulo'), (Sigla: 'SE'; Nome: 'Sergipe'),
      (Sigla: 'TO'; Nome: 'Tocantins'));
  end;

implementation

{ TEstados }

constructor TEstados.Create;
begin

end;

end.
