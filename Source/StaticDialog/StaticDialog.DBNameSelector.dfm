object DBNameSelectorDialog: TDBNameSelectorDialog
  Left = 0
  Top = 0
  BorderStyle = bsDialog
  Caption = 'Select DBName'
  ClientHeight = 102
  ClientWidth = 258
  Color = clWhite
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object Image: TImage
    Left = 19
    Top = 22
    Width = 32
    Height = 32
    Proportional = True
    Stretch = True
    Transparent = True
  end
  object bnOK: TcxButton
    Left = 85
    Top = 69
    Width = 75
    Height = 25
    Caption = 'OK'
    Default = True
    ModalResult = 1
    TabOrder = 0
  end
  object bnCancel: TcxButton
    Left = 166
    Top = 69
    Width = 75
    Height = 25
    Cancel = True
    Caption = 'Cancel'
    ModalResult = 2
    TabOrder = 1
  end
  object lbText: TcxLabel
    Left = 62
    Top = 5
    Caption = 'DBName'
  end
  object edDBName: TcxComboBox
    Left = 65
    Top = 28
    TabOrder = 3
    Text = 'edDBName'
    Width = 176
  end
end
