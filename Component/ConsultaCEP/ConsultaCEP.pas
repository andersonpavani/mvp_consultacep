unit ConsultaCEP;

interface

uses
  System.SysUtils, System.Classes, IdSSLOpenSSL, IdHTTP, IdURI, IdStack, IdSSL,
  System.JSON, Xml.XMLDoc, Xml.XMLIntf, System.Generics.Collections,
  uConsultaEndereco;

type
  TConsultarCEPTipoResposta = (cctrJSON, cctrXML);

  TConsultaCEP = class(TComponent)
  private
    { Private declarations }
    FEnderecos: TList<TConsultaEndereco>;
    FMensagem: string;
    FTipoResposta: TConsultarCEPTipoResposta;

    function ConsultarCEPJSON(const CEP: string): Boolean;
    function ConsultarCEPXML(const CEP: string): Boolean;
    function ConsultarEnderecoJSON(const UF, Localidade,
      Logradouro: String): Boolean;
    function ConsultarEnderecoXML(const UF, Localidade,
      Logradouro: String): Boolean;
    procedure JSONValueToConsultaEndereco(JSONValue: TJSONValue;
      ConsultaEndereco: TConsultaEndereco);
    procedure XMLNodeToConsultaEndereco(Node: IXMLNode;
      ConsultaEndereco: TConsultaEndereco);
    procedure SetTLS12(HTTP: TIdHTTP; SSLHandler: TIdSSLIOHandlerSocketOpenSSL);
    procedure ValidarCEP(const CEP: String);
    procedure ValidarEndereco(const UF, Localidade, Logradouro: String);

  const
    URLViaCEP = 'https://viacep.com.br/ws';

  const
    URLViaCEPSufixoParaRespostaJSON = 'json';

  const
    URLViaCEPSufixoParaRespostaXML = 'xml';
  protected
    { Protected declarations }
  public
    { Public declarations }
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;

    property Enderecos: TList<TConsultaEndereco> read FEnderecos;
    property Mensagem: string read FMensagem;

    function ConsultarCEP(const CEP: string): Boolean;
    function ConsultarEndereco(const UF, Localidade,
      Logradouro: String): Boolean;
  published
    { Published declarations }
    property TipoResposta: TConsultarCEPTipoResposta read FTipoResposta
      write FTipoResposta;
  end;

  procedure Register;

implementation

uses
  uRemoverCaracteresNaoNumericos;

 procedure Register;
 begin
 RegisterComponents('MVPComponents', [TConsultaCEP]);
 end;

{ TConsultaCEP }

function TConsultaCEP.ConsultarCEP(const CEP: string): Boolean;
begin
  ValidarCEP(CEP);

  FEnderecos.Clear;

  case FTipoResposta of
    cctrJSON:
      begin
        Result := ConsultarCEPJSON(CEP);
      end;
    cctrXML:
      begin
        Result := ConsultarCEPXML(CEP);
      end;
  else
    begin
      raise Exception.Create('Tipo de Resposta não implementado');
    end;
  end;
end;

function TConsultaCEP.ConsultarCEPJSON(const CEP: string): Boolean;
var
  CEPNumerico: String;
  HTTP: TIdHTTP;
  SSLHandler: TIdSSLIOHandlerSocketOpenSSL;
  Resposta: String;
  JSONValue: TJSONValue;
  ConsultaEndereco: TConsultaEndereco;
begin
  Result := False;

  CEPNumerico := RemoverCaracteresNaoNumericos(CEP);

  HTTP := TIdHTTP.Create(nil);
  SSLHandler := TIdSSLIOHandlerSocketOpenSSL.Create(nil);
  SetTLS12(HTTP, SSLHandler); // ViaSoft requer TLS 1.2

  try
    try
      Resposta := HTTP.Get(Format('%s/%s/%s/',
        [URLViaCEP, TIdURI.ParamsEncode(CEPNumerico),
        URLViaCEPSufixoParaRespostaJSON]));

      JSONValue := TJSONObject.ParseJSONValue(TEncoding.UTF8.GetBytes(Resposta),
        0) as TJSONValue;

      try
        if JSONValue.GetValue<string>('erro', EmptyStr) <> EmptyStr then
        begin
          FMensagem := 'CEP não encontrado';
          Exit;
        end;

        ConsultaEndereco := TConsultaEndereco.Create;

        JSONValueToConsultaEndereco(JSONValue, ConsultaEndereco);

        FEnderecos.Add(ConsultaEndereco);

        Result := True;
      finally
        JSONValue.Free;
      end;
    except
      on E: EIdSocketError do
      begin
        raise Exception.Create('Erro de conexão a API ViaCEP: ' + E.Message);
      end;
      on E: Exception do
      begin
        raise Exception.Create('Erro ao consultar CEP: ' + E.Message);
      end;
    end;
  finally
    SSLHandler.Free;
    HTTP.Free;
  end;
