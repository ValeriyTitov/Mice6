inherited ExternalFileDlg: TExternalFileDlg
  ActiveControl = bnOK
  Caption = 'Select action'
  ClientHeight = 247
  ClientWidth = 391
  Constraints.MinHeight = 240
  Constraints.MinWidth = 320
  OnCreate = FormCreate
  ExplicitWidth = 407
  ExplicitHeight = 285
  PixelsPerInch = 96
  TextHeight = 13
  inherited pnBottomButtons: TPanel
    Top = 206
    Width = 391
    ExplicitTop = 206
    ExplicitWidth = 391
    inherited bnOK: TcxButton
      Left = 221
      ExplicitLeft = 221
    end
    inherited bnCancel: TcxButton
      Left = 302
      ExplicitLeft = 302
    end
  end
  object Panel1: TPanel
    Left = 0
    Top = 0
    Width = 391
    Height = 206
    Align = alClient
    BevelOuter = bvNone
    ShowCaption = False
    TabOrder = 1
    object infoMemo: TcxMemo
      Left = 0
      Top = 81
      Align = alClient
      Properties.ReadOnly = True
      Style.Color = 15329769
      TabOrder = 0
      Height = 125
      Width = 391
    end
    object Panel2: TPanel
      Left = 0
      Top = 0
      Width = 391
      Height = 81
      Align = alTop
      BevelOuter = bvNone
      ShowCaption = False
      TabOrder = 1
      DesignSize = (
        391
        81)
      object Label1: TLabel
        Left = 313
        Top = 9
        Width = 64
        Height = 13
        Cursor = crHandPoint
        Anchors = [akTop, akRight]
        Caption = '%AppData%'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clBlue
        Font.Height = -11
        Font.Name = 'Tahoma'
        Font.Style = []
        ParentFont = False
        OnClick = Label1Click
      end
      object Image1: TImage
        Left = 21
        Top = 22
        Width = 32
        Height = 32
      end
      object rbSaveAs: TcxRadioButton
        Left = 80
        Top = 48
        Width = 113
        Height = 17
        Caption = 'Save as...'
        TabOrder = 0
        OnDblClick = rbSaveAndExecuteDblClick
      end
      object rbSaveAndExecute: TcxRadioButton
        Left = 80
        Top = 8
        Width = 129
        Height = 17
        Caption = 'Save and execute'
        Checked = True
        TabOrder = 1
        TabStop = True
        OnDblClick = rbSaveAndExecuteDblClick
      end
      object rbSaveAndBrowse: TcxRadioButton
        Left = 80
        Top = 28
        Width = 129
        Height = 17
        Caption = 'Save and browse'
        TabOrder = 2
        OnDblClick = rbSaveAndExecuteDblClick
      end
    end
  end
end
