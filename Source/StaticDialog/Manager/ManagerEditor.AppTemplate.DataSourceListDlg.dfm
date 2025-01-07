inherited DataSourceListDlg: TDataSourceListDlg
  Caption = 'Data Sources'
  ClientHeight = 425
  ClientWidth = 385
  ExplicitWidth = 401
  ExplicitHeight = 463
  PixelsPerInch = 96
  TextHeight = 13
  inherited pnBottomButtons: TPanel
    Top = 384
    Width = 385
    ExplicitTop = 384
    ExplicitWidth = 385
    inherited bnOK: TcxButton
      Left = 215
      ExplicitLeft = 215
    end
    inherited bnCancel: TcxButton
      Left = 296
      ExplicitLeft = 296
    end
  end
  object gridDataSets: TcxGrid
    Left = 0
    Top = 0
    Width = 385
    Height = 384
    Align = alClient
    PopupMenu = PopupMenu1
    TabOrder = 1
    object DataSetsView: TcxGridDBBandedTableView
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
      OnCustomDrawCell = DataSetsViewCustomDrawCell
      DataController.Summary.DefaultGroupSummaryItems = <>
      DataController.Summary.FooterSummaryItems = <>
      DataController.Summary.SummaryGroups = <>
      OptionsView.NoDataToDisplayInfoText = ' '
      OptionsView.ColumnAutoWidth = True
      OptionsView.GroupByBox = False
      OptionsView.BandHeaders = False
      Bands = <
        item
        end>
      object colName: TcxGridDBBandedColumn
        Caption = 'Name'
        DataBinding.FieldName = 'DataSetName'
        Options.Filtering = False
        Options.Moving = False
        Width = 98
        Position.BandIndex = 0
        Position.ColIndex = 0
        Position.RowIndex = 0
      end
      object colProviderName: TcxGridDBBandedColumn
        DataBinding.FieldName = 'ProviderName'
        PropertiesClassName = 'TcxButtonEditProperties'
        Properties.Buttons = <
          item
            Default = True
            Kind = bkEllipsis
          end>
        Properties.OnButtonClick = colProviderNamePropertiesButtonClick
        Options.Filtering = False
        Options.Moving = False
        Width = 99
        Position.BandIndex = 0
        Position.ColIndex = 1
        Position.RowIndex = 0
      end
      object colDBName: TcxGridDBBandedColumn
        DataBinding.FieldName = 'DBName'
        Options.Filtering = False
        Options.Moving = False
        Width = 117
        Position.BandIndex = 0
        Position.ColIndex = 2
        Position.RowIndex = 0
      end
    end
    object cxGridLevel1: TcxGridLevel
      GridView = DataSetsView
    end
  end
  object PopupMenu1: TPopupMenu
    Images = ImageContainer.Images16
    OnPopup = PopupMenu1Popup
    Left = 328
    Top = 32
    object Insert1: TMenuItem
      Caption = 'Add'
      ImageIndex = 8
      OnClick = Insert1Click
    end
    object Delete1: TMenuItem
      Caption = 'Delete'
      Enabled = False
      ImageIndex = 228
      OnClick = Delete1Click
    end
  end
end
