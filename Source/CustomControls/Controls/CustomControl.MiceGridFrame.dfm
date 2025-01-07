object MiceGridFrame: TMiceGridFrame
  Left = 0
  Top = 0
  Width = 491
  Height = 285
  TabOrder = 0
  object pnButtons: TPanel
    Left = 0
    Top = 244
    Width = 491
    Height = 41
    Align = alBottom
    BevelOuter = bvNone
    ShowCaption = False
    TabOrder = 0
    object bnAdd: TcxButton
      Left = 72
      Top = 8
      Width = 75
      Height = 25
      Caption = 'Add'
      OptionsImage.ImageIndex = 437
      OptionsImage.Images = ImageContainer.Images16
      TabOrder = 0
    end
    object bnOpen: TcxButton
      Left = 208
      Top = 8
      Width = 75
      Height = 25
      Caption = 'Edit'
      OptionsImage.ImageIndex = 434
      OptionsImage.Images = ImageContainer.Images16
      TabOrder = 1
    end
    object bnDelete: TcxButton
      Left = 344
      Top = 8
      Width = 75
      Height = 25
      Caption = 'Delete'
      OptionsImage.ImageIndex = 207
      OptionsImage.Images = ImageContainer.Images16
      TabOrder = 2
    end
  end
  object MainGrid: TcxGrid
    Left = 0
    Top = 0
    Width = 491
    Height = 244
    Align = alClient
    TabOrder = 1
    object MainView: TcxGridDBBandedTableView
      PopupMenu = PopupMenu1
      Navigator.Buttons.CustomButtons = <>
      OnCustomDrawCell = MainViewCustomDrawCell
      DataController.DataSource = DataSource
      DataController.Summary.DefaultGroupSummaryItems = <>
      DataController.Summary.FooterSummaryItems = <>
      DataController.Summary.SummaryGroups = <>
      Images = ImageContainer.Images16
      OptionsData.CancelOnExit = False
      OptionsData.Deleting = False
      OptionsData.DeletingConfirmation = False
      OptionsData.Editing = False
      OptionsData.Inserting = False
      OptionsView.ColumnAutoWidth = True
      OptionsView.GroupByBox = False
      OptionsView.BandHeaders = False
      Bands = <
        item
        end>
    end
    object MainGridLevel1: TcxGridLevel
      GridView = MainView
    end
  end
  object DataSource: TDataSource
    Left = 432
    Top = 88
  end
  object PopupMenu1: TPopupMenu
    Images = ImageContainer.Images16
    Left = 432
    Top = 24
    object miAdd: TMenuItem
      Caption = 'Add'
    end
    object miEdit: TMenuItem
      Caption = 'Edit'
    end
    object miDelete: TMenuItem
      Caption = 'Delete'
    end
    object miRefresh: TMenuItem
      Caption = 'Refresh'
    end
  end
end
