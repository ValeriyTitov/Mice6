object CommonCommands: TCommonCommands
  Left = 0
  Top = 0
  Caption = 'Common Commands'
  ClientHeight = 449
  ClientWidth = 735
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
  object gridCommands: TcxGrid
    Left = 0
    Top = 26
    Width = 735
    Height = 423
    Align = alClient
    TabOrder = 0
    object gridCommandsDBTableView1: TcxGridDBTableView
      OnDblClick = gridCommandsDBTableView1DblClick
      Navigator.Buttons.CustomButtons = <>
      OnCustomDrawCell = gridCommandsDBTableView1CustomDrawCell
      DataController.DataSource = DataSource
      DataController.Summary.DefaultGroupSummaryItems = <>
      DataController.Summary.FooterSummaryItems = <>
      DataController.Summary.SummaryGroups = <>
      OptionsData.Deleting = False
      OptionsData.DeletingConfirmation = False
      OptionsData.Editing = False
      OptionsData.Inserting = False
      OptionsView.ColumnAutoWidth = True
      OptionsView.GroupByBox = False
      object colImageIndex: TcxGridDBColumn
        DataBinding.FieldName = 'ImageIndex'
        PropertiesClassName = 'TcxImageComboBoxProperties'
        Properties.Images = ImageContainer.Images16
        Properties.Items = <>
        Options.Editing = False
        Options.Filtering = False
        Width = 23
        IsCaptionAssigned = True
      end
      object colAppCmdId: TcxGridDBColumn
        DataBinding.FieldName = 'AppCmdId'
        Options.Editing = False
        Options.Filtering = False
        Width = 66
      end
      object colType: TcxGridDBColumn
        Caption = 'Type'
        Options.Editing = False
        Options.Filtering = False
        Width = 96
      end
      object colName: TcxGridDBColumn
        DataBinding.FieldName = 'Name'
        Options.Editing = False
        Options.Filtering = False
        Width = 104
      end
      object colCaption: TcxGridDBColumn
        DataBinding.FieldName = 'Caption'
        Options.Editing = False
        Options.Filtering = False
        Width = 140
      end
      object colLocation: TcxGridDBColumn
        DataBinding.FieldName = 'Location'
        Options.Editing = False
        Options.Filtering = False
        Width = 170
      end
      object colAction: TcxGridDBColumn
        Caption = 'Action'
        DataBinding.FieldName = 'ActionType'
        Options.Editing = False
        Options.Filtering = False
        Width = 85
      end
      object colActive: TcxGridDBColumn
        DataBinding.FieldName = 'Active'
        Visible = False
        Width = 25
      end
    end
    object gridCommandsLevel1: TcxGridLevel
      GridView = gridCommandsDBTableView1
    end
  end
  object DataSource: TDataSource
    Left = 528
    Top = 120
  end
  object dxBarManager: TdxBarManager
    AllowReset = False
    AutoDockColor = False
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -12
    Font.Name = 'Segoe UI'
    Font.Style = []
    CanCustomize = False
    Categories.Strings = (
      'Default')
    Categories.ItemsVisibles = (
      2)
    Categories.Visibles = (
      True)
    DockColor = clBtnFace
    ImageOptions.Images = ImageContainer.Images16
    PopupMenuLinks = <
      item
      end>
    Style = bmsFlat
    UseSystemFont = True
    Left = 524
    Top = 196
    PixelsPerInch = 96
    DockControlHeights = (
      0
      0
      26
      0)
    object dxBarManagerBar1: TdxBar
      AllowClose = False
      AllowCustomizing = False
      AllowQuickCustomizing = False
      AllowReset = False
      Caption = 'Default'
      CaptionButtons = <>
      DockedDockingStyle = dsTop
      DockedLeft = 0
      DockedTop = 0
      DockingStyle = dsTop
      FloatLeft = 458
      FloatTop = 346
      FloatClientWidth = 23
      FloatClientHeight = 22
      ItemLinks = <
        item
          Visible = True
          ItemName = 'bnNewItem'
        end
        item
          Visible = True
          ItemName = 'bnEdit'
        end
        item
          Visible = True
          ItemName = 'bnDelete'
        end
        item
          BeginGroup = True
          Visible = True
          ItemName = 'bnRefresh'
        end
        item
          BeginGroup = True
          Visible = True
          ItemName = 'bnActivity'
        end>
      OldName = 'Default'
      OneOnRow = True
      Row = 0
      UseOwnFont = False
      Visible = True
      WholeRow = False
    end
    object bnNewCommand: TdxBarButton
      Caption = 'New command...'
      Category = 0
      Hint = 'New command'
      Visible = ivAlways
      ImageIndex = 131
    end
    object bnEdit: TdxBarButton
      Caption = 'Edit'
      Category = 0
      Hint = 'Edit'
      Visible = ivAlways
      ImageIndex = 434
      ShortCut = 13
    end
    object bnDelete: TdxBarButton
      Caption = 'Delete'
      Category = 0
      Hint = 'Delete'
      Visible = ivAlways
      ImageIndex = 228
      ShortCut = 16430
    end
    object bnRefresh: TdxBarButton
      Caption = 'Refresh'
      Category = 0
      Hint = 'Refresh'
      Visible = ivAlways
      ImageIndex = 43
      PaintStyle = psCaptionGlyph
      ShortCut = 116
      OnClick = bnRefreshClick
    end
    object bnActivity: TdxBarButton
      Caption = 'Activity'
      Category = 0
      Hint = 'Activity'
      Visible = ivAlways
      ImageIndex = 124
      PaintStyle = psCaptionGlyph
      ShortCut = 114
    end
    object bnNewItem: TdxBarSubItem
      Caption = 'New'
      Category = 0
      Visible = ivAlways
      ImageIndex = 430
      ShowCaption = False
      ItemLinks = <
        item
          Visible = True
          ItemName = 'bnNewCommand'
        end
        item
          Visible = True
          ItemName = 'bnNewFilter'
        end>
    end
    object bnNewFilter: TdxBarButton
      Caption = 'New Filter...'
      Category = 0
      Hint = 'New Filter'
      Visible = ivAlways
      ImageIndex = 653
    end
  end
  object dxBarPopupMenu: TdxBarPopupMenu
    BarManager = dxBarManager
    ItemLinks = <
      item
        Visible = True
        ItemName = 'bnNewCommand'
      end
      item
        Visible = True
        ItemName = 'bnEdit'
      end
      item
        Visible = True
        ItemName = 'bnDelete'
      end
      item
        Visible = True
        ItemName = 'bnActivity'
      end
      item
        BeginGroup = True
        Visible = True
        ItemName = 'bnRefresh'
      end>
    UseOwnFont = False
    Left = 528
    Top = 48
    PixelsPerInch = 96
  end
end