end;

function TConsultaCEP.ConsultarCEPXML(const CEP: string): Boolean;
var
  CEPNumerico: String;
  HTTP: TIdHTTP;
  SSLHandler: TIdSSLIOHandlerSocketOpenSSL;
  RespostaStream: TStringStream;
  XMLDoc: IXMLDocument;
  Node: IXMLNode;
  ConsultaEndereco: TConsultaEndereco;
begin
  Result := False;

  CEPNumerico := RemoverCaracteresNaoNumericos(CEP);

  HTTP := TIdHTTP.Create(nil);
  SSLHandler := TIdSSLIOHandlerSocketOpenSSL.Create(nil);
  SetTLS12(HTTP, SSLHandler); // ViaSoft requer TLS 1.2

  try
    try
      RespostaStream := TStringStream.Create('', TEncoding.UTF8);

      HTTP.Get(Format('%s/%s/%s/', [URLViaCEP, TIdURI.ParamsEncode(CEPNumerico),
        URLViaCEPSufixoParaRespostaXML]), RespostaStream);

      RespostaStream.Position := 0;

      XMLDoc := LoadXMLData(RespostaStream.DataString);
      Node := XMLDoc.DocumentElement;

      if Node.ChildNodes.FindNode('erro') <> nil then
      begin
        FMensagem := 'CEP não encontrado';
        Exit;
      end;

      ConsultaEndereco := TConsultaEndereco.Create;

      XMLNodeToConsultaEndereco(Node, ConsultaEndereco);

      FEnderecos.Add(ConsultaEndereco);

      Result := True;
    except
      on E: EIdSocketError do
      begin
        raise Exception.Create('Erro de conexão a API ViaCEP: ' + E.Message);
      end;
      on E: Exception do
      begin
        raise Exception.Create('Erro ao consultar CEP: ' + E.Message);
      end;
    end;
  finally
    RespostaStream.Free;
    SSLHandler.Free;
    HTTP.Free;
  end;
end;

function TConsultaCEP.ConsultarEndereco(const UF, Localidade,
  Logradouro: String): Boolean;
begin
  ValidarEndereco(UF, Localidade, Logradouro);

  FEnderecos.Clear;

  case FTipoResposta of
    cctrJSON:
      begin
        Result := ConsultarEnderecoJSON(UF, Localidade, Logradouro);
      end;
    cctrXML:
      begin
        Result := ConsultarEnderecoXML(UF, Localidade, Logradouro);
      end;
  else
    begin
      raise Exception.Create('Tipo de Resposta não implementado');
    end;
  end;

end;

function TConsultaCEP.ConsultarEnderecoJSON(const UF, Localidade,
  Logradouro: String): Boolean;
var
  HTTP: TIdHTTP;
  SSLHandler: TIdSSLIOHandlerSocketOpenSSL;
  Resposta: string;
  JSONArray: TJSONArray;
  ConsultaEndereco: TConsultaEndereco;
  i: Integer;
begin
  Result := False;

  HTTP := TIdHTTP.Create(nil);
  SSLHandler := TIdSSLIOHandlerSocketOpenSSL.Create(nil);
  SetTLS12(HTTP, SSLHandler); // ViaSoft requer TLS 1.2

  try
    try
      Resposta := HTTP.Get(Format('%s/%s/%s/%s/%s/',
        [URLViaCEP, TIdURI.ParamsEncode(UF), TIdURI.ParamsEncode(Localidade),
        TIdURI.ParamsEncode(Logradouro), URLViaCEPSufixoParaRespostaJSON]));

      JSONArray := TJSONObject.ParseJSONValue(TEncoding.UTF8.GetBytes(Resposta),
        0) as TJSONArray;

      try
        if Assigned(JSONArray) and (JSONArray.Count = 0) then
        begin
          FMensagem := 'Endereço não encontrado';
          Exit;
        end;

        for i := 0 to Pred(JSONArray.Count) do
        begin
          ConsultaEndereco := TConsultaEndereco.Create;

          JSONValueToConsultaEndereco(JSONArray.Items[i], ConsultaEndereco);

          FEnderecos.Add(ConsultaEndereco);
        end;

        Result := True;
      finally
        JSONArray.Free;
      end;
    except
      on E: EIdSocketError do
      begin
        raise Exception.Create('Erro de conexão a API ViaCEP: ' + E.Message);
      end;
      on E: Exception do
      begin
        raise Exception.Create('Erro ao consultar CEP: ' + E.Message);
      end;
    end;
  finally
    SSLHandler.Free;
    HTTP.Free;
  end;
end;

function TConsultaCEP.ConsultarEnderecoXML(const UF, Localidade,
  Logradouro: String): Boolean;
