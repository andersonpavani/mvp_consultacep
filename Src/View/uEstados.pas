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
      (Sigla: 'AL'; Nome: 'Alagoas'), (Sigla: 'AP'; Nome: 'Amapá'),
      (Sigla: 'AM'; Nome: 'Amazonas'), (Sigla: 'BA'; Nome: 'Bahia'),
      (Sigla: 'CE'; Nome: 'Ceará'), (Sigla: 'DF'; Nome: 'Distrito Federal'),
      (Sigla: 'ES'; Nome: 'Espírito Santo'), (Sigla: 'GO'; Nome: 'Goiás'),
      (Sigla: 'MA'; Nome: 'Maranhão'), (Sigla: 'MT'; Nome: 'Mato Grosso'),
      (Sigla: 'MS'; Nome: 'Mato Grosso do Sul'), (Sigla: 'MG';
      Nome: 'Minas Gerais'), (Sigla: 'PA'; Nome: 'Pará'), (Sigla: 'PB';
      Nome: 'Paraíba'), (Sigla: 'PR'; Nome: 'Paraná'), (Sigla: 'PE';
      Nome: 'Pernambuco'), (Sigla: 'PI'; Nome: 'Piauí'), (Sigla: 'RJ';
      Nome: 'Rio de Janeiro'), (Sigla: 'RN'; Nome: 'Rio Grande do Norte'),
      (Sigla: 'RS'; Nome: 'Rio Grande do Sul'), (Sigla: 'RO'; Nome: 'Rondônia'),
      (Sigla: 'RR'; Nome: 'Roraima'), (Sigla: 'SC'; Nome: 'Santa Catarina'),
      (Sigla: 'SP'; Nome: 'São Paulo'), (Sigla: 'SE'; Nome: 'Sergipe'),
      (Sigla: 'TO'; Nome: 'Tocantins'));
  end;

implementation

{ TEstados }

constructor TEstados.Create;
begin

end;

end.
