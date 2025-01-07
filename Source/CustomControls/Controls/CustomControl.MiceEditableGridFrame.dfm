object MiceEditableGridFrame: TMiceEditableGridFrame
  Left = 0
  Top = 0
  Width = 320
  Height = 240
  TabOrder = 0
  object EditableGrid: TcxGrid
    Left = 0
    Top = 0
    Width = 320
    Height = 240
    Align = alClient
    TabOrder = 0
    object MainView: TcxGridDBBandedTableView
      PopupMenu = PopupMenu1
      Navigator.Buttons.CustomButtons = <>
      OnCustomDrawCell = MainViewCustomDrawCell
      DataController.Summary.DefaultGroupSummaryItems = <>
      DataController.Summary.FooterSummaryItems = <>
      DataController.Summary.SummaryGroups = <>
      OptionsView.NoDataToDisplayInfoText = ' '
      OptionsView.ColumnAutoWidth = True
      OptionsView.GroupByBox = False
      OptionsView.BandHeaders = False
      Bands = <
        item
        end>
    end
    object EditableGridLevel1: TcxGridLevel
      GridView = MainView
    end
  end
  object PopupMenu1: TPopupMenu
    Images = ImageContainer.Images16
    OnPopup = PopupMenu1Popup
    Left = 240
    Top = 32
    object miAdd: TMenuItem
      Caption = 'Add'
    end
    object miDelete: TMenuItem
      Caption = 'Delete'
    end
    object miClone: TMenuItem
      Caption = 'Clone'
    end
    object miRefresh: TMenuItem
      Caption = 'Refresh'
    end
  end
end
