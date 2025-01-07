inherited DocFlowNewDocDialog: TDocFlowNewDocDialog
  Caption = 'Select Document Type'
  ClientHeight = 495
  ClientWidth = 359
  ExplicitWidth = 375
  ExplicitHeight = 533
  PixelsPerInch = 96
  TextHeight = 13
  inherited pnBottomButtons: TPanel
    Top = 454
    Width = 359
    ExplicitTop = 454
    ExplicitWidth = 359
    inherited lbInfo: TLabel
      Visible = False
    end
    inherited bnOK: TcxButton
      Left = 189
      ExplicitLeft = 189
    end
    inherited bnCancel: TcxButton
      Left = 270
      ExplicitLeft = 270
    end
  end
  inherited TreeView: TcxDBTreeList
    Width = 359
    Height = 454
    ExplicitWidth = 359
    ExplicitHeight = 454
    object colObjectId: TcxDBTreeListColumn
      Visible = False
      DataBinding.FieldName = 'ObjectId'
      Width = 100
      Position.ColIndex = 2
      Position.RowIndex = 0
      Position.BandIndex = 0
      Summary.FooterSummaryItems = <>
      Summary.GroupFooterSummaryItems = <>
    end
    object colIType: TcxDBTreeListColumn
      Visible = False
      DataBinding.FieldName = 'iType'
      Width = 100
      Position.ColIndex = 3
      Position.RowIndex = 0
      Position.BandIndex = 0
      Summary.FooterSummaryItems = <>
      Summary.GroupFooterSummaryItems = <>
    end
  end
end
