inherited DocFlowMessageWindow: TDocFlowMessageWindow
  Caption = 'Document messages'
  ClientHeight = 305
  ClientWidth = 465
  OnCreate = FormCreate
  ExplicitWidth = 481
  ExplicitHeight = 343
  PixelsPerInch = 96
  TextHeight = 13
  inherited pnBottomButtons: TPanel
    Top = 264
    Width = 465
    ExplicitTop = 264
    ExplicitWidth = 465
    inherited bnOK: TcxButton
      Left = 295
      ExplicitLeft = 295
    end
    inherited bnCancel: TcxButton
      Left = 376
      ExplicitLeft = 376
    end
  end
  object Grid1: TcxGrid
    Left = 0
    Top = 0
    Width = 465
    Height = 264
    Align = alClient
    TabOrder = 1
    object View: TcxGridDBTableView
      Navigator.Buttons.CustomButtons = <>
      FilterBox.CustomizeDialog = False
      OnCustomDrawCell = ViewCustomDrawCell
      DataController.DataSource = DataSource1
      DataController.Summary.DefaultGroupSummaryItems = <>
      DataController.Summary.FooterSummaryItems = <>
      DataController.Summary.SummaryGroups = <>
      Images = ImageContainer.Images16
      OptionsCustomize.ColumnFiltering = False
      OptionsCustomize.ColumnGrouping = False
      OptionsCustomize.ColumnHidingOnGrouping = False
      OptionsCustomize.ColumnMoving = False
      OptionsCustomize.ColumnSorting = False
      OptionsCustomize.ColumnsQuickCustomizationShowCommands = False
      OptionsData.Deleting = False
      OptionsData.DeletingConfirmation = False
      OptionsData.Editing = False
      OptionsData.Inserting = False
      OptionsView.CellAutoHeight = True
      OptionsView.ColumnAutoWidth = True
      OptionsView.GroupByBox = False
      object colImageIndex: TcxGridDBColumn
        Caption = '~'
        DataBinding.FieldName = 'ImageIndex'
        PropertiesClassName = 'TcxImageComboBoxProperties'
        Properties.Items = <>
        MinWidth = 22
        Options.Grouping = False
        Options.HorzSizing = False
        Options.Moving = False
        Width = 22
      end
      object ViewColumn1: TcxGridDBColumn
        DataBinding.FieldName = 'Caption'
        Width = 195
      end
      object colMessage: TcxGridDBColumn
        Caption = 'Message'
        DataBinding.FieldName = 'UserMessage'
        Width = 346
      end
    end
    object Grid1Level1: TcxGridLevel
      GridView = View
    end
  end
  object DataSource1: TDataSource
    Left = 16
    Top = 400
  end
end
