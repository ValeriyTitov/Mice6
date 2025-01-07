object ViewDataSet: TViewDataSet
  Left = 0
  Top = 0
  Caption = 'DataSet'
  ClientHeight = 355
  ClientWidth = 1184
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  OnClose = FormClose
  PixelsPerInch = 96
  TextHeight = 13
  object MainGrid: TcxGrid
    Left = 0
    Top = 25
    Width = 1184
    Height = 311
    Align = alClient
    PopupMenu = PopupMenu1
    TabOrder = 0
    object MainView: TcxGridDBTableView
      Navigator.Buttons.CustomButtons = <>
      OnCustomDrawCell = MainViewCustomDrawCell
      DataController.DataSource = DataSource
      DataController.Summary.DefaultGroupSummaryItems = <>
      DataController.Summary.FooterSummaryItems = <>
      DataController.Summary.SummaryGroups = <>
      OptionsData.CancelOnExit = False
      OptionsData.Deleting = False
      OptionsData.DeletingConfirmation = False
      OptionsData.Inserting = False
      OptionsView.ColumnAutoWidth = True
      OptionsView.GroupByBox = False
    end
    object MainGridLevel1: TcxGridLevel
      GridView = MainView
    end
  end
  object Panel1: TPanel
    Left = 0
    Top = 0
    Width = 1184
    Height = 25
    Align = alTop
    BevelOuter = bvNone
    TabOrder = 1
    object cbAutoWidth: TCheckBox
      Left = 8
      Top = 5
      Width = 73
      Height = 17
      Caption = 'AutoWidth'
      TabOrder = 0
      OnClick = cbAutoWidthClick
    end
  end
  object StatusBar: TStatusBar
    Left = 0
    Top = 336
    Width = 1184
    Height = 19
    Panels = <
      item
        Width = 100
      end
      item
        Width = 100
      end>
  end
  object DataSource: TDataSource
    Left = 24
    Top = 96
  end
  object SaveDialog1: TSaveDialog
    DefaultExt = '.xls'
    FileName = 'Export.xls'
    Filter = 'Excel files|*.xls'
    Options = [ofOverwritePrompt, ofHideReadOnly, ofEnableSizing]
    Left = 24
    Top = 152
  end
  object PopupMenu1: TPopupMenu
    Left = 24
    Top = 48
    object Excel1: TMenuItem
      Caption = 'Export to Excel...'
      ImageIndex = 3
      OnClick = Excel1Click
    end
  end
end
