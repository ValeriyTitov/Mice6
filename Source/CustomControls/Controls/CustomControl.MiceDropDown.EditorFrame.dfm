object DropDownEditorFrame: TDropDownEditorFrame
  Left = 0
  Top = 0
  Width = 424
  Height = 287
  TabOrder = 0
  object ddLayout: TdxLayoutControl
    Left = 0
    Top = 0
    Width = 424
    Height = 287
    Align = alClient
    TabOrder = 0
    LayoutLookAndFeel = DefaultLookAndFeel.ManagerDialog
    object gridItems: TcxTreeList
      Left = 3
      Top = 3
      Width = 418
      Height = 170
      Bands = <
        item
        end>
      Images = ImageContainer.Images16
      Navigator.Buttons.CustomButtons = <>
      OptionsBehavior.AlwaysShowEditor = True
      OptionsBehavior.Sorting = False
      OptionsCustomizing.BandCustomizing = False
      OptionsCustomizing.BandMoving = False
      OptionsCustomizing.BandVertSizing = False
      OptionsCustomizing.ColumnCustomizing = False
      OptionsCustomizing.ColumnMoving = False
      OptionsData.Appending = True
      OptionsData.Inserting = True
      OptionsSelection.HideFocusRect = False
      OptionsView.ShowEditButtons = ecsbFocused
      OptionsView.Buttons = False
      OptionsView.ColumnAutoWidth = True
      OptionsView.FixedSeparatorWidth = 0
      OptionsView.GridLines = tlglBoth
      OptionsView.IndicatorWidth = 0
      OptionsView.NavigatorOffset = 0
      OptionsView.ShowRoot = False
      OptionsView.UseImageIndexForSelected = False
      OptionsView.UseNodeColorForIndent = False
      PopupMenu = PopupMenu1
      ScrollbarAnnotations.CustomAnnotations = <>
      TabOrder = 0
      object gridItemsColumn5: TcxTreeListColumn
        PropertiesClassName = 'TcxButtonEditProperties'
        Properties.Buttons = <
          item
            Default = True
            Kind = bkEllipsis
          end>
        Properties.Images = ImageContainer.Images16
        Properties.ReadOnly = False
        Properties.ViewStyle = vsHideCursor
        Properties.OnButtonClick = gridItemsColumn5PropertiesButtonClick
        BestFitMaxWidth = 20
        Width = 20
        Position.ColIndex = 0
        Position.RowIndex = 0
        Position.BandIndex = 0
        Summary.FooterSummaryItems = <>
        Summary.GroupFooterSummaryItems = <>
      end
      object colImageIndex: TcxTreeListColumn
        PropertiesClassName = 'TcxImageComboBoxProperties'
        Properties.Images = ImageContainer.Images16
        Properties.Items = <>
        Caption.MultiLine = True
        Caption.Text = 'Image'
        DataBinding.ValueType = 'Integer'
        Width = 86
        Position.ColIndex = 1
        Position.RowIndex = 0
        Position.BandIndex = 0
        Summary.FooterSummaryItems = <>
        Summary.GroupFooterSummaryItems = <>
      end
      object colValue: TcxTreeListColumn
        Caption.Text = 'Value'
        DataBinding.ValueType = 'Integer'
        Width = 60
        Position.ColIndex = 2
        Position.RowIndex = 0
        Position.BandIndex = 0
        Summary.FooterSummaryItems = <>
        Summary.GroupFooterSummaryItems = <>
      end
      object colDescription: TcxTreeListColumn
        Caption.Text = 'Caption'
        Width = 211
        Position.ColIndex = 3
        Position.RowIndex = 0
        Position.BandIndex = 0
        Summary.FooterSummaryItems = <>
        Summary.GroupFooterSummaryItems = <>
      end
      object colTag: TcxTreeListColumn
        Caption.Text = 'Tag'
        DataBinding.ValueType = 'Integer'
        Width = 51
        Position.ColIndex = 4
        Position.RowIndex = 0
        Position.BandIndex = 0
        Summary.FooterSummaryItems = <>
        Summary.GroupFooterSummaryItems = <>
      end
    end
    object edDDProviderName: TcxButtonEdit
      Left = 90
      Top = 251
      Hint = 
        'Dataset should return at least 2 fields or fields in same order:' +
        ' <Value>, <Description>, [ImageIndex], [Tag]'
      ParentShowHint = False
      Properties.Buttons = <
        item
          Default = True
          Kind = bkEllipsis
        end>
      Properties.OnButtonClick = edDDProviderNamePropertiesButtonClick
      ShowHint = True
      Style.BorderColor = clWindowFrame
      Style.BorderStyle = ebsFlat
      Style.HotTrack = False
      Style.ButtonStyle = btsFlat
      TabOrder = 5
      Width = 147
    end
    object cbDBName: TcxComboBox
      Left = 288
      Top = 251
      AutoSize = False
      Style.BorderColor = clWindowFrame
      Style.BorderStyle = ebsFlat
      Style.HotTrack = False
      Style.ButtonStyle = btsFlat
      Style.PopupBorderStyle = epbsFlat
      TabOrder = 6
      Height = 21
      Width = 121
    end
    object cbAddAll: TcxCheckBox
      Left = 15
      Top = 197
      Caption = 'Add <All>'
      Style.BorderColor = clWindowFrame
      Style.BorderStyle = ebsFlat
      Style.HotTrack = False
      TabOrder = 1
      OnClick = cbAddAllClick
    end
    object cbAddNone: TcxCheckBox
      Left = 15
      Top = 224
      Caption = 'Add <None>'
      Style.BorderColor = clWindowFrame
      Style.BorderStyle = ebsFlat
      Style.HotTrack = False
      TabOrder = 3
      OnClick = cbAddNoneClick
    end
    object edAllValue: TcxTextEdit
      Left = 288
      Top = 197
      AutoSize = False
      Enabled = False
      Style.BorderColor = clWindowFrame
      Style.BorderStyle = ebsFlat
      Style.HotTrack = False
      TabOrder = 2
      Height = 21
      Width = 121
    end
    object edNoneValue: TcxTextEdit
      Left = 288
      Top = 224
      AutoSize = False
      Enabled = False
      Style.BorderColor = clWindowFrame
      Style.BorderStyle = ebsFlat
      Style.HotTrack = False
      TabOrder = 4
      Height = 21
      Width = 121
    end
    object ddLayoutGroup_Root: TdxLayoutGroup
      AlignHorz = ahClient
      AlignVert = avClient
      CaptionOptions.Visible = False
      Hidden = True
      ShowBorder = False
      Index = -1
    end
    object item_gridItems: TdxLayoutItem
      Parent = ddLayoutGroup_Root
      AlignHorz = ahClient
      AlignVert = avClient
      Control = gridItems
      ControlOptions.OriginalHeight = 192
      ControlOptions.OriginalWidth = 400
      ControlOptions.ShowBorder = False
      Index = 0
    end
    object FrmGrpBottom: TdxLayoutGroup
      Parent = ddLayoutGroup_Root
      CaptionOptions.Text = 'Settings'
      Index = 1
    end
    object item_edDDProviderName: TdxLayoutItem
      Parent = dxLayoutAutoCreatedGroup1
      AlignHorz = ahClient
      AlignVert = avTop
      CaptionOptions.Text = 'Provider Name'
      Control = edDDProviderName
      ControlOptions.OriginalHeight = 23
      ControlOptions.OriginalWidth = 121
      ControlOptions.ShowBorder = False
      Index = 0
    end
    object item_ddDBName: TdxLayoutItem
      Parent = dxLayoutAutoCreatedGroup1
      AlignHorz = ahLeft
      AlignVert = avClient
      CaptionOptions.Text = 'DBName'
      Control = cbDBName
      ControlOptions.OriginalHeight = 21
      ControlOptions.OriginalWidth = 121
      ControlOptions.ShowBorder = False
      Index = 1
    end
    object dxLayoutAutoCreatedGroup1: TdxLayoutAutoCreatedGroup
      Parent = FrmGrpBottom
      AlignVert = avTop
      LayoutDirection = ldHorizontal
      Index = 2
    end
    object item_cbAddAll: TdxLayoutItem
      Parent = dxLayoutAutoCreatedGroup4
      AlignHorz = ahLeft
      AlignVert = avTop
      CaptionOptions.Text = 'cxCheckBox1'
      CaptionOptions.Visible = False
      Control = cbAddAll
      ControlOptions.OriginalHeight = 23
      ControlOptions.OriginalWidth = 77
      ControlOptions.ShowBorder = False
      Index = 0
    end
    object dxLayoutAutoCreatedGroup3: TdxLayoutAutoCreatedGroup
      Parent = FrmGrpBottom
      AlignVert = avTop
      LayoutDirection = ldHorizontal
      Index = 1
    end
    object item_cbAddNone: TdxLayoutItem
      Parent = dxLayoutAutoCreatedGroup3
      AlignHorz = ahLeft
      AlignVert = avTop
      CaptionOptions.Text = 'cxCheckBox1'
      CaptionOptions.Visible = False
      Control = cbAddNone
      ControlOptions.OriginalHeight = 23
      ControlOptions.OriginalWidth = 92
      ControlOptions.ShowBorder = False
      Index = 0
    end
    object item_edAllValue: TdxLayoutItem
      Parent = dxLayoutAutoCreatedGroup4
      AlignHorz = ahRight
      AlignVert = avClient
      CaptionOptions.Text = '<All> Value'
      Control = edAllValue
      ControlOptions.OriginalHeight = 21
      ControlOptions.OriginalWidth = 121
      ControlOptions.ShowBorder = False
      Enabled = False
      Index = 1
    end
    object item_edNoneValue: TdxLayoutItem
      Parent = dxLayoutAutoCreatedGroup3
      AlignHorz = ahRight
      AlignVert = avClient
      CaptionOptions.Text = '<None> Value'
      Control = edNoneValue
      ControlOptions.OriginalHeight = 21
      ControlOptions.OriginalWidth = 121
      ControlOptions.ShowBorder = False
      Enabled = False
      Index = 1
    end
    object dxLayoutAutoCreatedGroup4: TdxLayoutAutoCreatedGroup
      Parent = FrmGrpBottom
      AlignVert = avTop
      LayoutDirection = ldHorizontal
      Index = 0
    end
  end
  object PopupMenu1: TPopupMenu
    Images = ImageContainer.Images16
    OnPopup = PopupMenu1Popup
    Left = 376
    Top = 32
    object miAdd: TMenuItem
      Caption = 'Add'
    end
    object miDelete: TMenuItem
      Caption = 'Delete'
    end
  end
end
