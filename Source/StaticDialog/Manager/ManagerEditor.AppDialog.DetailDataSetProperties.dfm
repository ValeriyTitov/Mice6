inherited DetailsDataSetPropertiesDlg: TDetailsDataSetPropertiesDlg
  Caption = 'Properties'
  ClientHeight = 336
  ClientWidth = 406
  ExplicitWidth = 422
  ExplicitHeight = 374
  PixelsPerInch = 96
  TextHeight = 13
  object Image1: TImage [0]
    Left = 8
    Top = 17
    Width = 32
    Height = 32
    Transparent = True
  end
  object Label1: TLabel [1]
    Left = 56
    Top = 27
    Width = 119
    Height = 13
    Caption = 'Additional properties'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Tahoma'
    Font.Style = [fsBold]
    ParentFont = False
  end
  object Label2: TLabel [2]
    Left = 18
    Top = 137
    Width = 47
    Height = 13
    Caption = 'Sequence'
  end
  object Label3: TLabel [3]
    Left = 16
    Top = 110
    Width = 90
    Height = 13
    Caption = 'Sequence DBName'
  end
  object Label4: TLabel [4]
    Left = 18
    Top = 164
    Width = 106
    Height = 13
    Caption = 'ProviderName Pattern'
  end
  inherited pnBottomButtons: TPanel
    Top = 295
    Width = 406
    ExplicitTop = 295
    ExplicitWidth = 406
    inherited bnOK: TcxButton
      Left = 236
      ExplicitLeft = 236
    end
    inherited bnCancel: TcxButton
      Left = 317
      ExplicitLeft = 317
    end
  end
  object edSequenceName: TcxDBButtonEdit
    Left = 132
    Top = 134
    Hint = 'Initialize key field with this sequence when adding records'
    DataBinding.DataField = 'SequenceName'
    DataBinding.DataSource = DataSource1
    Properties.Buttons = <
      item
        Default = True
        Kind = bkEllipsis
      end>
    Properties.OnButtonClick = edSequenceNamePropertiesButtonClick
    TabOrder = 1
    Width = 266
  end
  object cbReadOnly: TcxDBCheckBox
    Left = 8
    Top = 77
    Caption = 'Read Only'
    DataBinding.DataField = 'ReadOnly'
    DataBinding.DataSource = DataSource1
    TabOrder = 2
  end
  object cbSequenceDBName: TcxDBComboBox
    Left = 132
    Top = 107
    DataBinding.DataField = 'SequenceDBName'
    DataBinding.DataSource = DataSource1
    TabOrder = 3
    Width = 266
  end
  object edProviderPattern: TcxDBTextEdit
    Left = 132
    Top = 161
    Hint = 
      'Override standart query SELECT * FROM [%s] WITH (NOLOCK) WHERE %' +
      's=%d'
    DataBinding.DataField = 'ProviderPattern'
    DataBinding.DataSource = DataSource1
    TabOrder = 4
    Width = 266
  end
  object DataSource1: TDataSource
    Left = 224
    Top = 32
  end
end
