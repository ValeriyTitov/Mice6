inherited ControlEditorBase: TControlEditorBase
  Caption = 'Basic Control Editor Dialog'
  ClientHeight = 513
  ClientWidth = 539
  ExplicitWidth = 555
  ExplicitHeight = 551
  PixelsPerInch = 96
  TextHeight = 13
  inherited pnBottomButtons: TPanel
    Top = 472
    Width = 539
    ExplicitTop = 472
    ExplicitWidth = 539
    DesignSize = (
      539
      41)
    inherited bnOK: TcxButton
      Left = 369
      ExplicitLeft = 369
    end
    inherited bnCancel: TcxButton
      Left = 450
      ExplicitLeft = 450
    end
  end
  inherited DialogLayout: TdxLayoutControl
    Width = 539
    Height = 472
    Constraints.MinHeight = 400
    Constraints.MinWidth = 400
    ExplicitWidth = 539
    ExplicitHeight = 472
    object ddVisibleCondition: TcxDBImageComboBox [0]
      Left = 10000
      Top = 10000
      Properties.Items = <>
      Style.BorderColor = clWindowFrame
      Style.BorderStyle = ebs3D
      Style.HotTrack = False
      Style.ButtonStyle = bts3D
      Style.PopupBorderStyle = epbsFrame3D
      TabOrder = 4
      Visible = False
      Width = 121
    end
    object ddEnabledCondition: TcxDBImageComboBox [1]
      Left = 10000
      Top = 10000
      Properties.Items = <>
      Style.BorderColor = clWindowFrame
      Style.BorderStyle = ebs3D
      Style.HotTrack = False
      Style.ButtonStyle = bts3D
      Style.PopupBorderStyle = epbsFrame3D
      TabOrder = 5
      Visible = False
      Width = 121
    end
    object chbReadOnly: TcxCheckBox [2]
      Left = 10000
      Top = 10000
      Caption = 'ReadOnly'
      Style.BorderColor = clWindowFrame
      Style.BorderStyle = ebs3D
      Style.HotTrack = False
      TabOrder = 6
      Visible = False
    end
    object cbCaption: TcxDBComboBox [3]
      Left = 288
      Top = 91
      AutoSize = False
      DataBinding.DataField = 'Caption'
      DataBinding.DataSource = MainSource
      Properties.OnInitPopup = cbCaptionPropertiesInitPopup
      Style.BorderColor = clWindowFrame
      Style.BorderStyle = ebs3D
      Style.HotTrack = False
      Style.ButtonStyle = bts3D
      Style.PopupBorderStyle = epbsFrame3D
      TabOrder = 3
      Height = 21
      Width = 213
    end
    object edControlName: TcxDBButtonEdit [4]
      Left = 288
      Top = 64
      AutoSize = False
      DataBinding.DataField = 'ControlName'
      DataBinding.DataSource = MainSource
      Properties.Buttons = <
        item
          Default = True
          Kind = bkEllipsis
        end>
      Properties.OnButtonClick = edControlNamePropertiesButtonClick
      Style.BorderColor = clWindowFrame
      Style.BorderStyle = ebs3D
      Style.HotTrack = False
      Style.ButtonStyle = bts3D
      TabOrder = 1
      Height = 21
      Width = 213
    end
    object cbDataField: TcxDBComboBox [5]
      Left = 91
      Top = 64
      AutoSize = False
      DataBinding.DataField = 'DataField'
      DataBinding.DataSource = MainSource
      Style.BorderColor = clWindowFrame
      Style.BorderStyle = ebs3D
      Style.HotTrack = False
      Style.ButtonStyle = bts3D
      Style.PopupBorderStyle = epbsFrame3D
      TabOrder = 0
      Height = 21
      Width = 121
    end
    object cbDBName: TcxDBComboBox [6]
      Left = 91
      Top = 91
      DataBinding.DataField = 'DBName'
      DataBinding.DataSource = MainSource
      Properties.OnChange = cbDBNamePropertiesChange
      Style.BorderColor = clWindowFrame
      Style.BorderStyle = ebs3D
      Style.HotTrack = False
      Style.ButtonStyle = bts3D
      Style.PopupBorderStyle = epbsFrame3D
      TabOrder = 2
      Width = 121
    end
    inherited DialogLayoutGroup_Root: TdxLayoutGroup
      CaptionOptions.Visible = False
    end
    object AllPropertiesGroup: TdxLayoutGroup
      Parent = DialogLayoutGroup_Root
      CaptionOptions.Text = 'Properties'
      ButtonOptions.Buttons = <>
      Index = 0
    end
    object CommonPropertiesGroup: TdxLayoutGroup
      Parent = AllPropertiesGroup
      CaptionOptions.Text = 'Common Properties'
      ButtonOptions.Buttons = <>
      ItemIndex = 1
      Index = 0
    end
    object ControlActivityGroup: TdxLayoutGroup
      AlignHorz = ahClient
      CaptionOptions.Text = 'Activity properties'
      ButtonOptions.Buttons = <>
      LayoutDirection = ldHorizontal
      Index = -1
    end
    object ddVisibleCondition_Item: TdxLayoutItem
      Parent = ControlActivityGroup
      AlignHorz = ahClient
      AlignVert = avTop
      CaptionOptions.Text = 'Visible when'
      Control = ddVisibleCondition
      ControlOptions.OriginalHeight = 21
      ControlOptions.OriginalWidth = 121
      ControlOptions.ShowBorder = False
      Index = 0
    end
    object ddEnabledCondition_Item: TdxLayoutItem
      Parent = ControlActivityGroup
      AlignHorz = ahClient
      CaptionOptions.Text = 'Enabled when'
      Control = ddEnabledCondition
      ControlOptions.OriginalHeight = 21
      ControlOptions.OriginalWidth = 121
      ControlOptions.ShowBorder = False
      Index = 1
    end
    object ExtendedPropertiesGroup: TdxLayoutGroup
      Parent = AllPropertiesGroup
      AlignVert = avClient
      CaptionOptions.Text = 'Extended properties'
      ButtonOptions.Buttons = <>
      Index = 1
    end
    object RuntimePropertiesGroup: TdxLayoutGroup
      Parent = DialogLayoutGroup_Root
      CaptionOptions.Text = 'Runtime'
      ButtonOptions.Buttons = <>
      Index = 1
    end
    object cbDBName_Item: TdxLayoutItem
      Parent = dxLayoutAutoCreatedGroup2
      AlignHorz = ahLeft
      CaptionOptions.Text = 'DBName'
      Control = cbDBName
      ControlOptions.OriginalHeight = 21
      ControlOptions.OriginalWidth = 121
      ControlOptions.ShowBorder = False
      Index = 0
    end
    object chbReadOnly_Item: TdxLayoutItem
      Parent = ControlActivityGroup
      CaptionOptions.Text = 'cxCheckBox1'
      CaptionOptions.Visible = False
      Control = chbReadOnly
      ControlOptions.OriginalHeight = 21
      ControlOptions.OriginalWidth = 71
      ControlOptions.ShowBorder = False
      Index = 2
    end
    object cbCaption_Item: TdxLayoutItem
      Parent = dxLayoutAutoCreatedGroup2
      AlignHorz = ahClient
      AlignVert = avClient
      CaptionOptions.Text = 'Caption'
      Control = cbCaption
      ControlOptions.OriginalHeight = 21
      ControlOptions.OriginalWidth = 121
      ControlOptions.ShowBorder = False
      Index = 1
    end
    object edControlName_Item: TdxLayoutItem
      Parent = dxLayoutAutoCreatedGroup1
      AlignHorz = ahClient
      AlignVert = avClient
      CaptionOptions.Text = 'Control Name'
      Control = edControlName
      ControlOptions.OriginalHeight = 21
      ControlOptions.OriginalWidth = 121
      ControlOptions.ShowBorder = False
      Index = 1
    end
    object cbDataField_Item: TdxLayoutItem
      Parent = dxLayoutAutoCreatedGroup1
      AlignHorz = ahLeft
      AlignVert = avClient
      CaptionOptions.Text = 'Data Field'
      Control = cbDataField
      ControlOptions.OriginalHeight = 21
      ControlOptions.OriginalWidth = 121
      ControlOptions.ShowBorder = False
      Index = 0
    end
    object dxLayoutAutoCreatedGroup1: TdxLayoutAutoCreatedGroup
      Parent = CommonPropertiesGroup
      AlignHorz = ahClient
      AlignVert = avTop
      LayoutDirection = ldHorizontal
      Index = 0
    end
    object dxLayoutAutoCreatedGroup2: TdxLayoutAutoCreatedGroup
      Parent = CommonPropertiesGroup
      AlignVert = avTop
      LayoutDirection = ldHorizontal
      Index = 1
    end
  end
  inherited MainSource: TDataSource
    Left = 16
    Top = 521
  end
end
