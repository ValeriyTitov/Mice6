inherited PathFolderRuleDialog: TPathFolderRuleDialog
  Caption = 'Rule'
  ClientHeight = 604
  ClientWidth = 581
  ExplicitWidth = 597
  ExplicitHeight = 642
  PixelsPerInch = 96
  TextHeight = 13
  inherited pnBottomButtons: TPanel
    Top = 563
    Width = 581
    ExplicitTop = 563
    ExplicitWidth = 581
    inherited bnOK: TcxButton
      Left = 411
      ExplicitLeft = 411
    end
    inherited bnCancel: TcxButton
      Left = 492
      ExplicitLeft = 492
    end
  end
  object DialogLayout: TdxLayoutControl
    Left = 0
    Top = 0
    Width = 581
    Height = 563
    Align = alClient
    TabOrder = 1
    LayoutLookAndFeel = DefaultLookAndFeel.ManagerDialog
    OptionsImage.Images = ImageContainer.Images16
    object cbActive: TDBCheckBox
      Left = 6
      Top = 6
      Width = 569
      Height = 17
      Caption = 'Active'
      DataField = 'Active'
      DataSource = DataSource1
      TabOrder = 0
      OnClick = cbActiveClick
    end
    object edCaption: TcxDBTextEdit
      Left = 93
      Top = 127
      DataBinding.DataField = 'Caption'
      DataBinding.DataSource = DataSource1
      Style.BorderColor = clWindowFrame
      Style.BorderStyle = ebs3D
      Style.HotTrack = False
      TabOrder = 2
      Width = 467
    end
    object edExpression: TcxDBTextEdit
      Left = 93
      Top = 154
      DataBinding.DataField = 'Expression'
      DataBinding.DataSource = DataSource1
      Properties.OnChange = edExpressionPropertiesChange
      Style.BorderColor = clWindowFrame
      Style.BorderStyle = ebs3D
      Style.HotTrack = False
      TabOrder = 3
      Width = 467
    end
    object memoUserMessage: TcxDBMemo
      Left = 93
      Top = 181
      DataBinding.DataField = 'UserMessage'
      DataBinding.DataSource = DataSource1
      Properties.OnChange = edExpressionPropertiesChange
      Style.BorderColor = clWindowFrame
      Style.BorderStyle = ebs3D
      Style.HotTrack = False
      TabOrder = 4
      Height = 89
      Width = 467
    end
    object cbVisibleToUser: TDBCheckBox
      Left = 21
      Top = 104
      Width = 539
      Height = 17
      Hint = 'This rule is visible to users in Workflow window'
      Caption = 'Visible To User'
      DataField = 'VisibleToUser'
      DataSource = DataSource1
      TabOrder = 1
    end
    object MemoSqlExample: TDBMemo
      Left = 23
      Top = 296
      Width = 535
      Height = 244
      DataField = 'SQLStr'
      DataSource = dsExample
      TabOrder = 5
    end
    object Image1: TImage
      Left = 6
      Top = 29
      Width = 32
      Height = 32
    end
    object Label1: TLabel
      Left = 44
      Top = 29
      Width = 531
      Height = 32
      Caption = 'Incoming rule'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -16
      Font.Name = 'Tahoma'
      Font.Style = [fsBold]
      ParentFont = False
    end
    object DialogLayoutGroup_Root: TdxLayoutGroup
      AlignHorz = ahClient
      AlignVert = avClient
      LayoutLookAndFeel = DefaultLookAndFeel.ManagerDialog
      AllowRemove = False
      ButtonOptions.Buttons = <>
      Hidden = True
      ItemIndex = 1
      ShowBorder = False
      Index = -1
    end
    object item_Active: TdxLayoutItem
      Parent = DialogLayoutGroup_Root
      CaptionOptions.Text = 'DBCheckBox1'
      CaptionOptions.Visible = False
      Control = cbActive
      ControlOptions.AutoColor = True
      ControlOptions.OriginalHeight = 17
      ControlOptions.OriginalWidth = 97
      ControlOptions.ShowBorder = False
      Index = 0
    end
    object gpMain: TdxLayoutGroup
      Parent = Group_All
      AlignVert = avClient
      CaptionOptions.Text = 'Properties'
      ButtonOptions.Buttons = <>
      ItemIndex = 4
      Index = 2
    end
    object item_UserCaption: TdxLayoutItem
      Parent = gpMain
      CaptionOptions.Text = 'Caption'
      Control = edCaption
      ControlOptions.OriginalHeight = 21
      ControlOptions.OriginalWidth = 121
      ControlOptions.ShowBorder = False
      Index = 1
    end
    object item_Expression: TdxLayoutItem
      Parent = gpMain
      CaptionOptions.Text = 'Expression'
      Control = edExpression
      ControlOptions.OriginalHeight = 21
      ControlOptions.OriginalWidth = 121
      ControlOptions.ShowBorder = False
      Index = 2
    end
    object item_Message: TdxLayoutItem
      Parent = gpMain
      CaptionOptions.Text = 'User Message'
      Control = memoUserMessage
      ControlOptions.OriginalHeight = 89
      ControlOptions.OriginalWidth = 185
      ControlOptions.ShowBorder = False
      Index = 3
    end
    object item_VisibleToUser: TdxLayoutItem
      Parent = gpMain
      CaptionOptions.Visible = False
      Control = cbVisibleToUser
      ControlOptions.AutoColor = True
      ControlOptions.OriginalHeight = 17
      ControlOptions.OriginalWidth = 97
      ControlOptions.ShowBorder = False
      Index = 0
    end
    object item_Example: TdxLayoutItem
      Parent = Group_Eample
      AlignVert = avClient
      CaptionOptions.Text = 'Example'
      CaptionOptions.Layout = clTop
      Control = MemoSqlExample
      ControlOptions.OriginalHeight = 83
      ControlOptions.OriginalWidth = 499
      Index = 0
    end
    object Group_Eample: TdxLayoutGroup
      Parent = gpMain
      AlignVert = avClient
      CaptionOptions.Text = 'Example'
      CaptionOptions.Visible = False
      ButtonOptions.Buttons = <>
      ShowBorder = False
      Index = 4
    end
    object dxLayoutEmptySpaceItem1: TdxLayoutEmptySpaceItem
      Parent = Group_All
      CaptionOptions.Text = 'Empty Space Item'
      SizeOptions.Height = 10
      SizeOptions.Width = 10
      Index = 1
    end
    object dxLayoutItem1: TdxLayoutItem
      Parent = dxLayoutAutoCreatedGroup1
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
    object dxLayoutItem2: TdxLayoutItem
      Parent = dxLayoutAutoCreatedGroup1
      AlignHorz = ahClient
      AlignVert = avClient
      CaptionOptions.Text = 'Label1'
      CaptionOptions.Visible = False
      Control = Label1
      ControlOptions.AutoColor = True
      ControlOptions.OriginalHeight = 13
      ControlOptions.OriginalWidth = 31
      ControlOptions.ShowBorder = False
      Index = 1
    end
    object dxLayoutAutoCreatedGroup1: TdxLayoutAutoCreatedGroup
      Parent = Group_All
      LayoutDirection = ldHorizontal
      Index = 0
    end
    object Group_All: TdxLayoutGroup
      Parent = DialogLayoutGroup_Root
      AlignVert = avClient
      CaptionOptions.Text = 'New Group'
      CaptionOptions.Visible = False
      ButtonOptions.Buttons = <>
      ShowBorder = False
      Index = 1
    end
  end
  object DataSource1: TDataSource
    Left = 24
    Top = 440
  end
  object dsExample: TDataSource
    DataSet = dxMemData1
    Left = 288
    Top = 416
  end
  object dxMemData1: TdxMemData
    Indexes = <>
    SortOptions = []
    Left = 352
    Top = 416
    object dxMemData1SQLStr: TStringField
      FieldName = 'SQLStr'
      Size = 1024
    end
  end
end
