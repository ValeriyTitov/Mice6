object SideTreeFilter: TSideTreeFilter
  Left = 0
  Top = 0
  Width = 295
  Height = 621
  TabOrder = 0
  object TreeFilter: TcxDBTreeList
    Left = 0
    Top = 0
    Width = 295
    Height = 621
    Align = alClient
    Bands = <
      item
      end>
    Navigator.Buttons.CustomButtons = <>
    OptionsBehavior.CellHints = True
    OptionsView.ColumnAutoWidth = True
    OptionsView.FocusRect = False
    PopupMenu = SideTreePopupMenu
    RootValue = -1
    ScrollbarAnnotations.CustomAnnotations = <>
    TabOrder = 0
    OnGetCellHint = TreeFilterGetCellHint
    object colID: TcxDBTreeListColumn
      Visible = False
      DataBinding.FieldName = 'ID'
      Options.Footer = False
      Options.GroupFooter = False
      Options.Sizing = False
      Options.Customizing = False
      Options.Editing = False
      Options.Filtering = False
      Options.Moving = False
      Options.Sorting = False
      Position.ColIndex = 0
      Position.RowIndex = 0
      Position.BandIndex = 0
      Summary.FooterSummaryItems = <>
      Summary.GroupFooterSummaryItems = <>
    end
    object colParentId: TcxDBTreeListColumn
      Visible = False
      DataBinding.FieldName = 'ParentId'
      Options.Footer = False
      Options.GroupFooter = False
      Options.Sizing = False
      Options.Customizing = False
      Options.Editing = False
      Options.Filtering = False
      Options.Moving = False
      Options.Sorting = False
      Position.ColIndex = 1
      Position.RowIndex = 0
      Position.BandIndex = 0
      Summary.FooterSummaryItems = <>
      Summary.GroupFooterSummaryItems = <>
    end
    object colName: TcxDBTreeListColumn
      PropertiesClassName = 'TcxTextEditProperties'
      Options.Footer = False
      Options.GroupFooter = False
      Options.Customizing = False
      Options.Editing = False
      Options.Filtering = False
      Options.Moving = False
      Options.Sorting = False
      Width = 400
      Position.ColIndex = 2
      Position.RowIndex = 0
      Position.BandIndex = 0
      Summary.FooterSummaryItems = <>
      Summary.GroupFooterSummaryItems = <>
    end
    object colHint: TcxDBTreeListColumn
      Visible = False
      DataBinding.FieldName = 'Hint'
      Position.ColIndex = 3
      Position.RowIndex = 0
      Position.BandIndex = 0
      Summary.FooterSummaryItems = <>
      Summary.GroupFooterSummaryItems = <>
    end
    object colValue: TcxDBTreeListColumn
      Visible = False
      DataBinding.FieldName = 'Value'
      Position.ColIndex = 4
      Position.RowIndex = 0
      Position.BandIndex = 0
      Summary.FooterSummaryItems = <>
      Summary.GroupFooterSummaryItems = <>
    end
    object colOrderId: TcxDBTreeListColumn
      Visible = False
      DataBinding.FieldName = 'OrderId'
      Position.ColIndex = 5
      Position.RowIndex = 0
      Position.BandIndex = 0
      SortOrder = soAscending
      SortIndex = 0
      Summary.FooterSummaryItems = <>
      Summary.GroupFooterSummaryItems = <>
    end
  end
  object SideTreePopupMenu: TPopupMenu
    Images = ImageContainer.Images16
    Left = 256
    Top = 288
    object miRefresh: TMenuItem
      Caption = 'Refresh'
      ImageIndex = 44
      OnClick = miRefreshClick
    end
  end
end
