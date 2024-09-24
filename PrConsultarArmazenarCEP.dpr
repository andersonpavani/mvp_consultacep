program PrConsultarArmazenarCEP;

uses
  Vcl.Forms,
  UConsultarArmazenarCEP in 'src\View\UConsultarArmazenarCEP.pas' {FConsultarArmazenarCEP},
  uEndereco in 'src\Model\uEndereco.pas',
  uEnderecoRepositoryPostgres in 'src\Repository\Postgres\uEnderecoRepositoryPostgres.pas',
  uEnderecoRepositoryProtocol in 'src\Service\Endereco\uEnderecoRepositoryProtocol.pas',
  uEnderecoServicePesquisarCEP in 'src\Service\Endereco\uEnderecoServicePesquisarCEP.pas',
  uEnderecoServicePesquisarEndereco in 'src\Service\Endereco\uEnderecoServicePesquisarEndereco.pas',
  uEnderecoServicePersistirEnderecos in 'src\Service\Endereco\uEnderecoServicePersistirEnderecos.pas',
  uEnderecoControllerPesquisarCEP in 'src\Controller\Endereco\uEnderecoControllerPesquisarCEP.pas',
  uEnderecoControllerPesquisarEndereco in 'src\Controller\Endereco\uEnderecoControllerPesquisarEndereco.pas',
  uEnderecoControllerPersistirEnderecos in 'src\Controller\Endereco\uEnderecoControllerPersistirEnderecos.pas',
  uControllers in 'src\Controller\uControllers.pas',
  uConexaoPostgres in 'src\Repository\Postgres\uConexaoPostgres.pas',
  uEnderecoWS in 'src\Model\uEnderecoWS.pas',
  uEnderecoWSRepositoryProtocol in 'src\Service\EnderecoWS\uEnderecoWSRepositoryProtocol.pas',
  uEnderecoWSRepositoryViaCEP in 'src\Repository\WebServiceViaCEP\uEnderecoWSRepositoryViaCEP.pas',
  uEnderecoWSServiceSetTipoResposta in 'src\Service\EnderecoWS\uEnderecoWSServiceSetTipoResposta.pas',
  uEnderecoWSServicePesquisarCEP in 'src\Service\EnderecoWS\uEnderecoWSServicePesquisarCEP.pas',
  uRemoverCaracteresNaoNumericos in 'src\Common\uRemoverCaracteresNaoNumericos.pas',
  uEnderecoWSServicePesquisarEndereco in 'src\Service\EnderecoWS\uEnderecoWSServicePesquisarEndereco.pas',
  uEnderecoWSControllerSetTipoResposta in 'src\Controller\EnderecoWS\uEnderecoWSControllerSetTipoResposta.pas',
  uEnderecoWSControllerPesquisarCEP in 'src\Controller\EnderecoWS\uEnderecoWSControllerPesquisarCEP.pas',
  uEnderecoWSControllerJSONParser in 'src\Controller\EnderecoWS\uEnderecoWSControllerJSONParser.pas',
  uEnderecoWSControllerPesquisarEndereco in 'src\Controller\EnderecoWS\uEnderecoWSControllerPesquisarEndereco.pas',
  uEnderecoControllerJSONParser in 'src\Controller\Endereco\uEnderecoControllerJSONParser.pas',
  Vcl.Themes,
  Vcl.Styles,
  uEstados in 'src\View\uEstados.pas',
  uEnderecoServicePesquisarTodos in 'src\Service\Endereco\uEnderecoServicePesquisarTodos.pas',
  uEnderecoControllerPesquisarTodos in 'src\Controller\Endereco\uEnderecoControllerPesquisarTodos.pas',
  uEnderecoRepositoryFactory in 'src\Repository\uEnderecoRepositoryFactory.pas',
  uEnderecoWSRepositoryFactory in 'src\Repository\uEnderecoWSRepositoryFactory.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.Title := 'Consultar Armazena CEP';
  Application.CreateForm(TFConsultarArmazenarCEP, FConsultarArmazenarCEP);
  Application.Run;

end.