var
  HTTP: TIdHTTP;
  SSLHandler: TIdSSLIOHandlerSocketOpenSSL;
  RespostaStream: TStringStream;
  XMLDoc: IXMLDocument;
  Node: IXMLNode;
  ConsultaEndereco: TConsultaEndereco;
  i: Integer;
begin
  Result := False;

  HTTP := TIdHTTP.Create(nil);
  SSLHandler := TIdSSLIOHandlerSocketOpenSSL.Create(nil);
  SetTLS12(HTTP, SSLHandler); // ViaSoft requer TLS 1.2

  try
    try
      RespostaStream := TStringStream.Create('', TEncoding.UTF8);

      HTTP.Get(Format('%s/%s/%s/%s/%s/', [URLViaCEP, TIdURI.ParamsEncode(UF),
        TIdURI.ParamsEncode(Localidade), TIdURI.ParamsEncode(Logradouro),
        URLViaCEPSufixoParaRespostaXML]), RespostaStream);

      RespostaStream.Position := 0;

      XMLDoc := LoadXMLData(RespostaStream.DataString);

      Node := XMLDoc.DocumentElement.ChildNodes.FindNode('enderecos');

      if Assigned(Node) and (Node.ChildNodes.Count = 0) then
      begin
        FMensagem := 'Endereço não encontrado';
        Exit;
      end;

      for i := 0 to Pred(XMLDoc.DocumentElement.ChildNodes.FindNode('enderecos')
        .ChildNodes.Count) do
      begin
        Node := XMLDoc.DocumentElement.ChildNodes.FindNode('enderecos')
          .ChildNodes[i];

        if Node.NodeName = 'endereco' then
        begin
          ConsultaEndereco := TConsultaEndereco.Create;

          XMLNodeToConsultaEndereco(Node, ConsultaEndereco);

          FEnderecos.Add(ConsultaEndereco);
        end;
      end;

      Result := True;
    except
      on E: EIdSocketError do
      begin
        raise Exception.Create('Erro de conexão a API ViaCEP: ' + E.Message);
      end;
      on E: Exception do
      begin
        raise Exception.Create('Erro ao consultar CEP: ' + E.Message);
      end;
    end;
  finally
    RespostaStream.Free;
    SSLHandler.Free;
    HTTP.Free;
  end;
end;

constructor TConsultaCEP.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FTipoResposta := cctrJSON;
  FEnderecos := TList<TConsultaEndereco>.Create;
end;

destructor TConsultaCEP.Destroy;
begin
  FEnderecos.Free;
  inherited;
end;

procedure TConsultaCEP.JSONValueToConsultaEndereco(JSONValue: TJSONValue;
  ConsultaEndereco: TConsultaEndereco);
begin
  ConsultaEndereco.CEP := JSONValue.GetValue<string>('cep', EmptyStr);
  ConsultaEndereco.Logradouro := JSONValue.GetValue<string>('logradouro',
    EmptyStr);
  ConsultaEndereco.Complemento := JSONValue.GetValue<string>('complemento',
    EmptyStr);
  ConsultaEndereco.Bairro := JSONValue.GetValue<string>('bairro', EmptyStr);
  ConsultaEndereco.Localidade := JSONValue.GetValue<string>('localidade',
    EmptyStr);
  ConsultaEndereco.UF := JSONValue.GetValue<string>('uf', EmptyStr);
end;

procedure TConsultaCEP.SetTLS12(HTTP: TIdHTTP;
  SSLHandler: TIdSSLIOHandlerSocketOpenSSL);
begin
  SSLHandler.SSLOptions.Method := sslvTLSv1_2;
  SSLHandler.SSLOptions.SSLVersions := [sslvTLSv1_2];
  HTTP.IOHandler := SSLHandler;
end;

procedure TConsultaCEP.ValidarCEP(const CEP: String);
begin
  if Length(RemoverCaracteresNaoNumericos(CEP)) <> 8 then
  begin
    raise Exception.Create('CEP inválido');
  end;
end;

procedure TConsultaCEP.ValidarEndereco(const UF, Localidade,
  Logradouro: String);
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

procedure TConsultaCEP.XMLNodeToConsultaEndereco(Node: IXMLNode;
  ConsultaEndereco: TConsultaEndereco);
begin
  ConsultaEndereco.CEP := Node.ChildNodes['cep'].Text;
  ConsultaEndereco.Logradouro := Node.ChildNodes['logradouro'].Text;
  ConsultaEndereco.Complemento := Node.ChildNodes['complemento'].Text;
  ConsultaEndereco.Bairro := Node.ChildNodes['bairro'].Text;
  ConsultaEndereco.Localidade := Node.ChildNodes['localidade'].Text;
  ConsultaEndereco.UF := Node.ChildNodes['uf'].Text;
end;

end.

// TODO - Colocar icone no componente
