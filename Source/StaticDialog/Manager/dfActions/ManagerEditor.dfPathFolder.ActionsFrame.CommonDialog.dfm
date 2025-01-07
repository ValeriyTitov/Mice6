inherited CommonDfActionsDialog: TCommonDfActionsDialog
  Caption = 'Common Actions Dialog'
  ClientHeight = 686
  ClientWidth = 695
  ExplicitWidth = 711
  ExplicitHeight = 724
  PixelsPerInch = 96
  TextHeight = 13
  inherited pnBottomButtons: TPanel
    Top = 645
    Width = 695
    ExplicitTop = 645
    ExplicitWidth = 695
    DesignSize = (
      695
      41)
    inherited bnOK: TcxButton
      Left = 527
      OnClick = nil
      ExplicitLeft = 527
    end
    inherited bnCancel: TcxButton
      Left = 608
      ExplicitLeft = 608
    end
  end
  inherited DialogLayout: TdxLayoutControl
    Width = 695
    Height = 645
    ExplicitWidth = 695
    ExplicitHeight = 645
    object cbActive: TDBCheckBox [0]
      Left = 6
      Top = 6
      Width = 683
      Height = 17
      Caption = 'Active'
      DataField = 'Active'
      DataSource = MainSource
      TabOrder = 0
      OnClick = cbActiveClick
    end
    object edOrderId: TcxDBTextEdit [1]
      Left = 445
      Top = 131
      AutoSize = False
      DataBinding.DataField = 'OrderId'
      DataBinding.DataSource = MainSource
      Properties.Alignment.Horz = taRightJustify
      Style.BorderColor = clWindowFrame
      Style.BorderStyle = ebs3D
      Style.HotTrack = False
      TabOrder = 3
      Height = 21
      Width = 121
    end
    object edCaption: TcxDBTextEdit [2]
      Left = 96
      Top = 104
      DataBinding.DataField = 'Caption'
      DataBinding.DataSource = MainSource
      Style.BorderColor = clWindowFrame
      Style.BorderStyle = ebs3D
      Style.HotTrack = False
      TabOrder = 1
      Width = 576
    end
    object cbRequiresTransaction: TDBCheckBox [3]
      Left = 10000
      Top = 10000
      Width = 97
      Height = 17
      Caption = 'Requires Transaction'
      DataField = 'RequiresTransaction'
      DataSource = MainSource
      TabOrder = 10
      Visible = False
    end
    object cbRunSynchro: TDBCheckBox [4]
      Left = 10000
      Top = 10000
      Width = 97
      Height = 17
      Caption = 'Run Synchronously'
      DataField = 'RunSynchro'
      DataSource = MainSource
      TabOrder = 14
      Visible = False
    end
    object cbUseExpression: TDBCheckBox [5]
      Left = 23
      Top = 185
      Width = 97
      Height = 17
      Caption = 'Use condition to execute'
      DataField = 'UseExpression'
      DataSource = MainSource
      TabOrder = 5
      OnClick = cbUseExpressionClick
    end
    object memoExpression: TDBMemo [6]
      Left = 25
      Top = 228
      Width = 645
      Height = 85
      BorderStyle = bsNone
      DataField = 'Expression'
      DataSource = MainSource
      TabOrder = 6
    end
    object cbVisibleToUser: TDBCheckBox [7]
      Left = 10000
      Top = 10000
      Width = 543
      Height = 17
      Caption = 'Visible To User'
      DataField = 'VisibleToUser'
      DataSource = MainSource
      TabOrder = 7
      Visible = False
    end
    object memoUserInformation: TcxDBMemo [8]
      Left = 10000
      Top = 10000
      DataBinding.DataField = 'UserInformation'
      DataBinding.DataSource = MainSource
      Style.BorderColor = clWindowFrame
      Style.BorderStyle = ebs3D
      Style.HotTrack = False
      TabOrder = 9
      Visible = False
      Height = 469
      Width = 649
    end
    object bnImageIndex: TcxButton [9]
      Left = 10000
      Top = 10000
      Width = 100
      Height = 25
      Caption = 'ImageIndex'
      OptionsImage.Images = ImageContainer.Images16
      TabOrder = 8
      Visible = False
      OnClick = bnImageIndexClick
    end
    object ddPushOrRollback: TcxDBImageComboBox [10]
      Left = 96
      Top = 131
      AutoSize = False
      DataBinding.DataField = 'PushOrRollback'
      DataBinding.DataSource = MainSource
      Properties.Images = ImageContainer.Images16
      Properties.Items = <
        item
          Description = 'Pushing document'
          ImageIndex = 66
          Value = 0
        end
        item
          Description = 'Rollback document'
          ImageIndex = 65
          Value = 1
        end
        item
          Description = 'Always'
          ImageIndex = 1
          Value = 2
        end>
      Style.BorderColor = clWindowFrame
      Style.BorderStyle = ebs3D
      Style.HotTrack = False
      Style.ButtonStyle = bts3D
      Style.PopupBorderStyle = epbsFrame3D
      TabOrder = 2
      Height = 21
      Width = 300
    end
    object Image1: TImage [11]
      Left = 6
      Top = 29
      Width = 32
      Height = 32
    end
    object Label1: TLabel [12]
      Left = 44
      Top = 29
      Width = 114
      Height = 32
      Caption = 'Action Properties'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -13
      Font.Name = 'Tahoma'
      Font.Style = [fsBold]
      ParentFont = False
    end
    object ddOnError: TcxDBImageComboBox [13]
      Left = 96
      Top = 158
      DataBinding.DataField = 'OnError'
      DataBinding.DataSource = MainSource
      Properties.Images = ImageContainer.Images16
      Properties.Items = <
        item
          Description = 'Raise exception and abort SQL transaction'
          ImageIndex = 1
          Value = 0
        end
        item
          Description = 'Ignore exception (Do nothing)'
          ImageIndex = 5
          Value = 1
        end
        item
          Description = 'Ignore exception and notify client'
          ImageIndex = 198
          Value = 2
        end>
      Style.BorderColor = clWindowFrame
      Style.BorderStyle = ebs3D
      Style.HotTrack = False
      Style.ButtonStyle = bts3D
      Style.PopupBorderStyle = epbsFrame3D
      TabOrder = 4
      Width = 300
    end
    inherited DialogLayoutGroup_Root: TdxLayoutGroup
      ItemIndex = 2
      LayoutDirection = ldVertical
    end
    object Group_Common: TdxLayoutGroup
      Parent = Group_Main
      CaptionOptions.Text = 'Common'
      ButtonOptions.Buttons = <>
      ItemIndex = 1
      Index = 0
    end
    object Group_Properties: TdxLayoutGroup
      Parent = Group_Common
      AlignVert = avClient
      CaptionOptions.Text = 'Properites'
      ButtonOptions.Buttons = <>
      Index = 3
    end
    object item_cbActive: TdxLayoutItem
      Parent = DialogLayoutGroup_Root
      CaptionOptions.Text = 'Active'
      CaptionOptions.Visible = False
      Control = cbActive
      ControlOptions.AutoColor = True
      ControlOptions.OriginalHeight = 17
      ControlOptions.OriginalWidth = 97
      ControlOptions.ShowBorder = False
      Index = 0
    end
    object item_edOrderId: TdxLayoutItem
      Parent = dxLayoutAutoCreatedGroup1
      AlignVert = avClient
      CaptionOptions.Text = 'OrderId'
      Control = edOrderId
      ControlOptions.OriginalHeight = 21
      ControlOptions.OriginalWidth = 121
      ControlOptions.ShowBorder = False
      Index = 1
    end
    object Group_Expression: TdxLayoutGroup
      Parent = Group_Common
      CaptionOptions.Text = 'Expression'
      ButtonOptions.Buttons = <>
      ItemIndex = 1
      ShowBorder = False
      Index = 2
    end
    object item_edCaption: TdxLayoutItem
      Parent = Group_Common
      AlignHorz = ahClient
      AlignVert = avTop
      CaptionOptions.Text = 'Caption'
      Control = edCaption
      ControlOptions.OriginalHeight = 21
      ControlOptions.OriginalWidth = 121
      ControlOptions.ShowBorder = False
      Index = 0
    end
    object Group_GroupOptions: TdxLayoutGroup
      CaptionOptions.Text = 'Group Options'
      ButtonOptions.Buttons = <>
      ItemIndex = 1
      Index = -1
    end
    object item_cbRequiresTransaction: TdxLayoutItem
      Parent = Group_GroupOptions
      CaptionOptions.Text = 'DBCheckBox1'
      CaptionOptions.Visible = False
      Control = cbRequiresTransaction
      ControlOptions.AutoColor = True
      ControlOptions.OriginalHeight = 17
      ControlOptions.OriginalWidth = 97
      ControlOptions.ShowBorder = False
      Index = 0
    end
    object item_cbRunSynchro: TdxLayoutItem
      Parent = Group_GroupOptions
      CaptionOptions.Visible = False
      Control = cbRunSynchro
      ControlOptions.AutoColor = True
      ControlOptions.OriginalHeight = 17
      ControlOptions.OriginalWidth = 97
      ControlOptions.ShowBorder = False
      Index = 1
    end
    object item_cbUseExpression: TdxLayoutItem
      Parent = Group_Expression
      AlignHorz = ahLeft
      CaptionOptions.Text = 'DBCheckBox1'
      CaptionOptions.Visible = False
      CaptionOptions.Layout = clTop
      Control = cbUseExpression
      ControlOptions.AutoColor = True
      ControlOptions.OriginalHeight = 17
      ControlOptions.OriginalWidth = 97
      ControlOptions.ShowBorder = False
      Index = 1
    end
    object item_memoExpression: TdxLayoutItem
      Parent = Group_Expression
      AlignVert = avClient
      CaptionOptions.Text = 'Condition Expression'
      CaptionOptions.Layout = clTop
      Control = memoExpression
      ControlOptions.OriginalHeight = 85
      ControlOptions.OriginalWidth = 185
      Index = 2
    end
    object item_cbVisibleToUser: TdxLayoutItem
      Parent = dxLayoutAutoCreatedGroup2
      AlignHorz = ahClient
      CaptionOptions.Text = 'DBCheckBox1'
      CaptionOptions.Visible = False
      Control = cbVisibleToUser
      ControlOptions.AutoColor = True
      ControlOptions.OriginalHeight = 17
      ControlOptions.OriginalWidth = 97
      ControlOptions.ShowBorder = False
      Index = 0
    end
    object item_memoUserMessage: TdxLayoutItem
      Parent = Group_User
      AlignVert = avClient
      CaptionOptions.Text = 'User friendly description'
      CaptionOptions.Layout = clTop
      Control = memoUserInformation
      ControlOptions.OriginalHeight = 89
      ControlOptions.OriginalWidth = 185
      ControlOptions.ShowBorder = False
      Index = 1
    end
    object item_ImageIndex: TdxLayoutItem
      Parent = dxLayoutAutoCreatedGroup2
      CaptionOptions.Text = 'cxButton1'
      CaptionOptions.Visible = False
      Control = bnImageIndex
      ControlOptions.OriginalHeight = 25
      ControlOptions.OriginalWidth = 100
      ControlOptions.ShowBorder = False
      Index = 1
    end
    object Group_User: TdxLayoutGroup
      Parent = Group_Main
      CaptionOptions.Text = 'User'
      ButtonOptions.Buttons = <>
      Index = 1
    end
    object Group_Main: TdxLayoutGroup
      Parent = DialogLayoutGroup_Root
      AlignVert = avClient
      CaptionOptions.Text = 'New Group'
      CaptionOptions.Visible = False
      ButtonOptions.Buttons = <>
      LayoutDirection = ldTabbed
      ShowBorder = False
      Index = 2
    end
    object dxLayoutAutoCreatedGroup2: TdxLayoutAutoCreatedGroup
      Parent = Group_User
      LayoutDirection = ldHorizontal
      Index = 0
    end
    object Item_ddPushOrRollback: TdxLayoutItem
      Parent = dxLayoutAutoCreatedGroup1
      AlignVert = avClient
      CaptionOptions.Text = 'Execute when'
      Control = ddPushOrRollback
      ControlOptions.OriginalHeight = 21
      ControlOptions.OriginalWidth = 300
      ControlOptions.ShowBorder = False
      Index = 0
    end
    object dxLayoutAutoCreatedGroup1: TdxLayoutAutoCreatedGroup
      Parent = Group_Common
      LayoutDirection = ldHorizontal
      Index = 1
    end
    object item_Image: TdxLayoutItem
      Parent = dxLayoutAutoCreatedGroup3
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
    object dxLayoutItem1: TdxLayoutItem
      Parent = dxLayoutAutoCreatedGroup3
      AlignVert = avClient
      CaptionOptions.Text = 'Label1'
      CaptionOptions.Visible = False
      Control = Label1
      ControlOptions.AutoColor = True
      ControlOptions.OriginalHeight = 13
      ControlOptions.OriginalWidth = 114
      ControlOptions.ShowBorder = False
      Index = 1
    end
    object dxLayoutAutoCreatedGroup3: TdxLayoutAutoCreatedGroup
      Parent = DialogLayoutGroup_Root
      AlignVert = avTop
      LayoutDirection = ldHorizontal
      Index = 1
    end
    object Item_ddOnError: TdxLayoutItem
      Parent = Group_Expression
      AlignHorz = ahLeft
      AlignVert = avTop
      CaptionOptions.Text = 'OnError'
      Control = ddOnError
      ControlOptions.OriginalHeight = 21
      ControlOptions.OriginalWidth = 300
      ControlOptions.ShowBorder = False
      Index = 0
    end
  end
  object DetailSource: TDataSource
    Left = 304
    Top = 8
  end
end
