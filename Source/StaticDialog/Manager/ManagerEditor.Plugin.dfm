inherited ManagerEditorPlugin: TManagerEditorPlugin
  Caption = 'Edit Plugin'
  ClientHeight = 581
  ClientWidth = 575
  Constraints.MinHeight = 480
  ExplicitWidth = 591
  ExplicitHeight = 620
  TextHeight = 13
  inherited pnBottomButtons: TPanel
    Top = 540
    Width = 575
    ExplicitTop = 540
    ExplicitWidth = 575
    inherited bnAdvanced: TSpeedButton
      Visible = True
    end
    inherited bnOK: TcxButton
      Left = 397
      ExplicitLeft = 397
    end
    inherited bnCancel: TcxButton
      Left = 478
      ExplicitLeft = 478
    end
  end
  inherited DialogLayout: TdxLayoutControl
    Width = 575
    Height = 540
    HighlightRoot = False
    ExplicitWidth = 575
    ExplicitHeight = 540
    object Image1: TImage [0]
      Left = 23
      Top = 43
      Width = 32
      Height = 32
      Stretch = True
      Transparent = True
    end
    object Label2: TLabel [1]
      Left = 61
      Top = 51
      Width = 338
      Height = 16
      Caption = 'Plugn properties'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -13
      Font.Name = 'Tahoma'
      Font.Style = [fsBold]
      ParentFont = False
    end
    object edAppPluginsId: TcxDBTextEdit [2]
      Left = 472
      Top = 48
      DataBinding.DataField = 'AppPluginsId'
      DataBinding.DataSource = MainSource
      Style.BorderColor = clWindowFrame
      Style.BorderStyle = ebsFlat
      TabOrder = 0
      Width = 80
    end
    object cbPluginType: TcxDBImageComboBox [3]
      Left = 431
      Top = 111
      DataBinding.DataField = 'PluginType'
      DataBinding.DataSource = MainSource
      Properties.Images = ImageContainer.Images16
      Properties.Items = <
        item
          Description = 'Standart Grid'
          ImageIndex = 82
          Value = 0
        end
        item
          Description = 'Tree Grid'
          ImageIndex = 653
          Value = 1
        end
        item
          Description = 'Pivot Grid'
          ImageIndex = 468
          Value = 2
        end
        item
          Description = 'Charts'
          ImageIndex = 122
          Value = 3
        end
        item
          Description = 'Multi Plugin'
          ImageIndex = 4
          Value = 4
        end
        item
          Description = 'Page'
          ImageIndex = 445
          Value = 5
        end>
      Properties.OnChange = cbPluginTypePropertiesChange
      Style.BorderColor = clWindowFrame
      Style.BorderStyle = ebsFlat
      Style.ButtonStyle = btsFlat
      Style.PopupBorderStyle = epbsFlat
      TabOrder = 2
      Width = 121
    end
    object cbDialogIdField: TcxDBComboBox [4]
      Left = 192
      Top = 454
      DataBinding.DataField = 'AppDialogsIdField'
      DataBinding.DataSource = MainSource
      Style.BorderColor = clWindowFrame
      Style.BorderStyle = ebsFlat
      Style.ButtonStyle = btsFlat
      Style.PopupBorderStyle = epbsFlat
      TabOrder = 6
      Width = 345
    end
    object cbDocFlow: TcxDBCheckBox [5]
      Left = 10000
      Top = 10000
      AutoSize = False
      Caption = 'Enable DocFlow'
      DataBinding.DataField = 'DocFlow'
      DataBinding.DataSource = MainSource
      Style.BorderColor = clWindowFrame
      Style.BorderStyle = ebsFlat
      Style.HotTrack = False
      TabOrder = 16
      Visible = False
      OnClick = cbDocFlowClick
      Height = 21
      Width = 121
    end
    object cbShowDocClasses: TcxDBCheckBox [6]
      Left = 10000
      Top = 10000
      Caption = 'Show DocClasses'
      DataBinding.DataField = 'ShowDocClasses'
      DataBinding.DataSource = MainSource
      Enabled = False
      Style.BorderColor = clWindowFrame
      Style.BorderStyle = ebsFlat
      Style.HotTrack = False
      TabOrder = 18
      Visible = False
    end
    object cbShowDocFolders: TcxDBCheckBox [7]
      Left = 10000
      Top = 10000
      AutoSize = False
      Caption = 'Show DocFolders'
      DataBinding.DataField = 'ShowDocFolder'
      DataBinding.DataSource = MainSource
      Enabled = False
      Style.BorderColor = clWindowFrame
      Style.BorderStyle = ebsFlat
      Style.HotTrack = False
      TabOrder = 17
      Visible = False
      Height = 21
      Width = 121
    end
    object edProviderName: TcxDBButtonEdit [8]
      Left = 10000
      Top = 10000
      DataBinding.DataField = 'ProviderName'
      DataBinding.DataSource = MainSource
      Properties.Buttons = <
        item
          Default = True
          Kind = bkEllipsis
        end>
      Properties.OnButtonClick = edProviderNamePropertiesButtonClick
      Style.BorderColor = clWindowFrame
      Style.BorderStyle = ebsFlat
      Style.ButtonStyle = btsFlat
      TabOrder = 10
      Visible = False
      Width = 394
    end
    object edDelProviderName: TcxDBButtonEdit [9]
      Left = 10000
      Top = 10000
      DataBinding.DataField = 'DelProviderName'
      DataBinding.DataSource = MainSource
      Properties.Buttons = <
        item
          Default = True
          Kind = bkEllipsis
        end>
      Properties.OnButtonClick = edDelProviderNamePropertiesButtonClick
      Style.BorderColor = clWindowFrame
      Style.BorderStyle = ebsFlat
      Style.ButtonStyle = btsFlat
      TabOrder = 11
      Visible = False
      Width = 394
    end
    object edKeyField: TcxDBTextEdit [10]
      Left = 10000
      Top = 10000
      DataBinding.DataField = 'KeyField'
      DataBinding.DataSource = MainSource
      Style.BorderColor = clWindowFrame
      Style.BorderStyle = ebsFlat
      TabOrder = 12
      Visible = False
      Width = 121
    end
    object edImageIndexField: TcxDBTextEdit [11]
      Left = 10000
      Top = 10000
      DataBinding.DataField = 'ImageIndexField'
      DataBinding.DataSource = MainSource
      Style.BorderColor = clWindowFrame
      Style.BorderStyle = ebsFlat
      TabOrder = 14
      Visible = False
      Width = 121
    end
    object edSummuryField: TcxDBTextEdit [12]
      Left = 10000
      Top = 10000
      DataBinding.DataSource = MainSource
      Style.BorderColor = clWindowFrame
      Style.BorderStyle = ebsFlat
      TabOrder = 15
      Visible = False
      Width = 121
    end
    object TcxDBTextEdit [13]
      Left = 10000
      Top = 10000
      DataBinding.DataField = 'ParentIdField'
      DataBinding.DataSource = MainSource
      Style.BorderColor = clWindowFrame
      Style.BorderStyle = ebs3D
      TabOrder = 37
      Visible = False
      Width = 121
    end
    object cbAutoWidth: TcxDBCheckBox [14]
      Left = 10000
      Top = 10000
      Caption = 'Auto column width'
      DataBinding.DataField = 'AutoWidth'
      DataBinding.DataSource = MainSource
      Style.BorderColor = clWindowFrame
      Style.BorderStyle = ebsFlat
      TabOrder = 20
      Visible = False
    end
    object cbSorting: TcxDBCheckBox [15]
      Left = 10000
      Top = 10000
      Caption = 'Sorting'
      DataBinding.DataField = 'Sorting'
      DataBinding.DataSource = MainSource
      Style.BorderColor = clWindowFrame
      Style.BorderStyle = ebsFlat
      TabOrder = 21
      Visible = False
    end
    object cbGroupByPanel: TcxDBCheckBox [16]
      Left = 10000
      Top = 10000
      Caption = 'Group by panel'
      DataBinding.DataField = 'GroupByPanel'
      DataBinding.DataSource = MainSource
      Style.BorderColor = clWindowFrame
      Style.BorderStyle = ebsFlat
      TabOrder = 22
      Visible = False
    end
    inline ColumnEditor: TColumnEditorFrame [17]
      Left = 10000
      Top = 10000
      Width = 529
      Height = 393
      TabOrder = 23
      Visible = False
      ExplicitLeft = 10000
      ExplicitTop = 10000
      ExplicitWidth = 529
      ExplicitHeight = 393
      inherited gridColumns: TcxGrid
        Width = 529
        Height = 393
        ExplicitWidth = 529
        ExplicitHeight = 393
        inherited MainView: TcxGridDBBandedTableView
          inherited colOrderId: TcxGridDBBandedColumn
            DataBinding.IsNullValueType = True
          end
          inherited colHdr: TcxGridDBBandedColumn
            DataBinding.IsNullValueType = True
          end
          inherited colFieldName: TcxGridDBBandedColumn
            DataBinding.IsNullValueType = True
          end
          inherited colCaption: TcxGridDBBandedColumn
            DataBinding.IsNullValueType = True
          end
          inherited colWidth: TcxGridDBBandedColumn
            DataBinding.IsNullValueType = True
          end
          inherited colVisible: TcxGridDBBandedColumn
            DataBinding.IsNullValueType = True
          end
          inherited colSizing: TcxGridDBBandedColumn
            DataBinding.IsNullValueType = True
          end
          inherited colFilter: TcxGridDBBandedColumn
            DataBinding.IsNullValueType = True
          end
          inherited colAlign: TcxGridDBBandedColumn
            DataBinding.IsNullValueType = True
          end
          inherited colMore: TcxGridDBBandedColumn
            DataBinding.IsNullValueType = True
          end
        end
      end
    end
    object edBGColorField: TcxDBComboBox
      Left = 10000
      Top = 10000
      DataBinding.DataField = 'bgColorField'
      DataBinding.DataSource = MainSource
      Style.BorderColor = clWindowFrame
      Style.BorderStyle = ebsFlat
      Style.ButtonStyle = btsFlat
      Style.PopupBorderStyle = epbsFlat
      TabOrder = 24
      Visible = False
      Width = 412
    end
    object edFontColorField: TcxDBComboBox
      Left = 10000
      Top = 10000
      DataBinding.DataField = 'FontColorField'
      DataBinding.DataSource = MainSource
      Style.BorderColor = clWindowFrame
      Style.BorderStyle = ebsFlat
      Style.ButtonStyle = btsFlat
      Style.PopupBorderStyle = epbsFlat
      TabOrder = 25
      Visible = False
      Width = 412
    end
    object edFontStyleField: TcxDBComboBox
      Left = 10000
      Top = 10000
      DataBinding.DataField = 'FontStyleField'
      DataBinding.DataSource = MainSource
      Style.BorderColor = clWindowFrame
      Style.BorderStyle = ebsFlat
      Style.ButtonStyle = btsFlat
      Style.PopupBorderStyle = epbsFlat
      TabOrder = 26
      Visible = False
      Width = 412
    end
    object edParentIdField: TcxDBTextEdit
      Left = 10000
      Top = 10000
      DataBinding.DataField = 'ParentIdField'
      DataBinding.DataSource = MainSource
      Style.BorderColor = clWindowFrame
      Style.BorderStyle = ebsFlat
      Style.HotTrack = False
      TabOrder = 13
      Visible = False
      Width = 121
    end
    object memoDescription: TcxDBMemo
      Left = 23
      Top = 156
      DataBinding.DataField = 'Description'
      DataBinding.DataSource = MainSource
      Style.BorderColor = clWindowFrame
      Style.BorderStyle = ebsFlat
      TabOrder = 3
      Height = 181
      Width = 529
    end
    object edPluginName: TcxDBTextEdit
      Left = 23
      Top = 111
      DataBinding.DataField = 'Name'
      DataBinding.DataSource = MainSource
      Style.BorderColor = clWindowFrame
      Style.BorderStyle = ebsFlat
      TabOrder = 1
      Width = 402
    end
    object cbPluginDBName: TcxDBComboBox
      Left = 10000
      Top = 10000
      DataBinding.DataField = 'DBName'
      DataBinding.DataSource = MainSource
      Style.BorderColor = clWindowFrame
      Style.BorderStyle = ebsFlat
      Style.HotTrack = False
      Style.ButtonStyle = btsFlat
      Style.PopupBorderStyle = epbsFlat
      TabOrder = 9
      Visible = False
      Width = 394
    end
    object cbSideTreeEnabled: TcxDBCheckBox
      Left = 10000
      Top = 10000
      Caption = 'Enabled'
      DataBinding.DataField = 'SideTreeEnabled'
      DataBinding.DataSource = MainSource
      Style.BorderColor = clWindowFrame
      Style.BorderStyle = ebsFlat
      Style.HotTrack = False
      TabOrder = 28
      Visible = False
      OnClick = cbSideTreeEnabledClick
    end
    object edTreeKeyField: TcxDBTextEdit
      Left = 10000
      Top = 10000
      DataBinding.DataField = 'SideTreeKeyField'
      DataBinding.DataSource = MainSource
      Style.BorderColor = clWindowFrame
      Style.BorderStyle = ebsFlat
      Style.HotTrack = False
      TabOrder = 30
      Visible = False
      Width = 414
    end
    object edTreeProviderName: TcxDBButtonEdit
      Left = 10000
      Top = 10000
      Hint = 
        ' Must return following fields: ID, ParentId, Description, ImageI' +
        'ndex, [ProviderName], [OrderId], [Value]'
      DataBinding.DataField = 'SideTreeProviderName'
      DataBinding.DataSource = MainSource
      Properties.Buttons = <
        item
          Default = True
          Kind = bkEllipsis
        end>
      Properties.OnButtonClick = edTreeProviderNamePropertiesButtonClick
      Style.BorderColor = clWindowFrame
      Style.BorderStyle = ebsFlat
      Style.HotTrack = False
      Style.ButtonStyle = btsFlat
      TabOrder = 32
      Visible = False
      Width = 414
    end
    object edFilterParamName: TcxDBTextEdit
      Left = 10000
      Top = 10000
      Hint = 
        'Field to map as parameter with same name, for example field Name' +
        ' maps as @Name pararameeter'
      DataBinding.DataField = 'SideTreeParamName'
      DataBinding.DataSource = MainSource
      Style.BorderColor = clWindowFrame
      Style.BorderStyle = ebsFlat
      Style.HotTrack = False
      TabOrder = 34
      Visible = False
      Width = 414
    end
    object edTreeParentIdField: TcxDBTextEdit
      Left = 10000
      Top = 10000
      DataBinding.DataField = 'SideTreeParentField'
      DataBinding.DataSource = MainSource
      Style.BorderColor = clWindowFrame
      Style.BorderStyle = ebsFlat
      Style.HotTrack = False
      TabOrder = 31
      Visible = False
      Width = 414
    end
    inline ColorsEditor: TMiceGridColorEditorFrame
      Left = 10000
      Top = 10000
      Width = 529
      Height = 357
      TabOrder = 27
      Visible = False
      ExplicitLeft = 10000
      ExplicitTop = 10000
      ExplicitWidth = 529
      ExplicitHeight = 357
      inherited gridColumns: TcxGrid
        Width = 529
        Height = 357
        ExplicitWidth = 529
        ExplicitHeight = 357
        inherited MainView: TcxGridDBBandedTableView
          OnCustomDrawCell = nil
          inherited colOrderId: TcxGridDBBandedColumn
            DataBinding.IsNullValueType = True
          end
          inherited colFieldName: TcxGridDBBandedColumn
            DataBinding.IsNullValueType = True
          end
          inherited colSign: TcxGridDBBandedColumn
            DataBinding.IsNullValueType = True
          end
          inherited colValue: TcxGridDBBandedColumn
            DataBinding.IsNullValueType = True
          end
          inherited colBgColor: TcxGridDBBandedColumn
            DataBinding.IsNullValueType = True
          end
          inherited colColor: TcxGridDBBandedColumn
            Caption = 'Font color'
            DataBinding.IsNullValueType = True
          end
          inherited colBold: TcxGridDBBandedColumn
            DataBinding.IsNullValueType = True
          end
          inherited colItalic: TcxGridDBBandedColumn
            DataBinding.IsNullValueType = True
          end
          inherited colWholeLine: TcxGridDBBandedColumn
            DataBinding.IsNullValueType = True
          end
        end
      end
    end
    object spinSideTreeExpandLevel: TcxDBSpinEdit
      Left = 10000
      Top = 10000
      DataBinding.DataField = 'SideTreeExpandLevel'
      DataBinding.DataSource = MainSource
      Style.BorderColor = clWindowFrame
      Style.BorderStyle = ebsFlat
      Style.HotTrack = False
      Style.ButtonStyle = btsFlat
      TabOrder = 29
      Visible = False
      Width = 48
    end
    object bnDefAppCmdId: TcxButtonEdit
      Left = 192
      Top = 364
      Properties.Buttons = <
        item
          Default = True
          Kind = bkEllipsis
        end>
      Style.BorderColor = clWindowFrame
      Style.BorderStyle = ebsFlat
      Style.HotTrack = False
      Style.ButtonStyle = btsFlat
      TabOrder = 4
      Width = 345
    end
    object edCustomDialogId: TcxButtonEdit
      Left = 192
      Top = 427
      Properties.Buttons = <
        item
          Default = True
          Kind = bkEllipsis
        end>
      Properties.OnButtonClick = edCustomDialogIDPropertiesButtonClick
      Style.BorderColor = clWindowFrame
      Style.BorderStyle = ebsFlat
      Style.HotTrack = False
      Style.ButtonStyle = btsFlat
      TabOrder = 5
      Width = 345
    end
    object edAppPluginsIdPage: TcxTextEdit
      Left = 10000
      Top = 10000
      Hint = 
        'Field name which returns an ID of plugin to create in seperate p' +
        'age according current SideTree key field (Multipage plugin only)'
      Properties.ReadOnly = True
      Style.BorderColor = clWindowFrame
      Style.BorderStyle = ebsFlat
      Style.HotTrack = False
      TabOrder = 35
      Text = 'AppPluginsId'
      Visible = False
      Width = 414
    end
    object edSideTreeCaptionField: TcxDBTextEdit
      Left = 10000
      Top = 10000
      DataBinding.DataField = 'SideTreeCaptionField'
      DataBinding.DataSource = MainSource
      Style.BorderColor = clWindowFrame
      Style.BorderStyle = ebsFlat
      Style.HotTrack = False
      TabOrder = 33
      Visible = False
      Width = 414
    end
    object cbRefreshAfterCreate: TcxDBCheckBox
      Left = 10000
      Top = 10000
      Caption = 'Autorefresh After Create'
      DataBinding.DataField = 'RefreshAfterCreate'
      DataBinding.DataSource = MainSource
      Style.BorderColor = clWindowFrame
      Style.BorderStyle = ebsFlat
      Style.HotTrack = False
      TabOrder = 8
      Visible = False
    end
    object edCustomLayoutsIdField: TcxDBTextEdit
      Left = 192
      Top = 481
      DataBinding.DataField = 'AppDialogLayoutsIdField'
      DataBinding.DataSource = MainSource
      Style.BorderColor = clWindowFrame
      Style.BorderStyle = ebsFlat
      Style.HotTrack = False
      TabOrder = 7
      Width = 345
    end
    object bnEditScript: TcxButton
      Left = 10000
      Top = 10000
      Width = 75
      Height = 25
      Caption = 'Edit'
      TabOrder = 36
      Visible = False
      OnClick = bnEditScriptClick
    end
    object eddfClassesId: TcxDBTextEdit
      Left = 10000
      Top = 10000
      DataBinding.DataField = 'dfClassesId'
      DataBinding.DataSource = MainSource
      Style.BorderColor = clWindowFrame
      Style.BorderStyle = ebsFlat
      Style.HotTrack = False
      TabOrder = 19
      Visible = False
      Width = 394
    end
    inherited DialogLayoutGroup_Root: TdxLayoutGroup
      CaptionOptions.Text = 'Common'
      CaptionOptions.Visible = False
    end
    object Tab0: TdxLayoutGroup
      Parent = DialogLayoutGroup_Root
      AlignVert = avClient
      CaptionOptions.Text = 'Common'
      ButtonOptions.ShowExpandButton = True
      ItemIndex = 5
      Index = 0
    end
    object dxLayoutAutoCreatedGroup2: TdxLayoutAutoCreatedGroup
      Parent = Tab0
      AlignVert = avTop
      LayoutDirection = ldHorizontal
      Index = 0
    end
    object item_edAppPluginsId: TdxLayoutItem
      Parent = dxLayoutAutoCreatedGroup2
      AlignHorz = ahRight
      AlignVert = avCenter
      CaptionOptions.Text = 'AppPluginsId'
      Control = edAppPluginsId
      ControlOptions.OriginalHeight = 21
      ControlOptions.OriginalWidth = 80
      ControlOptions.ShowBorder = False
      Index = 0
    end
    object dxLayoutItem22: TdxLayoutItem
      Parent = dxLayoutAutoCreatedGroup2
      AlignHorz = ahLeft
      AlignVert = avTop
      Control = Image1
      ControlOptions.OriginalHeight = 32
      ControlOptions.OriginalWidth = 32
      ControlOptions.ShowBorder = False
      Index = 1
    end
    object dxLayoutItem23: TdxLayoutItem
      Parent = dxLayoutAutoCreatedGroup2
      AlignHorz = ahClient
      AlignVert = avCenter
      CaptionOptions.Text = 'Label2'
      CaptionOptions.Visible = False
      Control = Label2
      ControlOptions.AutoColor = True
      ControlOptions.OriginalHeight = 16
      ControlOptions.OriginalWidth = 107
      ControlOptions.ShowBorder = False
      Index = 2
    end
    object dxLayoutSeparatorItem1: TdxLayoutSeparatorItem
      Parent = Tab0
      AlignHorz = ahClient
      CaptionOptions.Text = 'Separator'
      Index = 1
    end
    object dxLayoutItem2: TdxLayoutItem
      Parent = dxLayoutAutoCreatedGroup1
      AlignHorz = ahRight
      AlignVert = avTop
      CaptionOptions.Text = 'Type'
      CaptionOptions.Layout = clTop
      Control = cbPluginType
      ControlOptions.OriginalHeight = 21
      ControlOptions.OriginalWidth = 121
      ControlOptions.ShowBorder = False
      Index = 1
    end
    object dxLayoutGroup4: TdxLayoutGroup
      Parent = Tab0
      AlignHorz = ahClient
      AlignVert = avTop
      CaptionOptions.Text = 'Dialog'
      Index = 5
    end
    object dxLayoutItem6: TdxLayoutItem
      Parent = dxLayoutGroup4
      AlignHorz = ahClient
      AlignVert = avTop
      CaptionOptions.Text = 'Custom DialogId Field'
      CaptionOptions.Width = 150
      Control = cbDialogIdField
      ControlOptions.OriginalHeight = 21
      ControlOptions.OriginalWidth = 121
      ControlOptions.ShowBorder = False
      Index = 1
    end
    object dxLayoutGroup1: TdxLayoutGroup
      Parent = Tab1
      AlignHorz = ahClient
      AlignVert = avTop
      CaptionOptions.Text = 'Doc flow'
      Index = 2
    end
    object dxLayoutItem25: TdxLayoutItem
      Parent = dxLayoutAutoCreatedGroup4
      AlignVert = avClient
      CaptionOptions.Text = 'cxDBCheckBox6'
      CaptionOptions.Visible = False
      Control = cbDocFlow
      ControlOptions.OriginalHeight = 21
      ControlOptions.OriginalWidth = 121
      ControlOptions.ShowBorder = False
      Index = 0
    end
    object dxLayoutItem17: TdxLayoutItem
      Parent = dxLayoutAutoCreatedGroup4
      AlignVert = avClient
      CaptionOptions.Visible = False
      Control = cbShowDocClasses
      ControlOptions.OriginalHeight = 21
      ControlOptions.OriginalWidth = 105
      ControlOptions.ShowBorder = False
      Enabled = False
      Index = 2
    end
    object dxLayoutItem26: TdxLayoutItem
      Parent = dxLayoutAutoCreatedGroup4
      AlignVert = avClient
      CaptionOptions.Text = 'cxDBCheckBox7'
      CaptionOptions.Visible = False
      Control = cbShowDocFolders
      ControlOptions.OriginalHeight = 21
      ControlOptions.OriginalWidth = 121
      ControlOptions.ShowBorder = False
      Enabled = False
      Index = 1
    end
    object Tab1: TdxLayoutGroup
      Parent = DialogLayoutGroup_Root
      AlignVert = avClient
      CaptionOptions.Text = 'Data'
      ItemIndex = 2
      Index = 1
    end
    object item_Providers: TdxLayoutGroup
      Parent = Tab1
      CaptionOptions.Text = 'SQL Providers'
      Index = 0
    end
    object dxLayoutItem11: TdxLayoutItem
      Parent = item_Providers
      AlignHorz = ahClient
      AlignVert = avTop
      CaptionOptions.Text = 'ProviderName'
      Control = edProviderName
      ControlOptions.OriginalHeight = 21
      ControlOptions.OriginalWidth = 121
      ControlOptions.ShowBorder = False
      Index = 2
    end
    object dxLayoutItem12: TdxLayoutItem
      Parent = item_Providers
      CaptionOptions.Text = 'Delete Providername'
      Control = edDelProviderName
      ControlOptions.OriginalHeight = 21
      ControlOptions.OriginalWidth = 121
      ControlOptions.ShowBorder = False
      Index = 3
    end
    object item_DataFields: TdxLayoutGroup
      Parent = Tab1
      AlignHorz = ahClient
      AlignVert = avTop
      CaptionOptions.Text = 'Data fields'
      ItemIndex = 1
      Index = 1
    end
    object dxLayoutItem7: TdxLayoutItem
      Parent = item_DataFields
      AlignHorz = ahLeft
      CaptionOptions.Text = 'Key Field'
      Control = edKeyField
      ControlOptions.OriginalHeight = 21
      ControlOptions.OriginalWidth = 121
      ControlOptions.ShowBorder = False
      Index = 0
    end
    object dxLayoutItem8: TdxLayoutItem
      Parent = item_DataFields
      AlignHorz = ahLeft
      CaptionOptions.Text = 'ImageIndex Field'
      Control = edImageIndexField
      ControlOptions.OriginalHeight = 21
      ControlOptions.OriginalWidth = 121
      ControlOptions.ShowBorder = False
      Index = 2
    end
    object dxLayoutItem10: TdxLayoutItem
      Parent = item_DataFields
      AlignHorz = ahLeft
      CaptionOptions.Text = 'Summary Field'
      Control = edSummuryField
      ControlOptions.OriginalHeight = 21
      ControlOptions.OriginalWidth = 121
      ControlOptions.ShowBorder = False
      Index = 3
    end
    object Tab2: TdxLayoutGroup
      Parent = DialogLayoutGroup_Root
      AlignVert = avClient
      CaptionOptions.Text = 'Columns'
      ItemIndex = 1
      Index = 2
    end
    object dxLayoutGroup8: TdxLayoutGroup
      Parent = Tab2
      AlignVert = avTop
      CaptionOptions.Text = 'Common'
      LayoutDirection = ldHorizontal
      Index = 0
    end
    object dxLayoutItem18: TdxLayoutItem
      Parent = dxLayoutGroup8
      AlignHorz = ahLeft
      AlignVert = avTop
      CaptionOptions.Visible = False
      Control = cbAutoWidth
      ControlOptions.OriginalHeight = 21
      ControlOptions.OriginalWidth = 110
      ControlOptions.ShowBorder = False
      Index = 0
    end
    object dxLayoutItem19: TdxLayoutItem
      Parent = dxLayoutGroup8
      AlignHorz = ahLeft
      AlignVert = avClient
      CaptionOptions.Visible = False
      Control = cbSorting
      ControlOptions.OriginalHeight = 21
      ControlOptions.OriginalWidth = 56
      ControlOptions.ShowBorder = False
      Index = 1
    end
    object dxLayoutItem20: TdxLayoutItem
      Parent = dxLayoutGroup8
      AlignHorz = ahLeft
      AlignVert = avClient
      CaptionOptions.Visible = False
      Control = cbGroupByPanel
      ControlOptions.OriginalHeight = 21
      ControlOptions.OriginalWidth = 95
      ControlOptions.ShowBorder = False
      Index = 2
    end
    object dxLayoutItem21: TdxLayoutItem
      Parent = Tab2
      AlignVert = avClient
      CaptionOptions.AlignVert = tavTop
      CaptionOptions.Text = 'Columns:'
      CaptionOptions.Layout = clTop
      Control = ColumnEditor
      ControlOptions.AutoColor = True
      ControlOptions.OriginalHeight = 279
      ControlOptions.OriginalWidth = 450
      ControlOptions.ShowBorder = False
      Index = 1
    end
    object Tab3: TdxLayoutGroup
      Parent = DialogLayoutGroup_Root
      AlignVert = avClient
      CaptionOptions.Text = 'Colors'
      Index = 3
    end
    object dxLayoutGroup7: TdxLayoutGroup
      Parent = Tab3
      CaptionOptions.Text = 'Fields'
      ItemIndex = 1
      Index = 0
    end
    object dxLayoutItem14: TdxLayoutItem
      Parent = dxLayoutGroup7
      CaptionOptions.Text = 'Background color'
      Control = edBGColorField
      ControlOptions.OriginalHeight = 21
      ControlOptions.OriginalWidth = 121
      ControlOptions.ShowBorder = False
      Index = 0
    end
    object dxLayoutItem15: TdxLayoutItem
      Parent = dxLayoutGroup7
      CaptionOptions.Text = 'Font color'
      Control = edFontColorField
      ControlOptions.OriginalHeight = 21
      ControlOptions.OriginalWidth = 121
      ControlOptions.ShowBorder = False
      Index = 1
    end
    object dxLayoutItem16: TdxLayoutItem
      Parent = dxLayoutGroup7
      AlignHorz = ahClient
      AlignVert = avTop
      CaptionOptions.Text = 'Font style'
      Control = edFontStyleField
      ControlOptions.OriginalHeight = 21
      ControlOptions.OriginalWidth = 121
      ControlOptions.ShowBorder = False
      Index = 2
    end
    object edParentIdField_Item: TdxLayoutItem
      Parent = item_DataFields
      AlignHorz = ahLeft
      CaptionOptions.Text = 'ParentId Field'
      Control = edParentIdField
      ControlOptions.OriginalHeight = 21
      ControlOptions.OriginalWidth = 121
      ControlOptions.ShowBorder = False
      Index = 1
    end
    object dxLayoutItem3: TdxLayoutItem
      Parent = Tab0
      AlignHorz = ahClient
      AlignVert = avClient
      CaptionOptions.Text = 'Description'
      CaptionOptions.Layout = clTop
      Control = memoDescription
      ControlOptions.OriginalHeight = 89
      ControlOptions.OriginalWidth = 185
      ControlOptions.ShowBorder = False
      Index = 3
    end
    object dxLayoutItem1: TdxLayoutItem
      Parent = dxLayoutAutoCreatedGroup1
      AlignHorz = ahClient
      AlignVert = avTop
      CaptionOptions.Text = 'Caption'
      CaptionOptions.Layout = clTop
      Control = edPluginName
      ControlOptions.OriginalHeight = 21
      ControlOptions.OriginalWidth = 121
      ControlOptions.ShowBorder = False
      Index = 0
    end
    object dxLayoutAutoCreatedGroup1: TdxLayoutAutoCreatedGroup
      Parent = Tab0
      AlignVert = avTop
      LayoutDirection = ldHorizontal
      Index = 2
    end
    object item_DBName: TdxLayoutItem
      Parent = item_Providers
      CaptionOptions.Text = 'DBName'
      Control = cbPluginDBName
      ControlOptions.OriginalHeight = 21
      ControlOptions.OriginalWidth = 121
      ControlOptions.ShowBorder = False
      Index = 1
    end
    object Tab4: TdxLayoutGroup
      Parent = DialogLayoutGroup_Root
      CaptionOptions.Text = 'Side Tree'
      ItemIndex = 1
      Index = 4
    end
    object dxLayoutItem9: TdxLayoutItem
      Parent = Tab4
      CaptionOptions.Text = 'cxDBCheckBox1'
      CaptionOptions.Visible = False
      Control = cbSideTreeEnabled
      ControlOptions.OriginalHeight = 21
      ControlOptions.OriginalWidth = 101
      ControlOptions.ShowBorder = False
      Index = 0
    end
    object edTreeKeyField_Item: TdxLayoutItem
      Parent = Group_SideTree
      CaptionOptions.Text = 'Keyfield'
      Control = edTreeKeyField
      ControlOptions.OriginalHeight = 21
      ControlOptions.OriginalWidth = 121
      ControlOptions.ShowBorder = False
      Index = 1
    end
    object edTreeProviderName_Item: TdxLayoutItem
      Parent = Group_SideTree
      CaptionOptions.Text = 'Provider Name'
      Control = edTreeProviderName
      ControlOptions.OriginalHeight = 21
      ControlOptions.OriginalWidth = 121
      ControlOptions.ShowBorder = False
      Index = 3
    end
    object dxLayoutItem28: TdxLayoutItem
      Parent = Group_SideTree
      CaptionOptions.Text = 'Parameter Name'
      Control = edFilterParamName
      ControlOptions.OriginalHeight = 21
      ControlOptions.OriginalWidth = 121
      ControlOptions.ShowBorder = False
      Index = 5
    end
    object edTreeParentIdField_Item: TdxLayoutItem
      Parent = Group_SideTree
      CaptionOptions.Text = 'ParentId Field'
      Control = edTreeParentIdField
      ControlOptions.OriginalHeight = 21
      ControlOptions.OriginalWidth = 121
      ControlOptions.ShowBorder = False
      Index = 2
    end
    object dxLayoutItem13: TdxLayoutItem
      Parent = Tab3
      AlignVert = avClient
      Control = ColorsEditor
      ControlOptions.AutoColor = True
      ControlOptions.OriginalHeight = 287
      ControlOptions.OriginalWidth = 549
      ControlOptions.ShowBorder = False
      Index = 1
    end
    object item_SideTreeExpandLevel: TdxLayoutItem
      Parent = Group_SideTree
      AlignHorz = ahLeft
      CaptionOptions.Text = 'Expand Level'
      Control = spinSideTreeExpandLevel
      ControlOptions.OriginalHeight = 21
      ControlOptions.OriginalWidth = 48
      ControlOptions.ShowBorder = False
      Index = 0
    end
    object dxLayoutGroup6: TdxLayoutGroup
      Parent = Tab0
      CaptionOptions.Text = 'Command'
      Index = 4
    end
    object dxLayoutItem27: TdxLayoutItem
      Parent = dxLayoutGroup6
      CaptionOptions.Text = 'Double Click Command'
      Control = bnDefAppCmdId
      ControlOptions.OriginalHeight = 21
      ControlOptions.OriginalWidth = 121
      ControlOptions.ShowBorder = False
      Index = 0
    end
    object dxLayoutItem5: TdxLayoutItem
      Parent = dxLayoutGroup4
      CaptionOptions.Text = 'Custom Dialog'
      Control = edCustomDialogId
      ControlOptions.OriginalHeight = 21
      ControlOptions.OriginalWidth = 121
      ControlOptions.ShowBorder = False
      Index = 0
    end
    object item_SideTreeAppPluginsId: TdxLayoutItem
      Parent = Group_SideTree
      CaptionOptions.Text = 'AppPlugins Field'
      Control = edAppPluginsIdPage
      ControlOptions.OriginalHeight = 21
      ControlOptions.OriginalWidth = 121
      ControlOptions.ShowBorder = False
      Index = 6
    end
    object item_SideTreeCaptionField: TdxLayoutItem
      Parent = Group_SideTree
      CaptionOptions.Text = 'Caption Field'
      Control = edSideTreeCaptionField
      ControlOptions.OriginalHeight = 21
      ControlOptions.OriginalWidth = 121
      ControlOptions.ShowBorder = False
      Index = 4
    end
    object dxLayoutItem29: TdxLayoutItem
      Parent = item_Providers
      CaptionOptions.Text = 'cxDBCheckBox1'
      CaptionOptions.Visible = False
      Control = cbRefreshAfterCreate
      ControlOptions.OriginalHeight = 21
      ControlOptions.OriginalWidth = 101
      ControlOptions.ShowBorder = False
      Index = 0
    end
    object dxLayoutItem30: TdxLayoutItem
      Parent = dxLayoutGroup4
      CaptionOptions.Text = 'Custom AppLayoutsId Field'
      Control = edCustomLayoutsIdField
      ControlOptions.OriginalHeight = 21
      ControlOptions.OriginalWidth = 121
      ControlOptions.ShowBorder = False
      Index = 2
    end
    object Group_SideTree: TdxLayoutGroup
      Parent = Tab4
      CaptionOptions.Text = 'New Group'
      CaptionOptions.Visible = False
      Index = 1
    end
    object Tab5: TdxLayoutGroup
      Parent = DialogLayoutGroup_Root
      CaptionOptions.Text = 'Script'
      Index = 5
    end
    object item_bnEditScript: TdxLayoutItem
      Parent = Tab5
      AlignHorz = ahLeft
      CaptionOptions.Text = 'Edit'
      CaptionOptions.Visible = False
      Control = bnEditScript
      ControlOptions.OriginalHeight = 25
      ControlOptions.OriginalWidth = 75
      ControlOptions.ShowBorder = False
      Index = 0
    end
    object item_eddfClassesId: TdxLayoutItem
      Parent = dxLayoutGroup1
      CaptionOptions.Text = 'dfClassesId'
      Control = eddfClassesId
      ControlOptions.OriginalHeight = 21
      ControlOptions.OriginalWidth = 121
      ControlOptions.ShowBorder = False
      Index = 1
    end
    object dxLayoutAutoCreatedGroup4: TdxLayoutAutoCreatedGroup
      Parent = dxLayoutGroup1
      LayoutDirection = ldHorizontal
      Index = 0
    end
  end
  inherited MainSource: TDataSource
    Left = 240
    Top = 537
  end
  inherited PopupMenu: TPopupMenu
    inherited miCopyFrom: TMenuItem
      Enabled = True
      OnClick = miCopyFromClick
    end
  end
  object dsDialogs: TDataSource
    Left = 296
    Top = 537
  end
end
