inherited VPickSelectGridDialog: TVPickSelectGridDialog
  Caption = 'Select item'
  ClientHeight = 459
  ClientWidth = 540
  ExplicitWidth = 556
  ExplicitHeight = 497
  PixelsPerInch = 96
  TextHeight = 13
  inherited pnBottomButtons: TPanel
    Top = 418
    Width = 540
    ExplicitTop = 418
    ExplicitWidth = 540
    inherited bnOK: TcxButton
      Left = 370
      Enabled = False
      ExplicitLeft = 370
    end
    inherited bnCancel: TcxButton
      Left = 451
      ExplicitLeft = 451
    end
  end
  object MainGrid: TcxGrid
    Left = 0
    Top = 0
    Width = 540
    Height = 418
    Align = alClient
    TabOrder = 1
    object MainView: TcxGridDBBandedTableView
      OnDblClick = MainViewDblClick
      Navigator.Buttons.CustomButtons = <>
      OnCustomDrawCell = MainViewCustomDrawCell
      DataController.DataSource = MainSource
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
  object MainSource: TDataSource
    Left = 24
    Top = 48
  end
end
