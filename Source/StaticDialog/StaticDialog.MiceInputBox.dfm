object MiceInputBox: TMiceInputBox
  Left = 0
  Top = 0
  BorderStyle = bsDialog
  Caption = 'Input new value'
  ClientHeight = 102
  ClientWidth = 316
  Color = clWhite
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
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
  object edText: TcxTextEdit
    Left = 62
    Top = 28
    Properties.OnChange = edTextPropertiesChange
    TabOrder = 0
    Text = 'edText'
    Width = 243
  end
  object bnOK: TcxButton
    Left = 149
    Top = 64
    Width = 75
    Height = 25
    Caption = 'OK'
    Default = True
    Enabled = False
    ModalResult = 1
    TabOrder = 1
  end
  object bnCancel: TcxButton
    Left = 230
    Top = 64
    Width = 75
    Height = 25
    Cancel = True
    Caption = 'Cancel'
    ModalResult = 2
    TabOrder = 2
  end
  object lbText: TcxLabel
    Left = 62
    Top = 5
    Caption = 'Input string'
  end
  object Timer1: TTimer
    Enabled = False
    Interval = 500
    OnTimer = Timer1Timer
    Left = 24
    Top = 64
  end
end
