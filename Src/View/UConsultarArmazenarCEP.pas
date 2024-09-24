unit UConsultarArmazenarCEP;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.ComCtrls, Vcl.Grids, Vcl.StdCtrls, Vcl.Buttons,
  Vcl.ExtCtrls, System.StrUtils, System.JSON, System.Generics.Collections;

type
  TStatusTela = (stNormal, stProcessando);

  TFConsultarArmazenarCEP = class(TForm)
    GbTipoConsulta: TGroupBox;
    RbTipoConsultaViaJSON: TRadioButton;
    RbTipoConsultaViaXML: TRadioButton;
    GbBusca: TGroupBox;
    CbOpcaoBusca: TComboBox;
    EdBuscaCEP: TEdit;
    BtLimpar: TBitBtn;
    BtBuscar: TBitBtn;
    StatusBar: TStatusBar;
    CbBuscaUF: TComboBox;
    EdBuscaLocalidade: TEdit;
    GpLayoutCamposEndereco: TGridPanel;
    EdBuscaLogradouro: TEdit;
    SgEnderecos: TStringGrid;
    LbBuscaExibirTodos: TLabel;
    procedure CbOpcaoBuscaChange(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure BtLimparClick(Sender: TObject);
    procedure BtBuscarClick(Sender: TObject);
  private
    { Private declarations }
    procedure AjustarGrid;
    procedure LimparGrid;
    procedure InserirItensComboEstado;
    procedure ConsultarCEP;
    procedure DefinirTipoResposta;
    procedure ConsultarExibirCEPWebService(const CEP: String);
    procedure ConsultarExibirEnderecoWebService(const UF, Localidade,
      Logradouro: String);
    procedure ConsultarEndereco;
    procedure ConsultarTodos;
    procedure JSONToGrid(Endereco: TJSONObject; const GridRow: Integer);
    procedure ExibirEnderecos(Endereco: TJSONObject); overload;
    procedure ExibirEnderecos(Enderecos: TJSONArray); overload;
    procedure MudarStatusTela(const StatusTela: TStatusTela);

  public
    { Public declarations }
  end;

var
  FConsultarArmazenarCEP: TFConsultarArmazenarCEP;

implementation

{$R *.dfm}

uses uControllers, uEnderecoControllerPersistirEnderecos, uEnderecoControllerPesquisarCEP,
  uEnderecoControllerPesquisarEndereco, uEnderecoWSControllerPesquisarCEP,
  uEnderecoWSControllerPesquisarEndereco, uEnderecoWSControllerSetTipoResposta, uEstados,
  uEnderecoControllerPesquisarTodos;

procedure TFConsultarArmazenarCEP.AjustarGrid;
begin
  SgEnderecos.Cells[0, 0] := 'CEP';
  SgEnderecos.ColWidths[0] := 100;

  SgEnderecos.Cells[1, 0] := 'Logradouro';
  SgEnderecos.ColWidths[1] := 250;

  SgEnderecos.Cells[2, 0] := 'Complemento';
  SgEnderecos.ColWidths[2] := 250;

  SgEnderecos.Cells[3, 0] := 'Bairro';
  SgEnderecos.ColWidths[3] := 250;

  SgEnderecos.Cells[4, 0] := 'Localidade - UF';
  SgEnderecos.ColWidths[4] := 250;
end;

procedure TFConsultarArmazenarCEP.BtBuscarClick(Sender: TObject);
var
  MensagemStatus: String;
begin
  // TODO: A execução a seguir é sincrona, mas pode ser mudado para Assincrona utilizando
  // Thread. A Vantatem da abordagem assincrona é o não bloqueio da linha principal
  // de execução do programa evitando o "congelamento" da tela durante o processo.

  MensagemStatus := IfThen(CbOpcaoBusca.ItemIndex = 0, 'CEP', 'Endereço');
  MensagemStatus := Format('Procurando %s, por favor aguarde.',
    [MensagemStatus]);
  StatusBar.Panels[0].Text := MensagemStatus;

  MudarStatusTela(stProcessando);

  Application.ProcessMessages;

  try
    if CbOpcaoBusca.ItemIndex = 0 then
    begin
      ConsultarCEP;
    end
    else if CbOpcaoBusca.ItemIndex = 1 then
    begin
      ConsultarEndereco;
    end
    else
    begin
      ConsultarTodos;
    end;
  finally
    MudarStatusTela(stNormal);
    StatusBar.Panels[0].Text := EmptyStr;
  end;
end;

procedure TFConsultarArmazenarCEP.BtLimparClick(Sender: TObject);
begin
  EdBuscaCEP.Clear;
  CbBuscaUF.Clear;
  EdBuscaLocalidade.Clear;
  EdBuscaLogradouro.Clear;
  LimparGrid;
end;

procedure TFConsultarArmazenarCEP.CbOpcaoBuscaChange(Sender: TObject);
begin
  if CbOpcaoBusca.ItemIndex = 0 then
  begin
    EdBuscaCEP.Visible := True;
    GpLayoutCamposEndereco.Visible := False;
    LbBuscaExibirTodos.Visible := False;
  end
  else if CbOpcaoBusca.ItemIndex = 1 then
  begin
    EdBuscaCEP.Visible := False;
    GpLayoutCamposEndereco.Visible := True;
    LbBuscaExibirTodos.Visible := False;
  end
  else
  begin
    EdBuscaCEP.Visible := False;
    GpLayoutCamposEndereco.Visible := False;
    LbBuscaExibirTodos.Visible := True;
  end;
end;

procedure TFConsultarArmazenarCEP.ConsultarCEP;
var
  Endereco: TJSONObject;
  EnderecoControllerPesquisarCEP: TEnderecoControllerPesquisarCEP;
begin
  Endereco := TJSONObject.Create;

  try
    EnderecoControllerPesquisarCEP :=
      TControllers.GetInstance.EnderecoControllerPesquisarCEP;

    if EnderecoControllerPesquisarCEP.PesquisarCEP(EdBuscaCEP.Text, Endereco)
    then
    begin
      if Application.MessageBox
        ('CEP já cadastrado na base de dados, deseja atualizar o endereço com uma nova consulta a base de dados online?',
        'CEP encontrado', MB_ICONQUESTION + MB_YESNO) = mrYes then
      begin
        ConsultarExibirCEPWebService(EdBuscaCEP.Text);
      end
      else
      begin
        ExibirEnderecos(Endereco);
      end;
    end
    else
    begin
      ConsultarExibirCEPWebService(EdBuscaCEP.Text);
    end;
  finally
    Endereco.Free;
  end;
end;

procedure TFConsultarArmazenarCEP.ConsultarExibirCEPWebService(const CEP: String);
var
  Enderecos: TJSONArray;
  EnderecoWSControllerPesquisarCEP: TEnderecoWSControllerPesquisarCEP;
  EnderecoControllerPersistirEnderecos: TEnderecoControllerPersistirEnderecos;
begin
  EnderecoWSControllerPesquisarCEP :=
    TControllers.GetInstance.EnderecoWSControllerPesquisarCEP;
  EnderecoControllerPersistirEnderecos :=
    TControllers.GetInstance.EnderecoControllerPersistirEnderecos;

  DefinirTipoResposta;

  Enderecos := TJSONArray.Create;
  Enderecos.Add(TJSONObject.Create);

  try
    if not EnderecoWSControllerPesquisarCEP.PesquisarCEP(CEP,
      Enderecos[0] as TJSONObject) then
    begin
      Application.MessageBox('CEP não encontrado', 'CEP não encontrado',
        MB_ICONINFORMATION + MB_OK);
      Exit;
    end;

    EnderecoControllerPersistirEnderecos.PersistirEnderecos(Enderecos);

    ExibirEnderecos(Enderecos);
  finally
    Enderecos.Free;
  end;
end;

procedure TFConsultarArmazenarCEP.ConsultarExibirEnderecoWebService(const UF, Localidade,
  Logradouro: String);
var
  Enderecos: TJSONArray;
  EnderecoWSControllerPesquisarEndereco: TEnderecoWSControllerPesquisarEndereco;
  EnderecoControllerPersistirEnderecos: TEnderecoControllerPersistirEnderecos;
begin
  EnderecoWSControllerPesquisarEndereco :=
    TControllers.GetInstance.EnderecoWSControllerPesquisarEndereco;
  EnderecoControllerPersistirEnderecos :=
    TControllers.GetInstance.EnderecoControllerPersistirEnderecos;

  DefinirTipoResposta;

  Enderecos := TJSONArray.Create;

  try
    EnderecoWSControllerPesquisarEndereco.PesquisarEndereco(UF, Localidade,
      Logradouro, Enderecos);

    if Enderecos.Count = 0 then
    begin
      Application.MessageBox('Endereço não encontrado',
        'Endereço não encontrado', MB_ICONINFORMATION + MB_OK);
      Exit;
    end;

    EnderecoControllerPersistirEnderecos.PersistirEnderecos(Enderecos);

    ExibirEnderecos(Enderecos);
  finally
    Enderecos.Free;
  end;
end;

procedure TFConsultarArmazenarCEP.ConsultarTodos;
var
  Enderecos: TJSONArray;
  EnderecoControllerPesquisarTodos: TEnderecoControllerPesquisarTodos;
begin
  EnderecoControllerPesquisarTodos :=
    TControllers.GetInstance.EnderecoControllerPesquisarTodos;

  Enderecos := TJSONArray.Create;

  try
    EnderecoControllerPesquisarTodos.PesquisarTodos(Enderecos);

    if Enderecos.Count = 0 then
    begin
      Application.MessageBox
        ('Não há endereços cadastrados na base de dados local',
        'Não encontrado', MB_ICONINFORMATION + MB_OK);
      Exit;
    end;

    ExibirEnderecos(Enderecos);
  finally
    Enderecos.Free;
  end;
end;

procedure TFConsultarArmazenarCEP.DefinirTipoResposta;
var
  EnderecoWSControllerSetTipoResposta: TEnderecoWSControllerSetTipoResposta;
  TipoResposta: String;
begin
  EnderecoWSControllerSetTipoResposta :=
    TControllers.GetInstance.EnderecoWSControllerSetTipoResposta;

  TipoResposta := IfThen(RbTipoConsultaViaJSON.Checked, 'JSON', 'XML');

  EnderecoWSControllerSetTipoResposta.SetTipoResposta(TipoResposta);
end;

procedure TFConsultarArmazenarCEP.ExibirEnderecos(Endereco: TJSONObject);
begin
  SgEnderecos.RowCount := 2;

  JSONToGrid(Endereco, 1);
end;

procedure TFConsultarArmazenarCEP.ConsultarEndereco;
var
  Enderecos: TJSONArray;
  EnderecoControllerPesquisarEndereco: TEnderecoControllerPesquisarEndereco;
begin
  Enderecos := TJSONArray.Create;

  try
    EnderecoControllerPesquisarEndereco :=
      TControllers.GetInstance.EnderecoControllerPesquisarEndereco;

    EnderecoControllerPesquisarEndereco.PesquisarEndereco
      (TEstados.ListaEstados[CbBuscaUF.ItemIndex].Sigla, EdBuscaLocalidade.Text,
      EdBuscaLogradouro.Text, Enderecos);

    if Enderecos.Count > 0 then
    begin
      if Application.MessageBox
        ('Endereço já cadastrado na base de dados, deseja atualizar o endereço com uma nova consulta a base de dados online?',
        'Endereço encontrado', MB_ICONQUESTION + MB_YESNO) = mrYes then
      begin
        ConsultarExibirEnderecoWebService
          (TEstados.ListaEstados[CbBuscaUF.ItemIndex].Sigla,
          EdBuscaLocalidade.Text, EdBuscaLogradouro.Text);
      end
      else
      begin
        ExibirEnderecos(Enderecos);
      end;
    end
    else
    begin
      ConsultarExibirEnderecoWebService
        (TEstados.ListaEstados[CbBuscaUF.ItemIndex].Sigla,
        EdBuscaLocalidade.Text, EdBuscaLogradouro.Text);
    end;
  finally
    Enderecos.Free;
  end;
end;

procedure TFConsultarArmazenarCEP.ExibirEnderecos(Enderecos: TJSONArray);
var
  i: Integer;
begin
  SgEnderecos.RowCount := Enderecos.Count + 1;

  for i := 0 to Pred(Enderecos.Count) do
  begin
    JSONToGrid(Enderecos[i] as TJSONObject, i + 1);
  end;
end;

procedure TFConsultarArmazenarCEP.FormCreate(Sender: TObject);
begin
  InserirItensComboEstado;
  AjustarGrid;
end;

procedure TFConsultarArmazenarCEP.InserirItensComboEstado;
var
  i: Integer;
begin
  for i := 0 to High(TEstados.ListaEstados) do
  begin
    CbBuscaUF.Items.Add(TEstados.ListaEstados[i].Nome);
  end;
end;

procedure TFConsultarArmazenarCEP.JSONToGrid(Endereco: TJSONObject;
  const GridRow: Integer);
begin
  SgEnderecos.Cells[0, GridRow] := Endereco.GetValue<String>('cep');
  SgEnderecos.Cells[1, GridRow] := Endereco.GetValue<String>('logradouro');
  SgEnderecos.Cells[2, GridRow] := Endereco.GetValue<String>('complemento');
  SgEnderecos.Cells[3, GridRow] := Endereco.GetValue<String>('bairro');
  SgEnderecos.Cells[4, GridRow] := Endereco.GetValue<String>('localidade') +
    ' - ' + Endereco.GetValue<String>('uf');
end;

procedure TFConsultarArmazenarCEP.LimparGrid;
begin
  SgEnderecos.RowCount := 2;

  SgEnderecos.Cells[0, 1] := EmptyStr;
  SgEnderecos.Cells[1, 1] := EmptyStr;
  SgEnderecos.Cells[2, 1] := EmptyStr;
  SgEnderecos.Cells[3, 1] := EmptyStr;
  SgEnderecos.Cells[4, 1] := EmptyStr;
end;

procedure TFConsultarArmazenarCEP.MudarStatusTela(const StatusTela
  : TStatusTela);
begin
  CbOpcaoBusca.Enabled := (StatusTela = stNormal);
  EdBuscaCEP.Enabled := (StatusTela = stNormal);
  CbBuscaUF.Enabled := (StatusTela = stNormal);
  EdBuscaLocalidade.Enabled := (StatusTela = stNormal);
  EdBuscaLogradouro.Enabled := (StatusTela = stNormal);
  BtBuscar.Enabled := (StatusTela = stNormal);
  BtLimpar.Enabled := (StatusTela = stNormal);
  RbTipoConsultaViaJSON.Enabled := (StatusTela = stNormal);
  RbTipoConsultaViaXML.Enabled := (StatusTela = stNormal);
  SgEnderecos.Enabled := (StatusTela = stNormal);
end;

end.
