inherited ControlEditorMiceGridFrame: TControlEditorMiceGridFrame
  Caption = 'MiceGridFrame Properties'
  ClientHeight = 553
  ClientWidth = 609
  ExplicitWidth = 625
  ExplicitHeight = 591
  PixelsPerInch = 96
  TextHeight = 13
  inherited pnBottomButtons: TPanel
    Top = 512
    Width = 609
    ExplicitTop = 512
    ExplicitWidth = 609
    inherited bnOK: TcxButton
      Left = 439
      ExplicitLeft = 439
    end
    inherited bnCancel: TcxButton
      Left = 520
      ExplicitLeft = 520
    end
  end
  inherited DialogLayout: TdxLayoutControl
    Width = 609
    Height = 512
    ExplicitWidth = 609
    ExplicitHeight = 512
    inherited ddVisibleCondition: TcxDBImageComboBox
      TabOrder = 14
    end
    inherited ddEnabledCondition: TcxDBImageComboBox
      TabOrder = 15
    end
    inherited chbReadOnly: TcxCheckBox
      TabOrder = 16
    end
    inherited cbCaption: TcxDBComboBox
      ExplicitWidth = 283
      Width = 283
    end
    inherited edControlName: TcxDBButtonEdit
      ExplicitWidth = 283
      Width = 283
    end
    inline ColorEditor: TMiceGridColorEditorFrame [7]
      Left = 10000
      Top = 10000
      Width = 523
      Height = 296
      TabOrder = 10
      Visible = False
      ExplicitLeft = 10000
      ExplicitTop = 10000
      ExplicitWidth = 523
      ExplicitHeight = 296
      inherited gridColumns: TcxGrid
        Width = 523
        Height = 296
        ExplicitWidth = 523
        ExplicitHeight = 296
      end
    end
    inline ColumnEditor: TColumnEditorFrame [8]
      Left = 10000
      Top = 10000
      Width = 523
      Height = 296
      TabOrder = 9
      Visible = False
      ExplicitLeft = 10000
      ExplicitTop = 10000
      ExplicitWidth = 523
      ExplicitHeight = 296
      inherited gridColumns: TcxGrid
        Width = 523
        Height = 296
        ExplicitWidth = 523
        ExplicitHeight = 296
      end
    end
    object cbSorting: TcxCheckBox [9]
      Left = 173
      Top = 245
      Caption = 'Sorting'
      Style.BorderColor = clWindowFrame
      Style.BorderStyle = ebs3D
      Style.HotTrack = False
      TabOrder = 7
    end
    object cbGroupBy: TcxCheckBox [10]
      Left = 237
      Top = 245
      AutoSize = False
      Caption = 'Group by box'
      Style.BorderColor = clWindowFrame
      Style.BorderStyle = ebs3D
      Style.HotTrack = False
      TabOrder = 8
      Height = 21
      Width = 89
    end
    object cbAutoWidth: TcxCheckBox [11]
      Left = 55
      Top = 245
      AutoSize = False
      Caption = 'Auto column width'
      Style.BorderColor = clWindowFrame
      Style.BorderStyle = ebs3D
      Style.HotTrack = False
      TabOrder = 6
      Height = 21
      Width = 112
    end
    object edProviderName: TcxButtonEdit [12]
      Left = 166
      Top = 191
      Properties.Buttons = <
        item
          Default = True
          Kind = bkEllipsis
        end>
      Properties.OnButtonClick = edProviderNamePropertiesButtonClick
      Properties.OnChange = edProviderNamePropertiesChange
      Style.BorderColor = clWindowFrame
      Style.BorderStyle = ebs3D
      Style.HotTrack = False
      Style.ButtonStyle = bts3D
      TabOrder = 4
      Width = 388
    end
    object cbShowEditButtons: TcxCheckBox [13]
      Left = 10000
      Top = 10000
      Caption = 'Show edit buttons'
      Style.BorderColor = clWindowFrame
      Style.BorderStyle = ebs3D
      Style.HotTrack = False
      TabOrder = 11
      Visible = False
    end
    object edappDialogID: TcxButtonEdit [14]
      Left = 10000
      Top = 10000
      Properties.Buttons = <
        item
          Default = True
          Kind = bkEllipsis
        end
        item
          ImageIndex = 228
          Kind = bkGlyph
        end>
      Properties.Images = ImageContainer.Images16
      Properties.ReadOnly = True
      Properties.OnButtonClick = edappDialogIDPropertiesButtonClick
      Style.BorderColor = clWindowFrame
      Style.BorderStyle = ebs3D
      Style.HotTrack = False
      Style.ButtonStyle = bts3D
      TabOrder = 12
      Visible = False
      Width = 399
    end
    object edAppDialogLayoutsIdFieldName: TcxTextEdit [15]
      Left = 10000
      Top = 10000
      Style.BorderColor = clWindowFrame
      Style.BorderStyle = ebs3D
      Style.HotTrack = False
      TabOrder = 13
      Visible = False
      Width = 399
    end
    object edKeyField: TcxTextEdit [16]
      Left = 166
      Top = 218
      Style.BorderColor = clWindowFrame
      Style.BorderStyle = ebs3D
      Style.HotTrack = False
      TabOrder = 5
      Width = 388
    end
    inherited DialogLayoutGroup_Root: TdxLayoutGroup [17]
    end
    inherited AllPropertiesGroup: TdxLayoutGroup [18]
      ItemIndex = 1
    end
    inherited CommonPropertiesGroup: TdxLayoutGroup [19]
    end
    inherited ControlActivityGroup: TdxLayoutGroup [20]
    end
    inherited ddVisibleCondition_Item: TdxLayoutItem [21]
    end
    inherited ddEnabledCondition_Item: TdxLayoutItem [22]
    end
    inherited ExtendedPropertiesGroup: TdxLayoutGroup [23]
      LayoutDirection = ldTabbed
    end
    inherited RuntimePropertiesGroup: TdxLayoutGroup [24]
    end
    inherited cbDBName_Item: TdxLayoutItem [25]
    end
    inherited chbReadOnly_Item: TdxLayoutItem [26]
    end
    inherited cbCaption_Item: TdxLayoutItem [27]
    end
    inherited edControlName_Item: TdxLayoutItem [28]
    end
    inherited cbDataField_Item: TdxLayoutItem [29]
    end
    object dxLayoutGroup1: TdxLayoutGroup
      Parent = ExtendedPropertiesGroup
      AlignVert = avClient
      CaptionOptions.Text = 'Columns'
      CaptionOptions.Visible = False
      ButtonOptions.Buttons = <>
      ShowBorder = False
      Index = 1
    end
    object dxLayoutGroup2: TdxLayoutGroup
      Parent = ExtendedPropertiesGroup
      CaptionOptions.Text = 'Common'
      ButtonOptions.Buttons = <>
      ItemIndex = 1
      Index = 0
    end
    object dxLayoutGroup3: TdxLayoutGroup
      Parent = ExtendedPropertiesGroup
      CaptionOptions.Text = 'Colors'
      ButtonOptions.Buttons = <>
      Index = 2
    end
    object dxLayoutGroup4: TdxLayoutGroup
      Parent = ExtendedPropertiesGroup
      CaptionOptions.Text = 'Dialog'
      ButtonOptions.Buttons = <>
      Index = 3
    end
    object item_ColorFrame: TdxLayoutItem
      Parent = dxLayoutGroup3
      AlignVert = avClient
      CaptionOptions.Text = 'Colors'
      CaptionOptions.Visible = False
      Control = ColorEditor
      ControlOptions.AutoColor = True
      ControlOptions.OriginalHeight = 287
      ControlOptions.OriginalWidth = 575
      ControlOptions.ShowBorder = False
      Index = 0
    end
    object Item_Columns: TdxLayoutItem
      Parent = dxLayoutGroup1
      AlignVert = avClient
      CaptionOptions.Text = 'New Item'
      CaptionOptions.Visible = False
      Control = ColumnEditor
      ControlOptions.AutoColor = True
      ControlOptions.OriginalHeight = 329
      ControlOptions.OriginalWidth = 538
      ControlOptions.ShowBorder = False
      Index = 0
    end
    object dxLayoutItem1: TdxLayoutItem
      Parent = dxLayoutAutoCreatedGroup3
      AlignVert = avClient
      CaptionOptions.Text = 'New Item'
      CaptionOptions.Visible = False
      Control = cbAutoWidth
      ControlOptions.OriginalHeight = 21
      ControlOptions.OriginalWidth = 112
      ControlOptions.ShowBorder = False
      Index = 0
    end
    object dxLayoutItem2: TdxLayoutItem
      Parent = dxLayoutAutoCreatedGroup3
      AlignVert = avClient
      CaptionOptions.Text = 'New Item'
      CaptionOptions.Visible = False
      Control = cbSorting
      ControlOptions.OriginalHeight = 21
      ControlOptions.OriginalWidth = 58
      ControlOptions.ShowBorder = False
      Index = 1
    end
    object dxLayoutItem3: TdxLayoutItem
      Parent = dxLayoutAutoCreatedGroup3
      AlignVert = avClient
      CaptionOptions.Text = 'New Item'
      CaptionOptions.Visible = False
      Control = cbGroupBy
      ControlOptions.OriginalHeight = 21
      ControlOptions.OriginalWidth = 89
      ControlOptions.ShowBorder = False
      Index = 2
    end
    object dxLayoutItem4: TdxLayoutItem
      Parent = dxLayoutGroup2
      CaptionOptions.Text = 'ProviderName Pattern'
      Control = edProviderName
      ControlOptions.OriginalHeight = 21
      ControlOptions.OriginalWidth = 121
      ControlOptions.ShowBorder = False
      Index = 0
    end
    object dxLayoutAutoCreatedGroup3: TdxLayoutAutoCreatedGroup
      Parent = dxLayoutGroup2
      LayoutDirection = ldHorizontal
      Index = 2
    end
    object dxLayoutItem5: TdxLayoutItem
      Parent = dxLayoutGroup4
      CaptionOptions.Text = 'cxCheckBox1'
      CaptionOptions.Visible = False
      Control = cbShowEditButtons
      ControlOptions.OriginalHeight = 21
      ControlOptions.OriginalWidth = 88
      ControlOptions.ShowBorder = False
      Index = 0
    end
    object item_edappDialogID: TdxLayoutItem
      Parent = dxLayoutGroup4
      CaptionOptions.Text = 'Dialog'
      Control = edappDialogID
      ControlOptions.OriginalHeight = 24
      ControlOptions.OriginalWidth = 121
      ControlOptions.ShowBorder = False
      Index = 1
    end
    object dxLayoutItem6: TdxLayoutItem
      Parent = dxLayoutGroup4
      CaptionOptions.Text = 'AppLayoutsId FieldName'
      Control = edAppDialogLayoutsIdFieldName
      ControlOptions.OriginalHeight = 21
      ControlOptions.OriginalWidth = 121
      ControlOptions.ShowBorder = False
      Index = 2
    end
    object item_KeyField: TdxLayoutItem
      Parent = dxLayoutGroup2
      CaptionOptions.Text = 'KeyField'
      Control = edKeyField
      ControlOptions.OriginalHeight = 21
      ControlOptions.OriginalWidth = 121
      ControlOptions.ShowBorder = False
      Index = 1
    end
  end
end
