inherited ControlEditorMiceDateEdit: TControlEditorMiceDateEdit
  Caption = 'MiceDateEdit Properties'
  ClientHeight = 441
  ExplicitHeight = 479
  PixelsPerInch = 96
  TextHeight = 13
  inherited pnBottomButtons: TPanel
    Top = 400
    ExplicitTop = 400
  end
  inherited DialogLayout: TdxLayoutControl
    Height = 400
    ExplicitHeight = 400
    object cbAcceptTabPaste: TcxCheckBox [7]
      Left = 29
      Top = 196
      Hint = 'Accept each part of tab seperated text to individual control'
      Caption = 'Accept Tab Paste'
      Style.BorderColor = clWindowFrame
      Style.BorderStyle = ebs3D
      Style.HotTrack = False
      TabOrder = 7
    end
    object cbShowClearButton: TcxCheckBox [8]
      Left = 41
      Top = 241
      Caption = 'Show "Clear" button'
      Style.BorderColor = clWindowFrame
      Style.BorderStyle = ebs3D
      Style.HotTrack = False
      TabOrder = 8
    end
    object cbShowTodayButton: TcxCheckBox [9]
      Left = 168
      Top = 241
      Caption = 'Show "Today" button'
      Style.BorderColor = clWindowFrame
      Style.BorderStyle = ebs3D
      Style.HotTrack = False
      TabOrder = 9
    end
    object cbSaveTime: TcxCheckBox [10]
      Left = 41
      Top = 298
      Caption = 'Save time'
      Style.BorderColor = clWindowFrame
      Style.BorderStyle = ebs3D
      Style.HotTrack = False
      TabOrder = 10
    end
    object cbShowTime: TcxCheckBox [11]
      Left = 118
      Top = 298
      Caption = 'Show time'
      Style.BorderColor = clWindowFrame
      Style.BorderStyle = ebs3D
      Style.HotTrack = False
      TabOrder = 11
    end
    inherited AllPropertiesGroup: TdxLayoutGroup
      ItemIndex = 2
    end
    object dxLayoutItem1: TdxLayoutItem
      Parent = ExtendedPropertiesGroup
      AlignHorz = ahLeft
      CaptionOptions.Text = 'cxCheckBox1'
      CaptionOptions.Visible = False
      Control = cbAcceptTabPaste
      ControlOptions.OriginalHeight = 21
      ControlOptions.OriginalWidth = 108
      ControlOptions.ShowBorder = False
      Index = 0
    end
    object dxLayoutItem2: TdxLayoutItem
      Parent = dxLayoutGroup2
      AlignHorz = ahLeft
      AlignVert = avTop
      CaptionOptions.Text = 'cbShowClearButton'
      CaptionOptions.Visible = False
      Control = cbShowClearButton
      ControlOptions.OriginalHeight = 21
      ControlOptions.OriginalWidth = 121
      ControlOptions.ShowBorder = False
      Index = 0
    end
    object dxLayoutItem3: TdxLayoutItem
      Parent = dxLayoutGroup2
      AlignHorz = ahLeft
      AlignVert = avClient
      CaptionOptions.Text = 'cxCheckBox1'
      CaptionOptions.Visible = False
      Control = cbShowTodayButton
      ControlOptions.OriginalHeight = 21
      ControlOptions.OriginalWidth = 126
      ControlOptions.ShowBorder = False
      Index = 1
    end
    object dxLayoutItem4: TdxLayoutItem
      Parent = dxLayoutGroup1
      AlignHorz = ahLeft
      AlignVert = avClient
      CaptionOptions.Text = 'cxCheckBox2'
      CaptionOptions.Visible = False
      Control = cbSaveTime
      ControlOptions.OriginalHeight = 21
      ControlOptions.OriginalWidth = 71
      ControlOptions.ShowBorder = False
      Index = 0
    end
    object dxLayoutItem5: TdxLayoutItem
      Parent = dxLayoutGroup1
      AlignHorz = ahLeft
      AlignVert = avTop
      CaptionOptions.Text = 'cxCheckBox3'
      CaptionOptions.Visible = False
      Control = cbShowTime
      ControlOptions.OriginalHeight = 21
      ControlOptions.OriginalWidth = 73
      ControlOptions.ShowBorder = False
      Index = 1
    end
    object dxLayoutGroup1: TdxLayoutGroup
      Parent = ExtendedPropertiesGroup
      CaptionOptions.Text = 'Time settings'
      ButtonOptions.Buttons = <>
      LayoutDirection = ldHorizontal
      Index = 2
    end
    object dxLayoutGroup2: TdxLayoutGroup
      Parent = ExtendedPropertiesGroup
      CaptionOptions.Text = 'Buttons'
      ButtonOptions.Buttons = <>
      ItemIndex = 1
      LayoutDirection = ldHorizontal
      Index = 1
    end
  end
end
