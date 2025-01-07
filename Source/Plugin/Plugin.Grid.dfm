inherited GridPlugin: TGridPlugin
  object MainGrid: TcxGrid [0]
    Left = 193
    Top = 0
    Width = 318
    Height = 358
    Align = alClient
    TabOrder = 2
    object MainView: TcxGridDBBandedTableView
      PopupMenu = GridPopupMenu
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
      ScrollbarAnnotations.CustomAnnotations = <>
      OnCellDblClick = MainViewCellDblClick
      OnCustomDrawCell = MainViewCustomDrawCell
      DataController.DataSource = DataSource
      DataController.Summary.DefaultGroupSummaryItems = <>
      DataController.Summary.FooterSummaryItems = <>
      DataController.Summary.SummaryGroups = <>
      Images = ImageContainer.Images16
      OptionsBehavior.CellHints = True
      OptionsData.CancelOnExit = False
      OptionsData.Deleting = False
      OptionsData.DeletingConfirmation = False
      OptionsData.Editing = False
      OptionsData.Inserting = False
      OptionsSelection.MultiSelect = True
      OptionsView.GroupByBox = False
      OptionsView.BandHeaders = False
      Bands = <
        item
          Caption = 'Default Band'
        end>
    end
    object MainLevel: TcxGridLevel
      GridView = MainView
    end
  end
  inherited DataSource: TDataSource
    OnDataChange = DataSourceDataChange
  end
  inherited PopupBarManager: TdxBarManager
    Left = 360
    Top = 208
    PixelsPerInch = 96
  end
  inherited GridPopupMenu: TdxBarPopupMenu
    Left = 452
    Top = 208
    PixelsPerInch = 96
  end
end
