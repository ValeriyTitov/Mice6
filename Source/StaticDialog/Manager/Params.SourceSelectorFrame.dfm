object CommandPropertiesFrame: TCommandPropertiesFrame
  Left = 0
  Top = 0
  Width = 460
  Height = 270
  TabOrder = 0
  object ParamGrid: TcxGrid
    Left = 0
    Top = 0
    Width = 460
    Height = 270
    Align = alClient
    TabOrder = 0
    object MainView: TcxGridDBTableView
      PopupMenu = PopupMenu1
      Navigator.Buttons.CustomButtons = <>
      ScrollbarAnnotations.CustomAnnotations = <>
      OnCustomDrawCell = MainViewCustomDrawCell
      DataController.Summary.DefaultGroupSummaryItems = <>
      DataController.Summary.FooterSummaryItems = <>
      DataController.Summary.SummaryGroups = <>
      OptionsView.NoDataToDisplayInfoText = ' '
      OptionsView.ColumnAutoWidth = True
      OptionsView.GroupByBox = False
      object colName: TcxGridDBColumn
        DataBinding.FieldName = 'Name'
        MinWidth = 64
        Options.Filtering = False
        Options.Sorting = False
      end
      object colSource: TcxGridDBColumn
        Caption = 'Source'
        DataBinding.FieldName = 'ParamType'
        PropertiesClassName = 'TcxImageComboBoxProperties'
        Properties.Images = ImageContainer.Images16
        Properties.Items = <
          item
            Description = 'Constant value'
            ImageIndex = 462
            Value = 0
          end
          item
            Description = 'Plugin DataField'
            ImageIndex = 164
            Value = 1
          end
          item
            Description = 'Plugin Parameter'
            ImageIndex = 284
            Value = 2
          end
          item
            Description = 'Global Setting'
            ImageIndex = 73
            Value = 3
          end>
        MinWidth = 64
        Options.Filtering = False
        Options.Sorting = False
        Width = 100
      end
      object colValue: TcxGridDBColumn
        DataBinding.FieldName = 'Value'
        MinWidth = 64
        Options.Filtering = False
        Options.Sorting = False
      end
    end
    object ParamGridLevel1: TcxGridLevel
      GridView = MainView
    end
  end
  object PopupMenu1: TPopupMenu
    Images = ImageContainer.Images16
    OnPopup = PopupMenu1Popup
    Left = 32
    Top = 200
    object Add1: TMenuItem
      Caption = 'Add'
      ImageIndex = 8
      OnClick = Add1Click
    end
    object Delete1: TMenuItem
      Caption = 'Delete'
      Enabled = False
      ImageIndex = 228
      OnClick = Delete1Click
    end
  end
end
