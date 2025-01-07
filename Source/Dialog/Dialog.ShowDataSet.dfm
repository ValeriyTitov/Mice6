inherited ShowDatasetDialog: TShowDatasetDialog
  Caption = 'Dataset contents'
  ClientHeight = 588
  ClientWidth = 663
  Constraints.MinHeight = 400
  Constraints.MinWidth = 550
  ExplicitWidth = 679
  ExplicitHeight = 627
  TextHeight = 13
  object lbDataSetIsNil: TLabel [0]
    Left = 257
    Top = 299
    Width = 161
    Height = 13
    Align = alCustom
    Anchors = [akBottom]
    Caption = 'Dataset is not assigned! (nil)'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clRed
    Font.Height = -11
    Font.Name = 'Tahoma'
    Font.Style = [fsBold]
    ParentFont = False
  end
  inherited pnBottomButtons: TPanel
    Top = 547
    Width = 663
    ExplicitTop = 547
    ExplicitWidth = 663
    object lbRows: TLabel [0]
      Left = 11
      Top = 6
      Width = 50
      Height = 13
      Caption = 'Rows: %d'
    end
    object lbColumns: TLabel [1]
      Left = 11
      Top = 22
      Width = 64
      Height = 13
      Caption = 'Columns: %d'
    end
    inherited bnOK: TcxButton
      Left = 493
      ExplicitLeft = 493
    end
    inherited bnCancel: TcxButton
      Left = 574
      ExplicitLeft = 574
    end
  end
  object pnTop: TPanel
    Left = 0
    Top = 0
    Width = 663
    Height = 41
    Align = alTop
    BevelOuter = bvNone
    ShowCaption = False
    TabOrder = 1
    object Image: TImage
      Left = 11
      Top = 5
      Width = 32
      Height = 32
      Proportional = True
      Stretch = True
      Transparent = True
    end
    object lbInfo: TLabel
      Left = 53
      Top = 14
      Width = 28
      Height = 13
      Caption = 'lbInfo'
    end
  end
  object MainGrid: TcxGrid
    Left = 0
    Top = 41
    Width = 663
    Height = 506
    Align = alClient
    TabOrder = 2
    object MainView: TcxGridDBBandedTableView
      PopupMenu = GridPopupMenu
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
      DataController.DataSource = DataSource
      DataController.Summary.DefaultGroupSummaryItems = <>
      DataController.Summary.FooterSummaryItems = <>
      DataController.Summary.SummaryGroups = <>
      Images = ImageContainer.Images16
      OptionsBehavior.CellHints = True
      OptionsData.CancelOnExit = False
      OptionsData.Deleting = False
      OptionsData.DeletingConfirmation = False
      OptionsData.Inserting = False
      OptionsSelection.MultiSelect = True
      OptionsView.ColumnAutoWidth = True
      OptionsView.GroupByBox = False
      OptionsView.BandHeaders = False
      Bands = <
        item
          Caption = 'Default Band'
        end>
    end
    object MainLevel: TcxGridLevel
      GridView = MainView
    end
  end
  object DataSource: TDataSource
    Left = 488
    Top = 56
  end
  object dxBar: TdxBarManager
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -12
    Font.Name = 'Segoe UI'
    Font.Style = []
    Categories.Strings = (
      'Default')
    Categories.ItemsVisibles = (
      2)
    Categories.Visibles = (
      True)
    ImageOptions.Images = ImageContainer.Images16
    PopupMenuLinks = <>
    UseSystemFont = True
    Left = 488
    Top = 112
    PixelsPerInch = 96
    object bnColumns: TdxBarSubItem
      Caption = 'Columns'
      Category = 0
      Visible = ivAlways
      ItemLinks = <
        item
          Visible = True
          ItemName = 'bnShowAll'
        end
        item
          Visible = True
          ItemName = 'bnHideAll'
        end
        item
          Visible = True
          ItemName = 'bnAutoWidth'
        end
        item
          Visible = True
          ItemName = 'dxBarSeparator1'
        end>
    end
    object bnShowAll: TdxBarButton
      Action = acShowAll
      Category = 0
      CloseSubMenuOnClick = False
    end
    object bnHideAll: TdxBarButton
      Action = acHideAll
      Category = 0
      CloseSubMenuOnClick = False
    end
    object bnAutoWidth: TdxBarButton
      Action = acAutoWidth
      Category = 0
      ButtonStyle = bsChecked
      CloseSubMenuOnClick = False
    end
    object dxBarSeparator1: TdxBarSeparator
      Category = 0
      Visible = ivAlways
      ShowCaption = False
    end
  end
  object GridPopupMenu: TdxBarPopupMenu
    BarManager = dxBar
    Images = ImageContainer.Images16
    ItemLinks = <
      item
        Visible = True
        ItemName = 'bnColumns'
      end>
    UseOwnFont = False
    Left = 488
    Top = 168
    PixelsPerInch = 96
  end
  object ActionList1: TActionList
    Images = ImageContainer.Images16
    Left = 488
    Top = 240
    object acShowAll: TAction
      Caption = 'Show All'
      ImageIndex = 1
      OnExecute = acShowAllExecute
    end
    object acHideAll: TAction
      Caption = 'Hide All'
      ImageIndex = 109
      OnExecute = acHideAllExecute
    end
    object acAutoWidth: TAction
      AutoCheck = True
      Caption = 'Auto width'
      Checked = True
      ImageIndex = 66
      OnExecute = acAutoWidthExecute
    end
  end
end
