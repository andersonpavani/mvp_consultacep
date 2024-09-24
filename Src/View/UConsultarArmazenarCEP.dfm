object FConsultarArmazenarCEP: TFConsultarArmazenarCEP
  Left = 0
  Top = 0
  Caption = 'Consultar/Armazenar CEP'
  ClientHeight = 619
  ClientWidth = 1164
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -12
  Font.Name = 'Segoe UI'
  Font.Style = []
  Position = poScreenCenter
  OnCreate = FormCreate
  DesignSize = (
    1164
    619)
  TextHeight = 15
  object GbTipoConsulta: TGroupBox
    Left = 984
    Top = 7
    Width = 169
    Height = 58
    Anchors = [akTop, akRight]
    Caption = 'Tipo da Consulta'
    TabOrder = 1
    object RbTipoConsultaViaJSON: TRadioButton
      Left = 17
      Top = 24
      Width = 71
      Height = 17
      Caption = 'Via JSON'
      Checked = True
      TabOrder = 0
      TabStop = True
    end
    object RbTipoConsultaViaXML: TRadioButton
      Left = 93
      Top = 24
      Width = 66
      Height = 17
      Caption = 'Via XML'
      TabOrder = 1
    end
  end
  object GbBusca: TGroupBox
    Left = 12
    Top = 7
    Width = 961
    Height = 57
    Anchors = [akLeft, akTop, akRight]
    Caption = 'Buscar Endere'#231'o'
    TabOrder = 0
    DesignSize = (
      961
      57)
    object LbBuscaExibirTodos: TLabel
      Left = 165
      Top = 25
      Width = 325
      Height = 15
      Caption = 'Exibir todos os endere'#231'os cadastrados na base de dados local.'
      Visible = False
    end
    object GpLayoutCamposEndereco: TGridPanel
      Left = 165
      Top = 21
      Width = 570
      Height = 23
      Anchors = [akLeft, akTop, akRight]
      BevelOuter = bvNone
      ColumnCollection = <
        item
          Value = 33.333000000000000000
        end
        item
          Value = 33.333000000000000000
        end
        item
          Value = 33.334000000000000000
        end>
      ControlCollection = <
        item
          Column = 0
          Control = CbBuscaUF
          Row = 0
        end
        item
          Column = 1
          Control = EdBuscaLocalidade
          Row = 0
        end
        item
          Column = 2
          Control = EdBuscaLogradouro
          Row = 0
        end>
      RowCollection = <
        item
          Value = 100.000000000000000000
        end>
      TabOrder = 2
      Visible = False
      object CbBuscaUF: TComboBox
        AlignWithMargins = True
        Left = 0
        Top = 0
        Width = 187
        Height = 23
        Margins.Left = 0
        Margins.Top = 0
        Margins.Bottom = 0
        Align = alClient
        Style = csDropDownList
        TabOrder = 0
        TextHint = 'UF'
      end
      object EdBuscaLocalidade: TEdit
        AlignWithMargins = True
        Left = 193
        Top = 0
        Width = 184
        Height = 23
        Margins.Top = 0
        Margins.Bottom = 0
        Align = alClient
        TabOrder = 1
        TextHint = 'Localidade'
      end
      object EdBuscaLogradouro: TEdit
        AlignWithMargins = True
        Left = 383
        Top = 0
        Width = 187
        Height = 23
        Margins.Top = 0
        Margins.Right = 0
        Margins.Bottom = 0
        Align = alClient
        TabOrder = 2
        TextHint = 'Logradouro'
      end
    end
    object EdBuscaCEP: TEdit
      Left = 165
      Top = 21
      Width = 570
      Height = 23
      Anchors = [akLeft, akTop, akRight]
      TabOrder = 1
      TextHint = 'Informe o CEP'
    end
    object CbOpcaoBusca: TComboBox
      Left = 14
      Top = 21
      Width = 145
      Height = 23
      Style = csDropDownList
      ItemIndex = 0
      TabOrder = 0
      Text = 'Busca por CEP'
      OnChange = CbOpcaoBuscaChange
      Items.Strings = (
        'Busca por CEP'
        'Busca por Endere'#231'o'
        'Exibir Todos')
    end
    object BtLimpar: TBitBtn
      Left = 847
      Top = 19
      Width = 100
      Height = 28
      Anchors = [akTop, akRight]
      Caption = 'Limpar'
      TabOrder = 4
      OnClick = BtLimparClick
    end
    object BtBuscar: TBitBtn
      Left = 741
      Top = 19
      Width = 100
      Height = 28
      Anchors = [akTop, akRight]
      Caption = 'Buscar'
      TabOrder = 3
      OnClick = BtBuscarClick
    end
  end
  object StatusBar: TStatusBar
    Left = 0
    Top = 600
    Width = 1164
    Height = 19
    Panels = <
      item
        Width = 50
      end>
  end
  object SgEnderecos: TStringGrid
    Left = 12
    Top = 76
    Width = 1141
    Height = 512
    Anchors = [akLeft, akTop, akRight, akBottom]
    DefaultRowHeight = 28
    FixedCols = 0
    RowCount = 2
    TabOrder = 3
  end
end
