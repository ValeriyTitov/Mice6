object MiceGridColorEditorFrame: TMiceGridColorEditorFrame
  Left = 0
  Top = 0
  Width = 549
  Height = 287
  TabOrder = 0
  object gridColumns: TcxGrid
    Left = 0
    Top = 0
    Width = 549
    Height = 287
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
        Caption = '~'
        DataBinding.FieldName = 'CreateOrder'
        DataBinding.IsNullValueType = True
        Options.Filtering = False
        Options.Sorting = False
        SortIndex = 0
        SortOrder = soAscending
        Width = 36
        Position.BandIndex = 0
        Position.ColIndex = 0
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
        Options.VertSizing = False
        Width = 91
        Position.BandIndex = 0
        Position.ColIndex = 1
        Position.RowIndex = 0
      end
      object colSign: TcxGridDBBandedColumn
        DataBinding.FieldName = 'Sign'
        DataBinding.IsNullValueType = True
        PropertiesClassName = 'TcxImageComboBoxProperties'
        Properties.Items = <
          item
            Description = '<None>'
            ImageIndex = 0
            Value = 0
          end
          item
            Description = '='
            Value = 1
          end
          item
            Description = '<>'
            Value = 2
          end
          item
            Description = '>'
            Value = 3
          end
          item
            Description = '>='
            Value = 4
          end
          item
            Description = '<'
            Value = 5
          end
          item
            Description = '<='
            Value = 6
          end
          item
            Description = 'IS NULL'
            Value = 7
          end
          item
            Description = 'IS NOT NULL'
            Value = 8
          end
          item
            Description = 'IN'
            Value = 9
          end
          item
            Description = 'NOT IN'
            Value = 10
          end>
        Options.Filtering = False
        Options.Grouping = False
        Options.Moving = False
        Options.Sorting = False
        Options.VertSizing = False
        Width = 40
        Position.BandIndex = 0
        Position.ColIndex = 2
        Position.RowIndex = 0
      end
      object colValue: TcxGridDBBandedColumn
        DataBinding.FieldName = 'Value'
        DataBinding.IsNullValueType = True
        PropertiesClassName = 'TcxTextEditProperties'
        Options.Filtering = False
        Options.Grouping = False
        Options.Moving = False
        Options.Sorting = False
        Options.VertSizing = False
        Width = 62
        Position.BandIndex = 0
        Position.ColIndex = 3
        Position.RowIndex = 0
      end
      object colBgColor: TcxGridDBBandedColumn
        Caption = 'BgColor'
        DataBinding.FieldName = 'bgColor'
        DataBinding.IsNullValueType = True
        PropertiesClassName = 'TcxButtonEditProperties'
        Properties.Buttons = <
          item
            Default = True
            Kind = bkEllipsis
          end>
        Properties.OnButtonClick = colBgColorPropertiesButtonClick
        Options.Filtering = False
        Options.Grouping = False
        Options.Moving = False
        Options.Sorting = False
        Options.VertSizing = False
        Width = 90
        Position.BandIndex = 0
        Position.ColIndex = 4
        Position.RowIndex = 0
      end
      object colColor: TcxGridDBBandedColumn
        DataBinding.FieldName = 'Color'
        DataBinding.IsNullValueType = True
        PropertiesClassName = 'TcxButtonEditProperties'
        Properties.Buttons = <
          item
            Default = True
            Kind = bkEllipsis
          end>
        Properties.OnButtonClick = colColorPropertiesButtonClick
        Options.Filtering = False
        Options.Grouping = False
        Options.Moving = False
        Options.Sorting = False
        Options.VertSizing = False
        Width = 90
        Position.BandIndex = 0
        Position.ColIndex = 5
        Position.RowIndex = 0
      end
      object colBold: TcxGridDBBandedColumn
        DataBinding.FieldName = 'Bold'
        DataBinding.IsNullValueType = True
        PropertiesClassName = 'TcxCheckBoxProperties'
        Options.Filtering = False
        Options.Grouping = False
        Options.Moving = False
        Options.Sorting = False
        Options.VertSizing = False
        Width = 33
        Position.BandIndex = 0
        Position.ColIndex = 6
        Position.RowIndex = 0
      end
      object colItalic: TcxGridDBBandedColumn
        DataBinding.FieldName = 'Italic'
        DataBinding.IsNullValueType = True
        PropertiesClassName = 'TcxCheckBoxProperties'
        Options.Filtering = False
        Options.Grouping = False
        Options.Moving = False
        Options.Sorting = False
        Options.VertSizing = False
        Width = 34
        Position.BandIndex = 0
        Position.ColIndex = 7
        Position.RowIndex = 0
      end
      object colWholeLine: TcxGridDBBandedColumn
        Caption = 'Line'
        DataBinding.FieldName = 'WholeRow'
        DataBinding.IsNullValueType = True
        PropertiesClassName = 'TcxCheckBoxProperties'
        Options.Filtering = False
        Options.Grouping = False
        Options.Moving = False
        Options.Sorting = False
        Options.VertSizing = False
        Width = 33
        Position.BandIndex = 0
        Position.ColIndex = 8
        Position.RowIndex = 0
      end
    end
    object gridColumnsLevel1: TcxGridLevel
      GridView = MainView
    end
  end
  object PopupMenu: TPopupMenu
    Images = ImageContainer.Images16
    Left = 472
    Top = 32
    object miNew: TMenuItem
      Caption = 'New'
    end
    object miDelete: TMenuItem
      Caption = 'Delete'
    end
    object miCopyFromPlugin: TMenuItem
      Caption = 'Copy from plugin...'
      Enabled = False
    end
    object miCopyFromGrid: TMenuItem
      Caption = 'Copy from grid...'
      Enabled = False
    end
  end
  object ColorDialog1: TColorDialog
    Color = 16744576
    CustomColors.Strings = (
      'ColorA=FFFFFFFF'
      'ColorB=FFFFFFFF'
      'ColorC=FFFFFFFF'
      'ColorD=FFFFFFFF'
      'ColorE=FFFFFFFF'
      'ColorF=FFFFFFFF'
      'ColorG=FFFFFFFF'
      'ColorH=FFFFFFFF'
      'ColorI=FFFFFFFF'
      'ColorJ=FFFFFFFF'
      'ColorK=FFFFFFFF'
      'ColorL=FFFFFFFF'
      'ColorM=FFFFFFFF'
      'ColorN=FFFFFFFF'
      'ColorO=FFFFFFFF'
      'ColorP=FFFFFFFF')
    Left = 472
    Top = 88
  end
end
