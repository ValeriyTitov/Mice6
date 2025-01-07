object dfPathFoldersIncomingRulesFrame: TdfPathFoldersIncomingRulesFrame
  Left = 0
  Top = 0
  Width = 473
  Height = 475
  TabOrder = 0
  object GridRules: TcxGrid
    Left = 0
    Top = 0
    Width = 473
    Height = 475
    Align = alClient
    TabOrder = 0
    object MainView: TcxGridDBBandedTableView
      PopupMenu = PopupMenu
      OnDblClick = MainViewDblClick
      Navigator.Buttons.CustomButtons = <>
      Navigator.Buttons.First.Visible = True
      Navigator.Buttons.PriorPage.Visible = True
      Navigator.Buttons.Prior.Visible = True
      Navigator.Buttons.Next.Visible = True
      Navigator.Buttons.NextPage.Visible = True
      Navigator.Buttons.Last.Visible = True
      Navigator.Buttons.Insert.Visible = True
      Navigator.Buttons.Append.Visible = False
      Navigator.Buttons.Delete.Visible = True
      Navigator.Buttons.Edit.Visible = True
      Navigator.Buttons.Post.Visible = True
      Navigator.Buttons.Cancel.Visible = True
      Navigator.Buttons.Refresh.Visible = True
      Navigator.Buttons.SaveBookmark.Visible = True
      Navigator.Buttons.GotoBookmark.Visible = True
      Navigator.Buttons.Filter.Visible = True
      OnCustomDrawCell = MainViewCustomDrawCell
      DataController.Summary.DefaultGroupSummaryItems = <>
      DataController.Summary.FooterSummaryItems = <>
      DataController.Summary.SummaryGroups = <>
      OptionsData.DeletingConfirmation = False
      OptionsView.NoDataToDisplayInfoText = ' '
      OptionsView.ColumnAutoWidth = True
      OptionsView.GroupByBox = False
      OptionsView.BandHeaders = False
      Bands = <
        item
          Caption = 'Common'
          VisibleForCustomization = False
          Width = 420
        end>
      object colOrderId: TcxGridDBBandedColumn
        Caption = 'Order'
        DataBinding.FieldName = 'OrderId'
        PropertiesClassName = 'TcxTextEditProperties'
        Options.Editing = False
        Options.Filtering = False
        Options.Sorting = False
        SortIndex = 0
        SortOrder = soAscending
        Width = 68
        Position.BandIndex = 0
        Position.ColIndex = 0
        Position.RowIndex = 0
      end
      object colCaption: TcxGridDBBandedColumn
        DataBinding.FieldName = 'Caption'
        PropertiesClassName = 'TcxTextEditProperties'
        Options.Editing = False
        Options.Filtering = False
        Options.Grouping = False
        Options.Moving = False
        Options.Sorting = False
        Options.VertSizing = False
        Width = 357
        Position.BandIndex = 0
        Position.ColIndex = 1
        Position.RowIndex = 0
      end
      object colActive: TcxGridDBBandedColumn
        DataBinding.FieldName = 'Active'
        PropertiesClassName = 'TcxCheckBoxProperties'
        Options.Filtering = False
        Options.Grouping = False
        Options.Moving = False
        Options.Sorting = False
        Width = 46
        Position.BandIndex = 0
        Position.ColIndex = 2
        Position.RowIndex = 0
      end
    end
    object GridRulesLevel1: TcxGridLevel
      GridView = MainView
    end
  end
  object PopupMenu: TPopupMenu
    Images = ImageContainer.Images16
    Left = 528
    Top = 160
    object miNew: TMenuItem
      Caption = 'New'
    end
    object miEdit: TMenuItem
      Caption = 'Edit'
    end
    object miActivity: TMenuItem
      Caption = 'Activity'
    end
    object miDelete: TMenuItem
      Caption = 'Delete'
    end
  end
end
