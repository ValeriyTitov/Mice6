inherited ControlEditorMiceValuePicker: TControlEditorMiceValuePicker
  Caption = 'MiceValuePicker Properties'
  ClientHeight = 719
  ClientWidth = 694
  ExplicitWidth = 710
  ExplicitHeight = 757
  PixelsPerInch = 96
  TextHeight = 13
  inherited pnBottomButtons: TPanel
    Top = 678
    Width = 694
    ExplicitTop = 678
    ExplicitWidth = 694
    inherited bnOK: TcxButton
      Left = 524
      ExplicitLeft = 524
    end
    inherited bnCancel: TcxButton
      Left = 605
      ExplicitLeft = 605
    end
  end
  inherited DialogLayout: TdxLayoutControl
    Width = 694
    Height = 678
    ExplicitWidth = 694
    ExplicitHeight = 678
    inherited ddVisibleCondition: TcxDBImageComboBox
      TabOrder = 17
    end
    inherited ddEnabledCondition: TcxDBImageComboBox
      TabOrder = 18
    end
    inherited chbReadOnly: TcxCheckBox
      TabOrder = 19
    end
    inherited cbCaption: TcxDBComboBox
      Left = 339
      ExplicitLeft = 339
      ExplicitWidth = 317
      Width = 317
    end
    inherited edControlName: TcxDBButtonEdit
      Left = 339
      ExplicitLeft = 339
      ExplicitWidth = 317
      Width = 317
    end
    inherited cbDataField: TcxDBComboBox
      Left = 142
      OnExit = cbDataFieldExit
      ExplicitLeft = 142
    end
    inherited cbDBName: TcxDBComboBox
      Left = 142
      ExplicitLeft = 142
    end
    object edProvider: TcxButtonEdit [7]
      Left = 142
      Top = 181
      Hint = 
        'Should return list of possible key values and they caption.  '#13#10'R' +
        'ecomended to limit records with keyfield value.'#13#10#13#10'Example:  spu' +
        'i_ItemList @ItemId=<ParentId>'
      Properties.Buttons = <
        item
          Default = True
          Kind = bkEllipsis
        end>
      Properties.OnButtonClick = edProviderPropertiesButtonClick
      Style.BorderColor = clWindowFrame
      Style.BorderStyle = ebs3D
      Style.HotTrack = False
      Style.ButtonStyle = bts3D
      TabOrder = 7
      Width = 514
    end
    object edParentId: TcxTextEdit [8]
      Left = 141
      Top = 400
      Hint = 'Required for Tree dialog type'
      Style.BorderColor = clWindowFrame
      Style.BorderStyle = ebs3D
      Style.HotTrack = False
      TabOrder = 13
      Width = 500
    end
    object edEnabledValue: TcxTextEdit [9]
      Left = 141
      Top = 454
      Style.BorderColor = clWindowFrame
      Style.BorderStyle = ebs3D
      Style.HotTrack = False
      TabOrder = 15
      Width = 121
    end
    object edImageIndex: TcxTextEdit [10]
      Left = 141
      Top = 310
      Style.BorderColor = clWindowFrame
      Style.BorderStyle = ebs3D
      Style.HotTrack = False
      TabOrder = 11
      Width = 500
    end
    object edEnabledField: TcxTextEdit [11]
      Left = 141
      Top = 427
      Style.BorderColor = clWindowFrame
      Style.BorderStyle = ebs3D
      Style.HotTrack = False
      TabOrder = 14
      Width = 121
    end
    object edKeyField: TcxTextEdit [12]
      Left = 141
      Top = 256
      Hint = 'Key field for validation and list providers'
      Properties.ReadOnly = False
      Style.BorderColor = clWindowFrame
      Style.BorderStyle = ebs3D
      Style.HotTrack = False
      TabOrder = 9
      Width = 500
    end
    object edListProviderName: TcxButtonEdit [13]
      Left = 142
      Top = 208
      Properties.Buttons = <
        item
          Default = True
          Kind = bkEllipsis
        end>
      Properties.OnButtonClick = edListProviderNamePropertiesButtonClick
      Style.BorderColor = clWindowFrame
      Style.BorderStyle = ebs3D
      Style.HotTrack = False
      Style.ButtonStyle = bts3D
      TabOrder = 8
      Width = 514
    end
    object cbDialogType: TcxImageComboBox [14]
      Left = 142
      Top = 154
      AutoSize = False
      Properties.Images = ImageContainer.Images16
      Properties.Items = <
        item
          Description = 'Item Tree List'
          ImageIndex = 653
          Value = 1
        end
        item
          Description = 'Item List'
          ImageIndex = 178
          Value = 0
        end
        item
          Description = 'Grid'
          ImageIndex = 163
          Value = 2
        end>
      Properties.OnChange = cbDialogTypePropertiesChange
      Style.BorderColor = clWindowFrame
      Style.BorderStyle = ebs3D
      Style.HotTrack = False
      Style.ButtonStyle = bts3D
      Style.PopupBorderStyle = epbsFrame3D
      TabOrder = 5
      Height = 21
      Width = 424
    end
    object edDescriptionFieldName: TcxTextEdit [15]
      Left = 141
      Top = 337
      Hint = 
        'Optional. Displays item description in bottom of selection dialo' +
        'g'
      Style.BorderColor = clWindowFrame
      Style.BorderStyle = ebs3D
      Style.HotTrack = False
      TabOrder = 12
      Width = 500
    end
    object bnAuto: TcxButton [16]
      Left = 581
      Top = 615
      Width = 75
      Height = 25
      Caption = 'Auto'
      TabOrder = 4
      OnClick = bnAutoClick
    end
    object cbEnableClearButton: TcxCheckBox [17]
      Left = 572
      Top = 154
      Caption = 'Clear Button'
      Style.BorderColor = clWindowFrame
      Style.BorderStyle = ebs3D
      Style.HotTrack = False
      TabOrder = 6
    end
    object edCaptionField: TcxTextEdit [18]
      Left = 141
      Top = 283
      Hint = 'Item name field'
      Style.BorderColor = clWindowFrame
      Style.BorderStyle = ebs3D
      Style.HotTrack = False
      TabOrder = 10
      Width = 500
    end
    object edGridRef: TcxButtonEdit [19]
      Left = 141
      Top = 517
      Properties.Buttons = <
        item
          Default = True
          Kind = bkEllipsis
        end>
      Properties.OnButtonClick = edGridRefPropertiesButtonClick
      Style.BorderColor = clWindowFrame
      Style.BorderStyle = ebs3D
      Style.HotTrack = False
      Style.ButtonStyle = bts3D
      TabOrder = 16
      Width = 500
    end
    inherited AllPropertiesGroup: TdxLayoutGroup
      ItemIndex = 1
    end
    inherited ExtendedPropertiesGroup: TdxLayoutGroup
      ItemIndex = 4
    end
    object edProvider_Item: TdxLayoutItem
      Parent = ExtendedPropertiesGroup
      CaptionOptions.Text = 'Validation Provider'
      Control = edProvider
      ControlOptions.OriginalHeight = 21
      ControlOptions.OriginalWidth = 121
      ControlOptions.ShowBorder = False
      Index = 2
    end
    object dxLayoutItem1: TdxLayoutItem
      Parent = item_TreeGroup
      CaptionOptions.Text = 'ParentId Field'
      Control = edParentId
      ControlOptions.OriginalHeight = 21
      ControlOptions.OriginalWidth = 121
      ControlOptions.ShowBorder = False
      Index = 0
    end
    object dxLayoutItem2: TdxLayoutItem
      Parent = item_TreeGroup
      AlignHorz = ahLeft
      CaptionOptions.Text = 'Enabled Value'
      Control = edEnabledValue
      ControlOptions.OriginalHeight = 21
      ControlOptions.OriginalWidth = 121
      ControlOptions.ShowBorder = False
      Index = 2
    end
    object dxLayoutItem3: TdxLayoutItem
      Parent = item_DataFields
      CaptionOptions.Text = 'ImageIndex Field'
      Control = edImageIndex
      ControlOptions.OriginalHeight = 21
      ControlOptions.OriginalWidth = 121
      ControlOptions.ShowBorder = False
      Index = 2
    end
    object dxLayoutItem4: TdxLayoutItem
      Parent = item_TreeGroup
      AlignHorz = ahLeft
      CaptionOptions.Text = 'Enabled Field'
      Control = edEnabledField
      ControlOptions.OriginalHeight = 21
      ControlOptions.OriginalWidth = 121
      ControlOptions.ShowBorder = False
      Index = 1
    end
    object item_DataFields: TdxLayoutGroup
      Parent = ExtendedPropertiesGroup
      CaptionOptions.Text = 'Datafields'
      ButtonOptions.Buttons = <>
      ItemIndex = 3
      Index = 4
    end
    object dxLayoutItem5: TdxLayoutItem
      Parent = item_DataFields
      CaptionOptions.Text = 'Keyfield'
      Control = edKeyField
      ControlOptions.OriginalHeight = 21
      ControlOptions.OriginalWidth = 121
      ControlOptions.ShowBorder = False
      Index = 0
    end
    object dxLayoutItem6: TdxLayoutItem
      Parent = ExtendedPropertiesGroup
      CaptionOptions.Text = 'Dialog ProviderName'
      Control = edListProviderName
      ControlOptions.OriginalHeight = 21
      ControlOptions.OriginalWidth = 121
      ControlOptions.ShowBorder = False
      Index = 3
    end
    object dxLayoutItem7: TdxLayoutItem
      Parent = dxLayoutAutoCreatedGroup3
      AlignHorz = ahClient
      CaptionOptions.Text = 'Dialog Type'
      Control = cbDialogType
      ControlOptions.OriginalHeight = 21
      ControlOptions.OriginalWidth = 121
      ControlOptions.ShowBorder = False
      Index = 0
    end
    object dxLayoutItem8: TdxLayoutItem
      Parent = item_DataFields
      CaptionOptions.Text = 'Description Field'
      Control = edDescriptionFieldName
      ControlOptions.OriginalHeight = 21
      ControlOptions.OriginalWidth = 121
      ControlOptions.ShowBorder = False
      Index = 3
    end
    object dxLayoutItem9: TdxLayoutItem
      Parent = ExtendedPropertiesGroup
      AlignHorz = ahRight
      AlignVert = avBottom
      CaptionOptions.Text = 'cxButton1'
      CaptionOptions.Visible = False
      Control = bnAuto
      ControlOptions.OriginalHeight = 25
      ControlOptions.OriginalWidth = 75
      ControlOptions.ShowBorder = False
      Index = 0
    end
    object dxLayoutItem10: TdxLayoutItem
      Parent = dxLayoutAutoCreatedGroup3
      AlignVert = avClient
      CaptionOptions.Text = 'Enable "Clear" Button'
      CaptionOptions.Visible = False
      Control = cbEnableClearButton
      ControlOptions.OriginalHeight = 21
      ControlOptions.OriginalWidth = 84
      ControlOptions.ShowBorder = False
      Index = 1
    end
    object dxLayoutItem11: TdxLayoutItem
      Parent = item_DataFields
      CaptionOptions.Text = 'Caption Field'
      Control = edCaptionField
      ControlOptions.OriginalHeight = 21
      ControlOptions.OriginalWidth = 121
      ControlOptions.ShowBorder = False
      Index = 1
    end
    object dxLayoutAutoCreatedGroup3: TdxLayoutAutoCreatedGroup
      Parent = ExtendedPropertiesGroup
      LayoutDirection = ldHorizontal
      Index = 1
    end
    object item_TreeGroup: TdxLayoutGroup
      Parent = ExtendedPropertiesGroup
      CaptionOptions.Text = 'Tree Dialog Fields'
      ButtonOptions.Buttons = <>
      ItemIndex = 2
      Index = 5
    end
    object item_GridReference: TdxLayoutGroup
      Parent = ExtendedPropertiesGroup
      CaptionOptions.Text = 'Grid Refrence'
      ButtonOptions.Buttons = <>
      Index = 6
    end
    object item_edGridReference: TdxLayoutItem
      Parent = item_GridReference
      CaptionOptions.Text = 'Grid Reference'
      Control = edGridRef
      ControlOptions.OriginalHeight = 21
      ControlOptions.OriginalWidth = 121
      ControlOptions.ShowBorder = False
      Index = 0
    end
  end
end
