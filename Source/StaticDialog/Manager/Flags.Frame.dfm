object FlagsFrame: TFlagsFrame
  Left = 0
  Top = 0
  Width = 487
  Height = 307
  TabOrder = 0
  object EuqtionGrid: TcxGrid
    Left = 0
    Top = 0
    Width = 487
    Height = 307
    Align = alClient
    TabOrder = 0
    object MainView: TcxGridDBTableView
      PopupMenu = PopupMenu1
      Navigator.Buttons.CustomButtons = <>
      OnCustomDrawCell = MainViewCustomDrawCell
      DataController.Summary.DefaultGroupSummaryItems = <>
      DataController.Summary.FooterSummaryItems = <>
      DataController.Summary.SummaryGroups = <>
      OptionsView.NoDataToDisplayInfoText = ' '
      OptionsView.ColumnAutoWidth = True
      OptionsView.GroupByBox = False
      object colName: TcxGridDBColumn
        DataBinding.FieldName = 'Name'
        Visible = False
        Options.Filtering = False
        Options.Sorting = False
        Width = 42
      end
      object colItemName: TcxGridDBColumn
        Caption = 'Control'
        DataBinding.FieldName = 'ItemName'
        PropertiesClassName = 'TcxComboBoxProperties'
        Options.Filtering = False
        Width = 141
      end
      object colType: TcxGridDBColumn
        Caption = 'Type'
        DataBinding.FieldName = 'FlagType'
        PropertiesClassName = 'TcxImageComboBoxProperties'
        Properties.Images = ImageContainer.Images16
        Properties.Items = <
          item
            Description = '<Flag disabled>'
            ImageIndex = 0
            Value = 0
          end
          item
            Description = 'Visible when'
            ImageIndex = 0
            Value = 1
          end
          item
            Description = 'Enabled when'
            ImageIndex = 0
            Value = 2
          end>
        Options.Filtering = False
      end
      object colFieldName: TcxGridDBColumn
        Caption = 'Field Name'
        DataBinding.FieldName = 'FieldName'
        PropertiesClassName = 'TcxComboBoxProperties'
        MinWidth = 64
        Options.Filtering = False
        Options.Sorting = False
        Width = 92
      end
      object colSign: TcxGridDBColumn
        Caption = 'Sign'
        DataBinding.FieldName = 'Equation'
        PropertiesClassName = 'TcxImageComboBoxProperties'
        Properties.Images = ImageContainer.Images16
        Properties.Items = <
          item
            Description = '='
            ImageIndex = 0
            Value = 1
          end
          item
            Description = '<>'
            ImageIndex = 0
            Value = 2
          end
          item
            Description = '>'
            ImageIndex = 0
            Value = 3
          end
          item
            Description = '>='
            ImageIndex = 0
            Value = 4
          end
          item
            Description = '<'
            ImageIndex = 0
            Value = 5
          end
          item
            Description = '<='
            ImageIndex = 0
            Value = 6
          end
          item
            Description = 'IS NULL'
            ImageIndex = 0
            Value = 7
          end
          item
            Description = 'NOT IS NULL'
            ImageIndex = 0
            Value = 8
          end
          item
            Description = 'IN'
            ImageIndex = 0
            Value = 9
          end
          item
            Description = 'NOT IN'
            ImageIndex = 0
            Value = 10
          end
          item
            Description = 'User is in role'
            ImageIndex = 685
            Value = 11
          end>
        MinWidth = 64
        Options.Filtering = False
        Options.Sorting = False
        Width = 64
      end
      object colValue: TcxGridDBColumn
        Caption = 'Comparation Value'
        DataBinding.FieldName = 'ComparationValue'
        MinWidth = 64
        Options.Filtering = False
        Options.Sorting = False
        Width = 146
      end
    end
    object EuqtionGridLevel1: TcxGridLevel
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
