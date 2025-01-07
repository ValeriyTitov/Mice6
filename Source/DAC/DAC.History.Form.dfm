object SQLHistoryForm: TSQLHistoryForm
  Left = 0
  Top = 0
  Caption = 'Query log'
  ClientHeight = 529
  ClientWidth = 838
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object HistoryList: TcxTreeList
    Left = 0
    Top = 0
    Width = 838
    Height = 509
    Align = alClient
    Bands = <
      item
      end>
    Navigator.Buttons.CustomButtons = <>
    OptionsBehavior.Sorting = False
    OptionsCustomizing.BandCustomizing = False
    OptionsCustomizing.BandMoving = False
    OptionsCustomizing.BandVertSizing = False
    OptionsCustomizing.ColumnCustomizing = False
    OptionsCustomizing.ColumnMoving = False
    OptionsData.Editing = False
    OptionsData.Deleting = False
    OptionsSelection.CellSelect = False
    OptionsSelection.MultiSelect = True
    OptionsView.ColumnAutoWidth = True
    OptionsView.TreeLineStyle = tllsNone
    OptionsView.UseImageIndexForSelected = False
    OptionsView.UseNodeColorForIndent = False
    PopupMenu = PopupMenu
    TabOrder = 0
    OnCustomDrawDataCell = HistoryListCustomDrawDataCell
    OnSelectionChanged = HistoryListSelectionChanged
    object colDBName: TcxTreeListColumn
      Caption.AlignVert = vaTop
      Caption.Text = 'Database'
      DataBinding.ValueType = 'String'
      Options.Editing = False
      Width = 68
      Position.ColIndex = 0
      Position.RowIndex = 0
      Position.BandIndex = 0
      Summary.FooterSummaryItems = <>
      Summary.GroupFooterSummaryItems = <>
    end
    object colAddedOn: TcxTreeListColumn
      Caption.Text = 'Added on'
      DataBinding.ValueType = 'String'
      Width = 100
      Position.ColIndex = 1
      Position.RowIndex = 0
      Position.BandIndex = 0
      Summary.FooterSummaryItems = <>
      Summary.GroupFooterSummaryItems = <>
    end
    object colSQL: TcxTreeListColumn
      Caption.Text = 'SQL'
      DataBinding.ValueType = 'String'
      Options.Editing = False
      Width = 483
      Position.ColIndex = 2
      Position.RowIndex = 0
      Position.BandIndex = 0
      Summary.FooterSummaryItems = <>
      Summary.GroupFooterSummaryItems = <>
    end
    object colEntry: TcxTreeListColumn
      Visible = False
      Caption.Text = #1048#1089#1090#1086#1095#1085#1080#1082
      DataBinding.ValueType = 'String'
      Options.Editing = False
      Width = 129
      Position.ColIndex = 3
      Position.RowIndex = 0
      Position.BandIndex = 0
      Summary.FooterSummaryItems = <>
      Summary.GroupFooterSummaryItems = <>
    end
    object colTime: TcxTreeListColumn
      Caption.Text = 'Time, ms'
      DataBinding.ValueType = 'String'
      Options.Editing = False
      Width = 64
      Position.ColIndex = 4
      Position.RowIndex = 0
      Position.BandIndex = 0
      Summary.FooterSummaryItems = <>
      Summary.GroupFooterSummaryItems = <>
    end
    object colRowCount: TcxTreeListColumn
      Caption.Text = 'Row count'
      DataBinding.ValueType = 'String'
      Options.Editing = False
      Width = 94
      Position.ColIndex = 5
      Position.RowIndex = 0
      Position.BandIndex = 0
      Summary.FooterSummaryItems = <>
      Summary.GroupFooterSummaryItems = <>
    end
    object colSource: TcxTreeListColumn
      Visible = False
      Caption.Text = #1057#1090#1072#1090#1091#1089
      DataBinding.ValueType = 'String'
      Options.Editing = False
      Width = 100
      Position.ColIndex = 6
      Position.RowIndex = 0
      Position.BandIndex = 0
      Summary.FooterSummaryItems = <>
      Summary.GroupFooterSummaryItems = <>
    end
    object colInfo: TcxTreeListColumn
      Visible = False
      Caption.Text = #1048#1085#1092#1086#1088#1084#1072#1094#1080#1103
      DataBinding.ValueType = 'String'
      Options.Editing = False
      Width = 100
      Position.ColIndex = 7
      Position.RowIndex = 0
      Position.BandIndex = 0
      Summary.FooterSummaryItems = <>
      Summary.GroupFooterSummaryItems = <>
    end
    object colStatus: TcxTreeListColumn
      Caption.Text = 'Status'
      DataBinding.ValueType = 'String'
      Width = 127
      Position.ColIndex = 8
      Position.RowIndex = 0
      Position.BandIndex = 0
      Summary.FooterSummaryItems = <>
      Summary.GroupFooterSummaryItems = <>
    end
  end
  object StatusBar: TdxStatusBar
    Left = 0
    Top = 509
    Width = 838
    Height = 20
    Panels = <
      item
        PanelStyleClassName = 'TdxStatusBarTextPanelStyle'
        Width = 320
      end
      item
        PanelStyleClassName = 'TdxStatusBarTextPanelStyle'
        Width = 64
      end>
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Tahoma'
    Font.Style = []
  end
  object PopupMenu: TPopupMenu
    Left = 24
    Top = 32
    object Copy1: TMenuItem
      Caption = 'Copy'
      ImageIndex = 205
      OnClick = Copy1Click
    end
    object Clearhistory1: TMenuItem
      Caption = 'Clear history'
      ImageIndex = 228
      OnClick = Clearhistory1Click
    end
  end
end
