inherited ControlEditorMiceCheckBox: TControlEditorMiceCheckBox
  Caption = 'ControlEditorMiceCheckBox'
  PixelsPerInch = 96
  TextHeight = 13
  inherited DialogLayout: TdxLayoutControl
    object edChecked: TcxTextEdit [7]
      Left = 115
      Top = 139
      Style.BorderColor = clWindowFrame
      Style.BorderStyle = ebs3D
      Style.HotTrack = False
      TabOrder = 4
      Text = 'edChecked'
      Width = 121
    end
    object edGrayed: TcxTextEdit [8]
      Left = 115
      Top = 193
      Style.BorderColor = clWindowFrame
      Style.BorderStyle = ebs3D
      Style.HotTrack = False
      TabOrder = 6
      Text = 'edGrayed'
      Width = 121
    end
    object edUnchecked: TcxTextEdit [9]
      Left = 115
      Top = 166
      Style.BorderColor = clWindowFrame
      Style.BorderStyle = ebs3D
      Style.HotTrack = False
      TabOrder = 5
      Text = 'edUnchecked'
      Width = 121
    end
    inherited AllPropertiesGroup: TdxLayoutGroup
      ItemIndex = 1
    end
    inherited ExtendedPropertiesGroup: TdxLayoutGroup
      ItemIndex = 2
    end
    inherited cbDBName_Item: TdxLayoutItem
      ControlOptions.OriginalWidth = 198
    end
    object edChecked_Item: TdxLayoutItem
      Parent = ExtendedPropertiesGroup
      AlignHorz = ahLeft
      CaptionOptions.Text = 'Checked value'
      Control = edChecked
      ControlOptions.OriginalHeight = 21
      ControlOptions.OriginalWidth = 121
      ControlOptions.ShowBorder = False
      Index = 0
    end
    object edGrayed_Item: TdxLayoutItem
      Parent = ExtendedPropertiesGroup
      AlignHorz = ahLeft
      CaptionOptions.Text = 'Grayed value'
      Control = edGrayed
      ControlOptions.OriginalHeight = 21
      ControlOptions.OriginalWidth = 121
      ControlOptions.ShowBorder = False
      Index = 2
    end
    object edUnchecked_Item: TdxLayoutItem
      Parent = ExtendedPropertiesGroup
      AlignHorz = ahLeft
      CaptionOptions.Text = 'Unchecked value'
      Control = edUnchecked
      ControlOptions.OriginalHeight = 21
      ControlOptions.OriginalWidth = 121
      ControlOptions.ShowBorder = False
      Index = 1
    end
  end
end
