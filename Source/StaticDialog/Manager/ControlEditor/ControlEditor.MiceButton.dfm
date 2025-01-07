inherited ControlEditorMiceButton: TControlEditorMiceButton
  Caption = 'MiceButton Properties'
  PixelsPerInch = 96
  TextHeight = 13
  inherited DialogLayout: TdxLayoutControl
    inherited ddVisibleCondition: TcxDBImageComboBox
      TabOrder = 5
    end
    inherited ddEnabledCondition: TcxDBImageComboBox
      TabOrder = 6
    end
    inherited chbReadOnly: TcxCheckBox
      TabOrder = 7
    end
    inherited cbDataField: TcxDBComboBox
      Enabled = False
    end
    inherited cbDBName: TcxDBComboBox
      Enabled = False
    end
    object btnSelectImage: TcxButton [7]
      Left = 29
      Top = 139
      Width = 110
      Height = 25
      Caption = 'Select Image'
      OptionsImage.Images = ImageContainer.Images16
      TabOrder = 4
      OnClick = btnSelectImageClick
    end
    inherited AllPropertiesGroup: TdxLayoutGroup
      ItemIndex = 1
    end
    inherited cbDBName_Item: TdxLayoutItem
      Enabled = False
    end
    inherited cbDataField_Item: TdxLayoutItem
      Enabled = False
    end
    object item_btnSelectImage: TdxLayoutItem
      Parent = ExtendedPropertiesGroup
      AlignHorz = ahLeft
      CaptionOptions.Text = 'cxButton1'
      CaptionOptions.Visible = False
      Control = btnSelectImage
      ControlOptions.OriginalHeight = 25
      ControlOptions.OriginalWidth = 110
      ControlOptions.ShowBorder = False
      Index = 0
    end
  end
end
