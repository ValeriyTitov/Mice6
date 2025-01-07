object ManagerMainForm: TManagerMainForm
  Left = 0
  Top = 0
  ActiveControl = MainTree
  Caption = 'Manager of Mice6'
  ClientHeight = 616
  ClientWidth = 340
  Color = clBtnFace
  Constraints.MinHeight = 512
  Constraints.MinWidth = 300
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  Position = poScreenCenter
  OnClose = FormClose
  DesignSize = (
    340
    616)
  TextHeight = 13
  object StatusBar: TdxStatusBar
    Left = 0
    Top = 596
    Width = 340
    Height = 20
    Panels = <
      item
        PanelStyleClassName = 'TdxStatusBarTextPanelStyle'
      end>
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Tahoma'
    Font.Style = []
    OnMouseDown = StatusBarMouseDown
  end
  object pnPath: TPanel
    Left = 0
    Top = 576
    Width = 340
    Height = 20
    Align = alBottom
    BevelOuter = bvNone
    TabOrder = 1
    object edPath: TcxTextEdit
      Left = 0
      Top = 0
      Align = alClient
      TabOrder = 0
      OnKeyPress = edPathKeyPress
      Width = 340
    end
  end
  object MainTree: TcxDBTreeList
    Left = 27
    Top = 25
    Width = 313
    Height = 551
    Align = alClient
    Bands = <
      item
      end>
    DataController.ImageIndexField = 'ImageIndex'
    DataController.ParentField = 'ParentId'
    DataController.KeyField = 'AppMainTreeId'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -9
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    Navigator.Buttons.CustomButtons = <>
    OptionsBehavior.CellHints = True
    OptionsBehavior.ImmediateEditor = False
    OptionsBehavior.ConfirmDelete = False
    OptionsBehavior.CopyCaptionsToClipboard = False
    OptionsBehavior.ExpandOnDblClick = False
    OptionsData.Editing = False
    OptionsData.Deleting = False
    OptionsView.ColumnAutoWidth = True
    OptionsView.Headers = False
    OptionsView.TreeLineStyle = tllsSolid
    ParentFont = False
    PopupMenu = PopupMenu
    RootValue = -1
    ScrollbarAnnotations.CustomAnnotations = <>
    TabOrder = 2
    OnDblClick = MainTreeDblClick
    OnFocusedNodeChanged = MainTreeFocusedNodeChanged
    object colAppMainTreeId: TcxDBTreeListColumn
      Visible = False
      DataBinding.FieldName = 'AppMainTreeId'
      Width = 100
      Position.ColIndex = 1
      Position.RowIndex = 0
      Position.BandIndex = 0
      Summary.FooterSummaryItems = <>
      Summary.GroupFooterSummaryItems = <>
    end
    object colParentId: TcxDBTreeListColumn
      Visible = False
      DataBinding.FieldName = 'ParentId'
      Width = 100
      Position.ColIndex = 4
      Position.RowIndex = 0
      Position.BandIndex = 0
      Summary.FooterSummaryItems = <>
      Summary.GroupFooterSummaryItems = <>
    end
    object colImageIndex: TcxDBTreeListColumn
      Visible = False
      DataBinding.FieldName = 'ImageIndex'
      Width = 100
      Position.ColIndex = 5
      Position.RowIndex = 0
      Position.BandIndex = 0
      Summary.FooterSummaryItems = <>
      Summary.GroupFooterSummaryItems = <>
    end
    object colName: TcxDBTreeListColumn
      DataBinding.FieldName = 'Description'
      Options.Editing = False
      Options.Moving = False
      Width = 95
      Position.ColIndex = 0
      Position.RowIndex = 0
      Position.BandIndex = 0
      Summary.FooterSummaryItems = <>
      Summary.GroupFooterSummaryItems = <>
    end
    object colObjectId: TcxDBTreeListColumn
      Visible = False
      DataBinding.FieldName = 'ObjectId'
      Width = 100
      Position.ColIndex = 2
      Position.RowIndex = 0
      Position.BandIndex = 0
      Summary.FooterSummaryItems = <>
      Summary.GroupFooterSummaryItems = <>
    end
    object colIType: TcxDBTreeListColumn
      Visible = False
      DataBinding.FieldName = 'iType'
      Width = 100
      Position.ColIndex = 3
      Position.RowIndex = 0
      Position.BandIndex = 0
      Summary.FooterSummaryItems = <>
      Summary.GroupFooterSummaryItems = <>
    end
    object colOrderId: TcxDBTreeListColumn
      Visible = False
      DataBinding.FieldName = 'OrderId'
      Width = 100
      Position.ColIndex = 6
      Position.RowIndex = 0
      Position.BandIndex = 0
      Summary.FooterSummaryItems = <>
      Summary.GroupFooterSummaryItems = <>
    end
    object colDBName: TcxDBTreeListColumn
      Visible = False
      DataBinding.FieldName = 'DBName'
      Width = 100
      Position.ColIndex = 7
      Position.RowIndex = 0
      Position.BandIndex = 0
      Summary.FooterSummaryItems = <>
      Summary.GroupFooterSummaryItems = <>
    end
  end
  object Button1: TButton
    Left = 265
    Top = 545
    Width = 75
    Height = 25
    Anchors = [akRight, akBottom]
    Caption = 'Test'
    TabOrder = 5
    OnClick = Button1Click
  end
  object MainBar: TdxBarManager
    AllowReset = False
    Scaled = False
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -12
    Font.Name = 'Segoe UI'
    Font.Style = []
    CanCustomize = False
    Categories.Strings = (
      'Default'
      'PopupMenu'
      'ApplicationObjects'
      'DocFlow'
      'LeftBar')
    Categories.ItemsVisibles = (
      2
      2
      2
      2
      2)
    Categories.Visibles = (
      True
      True
      True
      True
      True)
    ImageOptions.Images = ImageContainer.Images16
    MenusShowRecentItemsFirst = False
    PopupMenuLinks = <>
    Style = bmsFlat
    UseSystemFont = True
    Left = 232
    Top = 88
    PixelsPerInch = 96
    DockControlHeights = (
      27
      0
      25
      0)
    object MainMenuBar: TdxBar
      AllowClose = False
      AllowCustomizing = False
      AllowQuickCustomizing = False
      AllowReset = False
      Caption = 'MainMenu'
      CaptionButtons = <>
      DockedDockingStyle = dsTop
      DockedLeft = 0
      DockedTop = 0
      DockingStyle = dsTop
      FloatLeft = 374
      FloatTop = 8
      FloatClientWidth = 0
      FloatClientHeight = 0
      IsMainMenu = True
      ItemLinks = <
        item
          Visible = True
          ItemName = 'mnFile'
        end
        item
          Visible = True
          ItemName = 'mnSearchMenu'
        end
        item
          Visible = True
          ItemName = 'mnTools'
        end>
      MultiLine = True
      NotDocking = [dsNone, dsLeft, dsTop, dsRight, dsBottom]
      OneOnRow = True
      Row = 0
      UseOwnFont = False
      UseRecentItems = False
      Visible = True
      WholeRow = True
    end
    object SideToolBar: TdxBar
      AllowClose = False
      AllowCustomizing = False
      AllowQuickCustomizing = False
      AllowReset = False
      Caption = 'ToolBar'
      CaptionButtons = <>
      DockedDockingStyle = dsLeft
      DockedLeft = 0
      DockedTop = 0
      DockingStyle = dsLeft
      FloatLeft = 253
      FloatTop = 378
      FloatClientWidth = 51
      FloatClientHeight = 24
      ItemLinks = <
        item
          Visible = True
          ItemName = 'bnChangeImageIndex'
        end
        item
          Visible = True
          ItemName = 'bnCommonCommands'
        end
        item
          Visible = True
          ItemName = 'bnUseOnMainTree'
        end>
      NotDocking = [dsNone, dsLeft, dsTop, dsRight, dsBottom]
      OneOnRow = True
      Row = 0
      UseOwnFont = False
      UseRecentItems = False
      Visible = True
      WholeRow = False
    end
    object bnNewCommandGroup: TdxBarButton
      Caption = 'Command group'
      Category = 0
      Hint = 'Command group'
      Visible = ivAlways
      ImageIndex = 514
    end
    object bnNewFilterGroup: TdxBarButton
      Caption = 'Filter group'
      Category = 0
      Hint = 'Filter group'
      Visible = ivAlways
      ImageIndex = 74
    end
    object bnAddObject: TdxBarSubItem
      Caption = #1054'bject'
      Category = 0
      Visible = ivAlways
      ImageIndex = 12
      ItemLinks = <
        item
          Visible = True
          ItemName = 'bnNewSQLScript'
        end
        item
          Visible = True
          ItemName = 'bnNewPascalScript'
        end
        item
          Visible = True
          ItemName = 'bnNewCSharpScript'
        end
        item
          Visible = True
          ItemName = 'bnNewJson'
        end
        item
          Visible = True
          ItemName = 'bnNewXml'
        end
        item
          Visible = True
          ItemName = 'bnNewExternalFile'
        end
        item
          Visible = True
          ItemName = 'bnNewExportTemplate'
        end
        item
          Visible = True
          ItemName = 'bnNewAppDataSet'
        end>
    end
    object bnRefresh: TdxBarButton
      Caption = 'Refresh'
      Category = 0
      Hint = 'Refresh'
      Visible = ivAlways
      ImageIndex = 29
    end
    object bnCommonCommands: TdxBarButton
      Caption = 'Common Commands'
      Category = 0
      Hint = 'Common Commands'
      Visible = ivAlways
      ImageIndex = 174
    end
    object bnUseOnMainTree: TdxBarButton
      Caption = 'Use On Main Tree'
      Category = 0
      Hint = 'Use On Main Tree'
      Visible = ivAlways
      ImageIndex = 73
    end
    object mnFile: TdxBarSubItem
      Caption = '&File'
      Category = 0
      Visible = ivAlways
      ItemLinks = <
        item
          Visible = True
          ItemName = 'bnExit'
        end>
    end
    object bnExit: TdxBarButton
      Caption = 'Exit'
      Category = 0
      Hint = 'Exit'
      Visible = ivAlways
      OnClick = bnExitClick
    end
    object mnSearchMenu: TdxBarSubItem
      Caption = '&Search'
      Category = 0
      Visible = ivAlways
      ItemLinks = <
        item
          Visible = True
          ItemName = 'bnFind'
        end
        item
          Visible = True
          ItemName = 'bnFindNext'
        end>
    end
    object bnFind: TdxBarButton
      Caption = 'Find...'
      Category = 0
      Hint = 'Find'
      Visible = ivAlways
    end
    object bnFindNext: TdxBarButton
      Caption = 'Find Next'
      Category = 0
      Hint = 'Find Next'
      Visible = ivAlways
    end
    object bnImport: TdxBarButton
      Caption = 'Import'
      Category = 0
      Hint = 'Import'
      Visible = ivAlways
      ImageIndex = 213
      OnClick = bnImportClick
    end
    object bnExportMenu: TdxBarSubItem
      Caption = 'Export'
      Category = 0
      Visible = ivAlways
      ImageIndex = 211
      ItemLinks = <
        item
          Visible = True
          ItemName = 'bnExportCurrent'
        end
        item
          Visible = True
          ItemName = 'bnExportAll'
        end>
    end
    object bnExportAll: TdxBarButton
      Caption = 'All child nodes'
      Category = 0
      Hint = 'All child nodes'
      Visible = ivAlways
      ImageIndex = 687
      OnClick = bnExportAllClick
    end
    object bnExportCurrent: TdxBarButton
      Caption = 'This node only'
      Category = 0
      Hint = 'This node only'
      Visible = ivAlways
      ImageIndex = 271
      OnClick = bnExportCurrentClick
    end
    object mnTools: TdxBarSubItem
      Caption = '&Tools'
      Category = 0
      Visible = ivAlways
      ItemLinks = <
        item
          Visible = True
          ItemName = 'bnImport'
        end>
    end
    object bnNewSubMenu: TdxBarSubItem
      Caption = 'New'
      Category = 1
      Visible = ivAlways
      ImageIndex = 21
      ItemLinks = <
        item
          Visible = True
          ItemName = 'bnNewFolder'
        end
        item
          Visible = True
          ItemName = 'bnNewPlugin'
        end
        item
          Visible = True
          ItemName = 'bnNewDialog'
        end
        item
          Visible = True
          ItemName = 'bnNewLayout'
        end
        item
          Visible = True
          ItemName = 'bnNewCommandGroup'
        end
        item
          Visible = True
          ItemName = 'bnNewCustomCommand'
        end
        item
          Visible = True
          ItemName = 'bnNewCustomFilter'
        end
        item
          Visible = True
          ItemName = 'bnAddObject'
        end
        item
          BeginGroup = True
          Visible = True
          ItemName = 'bnNewdfClass'
        end
        item
          Visible = True
          ItemName = 'bnNewdfTypes'
        end>
    end
    object bnNewFolder: TdxBarButton
      Caption = 'Folder'
      Category = 1
      Hint = 'Folder'
      Visible = ivAlways
      ImageIndex = 80
    end
    object bnRenameItem: TdxBarButton
      Caption = 'Rename'
      Category = 1
      Hint = 'Rename'
      Visible = ivAlways
      ImageIndex = 28
    end
    object bnNewPlugin: TdxBarButton
      Caption = 'Plugin'
      Category = 1
      Hint = 'Plugin'
      Visible = ivAlways
      ImageIndex = 101
    end
    object bnEdit: TdxBarButton
      Caption = 'Edit'
      Category = 1
      Hint = 'Edit'
      Visible = ivAlways
      ImageIndex = 115
    end
    object bnDelete: TdxBarButton
      Caption = 'Delete selected item'
      Category = 1
      Hint = 'Delete selected item'
      Visible = ivAlways
      ImageIndex = 62
    end
    object bnAddRef: TdxBarSubItem
      Caption = 'Add refrence'
      Category = 1
      Visible = ivAlways
      ImageIndex = 70
      ItemLinks = <
        item
          Visible = True
          ItemName = 'bnAddPluginRef'
        end
        item
          Visible = True
          ItemName = 'bnAddDialogRef'
        end
        item
          Visible = True
          ItemName = 'bnAddCommonCommand'
        end>
    end
    object bnAddDialogRef: TdxBarButton
      Caption = 'Dialog...'
      Category = 1
      Hint = 'Add reference to an existing Dialog'
      Visible = ivAlways
      ImageIndex = 38
    end
    object bnAddPluginRef: TdxBarButton
      Caption = 'Plugin...'
      Category = 1
      Hint = 'Add reference to an existing plugin'
      Visible = ivAlways
      ImageIndex = 101
    end
    object bnNewCustomFilter: TdxBarButton
      Caption = 'New custom filter'
      Category = 1
      Hint = 'New custom filter'
      Visible = ivAlways
      ImageIndex = 210
    end
    object bnNewCustomCommand: TdxBarButton
      Caption = 'New custom command'
      Category = 1
      Hint = 'New custom command'
      Visible = ivAlways
      ImageIndex = 78
    end
    object bnAddCommonCommand: TdxBarSubItem
      Caption = 'Common command'
      Category = 1
      Visible = ivAlways
      ImageIndex = 50
      ItemLinks = <>
      OnPopup = bnAddCommonCommandPopup
    end
    object bnNewDialog: TdxBarButton
      Caption = 'Dialog'
      Category = 1
      Hint = 'Dialog'
      Visible = ivAlways
      ImageIndex = 38
    end
    object bnNewLayout: TdxBarButton
      Caption = 'Layout'
      Category = 1
      Hint = 'Layout'
      Visible = ivAlways
      ImageIndex = 53
    end
    object bnNewSQLScript: TdxBarButton
      Caption = 'SQL Script'
      Category = 2
      Hint = 'SQL Script'
      Visible = ivAlways
    end
    object bnNewPascalScript: TdxBarButton
      Caption = 'Pascal Script'
      Category = 2
      Hint = 'Pascal Script'
      Visible = ivAlways
    end
    object bnNewCSharpScript: TdxBarButton
      Caption = 'New C# Script'
      Category = 2
      Hint = 'New C# Script'
      Visible = ivAlways
    end
    object bnNewJson: TdxBarButton
      Caption = 'Json text'
      Category = 2
      Hint = 'Json text'
      Visible = ivAlways
    end
    object bnNewXml: TdxBarButton
      Caption = 'Xml Text'
      Category = 2
      Hint = 'Xml Text'
      Visible = ivAlways
    end
    object bnNewExternalFile: TdxBarButton
      Caption = 'External file'
      Category = 2
      Hint = 'External file'
      Visible = ivAlways
      ImageIndex = 442
    end
    object bnNewExportTemplate: TdxBarButton
      Caption = 'Template'
      Category = 2
      Hint = 'Template'
      Visible = ivAlways
      ImageIndex = 11
    end
    object bnNewAppDataSet: TdxBarButton
      Caption = 'Dataset'
      Category = 2
      Hint = 'Dataset'
      Visible = ivAlways
      ImageIndex = 86
    end
    object bnNewdfClass: TdxBarButton
      Caption = 'DocFlow Class'
      Category = 3
      Hint = 'DocFlow Class'
      Visible = ivAlways
      ImageIndex = 255
    end
    object bnNewdfTypes: TdxBarButton
      Caption = 'DocFlow Type'
      Category = 3
      Hint = 'DocFlow Type'
      Visible = ivAlways
      ImageIndex = 121
    end
    object bnChangeImageIndex: TdxBarButton
      Caption = 'Change ImageIndex'
      Category = 4
      Hint = 'Change ImageIndex'
      Visible = ivAlways
      ImageIndex = 379
      PaintStyle = psCaptionInMenu
    end
  end
  object PopupMenu: TdxBarPopupMenu
    BarManager = MainBar
    ItemLinks = <
      item
        Visible = True
        ItemName = 'bnEdit'
      end
      item
        Visible = True
        ItemName = 'bnRefresh'
      end
      item
        BeginGroup = True
        Visible = True
        ItemName = 'bnNewSubMenu'
      end
      item
        Visible = True
        ItemName = 'bnAddRef'
      end
      item
        Visible = True
        ItemName = 'bnExportMenu'
      end
      item
        BeginGroup = True
        Visible = True
        ItemName = 'bnDelete'
      end
      item
        BeginGroup = True
        Visible = True
        ItemName = 'bnRenameItem'
      end>
    UseOwnFont = False
    OnPopup = PopupMenuPopup
    Left = 288
    Top = 32
    PixelsPerInch = 96
  end
  object pmNew: TdxBarPopupMenu
    BarManager = MainBar
    ItemLinks = <
      item
        Visible = True
        ItemName = 'bnNewFolder'
      end
      item
        Visible = True
        ItemName = 'bnNewPlugin'
      end
      item
        Visible = True
        ItemName = 'bnNewFilterGroup'
      end
      item
        Visible = True
        ItemName = 'bnNewCommandGroup'
      end>
    UseOwnFont = False
    Left = 232
    Top = 32
    PixelsPerInch = 96
  end
  object pmAddRef: TdxBarPopupMenu
    BarManager = MainBar
    ItemLinks = <
      item
        Visible = True
        ItemName = 'bnAddPluginRef'
      end
      item
        Visible = True
        ItemName = 'bnAddDialogRef'
      end
      item
        Visible = True
        ItemName = 'bnAddCommonCommand'
      end>
    UseOwnFont = False
    Left = 176
    Top = 32
    PixelsPerInch = 96
  end
  object ImportDialog: TOpenDialog
    Filter = 'Json files|*.json'
    FilterIndex = 0
    Left = 288
    Top = 200
  end
end
