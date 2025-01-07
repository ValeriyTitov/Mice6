inherited CommonSelectTreeDialog: TCommonSelectTreeDialog
  Caption = 'Select Item'
  PixelsPerInch = 96
  TextHeight = 13
  inherited pnBottomButtons: TPanel
    object lbInfo: TLabel [0]
      Left = 16
      Top = 13
      Width = 111
      Height = 13
      Caption = 'ID=%d, ParentId=d%'
    end
    inherited bnOK: TcxButton
      Enabled = False
    end
  end
  object TreeView: TcxDBTreeList
    Left = 0
    Top = 0
    Width = 418
    Height = 241
    Align = alClient
    Bands = <
      item
      end>
    Navigator.Buttons.CustomButtons = <>
    OptionsView.ColumnAutoWidth = True
    RootValue = -1
    TabOrder = 1
    OnDblClick = TreeViewDblClick
    OnFocusedNodeChanged = TreeViewFocusedNodeChanged
    OnSelectionChanged = TreeViewSelectionChanged
    object colCaption: TcxDBTreeListColumn
      DataBinding.FieldName = 'Caption'
      Width = 335
      Position.ColIndex = 0
      Position.RowIndex = 0
      Position.BandIndex = 0
      Summary.FooterSummaryItems = <>
      Summary.GroupFooterSummaryItems = <>
    end
    object colOrderId: TcxDBTreeListColumn
      Visible = False
      DataBinding.FieldName = 'OrderId'
      Width = 81
      Position.ColIndex = 1
      Position.RowIndex = 0
      Position.BandIndex = 0
      SortOrder = soAscending
      SortIndex = 0
      Summary.FooterSummaryItems = <>
      Summary.GroupFooterSummaryItems = <>
    end
  end
end
