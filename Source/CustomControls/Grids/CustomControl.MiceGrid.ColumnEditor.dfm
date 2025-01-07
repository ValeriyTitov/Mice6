object ColumnEditorFrame: TColumnEditorFrame
  Left = 0
  Top = 0
  Width = 450
  Height = 279
  TabOrder = 0
  object gridColumns: TcxGrid
    Left = 0
    Top = 0
    Width = 450
    Height = 279
    Align = alClient
    TabOrder = 0
    object MainView: TcxGridDBBandedTableView
      PopupMenu = PopupMenu
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
      OnCustomDrawCell = MainViewCustomDrawCell
      OnFocusedItemChanged = MainViewFocusedItemChanged
      DataController.Summary.DefaultGroupSummaryItems = <>
      DataController.Summary.FooterSummaryItems = <>
      DataController.Summary.SummaryGroups = <>
      OptionsData.DeletingConfirmation = False
      OptionsView.NoDataToDisplayInfoText = ' '
      OptionsView.ColumnAutoWidth = True
      OptionsView.GroupByBox = False
      Bands = <
        item
          Caption = 'Common'
          Width = 235
        end
        item
          Caption = 'Properties'
          Width = 213
        end>
      object colOrderId: TcxGridDBBandedColumn
        Caption = '~'
        DataBinding.FieldName = 'CreateOrder'
        DataBinding.IsNullValueType = True
        Options.Filtering = False
        Options.Sorting = False
        SortIndex = 0
        SortOrder = soAscending
        Width = 28
        Position.BandIndex = 0
        Position.ColIndex = 0
        Position.RowIndex = 0
      end
      object colHdr: TcxGridDBBandedColumn
        Caption = 'Hdr'
        DataBinding.FieldName = 'IsBand'
        DataBinding.IsNullValueType = True
        PropertiesClassName = 'TcxCheckBoxProperties'
        Options.Filtering = False
        Options.Grouping = False
        Options.Moving = False
        Options.Sorting = False
        Width = 30
        Position.BandIndex = 0
        Position.ColIndex = 1
        Position.RowIndex = 0
      end
      object colFieldName: TcxGridDBBandedColumn
        Caption = 'Field Name'
        DataBinding.FieldName = 'FieldName'
        DataBinding.IsNullValueType = True
        PropertiesClassName = 'TcxComboBoxProperties'
        Options.Filtering = False
        Options.Grouping = False
        Options.Moving = False
        Options.Sorting = False
        Width = 80
        Position.BandIndex = 0
        Position.ColIndex = 3
        Position.RowIndex = 0
      end
      object colCaption: TcxGridDBBandedColumn
        DataBinding.FieldName = 'Caption'
        DataBinding.IsNullValueType = True
        PropertiesClassName = 'TcxComboBoxProperties'
        Options.Filtering = False
        Options.Grouping = False
        Options.Moving = False
        Options.Sorting = False
        Width = 83
        Position.BandIndex = 0
        Position.ColIndex = 2
        Position.RowIndex = 0
      end
      object colWidth: TcxGridDBBandedColumn
        DataBinding.FieldName = 'Width'
        DataBinding.IsNullValueType = True
        Options.Filtering = False
        Options.Grouping = False
        Options.Moving = False
        Options.Sorting = False
        Width = 44
        Position.BandIndex = 1
        Position.ColIndex = 0
        Position.RowIndex = 0
      end
      object colVisible: TcxGridDBBandedColumn
        DataBinding.FieldName = 'Visible'
        DataBinding.IsNullValueType = True
        PropertiesClassName = 'TcxCheckBoxProperties'
        Options.Filtering = False
        Options.Grouping = False
        Options.Moving = False
        Options.Sorting = False
        Width = 35
        Position.BandIndex = 1
        Position.ColIndex = 1
        Position.RowIndex = 0
      end
      object colSizing: TcxGridDBBandedColumn
        DataBinding.FieldName = 'Sizing'
        DataBinding.IsNullValueType = True
        PropertiesClassName = 'TcxCheckBoxProperties'
        Options.Filtering = False
        Options.Grouping = False
        Options.Moving = False
        Options.Sorting = False
        Width = 35
        Position.BandIndex = 1
        Position.ColIndex = 2
        Position.RowIndex = 0
      end
      object colFilter: TcxGridDBBandedColumn
        DataBinding.FieldName = 'Filter'
        DataBinding.IsNullValueType = True
        PropertiesClassName = 'TcxCheckBoxProperties'
        Options.Filtering = False
        Options.Grouping = False
        Options.Moving = False
        Options.Sorting = False
        Width = 35
        Position.BandIndex = 1
        Position.ColIndex = 3
        Position.RowIndex = 0
      end
      object colAlign: TcxGridDBBandedColumn
        DataBinding.FieldName = 'Align'
        DataBinding.IsNullValueType = True
        PropertiesClassName = 'TcxImageComboBoxProperties'
        Properties.Items = <
          item
            Description = 'Left'
            ImageIndex = 0
            Value = 0
          end
          item
            Description = 'Right'
            Value = 1
          end
          item
            Description = 'Center'
            Value = 2
          end>
        Visible = False
        Options.Filtering = False
        Options.Grouping = False
        Options.Moving = False
        Options.Sorting = False
        Width = 39
        Position.BandIndex = 1
        Position.ColIndex = 4
        Position.RowIndex = 0
      end
      object colMore: TcxGridDBBandedColumn
        Caption = 'More'
        DataBinding.IsNullValueType = True
        PropertiesClassName = 'TcxButtonEditProperties'
        Properties.Buttons = <
          item
            Default = True
            Kind = bkEllipsis
            Width = 24
          end>
        Properties.ReadOnly = True
        Properties.ViewStyle = vsHideCursor
        Properties.OnButtonClick = colMorePropertiesButtonClick
        Options.Filtering = False
        Options.ShowEditButtons = isebAlways
        Options.Grouping = False
        Options.Moving = False
        Options.Sorting = False
        Width = 38
        Position.BandIndex = 1
        Position.ColIndex = 5
        Position.RowIndex = 0
      end
    end
    object gridColumnsLevel1: TcxGridLevel
      GridView = MainView
    end
  end
  object PopupMenu: TPopupMenu
    Images = ImageContainer.Images16
    Left = 376
    Top = 40
    object miNew: TMenuItem
      Caption = 'New'
    end
    object miDelete: TMenuItem
      Caption = 'Delete'
    end
    object miClear: TMenuItem
      Caption = 'Clear'
      ImageIndex = 109
    end
    object N1: TMenuItem
      Caption = '-'
    end
    object miAutoFill: TMenuItem
      Caption = 'AutoFill'
    end
    object miCopyFromPlugin: TMenuItem
      Caption = 'Copy from plugin...'
      ImageIndex = 471
      OnClick = miCopyFromPluginClick
    end
    object miCopyFromGrid: TMenuItem
      Caption = 'Copy from grid...'
      ImageIndex = 163
      OnClick = miCopyFromGridClick
    end
    object miRearrage: TMenuItem
      Caption = 'Rearrage'
    end
  end
end
