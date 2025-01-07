object ThreadProgressForm: TThreadProgressForm
  Left = 0
  Top = 0
  BorderStyle = bsDialog
  Caption = 'Processing'
  ClientHeight = 113
  ClientWidth = 514
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  PixelsPerInch = 96
  TextHeight = 13
  object pnTop: TPanel
    Left = 0
    Top = 0
    Width = 514
    Height = 41
    Align = alTop
    BevelOuter = bvNone
    ShowCaption = False
    TabOrder = 0
    object lbUserMessage: TLabel
      Left = 211
      Top = 14
      Width = 80
      Height = 13
      Caption = '<UserMessage>'
    end
  end
  object pnMid: TPanel
    Left = 0
    Top = 41
    Width = 514
    Height = 24
    Align = alTop
    BevelOuter = bvNone
    ShowCaption = False
    TabOrder = 1
    object cxProgressBar1: TcxProgressBar
      Left = 0
      Top = 0
      Align = alClient
      TabOrder = 0
      ExplicitTop = -6
      Width = 514
    end
  end
  object pnBottom: TPanel
    Left = 0
    Top = 65
    Width = 514
    Height = 41
    Align = alTop
    BevelOuter = bvNone
    ShowCaption = False
    TabOrder = 2
    object bnAll: TcxButton
      Left = 211
      Top = 14
      Width = 80
      Height = 25
      Cancel = True
      Caption = 'Cancel'
      TabOrder = 0
    end
  end
end
