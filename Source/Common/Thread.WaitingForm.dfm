object ThreadWaitingForm: TThreadWaitingForm
  Left = 0
  Top = 0
  BorderStyle = bsToolWindow
  Caption = 'Work in progress'
  ClientHeight = 194
  ClientWidth = 331
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  OnCloseQuery = FormCloseQuery
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object pnMain: TPanel
    Left = 0
    Top = 0
    Width = 331
    Height = 93
    Align = alClient
    BevelOuter = bvNone
    Color = clWhite
    ParentBackground = False
    ShowCaption = False
    TabOrder = 0
    object Indicator: TdxActivityIndicator
      Left = 0
      Top = 0
      Width = 331
      Height = 74
      Align = alClient
      PropertiesClassName = 'TdxActivityIndicatorCircularDotsProperties'
      Properties.OverlayColor = -1
    end
    object pnInfo: TPanel
      Left = 0
      Top = 74
      Width = 331
      Height = 19
      Align = alBottom
      BevelOuter = bvNone
      ShowCaption = False
      TabOrder = 1
      object lbInfo: TLabel
        Left = 0
        Top = 0
        Width = 331
        Height = 19
        Align = alClient
        Alignment = taCenter
        AutoSize = False
        Caption = 'Information'
        ExplicitLeft = 128
        ExplicitWidth = 56
        ExplicitHeight = 13
      end
    end
  end
  object pnBottom: TPanel
    Left = 0
    Top = 153
    Width = 331
    Height = 41
    Align = alBottom
    BevelOuter = bvNone
    Color = clWhite
    ParentBackground = False
    ShowCaption = False
    TabOrder = 1
    object bnClose: TcxButton
      Left = 127
      Top = 6
      Width = 75
      Height = 25
      Caption = 'Cancel'
      TabOrder = 0
      OnClick = bnCloseClick
    end
  end
  object pnError: TPanel
    Left = 0
    Top = 93
    Width = 331
    Height = 60
    Align = alBottom
    BevelOuter = bvNone
    ShowCaption = False
    TabOrder = 2
    Visible = False
    object memoError: TcxMemo
      Left = 0
      Top = 0
      Align = alClient
      Properties.ReadOnly = True
      Properties.ScrollBars = ssVertical
      TabOrder = 0
      Height = 60
      Width = 331
    end
  end
end
