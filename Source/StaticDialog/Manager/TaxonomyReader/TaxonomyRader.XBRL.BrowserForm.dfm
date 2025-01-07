object XbrlBrowserForm: TXbrlBrowserForm
  Left = 0
  Top = 0
  Caption = 'Browse'
  ClientHeight = 375
  ClientWidth = 642
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  PixelsPerInch = 96
  TextHeight = 13
  object pnTop: TPanel
    Left = 0
    Top = 0
    Width = 642
    Height = 60
    Align = alTop
    BevelOuter = bvNone
    ShowCaption = False
    TabOrder = 0
    object cbDefinitions: TComboBox
      Left = 0
      Top = 0
      Width = 642
      Height = 21
      Align = alTop
      Style = csDropDownList
      TabOrder = 0
      OnChange = cbDefinitionsChange
    end
    object memDesc: TcxMemo
      Left = 0
      Top = 21
      Align = alClient
      Properties.ReadOnly = True
      TabOrder = 1
      ExplicitLeft = 48
      ExplicitTop = 27
      ExplicitHeight = 60
      Height = 39
      Width = 642
    end
  end
  object pgData: TPageControl
    Left = 0
    Top = 60
    Width = 642
    Height = 274
    Align = alClient
    TabOrder = 1
    ExplicitTop = 21
    ExplicitHeight = 313
  end
  object Panel1: TPanel
    Left = 0
    Top = 334
    Width = 642
    Height = 41
    Align = alBottom
    BevelOuter = bvNone
    TabOrder = 2
    object bnImport: TcxButton
      Left = 272
      Top = 6
      Width = 75
      Height = 25
      Caption = 'Import'
      Enabled = False
      TabOrder = 0
      OnClick = bnImportClick
    end
  end
end
