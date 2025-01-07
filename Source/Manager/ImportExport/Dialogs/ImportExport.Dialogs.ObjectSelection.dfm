inherited AppObjectExportDlg: TAppObjectExportDlg
  Caption = 'Select properties to export'
  ClientHeight = 361
  ClientWidth = 624
  Constraints.MinHeight = 400
  Constraints.MinWidth = 640
  ExplicitWidth = 640
  ExplicitHeight = 400
  TextHeight = 13
  inherited pnBottomButtons: TPanel
    Top = 320
    Width = 624
    ExplicitTop = 320
    ExplicitWidth = 624
    object lbCount: TLabel [0]
      Left = 16
      Top = 14
      Width = 77
      Height = 13
      Caption = '0 items selected'
    end
    inherited bnOK: TcxButton
      Left = 454
      Caption = 'Save as..'
      Enabled = False
      ModalResult = 0
      ExplicitLeft = 454
    end
    inherited bnCancel: TcxButton
      Left = 535
      Caption = 'Close'
      ExplicitLeft = 535
    end
    object bnPreview: TcxButton
      Left = 374
      Top = 9
      Width = 75
      Height = 25
      Anchors = [akRight, akBottom]
      Caption = 'Preview'
      Default = True
      Enabled = False
      TabOrder = 2
    end
    object bnBuild: TcxButton
      Left = 293
      Top = 9
      Width = 75
      Height = 25
      Anchors = [akRight, akBottom]
      Caption = 'Build'
      Default = True
      Enabled = False
      TabOrder = 3
    end
    object Progress: TcxProgressBar
      Left = 8
      Top = 11
      Anchors = [akLeft, akTop, akRight]
      Properties.Max = 1.000000000000000000
      Properties.OverloadValue = 1.000000000000000000
      TabOrder = 4
      Visible = False
      Width = 279
    end
  end
  object pgMain: TcxPageControl
    Left = 0
    Top = 41
    Width = 624
    Height = 279
    Align = alClient
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Tahoma'
    Font.Style = [fsBold]
    ParentFont = False
    TabOrder = 1
    Properties.CustomButtons.Buttons = <>
    ClientRectBottom = 275
    ClientRectLeft = 4
    ClientRectRight = 620
    ClientRectTop = 4
  end
  object Panel1: TPanel
    Left = 0
    Top = 0
    Width = 624
    Height = 41
    Align = alTop
    BevelOuter = bvNone
    TabOrder = 2
    object Image1: TImage
      Left = 8
      Top = 3
      Width = 32
      Height = 32
    end
    object lbDescription: TLabel
      Left = 64
      Top = 14
      Width = 196
      Height = 13
      Caption = 'Select data to include in export assembly'
    end
  end
  object ExportDialog: TSaveDialog
    Filter = 'Json Files|*.json'
    Options = [ofOverwritePrompt, ofHideReadOnly, ofEnableSizing]
    Left = 248
    Top = 217
  end
end
