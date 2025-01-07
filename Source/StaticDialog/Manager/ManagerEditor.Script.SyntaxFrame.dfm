object SyntaxFrame: TSyntaxFrame
  Left = 0
  Top = 0
  Width = 689
  Height = 516
  TabOrder = 0
  object Splitter1: TSplitter
    Left = 0
    Top = 356
    Width = 689
    Height = 3
    Cursor = crVSplit
    Align = alBottom
    ExplicitLeft = 1
    ExplicitTop = 324
  end
  object pnBottom: TPanel
    Left = 0
    Top = 359
    Width = 689
    Height = 157
    Align = alBottom
    BevelOuter = bvNone
    ShowCaption = False
    TabOrder = 0
    object pgOutput: TcxPageControl
      Left = 0
      Top = 41
      Width = 689
      Height = 116
      Align = alClient
      TabOrder = 0
      Properties.ActivePage = tabGrid
      Properties.CustomButtons.Buttons = <>
      ClientRectBottom = 112
      ClientRectLeft = 4
      ClientRectRight = 685
      ClientRectTop = 26
      object tabGrid: TcxTabSheet
        Caption = 'Grid'
        ImageIndex = 1
        object MainGrid: TcxGrid
          Left = 0
          Top = 0
          Width = 681
          Height = 66
          Align = alClient
          TabOrder = 0
          object MainView: TcxGridDBTableView
            OnKeyDown = MainViewKeyDown
            Navigator.Buttons.CustomButtons = <>
            ScrollbarAnnotations.CustomAnnotations = <>
            OnCustomDrawCell = MainViewCustomDrawCell
            DataController.DataSource = DataSource
            DataController.Summary.DefaultGroupSummaryItems = <>
            DataController.Summary.FooterSummaryItems = <>
            DataController.Summary.SummaryGroups = <>
            OptionsCustomize.ColumnGrouping = False
            OptionsData.CancelOnExit = False
            OptionsData.Deleting = False
            OptionsData.DeletingConfirmation = False
            OptionsData.Editing = False
            OptionsData.Inserting = False
            OptionsView.NoDataToDisplayInfoText = ' '
            OptionsView.GroupByBox = False
            OptionsView.Indicator = True
          end
          object MainGridLevel1: TcxGridLevel
            GridView = MainView
          end
        end
        object StatusBar: TdxStatusBar
          Left = 0
          Top = 66
          Width = 681
          Height = 20
          Panels = <
            item
              PanelStyleClassName = 'TdxStatusBarTextPanelStyle'
              Width = 100
            end
            item
              PanelStyleClassName = 'TdxStatusBarTextPanelStyle'
              Width = 100
            end
            item
              PanelStyleClassName = 'TdxStatusBarTextPanelStyle'
              Width = 200
            end>
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -12
          Font.Name = 'Segoe UI'
          Font.Style = []
          Visible = False
        end
      end
      object tabInfo: TcxTabSheet
        Caption = 'Information'
        ImageIndex = 0
        ExplicitLeft = 0
        ExplicitTop = 0
        ExplicitWidth = 0
        ExplicitHeight = 0
        object ExecutionInfo: TRichEdit
          Left = 0
          Top = 0
          Width = 681
          Height = 86
          Align = alClient
          Font.Charset = RUSSIAN_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'Tahoma'
          Font.Style = []
          ParentFont = False
          ScrollBars = ssVertical
          TabOrder = 0
        end
      end
    end
    object pnHelp: TPanel
      Left = 0
      Top = 0
      Width = 689
      Height = 41
      Align = alTop
      ShowCaption = False
      TabOrder = 1
      Visible = False
      object memoHelp: TMemo
        Left = 1
        Top = 1
        Width = 687
        Height = 39
        Align = alClient
        Color = 12251900
        ReadOnly = True
        TabOrder = 0
      end
    end
  end
  object Editor: TDBMemo
    AlignWithMargins = True
    Left = 196
    Top = 3
    Width = 305
    Height = 350
    Align = alClient
    DataField = 'Script'
    DataSource = EditorDS
    PopupMenu = PopupMenu1
    TabOrder = 1
    OnChange = EditorChange
    OnKeyDown = EditorKeyDown
  end
  object pnParams: TPanel
    Left = 504
    Top = 0
    Width = 185
    Height = 356
    Align = alRight
    BevelOuter = bvNone
    TabOrder = 2
    inline ParamsFrame: TCommandPropertiesFrame
      Left = 0
      Top = 0
      Width = 185
      Height = 356
      Align = alClient
      TabOrder = 0
      ExplicitWidth = 185
      ExplicitHeight = 356
      inherited ParamGrid: TcxGrid
        Width = 185
        Height = 356
        ExplicitWidth = 185
        ExplicitHeight = 356
        inherited MainView: TcxGridDBTableView
          inherited colName: TcxGridDBColumn
            DataBinding.IsNullValueType = True
            MinWidth = 80
            Width = 115
          end
          inherited colSource: TcxGridDBColumn
            DataBinding.IsNullValueType = True
            Visible = False
            MinWidth = 80
            Width = 192
          end
          inherited colValue: TcxGridDBColumn
            DataBinding.IsNullValueType = True
            MinWidth = 80
            Width = 119
          end
        end
      end
    end
  end
  object pnDataTree: TPanel
    Left = 0
    Top = 0
    Width = 185
    Height = 356
    Align = alLeft
    BevelOuter = bvNone
    ShowCaption = False
    TabOrder = 3
    Visible = False
    object DataTree: TcxTreeView
      Left = 0
      Top = 0
      Width = 185
      Height = 356
      TabStop = False
      Align = alClient
      TabOrder = 0
      OnDblClick = DataTreeDblClick
      Images = ImageContainer.Images16
      ReadOnly = True
      RowSelect = True
      OnChange = DataTreeChange
    end
  end
  object cxSplitter1: TcxSplitter
    Left = 185
    Top = 0
    Width = 8
    Height = 356
  end
  object EditorDS: TDataSource
    Left = 320
    Top = 440
  end
  object DataSource: TDataSource
    Left = 252
    Top = 440
  end
  object PopupMenu1: TPopupMenu
    Images = ImageContainer.Images16
    Left = 172
    Top = 443
    object Cut1: TMenuItem
      Action = EditCut1
    end
    object Copy1: TMenuItem
      Action = EditCopy1
    end
    object Paste1: TMenuItem
      Action = EditPaste1
    end
    object Undo1: TMenuItem
      Action = EditUndo1
    end
    object N1: TMenuItem
      Caption = '-'
    end
    object SelectAll1: TMenuItem
      Action = EditSelectAll1
    end
    object Quote1: TMenuItem
      Action = acQuote
    end
  end
  object ActionList1: TActionList
    Images = ImageContainer.Images16
    Left = 100
    Top = 443
    object EditCut1: TEditCut
      Category = 'Edit'
      Caption = 'Cu&t'
      Hint = 'Cut|Cuts the selection and puts it on the Clipboard'
      ImageIndex = 206
      ShortCut = 16472
    end
    object EditCopy1: TEditCopy
      Category = 'Edit'
      Caption = '&Copy'
      Hint = 'Copy|Copies the selection and puts it on the Clipboard'
      ImageIndex = 205
      ShortCut = 16451
    end
    object EditPaste1: TEditPaste
      Category = 'Edit'
      Caption = '&Paste'
      Hint = 'Paste|Inserts Clipboard contents'
      ImageIndex = 449
      ShortCut = 16470
    end
    object EditSelectAll1: TEditSelectAll
      Category = 'Edit'
      Caption = 'Select &All'
      Hint = 'Select All|Selects the entire document'
      ImageIndex = 212
      ShortCut = 16449
    end
    object EditUndo1: TEditUndo
      Category = 'Edit'
      Caption = '&Undo'
      Hint = 'Undo|Reverts the last action'
      ImageIndex = 655
      ShortCut = 16474
    end
    object EditDelete1: TEditDelete
      Category = 'Edit'
      Caption = '&Delete'
      Hint = 'Delete|Erases the selection'
      ImageIndex = 207
      ShortCut = 46
    end
    object acQuote: TAction
      Category = 'Edit'
      Caption = 'Quote string'
      Hint = 'Qutoes first word of each selected line'
      ShortCut = 16465
      OnExecute = acQuoteExecute
    end
  end
end
