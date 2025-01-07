inherited ImportConfirmDialog: TImportConfirmDialog
  Caption = 'Import'
  ClientHeight = 434
  ClientWidth = 612
  Constraints.MinHeight = 400
  Constraints.MinWidth = 600
  OnCreate = FormCreate
  ExplicitWidth = 628
  ExplicitHeight = 473
  TextHeight = 13
  inherited pnBottomButtons: TPanel
    Top = 393
    Width = 612
    ExplicitTop = 393
    ExplicitWidth = 612
    inherited bnOK: TcxButton
      Left = 442
      Enabled = False
      ExplicitLeft = 442
    end
    inherited bnCancel: TcxButton
      Left = 523
      ExplicitLeft = 523
    end
  end
  object Panel1: TPanel
    Left = 0
    Top = 0
    Width = 612
    Height = 41
    Align = alTop
    BevelOuter = bvNone
    TabOrder = 1
    object Image1: TImage
      Left = 8
      Top = 3
      Width = 32
      Height = 32
    end
    object lbDescription: TLabel
      Left = 64
      Top = 14
      Width = 135
      Height = 13
      Caption = 'Import information summary'
    end
  end
  object Tree: TcxTreeList
    Left = 0
    Top = 41
    Width = 612
    Height = 352
    Align = alClient
    Bands = <
      item
        Options.Customizing = False
        Options.Moving = False
      end>
    Navigator.Buttons.CustomButtons = <>
    OptionsData.Editing = False
    OptionsData.Deleting = False
    OptionsView.Buttons = False
    OptionsView.ColumnAutoWidth = True
    OptionsView.Footer = True
    OptionsView.ShowRoot = False
    OptionsView.TreeLineStyle = tllsNone
    OptionsView.UseNodeColorForIndent = False
    ScrollbarAnnotations.CustomAnnotations = <>
    TabOrder = 2
    OnCustomDrawDataCell = TreeCustomDrawDataCell
    object colName: TcxTreeListColumn
      Caption.Text = 'Object'
      Width = 244
      Position.ColIndex = 0
      Position.RowIndex = 0
      Position.BandIndex = 0
      Summary.FooterSummaryItems = <>
      Summary.GroupFooterSummaryItems = <>
    end
    object ColChanged: TcxTreeListColumn
      Caption.Text = 'Changed'
      Width = 64
      Position.ColIndex = 1
      Position.RowIndex = 0
      Position.BandIndex = 0
      StatusHint = 'Total rows changed'
      Summary.FooterSummaryItems = <>
      Summary.GroupFooterSummaryItems = <>
    end
    object colInserted: TcxTreeListColumn
      Caption.Text = 'New'
      Width = 64
      Position.ColIndex = 2
      Position.RowIndex = 0
      Position.BandIndex = 0
      StatusHint = 'Total rows inserted'
      Summary.FooterSummaryItems = <>
      Summary.GroupFooterSummaryItems = <>
    end
    object colDeleted: TcxTreeListColumn
      Caption.Text = 'Deleted'
      Width = 64
      Position.ColIndex = 3
      Position.RowIndex = 0
      Position.BandIndex = 0
      Summary.FooterSummaryItems = <>
      Summary.GroupFooterSummaryItems = <>
    end
    object colFields: TcxTreeListColumn
      Caption.Text = 'Fields changed'
      Width = 100
      Position.ColIndex = 4
      Position.RowIndex = 0
      Position.BandIndex = 0
      StatusHint = 'Total field changes, including new rows'
      Summary.FooterSummaryItems = <
        item
          AlignHorz = taLeftJustify
          CalculatedColumn = colFields
          Format = '#'
          Kind = skSum
        end>
      Summary.GroupFooterSummaryItems = <>
    end
  end
end
