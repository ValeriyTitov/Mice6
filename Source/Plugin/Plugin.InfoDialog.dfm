inherited PluginInfoDialog: TPluginInfoDialog
  Caption = 'Plugin Information'
  ClientHeight = 481
  ClientWidth = 634
  ExplicitWidth = 650
  ExplicitHeight = 519
  PixelsPerInch = 96
  TextHeight = 13
  inherited pnBottomButtons: TPanel
    Top = 440
    Width = 634
    ExplicitTop = 440
    ExplicitWidth = 634
    inherited bnOK: TcxButton
      Left = 464
      ExplicitLeft = 464
    end
    inherited bnCancel: TcxButton
      Left = 545
      ExplicitLeft = 545
    end
  end
  object cxPageControl1: TcxPageControl
    Left = 0
    Top = 0
    Width = 634
    Height = 440
    Align = alClient
    TabOrder = 1
    Properties.ActivePage = cxTabSheet1
    Properties.CustomButtons.Buttons = <>
    ClientRectBottom = 436
    ClientRectLeft = 4
    ClientRectRight = 630
    ClientRectTop = 24
    object cxTabSheet1: TcxTabSheet
      Caption = 'Common'
      ImageIndex = 0
      object memInfo: TcxMemo
        Left = 0
        Top = 0
        Align = alClient
        Properties.ReadOnly = True
        Properties.ScrollBars = ssVertical
        TabOrder = 0
        Height = 412
        Width = 626
      end
    end
    object cxTabSheet2: TcxTabSheet
      Caption = 'Commands'
      ImageIndex = 1
      object cxGrid1: TcxGrid
        Left = 0
        Top = 0
        Width = 626
        Height = 412
        Align = alClient
        TabOrder = 0
        object InfoView: TcxGridDBTableView
          Navigator.Buttons.CustomButtons = <>
          OnCustomDrawCell = InfoViewCustomDrawCell
          DataController.DataSource = DataSource1
          DataController.Summary.DefaultGroupSummaryItems = <>
          DataController.Summary.FooterSummaryItems = <>
          DataController.Summary.SummaryGroups = <>
          OptionsData.Deleting = False
          OptionsData.DeletingConfirmation = False
          OptionsData.Editing = False
          OptionsData.Inserting = False
          OptionsView.ColumnAutoWidth = True
          OptionsView.GroupByBox = False
          object InfoViewAppCmdId: TcxGridDBColumn
            DataBinding.FieldName = 'AppCmdId'
            Width = 65
          end
          object InfoViewName: TcxGridDBColumn
            DataBinding.FieldName = 'Name'
            Width = 141
          end
          object InfoViewCaption: TcxGridDBColumn
            DataBinding.FieldName = 'Caption'
            Width = 143
          end
          object InfoViewClassName: TcxGridDBColumn
            DataBinding.FieldName = 'ClassName'
            Width = 142
          end
          object InfoViewCurrentValue: TcxGridDBColumn
            DataBinding.FieldName = 'CurrentValue'
            Width = 141
          end
        end
        object cxGrid1Level1: TcxGridLevel
          GridView = InfoView
        end
      end
    end
    object cxTabSheet3: TcxTabSheet
      Caption = 'Columns'
      ImageIndex = 2
    end
  end
  object DataSource1: TDataSource
    DataSet = ControlsTable
    Left = 520
    Top = 176
  end
  object ControlsTable: TFDMemTable
    FetchOptions.AssignedValues = [evMode]
    FetchOptions.Mode = fmAll
    ResourceOptions.AssignedValues = [rvSilentMode]
    ResourceOptions.SilentMode = True
    UpdateOptions.AssignedValues = [uvCheckRequired, uvAutoCommitUpdates]
    UpdateOptions.CheckRequired = False
    UpdateOptions.AutoCommitUpdates = True
    Left = 520
    Top = 240
    object ControlsTableAppCmdId: TIntegerField
      FieldName = 'AppCmdId'
    end
    object ControlsTableName: TStringField
      FieldName = 'Name'
      Size = 255
    end
    object ControlsTableCaption: TStringField
      FieldName = 'Caption'
      Size = 255
    end
    object ControlsTableClassName: TStringField
      FieldName = 'ClassName'
      Size = 255
    end
    object ControlsTableCurrentValue: TStringField
      FieldName = 'CurrentValue'
      Size = 200
    end
  end
end
