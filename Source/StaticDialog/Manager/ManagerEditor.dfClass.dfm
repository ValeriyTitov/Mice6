inherited ManagerEditorDfClass: TManagerEditorDfClass
  Caption = 'Edit Doc Flow Class'
  ClientHeight = 461
  ClientWidth = 434
  Constraints.MinHeight = 500
  Constraints.MinWidth = 450
  ExplicitWidth = 450
  ExplicitHeight = 500
  TextHeight = 13
  inherited pnBottomButtons: TPanel
    Top = 420
    Width = 434
    ExplicitTop = 420
    ExplicitWidth = 434
    inherited bnOK: TcxButton
      Left = 266
      ExplicitLeft = 266
    end
    inherited bnCancel: TcxButton
      Left = 347
      ExplicitLeft = 347
    end
  end
  inherited DialogLayout: TdxLayoutControl
    Width = 434
    Height = 420
    ExplicitWidth = 434
    ExplicitHeight = 420
    object Image1: TImage [0]
      Left = 21
      Top = 27
      Width = 32
      Height = 32
    end
    object eddfClassesId: TcxDBTextEdit [1]
      Left = 103
      Top = 101
      DataBinding.DataField = 'dfClassesId'
      DataBinding.DataSource = MainSource
      Enabled = False
      Style.BorderColor = clWindowFrame
      Style.BorderStyle = ebsFlat
      Style.HotTrack = False
      TabOrder = 0
      Width = 121
    end
    object edCaption: TcxDBTextEdit [2]
      Left = 103
      Top = 128
      DataBinding.DataField = 'Caption'
      DataBinding.DataSource = MainSource
      Style.BorderColor = clWindowFrame
      Style.BorderStyle = ebsFlat
      Style.HotTrack = False
      TabOrder = 1
      Width = 310
    end
    object edAppDialogsId: TcxDBButtonEdit [3]
      Left = 103
      Top = 155
      DataBinding.DataField = 'AppDialogsId'
      DataBinding.DataSource = MainSource
      Properties.Buttons = <
        item
          Default = True
          Kind = bkEllipsis
        end>
      Properties.OnButtonClick = edAppDialogsIdPropertiesButtonClick
      Style.BorderColor = clWindowFrame
      Style.BorderStyle = ebsFlat
      Style.HotTrack = False
      Style.ButtonStyle = btsFlat
      TabOrder = 2
      Width = 310
    end
    object edMainDataTable: TcxDBButtonEdit [4]
      Left = 103
      Top = 268
      DataBinding.DataField = 'MainTable'
      DataBinding.DataSource = MainSource
      Properties.Buttons = <
        item
          Default = True
          Kind = bkEllipsis
        end>
      Properties.OnButtonClick = edMainDataTablePropertiesButtonClick
      Style.BorderColor = clWindowFrame
      Style.BorderStyle = ebsFlat
      Style.HotTrack = False
      Style.ButtonStyle = btsFlat
      TabOrder = 5
      OnExit = edMainDataTableExit
      Width = 310
    end
    object edDataView: TcxDBButtonEdit [5]
      Left = 103
      Top = 295
      DataBinding.DataField = 'DataView'
      DataBinding.DataSource = MainSource
      Properties.Buttons = <
        item
          Default = True
          Kind = bkEllipsis
        end>
      Properties.OnButtonClick = edDataViewPropertiesButtonClick
      Style.BorderColor = clWindowFrame
      Style.BorderStyle = ebsFlat
      Style.HotTrack = False
      Style.ButtonStyle = btsFlat
      TabOrder = 6
      Width = 310
    end
    object Label1: TLabel [6]
      Left = 59
      Top = 27
      Width = 354
      Height = 32
      Caption = 'Doc Flow Class properties'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -13
      Font.Name = 'Tahoma'
      Font.Style = [fsBold]
      ParentFont = False
    end
    object edKeyField: TcxDBTextEdit [7]
      Left = 103
      Top = 241
      DataBinding.DataField = 'KeyField'
      DataBinding.DataSource = MainSource
      Style.BorderColor = clWindowFrame
      Style.BorderStyle = ebsFlat
      Style.HotTrack = False
      TabOrder = 4
      Width = 310
    end
    object chboxEnableEventSystem: TDBCheckBox [8]
      Left = 21
      Top = 182
      Width = 392
      Height = 17
      Caption = 'Enable dfEvent System'
      DataField = 'EnableDfEvents'
      DataSource = MainSource
      TabOrder = 3
    end
    object edRoutingKey: TcxDBTextEdit [9]
      Left = 103
      Top = 376
      DataBinding.DataField = 'RoutingKey'
      DataBinding.DataSource = MainSource
      Style.BorderColor = clWindowFrame
      Style.BorderStyle = ebsFlat
      Style.HotTrack = False
      TabOrder = 9
      Width = 310
    end
    object edProgressProviderName: TcxDBButtonEdit [10]
      Left = 103
      Top = 322
      Hint = 'Accepts columns from DataView as parameters, also @dfMethodsId'
      DataBinding.DataField = 'LogProviderName'
      DataBinding.DataSource = MainSource
      Properties.Buttons = <
        item
          Default = True
          Kind = bkEllipsis
        end>
      Properties.OnButtonClick = edProgressProviderNamePropertiesButtonClick
      Style.BorderColor = clWindowFrame
      Style.BorderStyle = ebsFlat
      Style.HotTrack = False
      Style.TransparentBorder = False
      Style.ButtonStyle = btsFlat
      TabOrder = 7
      Width = 310
    end
    object edHistoryProviderName: TcxDBButtonEdit [11]
      Left = 103
      Top = 349
      Hint = 
        'Should accept @DocumentsId parameter; Optional - @dfTypesId, dfP' +
        'athFoldersId'
      DataBinding.DataField = 'HistoryProviderName'
      DataBinding.DataSource = MainSource
      Properties.Buttons = <
        item
          Default = True
          Kind = bkEllipsis
        end>
      Properties.OnButtonClick = edHistoryProviderNamePropertiesButtonClick
      Style.BorderColor = clWindowFrame
      Style.BorderStyle = ebsFlat
      Style.HotTrack = False
      Style.TransparentBorder = False
      Style.ButtonStyle = btsFlat
      TabOrder = 8
      Width = 310
    end
    inherited DialogLayoutGroup_Root: TdxLayoutGroup
      ItemIndex = 2
      LayoutDirection = ldVertical
    end
    object item_Image: TdxLayoutItem
      Parent = dxLayoutGroup1
      AlignHorz = ahLeft
      AlignVert = avTop
      CaptionOptions.Text = 'Image1'
      CaptionOptions.Visible = False
      Control = Image1
      ControlOptions.OriginalHeight = 32
      ControlOptions.OriginalWidth = 32
      ControlOptions.ShowBorder = False
      Index = 0
    end
    object dxLayoutGroup1: TdxLayoutGroup
      Parent = DialogLayoutGroup_Root
      CaptionOptions.Text = 'Propties'
      ItemIndex = 1
      LayoutDirection = ldHorizontal
      Index = 0
    end
    object dxLayoutGroup2: TdxLayoutGroup
      Parent = DialogLayoutGroup_Root
      AlignVert = avTop
      CaptionOptions.Text = 'Common'
      Index = 1
    end
    object item_eddfClassesId: TdxLayoutItem
      Parent = dxLayoutGroup2
      AlignHorz = ahLeft
      CaptionOptions.Text = 'dfClassesId'
      Control = eddfClassesId
      ControlOptions.OriginalHeight = 21
      ControlOptions.OriginalWidth = 121
      ControlOptions.ShowBorder = False
      Enabled = False
      Index = 0
    end
    object dxLayoutGroup3: TdxLayoutGroup
      Parent = DialogLayoutGroup_Root
      AlignVert = avClient
      CaptionOptions.Text = 'Data'
      Index = 2
    end
    object item_edCaption: TdxLayoutItem
      Parent = dxLayoutGroup2
      CaptionOptions.Text = 'Caption'
      Control = edCaption
      ControlOptions.OriginalHeight = 21
      ControlOptions.OriginalWidth = 121
      ControlOptions.ShowBorder = False
      Index = 1
    end
    object item_edAppDialogsId: TdxLayoutItem
      Parent = dxLayoutGroup2
      CaptionOptions.Text = 'Dialog'
      Control = edAppDialogsId
      ControlOptions.OriginalHeight = 21
      ControlOptions.OriginalWidth = 272
      ControlOptions.ShowBorder = False
      Index = 2
    end
    object item_edMainDataTable: TdxLayoutItem
      Parent = dxLayoutGroup3
      CaptionOptions.Text = 'Main Data Table'
      Control = edMainDataTable
      ControlOptions.OriginalHeight = 21
      ControlOptions.OriginalWidth = 392
      ControlOptions.ShowBorder = False
      Index = 1
    end
    object item_edDataView: TdxLayoutItem
      Parent = dxLayoutGroup3
      CaptionOptions.Text = 'Data view'
      Control = edDataView
      ControlOptions.OriginalHeight = 21
      ControlOptions.OriginalWidth = 392
      ControlOptions.ShowBorder = False
      Index = 2
    end
    object dxLayoutItem1: TdxLayoutItem
      Parent = dxLayoutGroup1
      AlignHorz = ahClient
      AlignVert = avClient
      CaptionOptions.Visible = False
      Control = Label1
      ControlOptions.AutoColor = True
      ControlOptions.OriginalHeight = 13
      ControlOptions.OriginalWidth = 31
      ControlOptions.ShowBorder = False
      Index = 1
    end
    object item_KeyField: TdxLayoutItem
      Parent = dxLayoutGroup3
      CaptionOptions.Text = 'Key Field'
      Control = edKeyField
      ControlOptions.OriginalHeight = 21
      ControlOptions.OriginalWidth = 121
      ControlOptions.ShowBorder = False
      Index = 0
    end
    object dxLayoutItem2: TdxLayoutItem
      Parent = dxLayoutGroup2
      CaptionOptions.Text = 'DBCheckBox1'
      CaptionOptions.Visible = False
      Control = chboxEnableEventSystem
      ControlOptions.AutoColor = True
      ControlOptions.OriginalHeight = 17
      ControlOptions.OriginalWidth = 97
      ControlOptions.ShowBorder = False
      Index = 3
    end
    object item_edRoutingKey: TdxLayoutItem
      Parent = dxLayoutGroup3
      CaptionOptions.Text = 'Routing Key'
      Control = edRoutingKey
      ControlOptions.OriginalHeight = 21
      ControlOptions.OriginalWidth = 121
      ControlOptions.ShowBorder = False
      Index = 5
    end
    object item_edProgressProviderName: TdxLayoutItem
      Parent = dxLayoutGroup3
      CaptionOptions.Text = 'Log Provider'
      Control = edProgressProviderName
      ControlOptions.OriginalHeight = 21
      ControlOptions.OriginalWidth = 121
      ControlOptions.ShowBorder = False
      Index = 3
    end
    object item_edHistoryProviderName: TdxLayoutItem
      Parent = dxLayoutGroup3
      CaptionOptions.Text = 'History Provider'
      Control = edHistoryProviderName
      ControlOptions.OriginalHeight = 21
      ControlOptions.OriginalWidth = 121
      ControlOptions.ShowBorder = False
      Index = 4
    end
  end
end
