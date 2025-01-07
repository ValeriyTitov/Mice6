inherited ManagerEditorDfTypes: TManagerEditorDfTypes
  Caption = 'Edit doc flow type'
  ClientHeight = 312
  ClientWidth = 384
  Constraints.MinHeight = 350
  Constraints.MinWidth = 400
  ExplicitWidth = 400
  ExplicitHeight = 351
  TextHeight = 13
  inherited pnBottomButtons: TPanel
    Top = 271
    Width = 384
    ExplicitTop = 271
    ExplicitWidth = 384
    inherited bnOK: TcxButton
      Left = 216
      ExplicitLeft = 216
    end
    inherited bnCancel: TcxButton
      Left = 297
      ExplicitLeft = 297
    end
  end
  inherited DialogLayout: TdxLayoutControl
    Width = 384
    Height = 271
    ExplicitWidth = 384
    ExplicitHeight = 271
    object Image1: TImage [0]
      Left = 21
      Top = 27
      Width = 32
      Height = 32
    end
    object Label1: TLabel [1]
      Left = 59
      Top = 27
      Width = 304
      Height = 32
      Caption = 'Doc Flow type properties'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -13
      Font.Name = 'Tahoma'
      Font.Style = [fsBold]
      ParentFont = False
    end
    object ddDfClasses: TcxDBImageComboBox [2]
      Left = 82
      Top = 101
      DataBinding.DataField = 'dfClassesId'
      DataBinding.DataSource = MainSource
      Enabled = False
      Properties.Items = <>
      Properties.ReadOnly = True
      Style.BorderColor = clWindowFrame
      Style.BorderStyle = ebsFlat
      Style.HotTrack = False
      Style.ButtonStyle = btsFlat
      Style.PopupBorderStyle = epbsFlat
      TabOrder = 0
      Width = 281
    end
    object eddfTypesId: TcxDBTextEdit [3]
      Left = 82
      Top = 128
      DataBinding.DataField = 'dfTypesId'
      DataBinding.DataSource = MainSource
      Enabled = False
      Style.BorderColor = clWindowFrame
      Style.BorderStyle = ebsFlat
      Style.HotTrack = False
      TabOrder = 1
      Width = 281
    end
    object edCaption: TcxDBTextEdit [4]
      Left = 82
      Top = 155
      DataBinding.DataField = 'Caption'
      DataBinding.DataSource = MainSource
      Style.BorderColor = clWindowFrame
      Style.BorderStyle = ebsFlat
      Style.HotTrack = False
      TabOrder = 2
      Width = 281
    end
    object edShortName: TcxDBTextEdit [5]
      Left = 82
      Top = 182
      DataBinding.DataField = 'ShortName'
      DataBinding.DataSource = MainSource
      Style.BorderColor = clWindowFrame
      Style.BorderStyle = ebsFlat
      Style.HotTrack = False
      TabOrder = 3
      Width = 281
    end
    inherited DialogLayoutGroup_Root: TdxLayoutGroup
      ItemIndex = 1
      LayoutDirection = ldVertical
    end
    object dxLayoutItem1: TdxLayoutItem
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
      CaptionOptions.Text = 'dfTypes'
      LayoutDirection = ldHorizontal
      Index = 0
    end
    object dxLayoutGroup2: TdxLayoutGroup
      Parent = DialogLayoutGroup_Root
      AlignHorz = ahClient
      AlignVert = avClient
      CaptionOptions.AlignVert = tavCenter
      CaptionOptions.Text = 'New Group'
      CaptionOptions.Visible = False
      LayoutDirection = ldHorizontal
      Index = 1
    end
    object dxLayoutItem2: TdxLayoutItem
      Parent = dxLayoutGroup1
      AlignHorz = ahClient
      AlignVert = avClient
      CaptionOptions.Text = 'New Item'
      CaptionOptions.Visible = False
      Control = Label1
      ControlOptions.AutoColor = True
      ControlOptions.OriginalHeight = 16
      ControlOptions.OriginalWidth = 162
      ControlOptions.ShowBorder = False
      Index = 1
    end
    object item_dfClassesId: TdxLayoutItem
      Parent = dxLayoutAutoCreatedGroup1
      CaptionOptions.Text = 'dfClass'
      Control = ddDfClasses
      ControlOptions.OriginalHeight = 21
      ControlOptions.OriginalWidth = 254
      ControlOptions.ShowBorder = False
      Enabled = False
      Index = 0
    end
    object item_eddfTypesId: TdxLayoutItem
      Parent = dxLayoutAutoCreatedGroup1
      CaptionOptions.Text = 'dfTypesId'
      Control = eddfTypesId
      ControlOptions.OriginalHeight = 21
      ControlOptions.OriginalWidth = 121
      ControlOptions.ShowBorder = False
      Enabled = False
      Index = 1
    end
    object dxLayoutAutoCreatedGroup1: TdxLayoutAutoCreatedGroup
      Parent = dxLayoutGroup2
      AlignHorz = ahClient
      Index = 0
    end
    object item_edCaption: TdxLayoutItem
      Parent = dxLayoutAutoCreatedGroup1
      CaptionOptions.Text = 'Caption'
      Control = edCaption
      ControlOptions.OriginalHeight = 21
      ControlOptions.OriginalWidth = 121
      ControlOptions.ShowBorder = False
      Index = 2
    end
    object item_edShortName: TdxLayoutItem
      Parent = dxLayoutAutoCreatedGroup1
      CaptionOptions.Text = 'Short Name'
      Control = edShortName
      ControlOptions.OriginalHeight = 21
      ControlOptions.OriginalWidth = 121
      ControlOptions.ShowBorder = False
      Index = 3
    end
  end
  inherited MainSource: TDataSource
    Left = 320
    Top = 17
  end
end
