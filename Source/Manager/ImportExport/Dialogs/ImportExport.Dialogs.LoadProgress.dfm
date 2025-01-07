object LoadProgressForm: TLoadProgressForm
  Left = 0
  Top = 0
  BorderStyle = bsSizeToolWin
  Caption = 'Information'
  ClientHeight = 261
  ClientWidth = 584
  Color = clBtnFace
  Constraints.MinHeight = 300
  Constraints.MinWidth = 600
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -12
  Font.Name = 'Segoe UI'
  Font.Style = []
  Position = poScreenCenter
  TextHeight = 15
  object Panel1: TPanel
    Left = 0
    Top = 242
    Width = 584
    Height = 19
    Align = alBottom
    BevelOuter = bvNone
    ShowCaption = False
    TabOrder = 0
    object ProgressBar1: TProgressBar
      Left = 0
      Top = 0
      Width = 584
      Height = 19
      Align = alClient
      TabOrder = 0
    end
  end
  object InfoRich: TcxRichEdit
    Left = 0
    Top = 0
    Align = alClient
    Properties.ReadOnly = True
    Properties.ScrollBars = ssVertical
    Properties.WordWrap = False
    TabOrder = 1
    Height = 242
    Width = 584
  end
end
