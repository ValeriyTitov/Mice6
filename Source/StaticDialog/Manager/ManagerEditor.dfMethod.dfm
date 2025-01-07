inherited ManagerEditorDfMethod: TManagerEditorDfMethod
  Caption = 'Edit Method'
  ClientHeight = 632
  ClientWidth = 669
  ExplicitWidth = 685
  ExplicitHeight = 670
  PixelsPerInch = 96
  TextHeight = 13
  inherited pnBottomButtons: TPanel
    Top = 591
    Width = 669
    ExplicitTop = 591
    ExplicitWidth = 669
    inherited bnOK: TcxButton
      Left = 501
      OnClick = nil
      ExplicitLeft = 501
    end
    inherited bnCancel: TcxButton
      Left = 582
      ExplicitLeft = 582
    end
  end
  inherited DialogLayout: TdxLayoutControl
    Width = 669
    Height = 591
    ExplicitWidth = 669
    ExplicitHeight = 591
    object edCaption: TcxDBTextEdit [0]
      Left = 80
      Top = 125
      AutoSize = False
      DataBinding.DataField = 'Caption'
      DataBinding.DataSource = MainSource
      Style.BorderColor = clWindowFrame
      Style.BorderStyle = ebs3D
      Style.HotTrack = False
      TabOrder = 1
      Height = 21
      Width = 388
    end
    object cbActive: TDBCheckBox [1]
      Left = 6
      Top = 6
      Width = 97
      Height = 17
      Caption = 'Active'
      DataField = 'Active'
      DataSource = MainSource
      TabOrder = 0
      OnClick = cbActiveClick
    end
    object Image1: TImage [2]
      Left = 6
      Top = 29
      Width = 32
      Height = 32
    end
    object Label1: TLabel [3]
      Left = 44
      Top = 29
      Width = 121
      Height = 32
      Caption = 'Method properties'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -13
      Font.Name = 'Tahoma'
      Font.Style = [fsBold]
      ParentFont = False
    end
    object cbAllowRollBack: TDBCheckBox [4]
      Left = 38
      Top = 152
      Width = 430
      Height = 17
      Caption = 'Allow Rollback'
      DataField = 'AllowRollback'
      DataSource = MainSource
      TabOrder = 2
    end
    object cbDefaultRoute: TDBCheckBox [5]
      Left = 38
      Top = 175
      Width = 430
      Height = 17
      Caption = 'Default Route'
      DataField = 'IsDefault'
      DataSource = MainSource
      TabOrder = 3
    end
    object ddCodeName: TcxDBComboBox [6]
      Left = 531
      Top = 125
      DataBinding.DataField = 'CodeName'
      DataBinding.DataSource = MainSource
      Style.BorderColor = clWindowFrame
      Style.BorderStyle = ebs3D
      Style.HotTrack = False
      Style.ButtonStyle = bts3D
      Style.PopupBorderStyle = epbsFrame3D
      TabOrder = 5
      Width = 100
    end
    object bnImageIndex: TcxButton [7]
      Left = 571
      Top = 236
      Width = 75
      Height = 25
      Caption = 'Image'
      OptionsImage.Images = ImageContainer.Images16
      TabOrder = 6
      OnClick = bnImageIndexClick
    end
    object cbAllowFromDesktop: TDBCheckBox [8]
      Left = 38
      Top = 198
      Width = 430
      Height = 17
      Caption = 'Allow From Desktop'
      DataField = 'AllowDesktop'
      DataSource = MainSource
      TabOrder = 4
    end
    object InfoMemo: TcxDBMemo [9]
      Left = 10000
      Top = 10000
      DataBinding.DataField = 'Info'
      DataBinding.DataSource = MainSource
      Style.BorderColor = clWindowFrame
      Style.BorderStyle = ebs3D
      Style.HotTrack = False
      TabOrder = 11
      Visible = False
      Height = 464
      Width = 623
    end
    inline PermissionsFrame1: TPermissionsFrame [10]
      Left = 10000
      Top = 10000
      Width = 464
      Height = 464
      TabOrder = 10
      Visible = False
      ExplicitLeft = 10000
      ExplicitTop = 10000
      ExplicitHeight = 464
    end
    object cbUseExpression: TDBCheckBox
      Left = 10000
      Top = 10000
      Width = 623
      Height = 17
      Caption = 'Use Expression'
      DataField = 'UseExpression'
      DataSource = MainSource
      TabOrder = 7
      Visible = False
      OnClick = cbUseExpressionClick
    end
    object edUserMessage: TcxDBTextEdit
      Left = 10000
      Top = 10000
      DataBinding.DataField = 'UserMessage'
      DataBinding.DataSource = MainSource
      Style.BorderColor = clWindowFrame
      Style.BorderStyle = ebs3D
      Style.HotTrack = False
      TabOrder = 8
      Visible = False
      Width = 551
    end
    object memo_Expression: TDBMemo
      Left = 10000
      Top = 10000
      Width = 619
      Height = 392
      BevelInner = bvNone
      BevelOuter = bvSpace
      BevelKind = bkFlat
      BorderStyle = bsNone
      DataField = 'Expression'
      DataSource = MainSource
      TabOrder = 9
      Visible = False
    end
    inherited DialogLayoutGroup_Root: TdxLayoutGroup
      ItemIndex = 2
      LayoutDirection = ldVertical
    end
    object Tab0: TdxLayoutGroup
      Parent = Group_All
      CaptionOptions.Text = 'General'
      ButtonOptions.Buttons = <>
      Index = 0
    end
    object Tab1: TdxLayoutGroup
      Parent = Group_All
      CaptionOptions.Text = 'Rules'
      ButtonOptions.Buttons = <>
      Index = 1
    end
    object Tab2: TdxLayoutGroup
      Parent = Group_All
      CaptionOptions.Text = 'Permissions'
      ButtonOptions.Buttons = <>
      Index = 2
    end
    object Tab3: TdxLayoutGroup
      Parent = Group_All
      CaptionOptions.Text = 'User Information'
      ButtonOptions.Buttons = <>
      Index = 3
    end
    object item_edCaption: TdxLayoutItem
      Parent = dxLayoutAutoCreatedGroup2
      AlignHorz = ahClient
      AlignVert = avClient
      CaptionOptions.Text = 'Caption'
      Control = edCaption
      ControlOptions.OriginalHeight = 21
      ControlOptions.OriginalWidth = 121
      ControlOptions.ShowBorder = False
      Index = 0
    end
    object dxLayoutItem1: TdxLayoutItem
      Parent = DialogLayoutGroup_Root
      AlignHorz = ahLeft
      CaptionOptions.Text = 'DBCheckBox1'
      CaptionOptions.Visible = False
      Control = cbActive
      ControlOptions.AutoColor = True
      ControlOptions.OriginalHeight = 17
      ControlOptions.OriginalWidth = 97
      ControlOptions.ShowBorder = False
      Index = 0
    end
    object dxLayoutItem2: TdxLayoutItem
      Parent = dxLayoutAutoCreatedGroup1
      AlignHorz = ahLeft
      CaptionOptions.Visible = False
      Control = Image1
      ControlOptions.OriginalHeight = 32
      ControlOptions.OriginalWidth = 32
      ControlOptions.ShowBorder = False
      Index = 0
    end
    object dxLayoutItem3: TdxLayoutItem
      Parent = dxLayoutAutoCreatedGroup1
      AlignVert = avClient
      CaptionOptions.Text = 'Method properties'
      CaptionOptions.Visible = False
      Control = Label1
      ControlOptions.AutoColor = True
      ControlOptions.OriginalHeight = 13
      ControlOptions.OriginalWidth = 121
      ControlOptions.ShowBorder = False
      Index = 1
    end
    object CommonGroup: TdxLayoutGroup
      Parent = Tab0
      AlignHorz = ahClient
      AlignVert = avTop
      CaptionOptions.Text = 'Common'
      ButtonOptions.Buttons = <>
      ItemIndex = 1
      LayoutDirection = ldHorizontal
      Index = 0
    end
    object item_cbAllowRollBack: TdxLayoutItem
      Parent = dxLayoutAutoCreatedGroup2
      CaptionOptions.Text = 'cbAllowRollBack'
      CaptionOptions.Visible = False
      Control = cbAllowRollBack
      ControlOptions.AutoColor = True
      ControlOptions.OriginalHeight = 17
      ControlOptions.OriginalWidth = 97
      ControlOptions.ShowBorder = False
      Index = 1
    end
    object item_cbDefaultRoute: TdxLayoutItem
      Parent = dxLayoutAutoCreatedGroup2
      CaptionOptions.Text = 'cbDefaultRoute'
      CaptionOptions.Visible = False
      Control = cbDefaultRoute
      ControlOptions.AutoColor = True
      ControlOptions.OriginalHeight = 17
      ControlOptions.OriginalWidth = 97
      ControlOptions.ShowBorder = False
      Index = 2
    end
    object item_ddCodeName: TdxLayoutItem
      Parent = CommonGroup
      AlignHorz = ahLeft
      AlignVert = avTop
      CaptionOptions.Text = 'CodeName'
      Control = ddCodeName
      ControlOptions.OriginalHeight = 21
      ControlOptions.OriginalWidth = 100
      ControlOptions.ShowBorder = False
      Index = 1
    end
    object dxLayoutItem6: TdxLayoutItem
      Parent = Tab0
      AlignHorz = ahRight
      CaptionOptions.Text = 'cxButton1'
      CaptionOptions.Visible = False
      Control = bnImageIndex
      ControlOptions.OriginalHeight = 25
      ControlOptions.OriginalWidth = 75
      ControlOptions.ShowBorder = False
      Index = 1
    end
    object item_cbAllowFromDesktop: TdxLayoutItem
      Parent = dxLayoutAutoCreatedGroup2
      CaptionOptions.Text = 'cbAllowFromDesktop'
      CaptionOptions.Visible = False
      Control = cbAllowFromDesktop
      ControlOptions.AutoColor = True
      ControlOptions.OriginalHeight = 17
      ControlOptions.OriginalWidth = 97
      ControlOptions.ShowBorder = False
      Index = 3
    end
    object dxLayoutAutoCreatedGroup2: TdxLayoutAutoCreatedGroup
      Parent = CommonGroup
      AlignHorz = ahClient
      Index = 0
    end
    object item_InfoMemo: TdxLayoutItem
      Parent = Tab3
      AlignVert = avClient
      CaptionOptions.Visible = False
      Control = InfoMemo
      ControlOptions.OriginalHeight = 89
      ControlOptions.OriginalWidth = 185
      ControlOptions.ShowBorder = False
      Index = 0
    end
    object Group_All: TdxLayoutGroup
      Parent = DialogLayoutGroup_Root
      AlignVert = avClient
      CaptionOptions.Text = 'New Group'
      CaptionOptions.Visible = False
      ButtonOptions.Buttons = <>
      LayoutDirection = ldTabbed
      ShowBorder = False
      Index = 2
    end
    object item_PermissionsFrame: TdxLayoutItem
      Parent = Tab2
      AlignHorz = ahLeft
      AlignVert = avClient
      Control = PermissionsFrame1
      ControlOptions.AutoColor = True
      ControlOptions.OriginalHeight = 445
      ControlOptions.OriginalWidth = 464
      ControlOptions.ShowBorder = False
      Index = 0
    end
    object item_cbUseExpression: TdxLayoutItem
      Parent = Tab1
      CaptionOptions.Visible = False
      Control = cbUseExpression
      ControlOptions.AutoColor = True
      ControlOptions.OriginalHeight = 17
      ControlOptions.OriginalWidth = 97
      ControlOptions.ShowBorder = False
      Index = 0
    end
    object item_UserMessage: TdxLayoutItem
      Parent = Group_Expression
      CaptionOptions.Text = 'User Message'
      Control = edUserMessage
      ControlOptions.OriginalHeight = 21
      ControlOptions.OriginalWidth = 121
      ControlOptions.ShowBorder = False
      Index = 0
    end
    object item_memoExpression: TdxLayoutItem
      Parent = Group_Expression
      AlignVert = avClient
      CaptionOptions.Text = 'Expression'
      CaptionOptions.Layout = clTop
      Control = memo_Expression
      ControlOptions.OriginalHeight = 85
      ControlOptions.OriginalWidth = 185
      Index = 1
    end
    object Group_Expression: TdxLayoutGroup
      Parent = Tab1
      AlignVert = avClient
      CaptionOptions.Text = 'New Group'
      CaptionOptions.Visible = False
      ButtonOptions.Buttons = <>
      ItemIndex = 1
      ShowBorder = False
      Index = 1
    end
    object dxLayoutAutoCreatedGroup1: TdxLayoutAutoCreatedGroup
      Parent = DialogLayoutGroup_Root
      LayoutDirection = ldHorizontal
      Index = 1
    end
  end
end
