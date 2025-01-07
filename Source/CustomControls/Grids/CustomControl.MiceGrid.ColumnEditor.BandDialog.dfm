inherited BandPropetiesDlg: TBandPropetiesDlg
  Caption = 'Band Properties'
  ClientHeight = 213
  ClientWidth = 300
  OnCreate = FormCreate
  ExplicitWidth = 316
  ExplicitHeight = 251
  PixelsPerInch = 96
  TextHeight = 13
  object Label1: TLabel [0]
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
  object Image1: TImage [1]
    Left = 8
    Top = 17
    Width = 32
    Height = 32
    Transparent = True
  end
  object lbColType: TLabel [2]
    Left = 8
    Top = 75
    Width = 26
    Height = 13
    Caption = 'Fixed'
  end
  object Label2: TLabel [3]
    Left = 8
    Top = 102
    Width = 23
    Height = 13
    Caption = 'Align'
  end
  inherited pnBottomButtons: TPanel
    Top = 172
    Width = 300
    inherited bnOK: TcxButton
      Left = 130
    end
    inherited bnCancel: TcxButton
      Left = 211
    end
  end
  object cbFixed: TcxDBImageComboBox
    Left = 56
    Top = 71
    DataBinding.DataField = 'Fixed'
    DataBinding.DataSource = DataSource
    Properties.Images = ImageContainer.Images16
    Properties.Items = <
      item
        Description = 'None'
        ImageIndex = 0
        Value = 0
      end
      item
        Description = 'Left'
        ImageIndex = 37
        Value = 1
      end
      item
        Description = 'Right'
        ImageIndex = 45
        Value = 2
      end>
    TabOrder = 1
    Width = 121
  end
  object cbMoving: TcxDBCheckBox
    Left = 56
    Top = 130
    Caption = 'Moving'
    DataBinding.DataField = 'Moving'
    DataBinding.DataSource = DataSource
    TabOrder = 2
  end
  object cbAlign: TcxDBImageComboBox
    Left = 56
    Top = 98
    DataBinding.DataField = 'Align'
    DataBinding.DataSource = DataSource
    Properties.Images = ImageContainer.Images16
    Properties.Items = <
      item
        Description = 'Left'
        ImageIndex = 37
        Value = 0
      end
      item
        Description = 'Right'
        ImageIndex = 45
        Value = 1
      end
      item
        Description = 'Center'
        ImageIndex = 34
        Value = 2
      end>
    TabOrder = 3
    Width = 121
  end
  object DataSource: TDataSource
    Left = 248
    Top = 16
  end
end
