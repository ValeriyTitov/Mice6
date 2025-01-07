inherited ManagerEditorDfPathFolder: TManagerEditorDfPathFolder
  Caption = 'Edit Path Folder'
  ClientHeight = 678
  ClientWidth = 615
  ExplicitWidth = 631
  ExplicitHeight = 716
  PixelsPerInch = 96
  TextHeight = 13
  inherited pnBottomButtons: TPanel
    Top = 637
    Width = 615
    ExplicitTop = 637
    ExplicitWidth = 615
    inherited bnOK: TcxButton
      Left = 447
      OnClick = nil
      ExplicitLeft = 447
    end
    inherited bnCancel: TcxButton
      Left = 528
      ExplicitLeft = 528
    end
  end
  inherited DialogLayout: TdxLayoutControl
    Width = 615
    Height = 637
    ExplicitWidth = 615
    ExplicitHeight = 637
    object Label2: TLabel [0]
      Left = 44
      Top = 29
      Width = 144
      Height = 32
      Caption = 'Path folder properties'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -13
      Font.Name = 'Tahoma'
      Font.Style = [fsBold]
      ParentFont = False
    end
    object Image1: TImage [1]
      Left = 6
      Top = 29
      Width = 32
      Height = 32
    end
    object edCaption: TcxDBTextEdit [2]
      Left = 157
      Top = 137
      AutoSize = False
      DataBinding.DataField = 'Caption'
      DataBinding.DataSource = MainSource
      Style.BorderColor = clWindowFrame
      Style.BorderStyle = ebs3D
      Style.HotTrack = False
      TabOrder = 1
      Height = 21
      Width = 233
    end
    object ceFontColor: TdxDBColorEdit [3]
      Left = 157
      Top = 476
      DataBinding.DataField = 'FontColor'
      DataBinding.DataSource = MainSource
      Style.BorderColor = clWindowFrame
      Style.BorderStyle = ebs3D
      Style.HotTrack = False
      Style.ButtonStyle = bts3D
      Style.PopupBorderStyle = epbsFrame3D
      TabOrder = 12
      Width = 121
    end
    object ceBGColor: TdxDBColorEdit [4]
      Left = 157
      Top = 503
      DataBinding.DataField = 'bgColor'
      DataBinding.DataSource = MainSource
      Style.BorderColor = clWindowFrame
      Style.BorderStyle = ebs3D
      Style.HotTrack = False
      Style.ButtonStyle = bts3D
      Style.PopupBorderStyle = epbsFrame3D
      TabOrder = 16
      Width = 121
    end
    object bnImageIndex: TcxButton [5]
      Left = 284
      Top = 503
      Width = 75
      Height = 25
      Caption = 'Image'
      OptionsImage.Images = ImageContainer.Images16
      TabOrder = 17
      OnClick = bnImageIndexClick
    end
    object cbActive: TDBCheckBox [6]
      Left = 6
      Top = 6
      Width = 90
      Height = 17
      Caption = 'Active'
      DataField = 'Active'
      DataSource = MainSource
      TabOrder = 0
      OnClick = cbActiveClick
    end
    object cbAllowEdit: TDBCheckBox [7]
      Left = 38
      Top = 273
      Width = 97
      Height = 17
      Caption = 'Allow Edit'
      DataField = 'AllowEdit'
      DataSource = MainSource
      TabOrder = 5
      OnClick = cbAllowEditClick
    end
    object ddFolderType: TcxDBImageComboBox [8]
      Left = 157
      Top = 164
      DataBinding.DataField = 'FolderType'
      DataBinding.DataSource = MainSource
      Properties.Items = <>
      Properties.OnChange = ddFolderTypePropertiesChange
      Style.BorderColor = clWindowFrame
      Style.BorderStyle = ebs3D
      Style.HotTrack = False
      Style.ButtonStyle = bts3D
      Style.PopupBorderStyle = epbsFrame3D
      TabOrder = 3
      Width = 420
    end
    object cbAllowDelete: TDBCheckBox [9]
      Left = 244
      Top = 273
      Width = 97
      Height = 17
      Caption = 'Allow Delete'
      DataField = 'AllowDelete'
      DataSource = MainSource
      TabOrder = 7
    end
    object ddCodeName: TcxDBComboBox [10]
      Left = 456
      Top = 137
      AutoSize = False
      DataBinding.DataField = 'CodeName'
      DataBinding.DataSource = MainSource
      Properties.Items.Strings = (
        'New'
        'End'
        'OnHold'
        'Waiting'
        'Active'
        'InProcess'
        'Completed'
        'Closed'
        'Quering'
        'Archive')
      Properties.OnChange = ddCodeNamePropertiesChange
      Style.BorderColor = clWindowFrame
      Style.BorderStyle = ebs3D
      Style.HotTrack = False
      Style.ButtonStyle = bts3D
      Style.PopupBorderStyle = epbsFrame3D
      TabOrder = 2
      Height = 21
      Width = 121
    end
    object cbAllowDesktop: TDBCheckBox [11]
      Left = 141
      Top = 273
      Width = 97
      Height = 17
      Caption = 'Allow Desktop'
      DataField = 'AllowDesktop'
      DataSource = MainSource
      TabOrder = 6
    end
    object cbAutoRoute: TDBCheckBox [12]
      Left = 10000
      Top = 10000
      Width = 539
      Height = 17
      Caption = 'Auto route selection'
      DataField = 'AutoRoute'
      DataSource = MainSource
      Enabled = False
      TabOrder = 21
      Visible = False
    end
    object cbEnableMethodSelection: TDBCheckBox [13]
      Left = 10000
      Top = 10000
      Width = 539
      Height = 17
      Caption = 'Enable method selection'
      DataField = 'EnableMethodSelection'
      DataSource = MainSource
      Enabled = False
      TabOrder = 20
      Visible = False
    end
    object cbShowForEach: TDBCheckBox [14]
      Left = 38
      Top = 413
      Width = 97
      Height = 21
      Caption = 'Show for each'
      DataField = 'ShowForEach'
      DataSource = MainSource
      TabOrder = 11
    end
    object ddApplyMethod: TcxDBImageComboBox [15]
      Left = 157
      Top = 296
      AutoSize = False
      DataBinding.DataField = 'EditdfMethodsId'
      DataBinding.DataSource = MainSource
      Properties.Items = <>
      Style.BorderColor = clWindowFrame
      Style.BorderStyle = ebs3D
      Style.HotTrack = False
      Style.ButtonStyle = bts3D
      Style.PopupBorderStyle = epbsFrame3D
      TabOrder = 8
      Height = 21
      Width = 420
    end
    object memoUserInformation: TcxDBMemo [16]
      Left = 10000
      Top = 10000
      DataBinding.DataField = 'UserInformation'
      DataBinding.DataSource = MainSource
      Style.BorderColor = clWindowFrame
      Style.BorderStyle = ebs3D
      Style.HotTrack = False
      TabOrder = 24
      Visible = False
      Height = 439
      Width = 552
    end
    object cbItalic: TCheckBox [17]
      Left = 345
      Top = 480
      Width = 56
      Height = 17
      Caption = 'Italic'
      TabOrder = 14
    end
    object cbUnderLined: TCheckBox [18]
      Left = 407
      Top = 480
      Width = 84
      Height = 17
      Caption = 'Underlined'
      TabOrder = 15
    end
    object cbBold: TCheckBox [19]
      Left = 284
      Top = 480
      Width = 55
      Height = 17
      Caption = 'Bold'
      TabOrder = 13
    end
    inline RulesFrame: TdfPathFoldersIncomingRulesFrame [20]
      Left = 10000
      Top = 10000
      Width = 569
      Height = 510
      TabOrder = 18
      Visible = False
      ExplicitLeft = 10000
      ExplicitTop = 10000
      ExplicitWidth = 569
      ExplicitHeight = 510
      inherited GridRules: TcxGrid
        Width = 569
        Height = 510
        ExplicitWidth = 569
        ExplicitHeight = 510
      end
      inherited PopupMenu: TPopupMenu
        Left = 520
        Top = 400
      end
    end
    inline dfPathFoldersInitFrame1: TdfPathFoldersInitFrame
      Left = 10000
      Top = 10000
      Width = 473
      Height = 475
      TabOrder = 29
      Visible = False
      ExplicitLeft = 10000
      ExplicitTop = 10000
    end
    inline ActionsFrame: TdfPathFoldersActionsFrame
      Left = 10000
      Top = 10000
      Width = 569
      Height = 510
      TabOrder = 19
      Visible = False
      ExplicitLeft = 10000
      ExplicitTop = 10000
      ExplicitWidth = 569
      ExplicitHeight = 510
      inherited MainGrid: TcxGrid
        Width = 569
        Height = 510
        ExplicitWidth = 569
        ExplicitHeight = 510
      end
    end
    inline dfPathFoldersDecisionFrame1: TdfPathFoldersDecisionFrame
      Left = 10000
      Top = 10000
      Width = 569
      Height = 396
      Enabled = False
      TabOrder = 22
      Visible = False
      ExplicitLeft = 10000
      ExplicitTop = 10000
      ExplicitWidth = 569
      ExplicitHeight = 396
    end
    inline PermissionsFrame1: TPermissionsFrame
      Left = 10000
      Top = 10000
      Width = 569
      Height = 478
      TabOrder = 23
      Visible = False
      ExplicitLeft = 10000
      ExplicitTop = 10000
      ExplicitWidth = 569
      ExplicitHeight = 478
    end
    object vpick_ActiveLayout: TcxButtonEdit
      Left = 157
      Top = 359
      Properties.Buttons = <
        item
          Default = True
          Kind = bkEllipsis
        end>
      Style.BorderColor = clWindowFrame
      Style.BorderStyle = ebs3D
      Style.HotTrack = False
      Style.ButtonStyle = bts3D
      TabOrder = 9
      Width = 420
    end
    object vpick_AppDialogsLayoutIdApply: TcxButtonEdit
      Left = 157
      Top = 386
      Properties.Buttons = <
        item
          Default = True
          Kind = bkEllipsis
        end>
      Style.BorderColor = clWindowFrame
      Style.BorderStyle = ebs3D
      Style.HotTrack = False
      Style.ButtonStyle = bts3D
      TabOrder = 10
      Width = 420
    end
    object memoDesc: TcxMemo
      Left = 157
      Top = 191
      Properties.ReadOnly = True
      Style.BorderColor = clWindowFrame
      Style.BorderStyle = ebs3D
      Style.HotTrack = False
      TabOrder = 4
      Height = 40
      Width = 420
    end
    inline ShapeFrame: TShapePropertiesFrame
      Left = 10000
      Top = 10000
      Width = 569
      Height = 510
      TabOrder = 25
      Visible = False
      ExplicitLeft = 10000
      ExplicitTop = 10000
      ExplicitWidth = 569
      ExplicitHeight = 510
      inherited Panel1: TPanel
        Width = 569
        ExplicitWidth = 569
        inherited cbTransparent: TcxCheckBox
          ExplicitWidth = 83
        end
      end
      inherited Panel2: TPanel
        Width = 569
        Height = 261
        ExplicitWidth = 569
        ExplicitHeight = 261
        inherited memoText: TcxMemo
          ExplicitWidth = 569
          ExplicitHeight = 261
          Height = 261
          Width = 569
        end
      end
    end
    inherited DialogLayoutGroup_Root: TdxLayoutGroup
      ItemIndex = 2
      LayoutDirection = ldVertical
    end
    object item_Label1: TdxLayoutItem
      Parent = dxLayoutAutoCreatedGroup1
      AlignVert = avClient
      CaptionOptions.Text = 'New Item'
      CaptionOptions.Visible = False
      Control = Label2
      ControlOptions.AutoColor = True
      ControlOptions.OriginalHeight = 32
      ControlOptions.OriginalWidth = 144
      ControlOptions.ShowBorder = False
      Index = 1
    end
    object item_Image: TdxLayoutItem
      Parent = dxLayoutAutoCreatedGroup1
      AlignHorz = ahLeft
      CaptionOptions.Text = 'Image1'
      CaptionOptions.Visible = False
      Control = Image1
      ControlOptions.OriginalHeight = 32
      ControlOptions.OriginalWidth = 32
      ControlOptions.ShowBorder = False
      Index = 0
    end
    object dxLayoutSeparatorItem1: TdxLayoutSeparatorItem
      Parent = Tab0
      CaptionOptions.Text = 'Separator'
      Index = 0
    end
    object edCaption_Item: TdxLayoutItem
      Parent = dxLayoutAutoCreatedGroup3
      AlignHorz = ahClient
      CaptionOptions.Text = 'Caption'
      Control = edCaption
      ControlOptions.OriginalHeight = 21
      ControlOptions.OriginalWidth = 121
      ControlOptions.ShowBorder = False
      Index = 0
    end
    object item_FontColor: TdxLayoutItem
      Parent = dxLayoutAutoCreatedGroup2
      AlignHorz = ahLeft
      AlignVert = avTop
      CaptionOptions.Text = 'Font color'
      Control = ceFontColor
      ControlOptions.OriginalHeight = 21
      ControlOptions.OriginalWidth = 121
      ControlOptions.ShowBorder = False
      Index = 0
    end
    object Item_BackgroundColor: TdxLayoutItem
      Parent = dxLayoutAutoCreatedGroup5
      AlignHorz = ahLeft
      CaptionOptions.Text = 'Background color'
      Control = ceBGColor
      ControlOptions.OriginalHeight = 21
      ControlOptions.OriginalWidth = 121
      ControlOptions.ShowBorder = False
      Index = 0
    end
    object dxLayoutItem4: TdxLayoutItem
      Parent = dxLayoutAutoCreatedGroup5
      CaptionOptions.Text = 'cxButton1'
      CaptionOptions.Visible = False
      Control = bnImageIndex
      ControlOptions.OriginalHeight = 25
      ControlOptions.OriginalWidth = 75
      ControlOptions.ShowBorder = False
      Index = 1
    end
    object Tab0: TdxLayoutGroup
      Parent = Group_All
      CaptionOptions.Text = 'General'
      ButtonOptions.Buttons = <>
      ItemIndex = 1
      Index = 0
    end
    object Tab2: TdxLayoutGroup
      CaptionOptions.Text = 'Validation'
      ButtonOptions.Buttons = <>
      Index = -1
    end
    object Tab3: TdxLayoutGroup
      Parent = Group_All
      CaptionOptions.Text = 'Actions'
      ButtonOptions.Buttons = <>
      Index = 2
    end
    object Tab1: TdxLayoutGroup
      Parent = Group_All
      CaptionOptions.Text = 'Incoming Rules'
      ButtonOptions.Buttons = <>
      Index = 1
    end
    object CommonGroup: TdxLayoutGroup
      Parent = Tab0
      AlignHorz = ahClient
      CaptionOptions.Text = 'Common'
      ButtonOptions.Buttons = <>
      ItemIndex = 2
      Index = 1
    end
    object Item_Active: TdxLayoutItem
      Parent = DialogLayoutGroup_Root
      AlignHorz = ahLeft
      CaptionOptions.Text = 'DBCheckBox1'
      CaptionOptions.Visible = False
      Control = cbActive
      ControlOptions.AutoColor = True
      ControlOptions.OriginalHeight = 17
      ControlOptions.OriginalWidth = 90
      ControlOptions.ShowBorder = False
      Index = 0
    end
    object dxLayoutItem6: TdxLayoutItem
      Parent = dxLayoutAutoCreatedGroup4
      AlignHorz = ahLeft
      CaptionOptions.Text = 'Allow Edit'
      CaptionOptions.Visible = False
      Control = cbAllowEdit
      ControlOptions.AutoColor = True
      ControlOptions.OriginalHeight = 17
      ControlOptions.OriginalWidth = 97
      ControlOptions.ShowBorder = False
      Index = 0
    end
    object Tab4: TdxLayoutGroup
      Parent = Group_All
      CaptionOptions.Text = 'Decision'
      ButtonOptions.Buttons = <>
      Enabled = False
      ItemIndex = 1
      Index = 3
    end
    object item_FolderType: TdxLayoutItem
      Parent = CommonGroup
      CaptionOptions.Text = 'Folder Type'
      Control = ddFolderType
      ControlOptions.OriginalHeight = 21
      ControlOptions.OriginalWidth = 121
      ControlOptions.ShowBorder = False
      Index = 1
    end
    object cbAllowDelete_Item: TdxLayoutItem
      Parent = dxLayoutAutoCreatedGroup4
      AlignVert = avClient
      CaptionOptions.Text = 'Allow Delete'
      CaptionOptions.Visible = False
      Control = cbAllowDelete
      ControlOptions.AutoColor = True
      ControlOptions.OriginalHeight = 17
      ControlOptions.OriginalWidth = 97
      ControlOptions.ShowBorder = False
      Index = 2
    end
    object item_cbStateName: TdxLayoutItem
      Parent = dxLayoutAutoCreatedGroup3
      AlignVert = avClient
      CaptionOptions.Text = 'Code Name'
      Control = ddCodeName
      ControlOptions.OriginalHeight = 21
      ControlOptions.OriginalWidth = 121
      ControlOptions.ShowBorder = False
      Index = 1
    end
    object dxLayoutItem7: TdxLayoutItem
      Parent = dxLayoutAutoCreatedGroup4
      AlignVert = avClient
      CaptionOptions.Text = 'DBCheckBox1'
      CaptionOptions.Visible = False
      Control = cbAllowDesktop
      ControlOptions.AutoColor = True
      ControlOptions.OriginalHeight = 17
      ControlOptions.OriginalWidth = 97
      ControlOptions.ShowBorder = False
      Index = 1
    end
    object dxLayoutAutoCreatedGroup3: TdxLayoutAutoCreatedGroup
      Parent = CommonGroup
      LayoutDirection = ldHorizontal
      Index = 0
    end
    object item_AutoRoute: TdxLayoutItem
      Parent = DecisionOptionsGroup
      CaptionOptions.Visible = False
      Control = cbAutoRoute
      ControlOptions.AutoColor = True
      ControlOptions.OriginalHeight = 17
      ControlOptions.OriginalWidth = 97
      ControlOptions.ShowBorder = False
      Index = 1
    end
    object item_cbEnableMethodSelection: TdxLayoutItem
      Parent = DecisionOptionsGroup
      CaptionOptions.Text = 'DBCheckBox1'
      CaptionOptions.Visible = False
      Control = cbEnableMethodSelection
      ControlOptions.AutoColor = True
      ControlOptions.OriginalHeight = 17
      ControlOptions.OriginalWidth = 186
      ControlOptions.ShowBorder = False
      Index = 0
    end
    object Tab6: TdxLayoutGroup
      Parent = Group_All
      CaptionOptions.Text = 'User Information'
      ButtonOptions.Buttons = <>
      Index = 5
    end
    object LineGroup: TdxLayoutGroup
      Parent = Tab0
      AlignVert = avClient
      CaptionOptions.Text = 'Plugin Row'
      ButtonOptions.Buttons = <>
      Index = 4
    end
    object dxLayoutAutoCreatedGroup5: TdxLayoutAutoCreatedGroup
      Parent = LineGroup
      LayoutDirection = ldHorizontal
      Index = 1
    end
    object Schema: TdxLayoutGroup
      Parent = Group_All
      CaptionOptions.Text = 'Shape'
      ButtonOptions.Buttons = <>
      LayoutDirection = ldHorizontal
      Index = 6
    end
    object Dialogs: TdxLayoutGroup
      Parent = Tab0
      CaptionOptions.Text = 'Dialog'
      ButtonOptions.Buttons = <>
      ItemIndex = 2
      Index = 3
    end
    object item_cbShowForEach: TdxLayoutItem
      Parent = Dialogs
      AlignHorz = ahLeft
      AlignVert = avTop
      CaptionOptions.Text = 'DBCheckBox1'
      CaptionOptions.Visible = False
      Control = cbShowForEach
      ControlOptions.AutoColor = True
      ControlOptions.OriginalHeight = 21
      ControlOptions.OriginalWidth = 97
      ControlOptions.ShowBorder = False
      Index = 2
    end
    object item_ddApplyMethod: TdxLayoutItem
      Parent = grp_User
      AlignHorz = ahClient
      AlignVert = avTop
      CaptionOptions.Text = 'Apply method after edit'
      Control = ddApplyMethod
      ControlOptions.OriginalHeight = 21
      ControlOptions.OriginalWidth = 121
      ControlOptions.ShowBorder = False
      Index = 1
    end
    object item_MemInfo: TdxLayoutItem
      Parent = Tab6
      AlignVert = avClient
      Control = memoUserInformation
      ControlOptions.OriginalHeight = 89
      ControlOptions.OriginalWidth = 185
      ControlOptions.ShowBorder = False
      Index = 0
    end
    object Tab5: TdxLayoutGroup
      Parent = Group_All
      CaptionOptions.Text = 'Permissions'
      ButtonOptions.Buttons = <>
      Index = 4
    end
    object dxLayoutItem1: TdxLayoutItem
      Parent = dxLayoutAutoCreatedGroup2
      AlignVert = avBottom
      CaptionOptions.Text = 'Italic'
      CaptionOptions.Visible = False
      Control = cbItalic
      ControlOptions.AutoColor = True
      ControlOptions.OriginalHeight = 17
      ControlOptions.OriginalWidth = 56
      ControlOptions.ShowBorder = False
      Index = 2
    end
    object dxLayoutItem2: TdxLayoutItem
      Parent = dxLayoutAutoCreatedGroup2
      AlignVert = avBottom
      CaptionOptions.Text = 'CheckBox2'
      CaptionOptions.Visible = False
      Control = cbUnderLined
      ControlOptions.AutoColor = True
      ControlOptions.OriginalHeight = 17
      ControlOptions.OriginalWidth = 84
      ControlOptions.ShowBorder = False
      Index = 3
    end
    object dxLayoutItem3: TdxLayoutItem
      Parent = dxLayoutAutoCreatedGroup2
      AlignVert = avBottom
      CaptionOptions.Text = 'CheckBox3'
      CaptionOptions.Visible = False
      Control = cbBold
      ControlOptions.AutoColor = True
      ControlOptions.OriginalHeight = 17
      ControlOptions.OriginalWidth = 55
      ControlOptions.ShowBorder = False
      Index = 1
    end
    object dxLayoutAutoCreatedGroup2: TdxLayoutAutoCreatedGroup
      Parent = LineGroup
      AlignVert = avTop
      LayoutDirection = ldHorizontal
      Index = 0
    end
    object item_dfRules: TdxLayoutItem
      Parent = Tab1
      AlignVert = avClient
      Control = RulesFrame
      ControlOptions.AutoColor = True
      ControlOptions.OriginalHeight = 475
      ControlOptions.OriginalWidth = 473
      ControlOptions.ShowBorder = False
      Index = 0
    end
    object item_dfInit: TdxLayoutItem
      Parent = Tab2
      AlignVert = avClient
      Control = dfPathFoldersInitFrame1
      ControlOptions.AutoColor = True
      ControlOptions.OriginalHeight = 475
      ControlOptions.OriginalWidth = 473
      ControlOptions.ShowBorder = False
      Index = 0
    end
    object DecisionOptionsGroup: TdxLayoutGroup
      Parent = Tab4
      CaptionOptions.Text = 'Options'
      ButtonOptions.Buttons = <>
      ItemIndex = 1
      Index = 0
    end
    object item_dfActions: TdxLayoutItem
      Parent = Tab3
      AlignVert = avClient
      Control = ActionsFrame
      ControlOptions.AutoColor = True
      ControlOptions.OriginalHeight = 475
      ControlOptions.OriginalWidth = 473
      ControlOptions.ShowBorder = False
      Index = 0
    end
    object dxLayoutItem5: TdxLayoutItem
      Parent = Tab4
      AlignVert = avClient
      Control = dfPathFoldersDecisionFrame1
      ControlOptions.AutoColor = True
      ControlOptions.OriginalHeight = 240
      ControlOptions.OriginalWidth = 320
      ControlOptions.ShowBorder = False
      Index = 1
    end
    object item_Permissions: TdxLayoutItem
      Parent = Tab5
      AlignVert = avClient
      Control = PermissionsFrame1
      ControlOptions.AutoColor = True
      ControlOptions.OriginalHeight = 351
      ControlOptions.OriginalWidth = 464
      ControlOptions.ShowBorder = False
      Index = 0
    end
    object item_ActiveLayout: TdxLayoutItem
      Parent = Dialogs
      AlignHorz = ahClient
      AlignVert = avTop
      CaptionOptions.Text = 'Active Layout'
      Control = vpick_ActiveLayout
      ControlOptions.OriginalHeight = 21
      ControlOptions.OriginalWidth = 121
      ControlOptions.ShowBorder = False
      Index = 0
    end
    object item_AppDialogsLayoutIdApply: TdxLayoutItem
      Parent = Dialogs
      AlignHorz = ahClient
      AlignVert = avTop
      CaptionOptions.Text = 'Show before execute'
      Control = vpick_AppDialogsLayoutIdApply
      ControlOptions.OriginalHeight = 21
      ControlOptions.OriginalWidth = 121
      ControlOptions.ShowBorder = False
      Index = 1
    end
    object Group_All: TdxLayoutGroup
      Parent = DialogLayoutGroup_Root
      AlignHorz = ahClient
      AlignVert = avClient
      CaptionOptions.Text = 'New Group'
      CaptionOptions.Visible = False
      ButtonOptions.Buttons = <>
      LayoutDirection = ldTabbed
      ShowBorder = False
      Index = 2
    end
    object dxLayoutAutoCreatedGroup1: TdxLayoutAutoCreatedGroup
      Parent = DialogLayoutGroup_Root
      LayoutDirection = ldHorizontal
      Index = 1
    end
    object grp_User: TdxLayoutGroup
      Parent = Tab0
      AlignHorz = ahClient
      AlignVert = avTop
      CaptionOptions.Text = 'User'
      ButtonOptions.Buttons = <>
      Index = 2
    end
    object dxLayoutAutoCreatedGroup4: TdxLayoutAutoCreatedGroup
      Parent = grp_User
      AlignHorz = ahClient
      AlignVert = avTop
      LayoutDirection = ldHorizontal
      Index = 0
    end
    object item_Desc: TdxLayoutItem
      Parent = CommonGroup
      CaptionOptions.Text = 'Folder type description'
      Control = memoDesc
      ControlOptions.OriginalHeight = 40
      ControlOptions.OriginalWidth = 185
      ControlOptions.ShowBorder = False
      Index = 2
    end
    object dxLayoutItem8: TdxLayoutItem
      Parent = Schema
      AlignHorz = ahClient
      AlignVert = avClient
      Control = ShapeFrame
      ControlOptions.AutoColor = True
      ControlOptions.OriginalHeight = 314
      ControlOptions.OriginalWidth = 376
      ControlOptions.ShowBorder = False
      Index = 0
    end
  end
end
