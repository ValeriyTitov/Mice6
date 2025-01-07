inherited ManagerDialogAppDataSet: TManagerDialogAppDataSet
  Caption = 'Edit Dataset'
  ClientHeight = 616
  ClientWidth = 757
  ExplicitWidth = 773
  ExplicitHeight = 655
  TextHeight = 13
  inherited pnBottomButtons: TPanel
    Top = 575
    Width = 757
    ExplicitTop = 575
    ExplicitWidth = 757
    inherited bnOK: TcxButton
      Left = 589
      ExplicitLeft = 589
    end
    inherited bnCancel: TcxButton
      Left = 670
      ExplicitLeft = 670
    end
  end
  inherited DialogLayout: TdxLayoutControl
    Width = 757
    Height = 575
    ExplicitWidth = 757
    ExplicitHeight = 575
    object TableGrid: TcxGrid [0]
      Left = 6
      Top = 304
      Width = 745
      Height = 265
      PopupMenu = PopupMenu1
      TabOrder = 4
      object TableGridView: TcxGridDBTableView
        Navigator.Buttons.CustomButtons = <>
        ScrollbarAnnotations.CustomAnnotations = <>
        OnCustomDrawCell = TableGridViewCustomDrawCell
        DataController.DataSource = dsGrid
        DataController.Summary.DefaultGroupSummaryItems = <>
        DataController.Summary.FooterSummaryItems = <>
        DataController.Summary.SummaryGroups = <>
        OptionsView.GroupByBox = False
      end
      object TableGridLevel1: TcxGridLevel
        GridView = TableGridView
      end
    end
    object cbDBName: TcxDBComboBox [1]
      Left = 615
      Top = 45
      AutoSize = False
      DataBinding.DataField = 'DBName'
      DataBinding.DataSource = MainSource
      Style.BorderColor = clWindowFrame
      Style.BorderStyle = ebsFlat
      Style.HotTrack = False
      Style.ButtonStyle = btsFlat
      Style.PopupBorderStyle = epbsFlat
      TabOrder = 1
      OnExit = cbDBNameExit
      Height = 21
      Width = 121
    end
    object cbTableName: TcxDBComboBox [2]
      Left = 21
      Top = 45
      AutoSize = False
      DataBinding.DataField = 'TableName'
      DataBinding.DataSource = MainSource
      Properties.OnChange = cbTableNamePropertiesChange
      Style.BorderColor = clWindowFrame
      Style.BorderStyle = ebsFlat
      Style.HotTrack = False
      Style.ButtonStyle = btsFlat
      Style.PopupBorderStyle = epbsFlat
      TabOrder = 0
      Height = 21
      Width = 588
    end
    object memoDescription: TcxDBMemo [3]
      Left = 21
      Top = 90
      DataBinding.DataField = 'Description'
      DataBinding.DataSource = MainSource
      Style.BorderColor = clWindowFrame
      Style.BorderStyle = ebsFlat
      Style.HotTrack = False
      TabOrder = 2
      Height = 42
      Width = 715
    end
    object memoProviderName: TDBMemo [4]
      Left = 23
      Top = 158
      Width = 711
      Height = 123
      BevelInner = bvNone
      BevelOuter = bvSpace
      BevelKind = bkFlat
      BorderStyle = bsNone
      DataField = 'ProviderName'
      DataSource = MainSource
      PopupMenu = PopupMenu2
      TabOrder = 3
    end
    inherited DialogLayoutGroup_Root: TdxLayoutGroup
      LayoutDirection = ldVertical
    end
    object item_TopGroup: TdxLayoutGroup
      Parent = DialogLayoutGroup_Root
      AlignVert = avClient
      CaptionOptions.Text = 'Properties'
      Index = 0
    end
    object item_TableGrid: TdxLayoutItem
      Parent = DialogLayoutGroup_Root
      AlignVert = avClient
      CaptionOptions.Text = 'cxGrid1'
      CaptionOptions.Visible = False
      Control = TableGrid
      ControlOptions.OriginalHeight = 200
      ControlOptions.OriginalWidth = 250
      ControlOptions.ShowBorder = False
      Index = 1
    end
    object item_cbDBName: TdxLayoutItem
      Parent = dxLayoutAutoCreatedGroup1
      AlignHorz = ahLeft
      AlignVert = avClient
      CaptionOptions.AlignVert = tavTop
      CaptionOptions.Text = 'DBName'
      CaptionOptions.Layout = clTop
      Control = cbDBName
      ControlOptions.OriginalHeight = 21
      ControlOptions.OriginalWidth = 121
      ControlOptions.ShowBorder = False
      Index = 1
    end
    object dxLayoutAutoCreatedGroup1: TdxLayoutAutoCreatedGroup
      Parent = item_TopGroup
      AlignVert = avTop
      LayoutDirection = ldHorizontal
      Index = 0
    end
    object item_cbTableName: TdxLayoutItem
      Parent = dxLayoutAutoCreatedGroup1
      AlignHorz = ahClient
      AlignVert = avClient
      CaptionOptions.AlignVert = tavTop
      CaptionOptions.Text = 'Table Name'
      CaptionOptions.Layout = clTop
      Control = cbTableName
      ControlOptions.OriginalHeight = 21
      ControlOptions.OriginalWidth = 121
      ControlOptions.ShowBorder = False
      Index = 0
    end
    object item_memoDescription: TdxLayoutItem
      Parent = item_TopGroup
      AlignHorz = ahClient
      AlignVert = avClient
      CaptionOptions.AlignVert = tavTop
      CaptionOptions.Text = 'Description'
      CaptionOptions.Layout = clTop
      Control = memoDescription
      ControlOptions.OriginalHeight = 21
      ControlOptions.OriginalWidth = 185
      ControlOptions.ShowBorder = False
      Index = 1
    end
    object item_ProviderName: TdxLayoutItem
      Parent = item_TopGroup
      AlignVert = avClient
      CaptionOptions.AlignVert = tavTop
      CaptionOptions.Text = 'Provider Name'
      CaptionOptions.Layout = clTop
      Control = memoProviderName
      ControlOptions.OriginalHeight = 73
      ControlOptions.OriginalWidth = 185
      Index = 2
    end
  end
  inherited MainSource: TDataSource
    Left = 24
    Top = 409
  end
  object dsGrid: TDataSource
    Left = 24
    Top = 456
  end
  object PopupMenu1: TPopupMenu
    Images = ImageContainer.Images16
    OnPopup = PopupMenu1Popup
    Left = 56
    Top = 88
    object miAdd: TMenuItem
      Caption = 'Add'
      ImageIndex = 44
      OnClick = miAddClick
    end
    object miDelete: TMenuItem
      Caption = 'Delete'
      ImageIndex = 175
      OnClick = miDeleteClick
    end
    object miClone: TMenuItem
      Caption = 'Clone'
      ImageIndex = 6
      OnClick = miCloneClick
    end
  end
  object ActionManager1: TActionManager
    Left = 664
    Top = 192
    StyleName = 'Platform Default'
    object EditCut1: TEditCut
      Category = 'Edit'
      Caption = 'Cu&t'
      Hint = 'Cut|Cuts the selection and puts it on the Clipboard'
      ImageIndex = 0
      ShortCut = 16472
    end
    object EditCopy1: TEditCopy
      Category = 'Edit'
      Caption = '&Copy'
      Hint = 'Copy|Copies the selection and puts it on the Clipboard'
      ImageIndex = 1
      ShortCut = 16451
    end
    object EditPaste1: TEditPaste
      Category = 'Edit'
      Caption = '&Paste'
      Hint = 'Paste|Inserts Clipboard contents'
      ImageIndex = 2
      ShortCut = 16470
    end
    object EditDelete1: TEditDelete
      Category = 'Edit'
      Caption = '&Delete'
      Hint = 'Delete|Erases the selection'
      ImageIndex = 5
      ShortCut = 46
    end
    object EditSelectAll1: TEditSelectAll
      Category = 'Edit'
      Caption = 'Select &All'
      Hint = 'Select All|Selects the entire document'
      ShortCut = 16449
    end
  end
  object PopupMenu2: TPopupMenu
    Left = 584
    Top = 200
    object Copy1: TMenuItem
      Action = EditCopy1
    end
    object Copy2: TMenuItem
      Action = EditCut1
    end
    object Delete1: TMenuItem
      Action = EditDelete1
    end
    object Paste1: TMenuItem
      Action = EditPaste1
    end
    object SelectAll1: TMenuItem
      Action = EditSelectAll1
    end
  end
end
