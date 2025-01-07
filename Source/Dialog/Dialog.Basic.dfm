object BasicDialog: TBasicDialog
  Left = 0
  Top = 0
  Caption = 'Basic Dialog'
  ClientHeight = 282
  ClientWidth = 418
  Color = clBtnFace
  Constraints.MinHeight = 140
  Constraints.MinWidth = 210
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  Position = poScreenCenter
  ShowHint = True
  TextHeight = 13
  object pnBottomButtons: TPanel
    Left = 0
    Top = 241
    Width = 418
    Height = 41
    Align = alBottom
    BevelOuter = bvNone
    TabOrder = 0
    DesignSize = (
      418
      41)
    object bnOK: TcxButton
      Left = 248
      Top = 8
      Width = 75
      Height = 25
      Anchors = [akRight, akBottom]
      Caption = 'OK'
      Default = True
      ModalResult = 1
      TabOrder = 0
    end
    object bnCancel: TcxButton
      Left = 329
      Top = 8
      Width = 75
      Height = 25
      Anchors = [akRight, akBottom]
      Cancel = True
      Caption = 'Cancel'
      ModalResult = 2
      TabOrder = 1
    end
  end
end
