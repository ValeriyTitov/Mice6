object TaxonomyReaderLogForm: TTaxonomyReaderLogForm
  Left = 0
  Top = 0
  Caption = 'Loading...'
  ClientHeight = 466
  ClientWidth = 649
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  OnActivate = FormActivate
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  PixelsPerInch = 96
  TextHeight = 13
  object Panel1: TPanel
    Left = 0
    Top = 425
    Width = 649
    Height = 41
    Align = alBottom
    BevelOuter = bvNone
    TabOrder = 0
  end
  object Memo1: TMemo
    Left = 0
    Top = 0
    Width = 649
    Height = 425
    Align = alClient
    ScrollBars = ssVertical
    TabOrder = 1
  end
end
