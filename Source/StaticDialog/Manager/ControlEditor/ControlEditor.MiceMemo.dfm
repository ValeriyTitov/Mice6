inherited ControlEditorMiceMemo: TControlEditorMiceMemo
  Caption = 'ControlEditorMiceMemo'
  PixelsPerInch = 96
  TextHeight = 13
  inherited DialogLayout: TdxLayoutControl
    inherited ddVisibleCondition: TcxDBImageComboBox
      TabOrder = 8
    end
    inherited ddEnabledCondition: TcxDBImageComboBox
      TabOrder = 9
    end
    inherited chbReadOnly: TcxCheckBox
      TabOrder = 10
    end
    object cbRemoveDualSpaces: TcxCheckBox [7]
      Left = 29
      Top = 139
      Caption = 'Remove dual spaces'
      Style.BorderColor = clWindowFrame
      Style.BorderStyle = ebs3D
      Style.HotTrack = False
      TabOrder = 4
    end
    object cbTrimOnPost: TcxCheckBox [8]
      Left = 157
      Top = 139
      Caption = 'Trim on post'
      Style.BorderColor = clWindowFrame
      Style.BorderStyle = ebs3D
      Style.HotTrack = False
      TabOrder = 5
    end
    object cbSpellCheck: TcxCheckBox [9]
      Left = 246
      Top = 139
      Caption = 'Spell check'
      Style.BorderColor = clWindowFrame
      Style.BorderStyle = ebs3D
      Style.HotTrack = False
      TabOrder = 6
    end
    object cbAcceptTabPaste: TcxCheckBox [10]
      Left = 328
      Top = 139
      Hint = 'Accept each part of tab seperated text to individual control'
      Caption = 'Accept Tab Paste'
      Style.BorderColor = clWindowFrame
      Style.BorderStyle = ebs3D
      Style.HotTrack = False
      TabOrder = 7
    end
    inherited AllPropertiesGroup: TdxLayoutGroup
      ItemIndex = 1
    end
    inherited ExtendedPropertiesGroup: TdxLayoutGroup
      ItemIndex = 2
      LayoutDirection = ldHorizontal
    end
    object cbRemoveDualSpaces_Item: TdxLayoutItem
      Parent = ExtendedPropertiesGroup
      AlignHorz = ahLeft
      AlignVert = avTop
      CaptionOptions.Text = 'cxCheckBox1'
      CaptionOptions.Visible = False
      Control = cbRemoveDualSpaces
      ControlOptions.OriginalHeight = 21
      ControlOptions.OriginalWidth = 122
      ControlOptions.ShowBorder = False
      Index = 0
    end
    object cbTrimOnPost_Item: TdxLayoutItem
      Parent = ExtendedPropertiesGroup
      AlignHorz = ahLeft
      AlignVert = avTop
      CaptionOptions.Text = 'cxCheckBox2'
      CaptionOptions.Visible = False
      Control = cbTrimOnPost
      ControlOptions.OriginalHeight = 21
      ControlOptions.OriginalWidth = 83
      ControlOptions.ShowBorder = False
      Index = 1
    end
    object cbSpellCheck_Item: TdxLayoutItem
      Parent = ExtendedPropertiesGroup
      CaptionOptions.Text = 'cxCheckBox1'
      CaptionOptions.Visible = False
      Control = cbSpellCheck
      ControlOptions.OriginalHeight = 21
      ControlOptions.OriginalWidth = 76
      ControlOptions.ShowBorder = False
      Index = 2
    end
    object dxLayoutItem1: TdxLayoutItem
      Parent = ExtendedPropertiesGroup
      CaptionOptions.Text = 'cxCheckBox1'
      CaptionOptions.Visible = False
      Control = cbAcceptTabPaste
      ControlOptions.OriginalHeight = 21
      ControlOptions.OriginalWidth = 108
      ControlOptions.ShowBorder = False
      Index = 3
    end
  end
end
