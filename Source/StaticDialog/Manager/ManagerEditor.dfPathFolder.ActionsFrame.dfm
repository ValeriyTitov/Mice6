object dfPathFoldersActionsFrame: TdfPathFoldersActionsFrame
  Left = 0
  Top = 0
  Width = 455
  Height = 509
  TabOrder = 0
  object MainGrid: TcxGrid
    Left = 0
    Top = 0
    Width = 455
    Height = 509
    Align = alClient
    TabOrder = 0
    object MainView: TcxGridDBBandedTableView
      PopupMenu = PopupMenu
      OnDblClick = MainViewDblClick
      Navigator.Buttons.CustomButtons = <>
      OnCustomDrawCell = MainViewCustomDrawCell
      DataController.KeyFieldNames = 'dfPathFolderActionsId'
      DataController.Summary.DefaultGroupSummaryItems = <>
      DataController.Summary.FooterSummaryItems = <>
      DataController.Summary.SummaryGroups = <>
      OptionsCustomize.ColumnMoving = False
      OptionsCustomize.ColumnSorting = False
      OptionsView.ColumnAutoWidth = True
      OptionsView.GroupByBox = False
      OptionsView.BandHeaders = False
      Bands = <
        item
        end>
      object colID: TcxGridDBBandedColumn
        Caption = 'Id'
        DataBinding.FieldName = 'dfPathFolderActionsId'
        Options.Editing = False
        Options.Filtering = False
        Options.Moving = False
        Options.Sorting = False
        Width = 66
        Position.BandIndex = 0
        Position.ColIndex = 1
        Position.RowIndex = 0
      end
      object colImageIndex: TcxGridDBBandedColumn
        Caption = '~'
        DataBinding.FieldName = 'ImageIndex'
        Options.Editing = False
        Options.Filtering = False
        Options.Moving = False
        Options.Sorting = False
        Width = 28
        Position.BandIndex = 0
        Position.ColIndex = 0
        Position.RowIndex = 0
      end
      object colOrderId: TcxGridDBBandedColumn
        DataBinding.FieldName = 'OrderId'
        Visible = False
        Options.Editing = False
        Options.Filtering = False
        Options.Moving = False
        Options.Sorting = False
        SortIndex = 0
        SortOrder = soAscending
        Position.BandIndex = 0
        Position.ColIndex = 3
        Position.RowIndex = 0
      end
      object colCaption: TcxGridDBBandedColumn
        DataBinding.FieldName = 'Caption'
        Options.Editing = False
        Options.Filtering = False
        Options.Moving = False
        Options.Sorting = False
        Width = 359
        Position.BandIndex = 0
        Position.ColIndex = 2
        Position.RowIndex = 0
      end
      object colActive: TcxGridDBBandedColumn
        AlternateCaption = 'Active'
        DataBinding.FieldName = 'Active'
        Visible = False
        Options.Editing = False
        Options.Filtering = False
        Options.Moving = False
        Options.Sorting = False
        Position.BandIndex = 0
        Position.ColIndex = 4
        Position.RowIndex = 0
      end
      object colRequiresTransaction: TcxGridDBBandedColumn
        DataBinding.FieldName = 'RequiresTransaction'
        Visible = False
        Options.Editing = False
        Options.Filtering = False
        Options.Moving = False
        Options.Sorting = False
        Position.BandIndex = 0
        Position.ColIndex = 5
        Position.RowIndex = 0
      end
      object colActionType: TcxGridDBBandedColumn
        DataBinding.FieldName = 'ActionType'
        Visible = False
        Options.Editing = False
        Options.Filtering = False
        Options.Moving = False
        Options.Sorting = False
        Position.BandIndex = 0
        Position.ColIndex = 6
        Position.RowIndex = 0
      end
    end
    object MainGridLevel1: TcxGridLevel
      GridView = MainView
    end
  end
  object PopupMenu: TPopupMenu
    Images = ImageContainer.Images16
    Left = 24
    Top = 80
    object Newstandartaction1: TMenuItem
      Caption = 'New standart action'
      object miExecStoredProc: TMenuItem
        Caption = 'Execute Stored Procedure'
        ImageIndex = 604
      end
      object miInsertRecord: TMenuItem
        Caption = 'Manage Record'
        Enabled = False
        ImageIndex = 166
      end
      object miSendMessage: TMenuItem
        Caption = 'Send Message'
        ImageIndex = 220
      end
      object Document1: TMenuItem
        Caption = 'Document'
        object miDfCreateNewDocument: TMenuItem
          Caption = 'Create New Document'
          Enabled = False
        end
        object miDfPushdocument: TMenuItem
          Caption = 'Push Document'
          Enabled = False
        end
        object miDfRollbackDocument: TMenuItem
          Caption = 'Rollback Document'
          Enabled = False
        end
        object ChangeType1: TMenuItem
          Caption = 'Change Document Type'
          Enabled = False
        end
      end
      object Webservices1: TMenuItem
        Caption = 'Web services'
        object miHttpRequest: TMenuItem
          Caption = 'Http Request (Rest)'
          Enabled = False
        end
        object miSoapRequest: TMenuItem
          Caption = 'Soap Request'
          Enabled = False
        end
      end
    end
    object Newextendedaction1: TMenuItem
      Caption = 'New extended action'
      Enabled = False
    end
    object miEdit: TMenuItem
      Caption = 'Edit'
    end
    object miActivity: TMenuItem
      Caption = 'Activity'
    end
    object miDelete: TMenuItem
      Caption = 'Delete'
    end
  end
end
