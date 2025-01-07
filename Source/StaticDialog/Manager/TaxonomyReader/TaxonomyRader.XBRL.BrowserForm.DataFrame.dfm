object DataFrame: TDataFrame
  Left = 0
  Top = 0
  Width = 775
  Height = 528
  TabOrder = 0
  object Grid: TcxGrid
    Left = 0
    Top = 0
    Width = 775
    Height = 528
    Align = alClient
    TabOrder = 0
    ExplicitWidth = 384
    ExplicitHeight = 350
    object gridView: TcxGridDBTableView
      Navigator.Buttons.CustomButtons = <>
      OnCustomDrawCell = gridViewCustomDrawCell
      DataController.DataSource = DataSource
      DataController.Summary.DefaultGroupSummaryItems = <>
      DataController.Summary.FooterSummaryItems = <>
      DataController.Summary.SummaryGroups = <>
      OptionsCustomize.ColumnFiltering = False
      OptionsCustomize.ColumnGrouping = False
      OptionsCustomize.ColumnSorting = False
      OptionsCustomize.ColumnsQuickCustomizationShowCommands = False
      OptionsData.Deleting = False
      OptionsData.Inserting = False
      OptionsView.NoDataToDisplayInfoText = ' '
      OptionsView.CellAutoHeight = True
      OptionsView.ColumnAutoWidth = True
      OptionsView.GroupByBox = False
      object gridViewColumn1: TcxGridDBColumn
        DataBinding.FieldName = 'Name'
        PropertiesClassName = 'TcxTextEditProperties'
        Properties.ReadOnly = True
        Width = 106
      end
      object gridViewColumn2: TcxGridDBColumn
        DataBinding.FieldName = 'Label'
        PropertiesClassName = 'TcxTextEditProperties'
        Properties.ReadOnly = True
        Width = 408
      end
      object gridViewColumn3: TcxGridDBColumn
        DataBinding.FieldName = 'Type'
        PropertiesClassName = 'TcxTextEditProperties'
        Properties.ReadOnly = True
        Width = 136
      end
      object gridViewColumn4: TcxGridDBColumn
        DataBinding.FieldName = 'Enumeration'
        PropertiesClassName = 'TcxTextEditProperties'
        Properties.ReadOnly = True
        Width = 87
      end
      object gridViewColumn5: TcxGridDBColumn
        DataBinding.FieldName = 'Nilable'
        PropertiesClassName = 'TcxTextEditProperties'
        Properties.ReadOnly = True
        Width = 36
      end
    end
    object GridLevel1: TcxGridLevel
      GridView = gridView
    end
  end
  object DataSource: TDataSource
    DataSet = DataSet
    Left = 584
    Top = 56
  end
  object DataSet: TFDMemTable
    FetchOptions.AssignedValues = [evMode]
    FetchOptions.Mode = fmAll
    ResourceOptions.AssignedValues = [rvSilentMode]
    ResourceOptions.SilentMode = True
    UpdateOptions.AssignedValues = [uvCheckRequired, uvAutoCommitUpdates]
    UpdateOptions.CheckRequired = False
    UpdateOptions.AutoCommitUpdates = True
    Left = 584
    Top = 128
  end
end
