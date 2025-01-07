inherited MessageDialog: TMessageDialog
  Caption = 'Dialog'
  ClientHeight = 361
  ClientWidth = 524
  Constraints.MinHeight = 200
  Constraints.MinWidth = 400
  OnClose = FormClose
  ExplicitWidth = 540
  ExplicitHeight = 400
  TextHeight = 13
  inherited pnBottomButtons: TPanel
    Top = 320
    Width = 524
    ExplicitTop = 320
    ExplicitWidth = 524
    object lbRows: TLabel [0]
      Left = 12
      Top = 14
      Width = 50
      Height = 13
      Caption = 'Rows: %d'
    end
    inherited bnOK: TcxButton
      Left = 354
      ExplicitLeft = 354
    end
    inherited bnCancel: TcxButton
      Left = 435
      ExplicitLeft = 435
    end
  end
  object pnTop: TPanel
    Left = 0
    Top = 0
    Width = 524
    Height = 41
    Align = alTop
    BevelOuter = bvNone
    ShowCaption = False
    TabOrder = 1
    object Image: TImage
      Left = 11
      Top = 5
      Width = 32
      Height = 32
      Proportional = True
      Stretch = True
      Transparent = True
    end
    object lbInfo: TLabel
      Left = 53
      Top = 14
      Width = 28
      Height = 13
      Caption = 'lbInfo'
    end
  end
  object pgTextStyle: TcxPageControl
    Left = 0
    Top = 41
    Width = 524
    Height = 279
    Align = alClient
    TabOrder = 2
    Properties.ActivePage = TabSimpleText
    Properties.CustomButtons.Buttons = <>
    OnPageChanging = pgTextStylePageChanging
    ClientRectBottom = 275
    ClientRectLeft = 4
    ClientRectRight = 520
    ClientRectTop = 24
    object TabSimpleText: TcxTabSheet
      Caption = 'Simple Text'
      ImageIndex = 0
      object Memo: TcxMemo
        Left = 0
        Top = 0
        Align = alClient
        Properties.ReadOnly = True
        Properties.ScrollBars = ssVertical
        Properties.WordWrap = False
        Properties.OnChange = MemoPropertiesChange
        TabOrder = 0
        Height = 251
        Width = 516
      end
    end
    object TabJsonText: TcxTabSheet
      Caption = 'Json Text'
      ImageIndex = 1
      object MemoJson: TDBMemo
        Left = 0
        Top = 0
        Width = 516
        Height = 251
        Align = alClient
        DataField = 'TextHolder'
        DataSource = DataSource
        PopupMenu = PopupMenu1
        TabOrder = 0
      end
    end
    object TabXmlText: TcxTabSheet
      Caption = 'Xml Text'
      ImageIndex = 2
      object MemoXml: TDBMemo
        Left = 0
        Top = 0
        Width = 516
        Height = 251
        Align = alClient
        DataField = 'TextHolder'
        DataSource = DataSource
        PopupMenu = PopupMenu1
        TabOrder = 0
      end
    end
  end
  object dsText: TdxMemData
    Indexes = <>
    SortOptions = []
    Left = 360
    Top = 16
    object dsTextTextHolder: TMemoField
      FieldName = 'TextHolder'
      BlobType = ftMemo
    end
  end
  object DataSource: TDataSource
    DataSet = dsText
    Left = 304
    Top = 16
  end
  object ActionList1: TActionList
    Left = 488
    Top = 16
    object EditSelectAll1: TEditSelectAll
      Category = 'Edit'
      Caption = 'Select &All'
      Hint = 'Select All|Selects the entire document'
      ShortCut = 16449
    end
    object EditCopy1: TEditCopy
      Category = 'Edit'
      Caption = '&Copy'
      Hint = 'Copy|Copies the selection and puts it on the Clipboard'
      ImageIndex = 1
      ShortCut = 16451
    end
  end
  object PopupMenu1: TPopupMenu
    Left = 420
    Top = 17
    object Copy1: TMenuItem
      Action = EditCopy1
    end
    object SelectAll1: TMenuItem
      Action = EditSelectAll1
    end
  end
end
