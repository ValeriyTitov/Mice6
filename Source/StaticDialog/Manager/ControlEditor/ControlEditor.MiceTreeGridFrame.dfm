inherited ControlEditorMiceTreeGridFrame: TControlEditorMiceTreeGridFrame
  Caption = 'ControlEditorMiceTreeGridFrame'
  ClientHeight = 573
  ClientWidth = 626
  ExplicitWidth = 642
  ExplicitHeight = 611
  PixelsPerInch = 96
  TextHeight = 13
  inherited pnBottomButtons: TPanel
    Top = 532
    Width = 626
    ExplicitTop = 532
    ExplicitWidth = 626
    inherited bnOK: TcxButton
      Left = 456
      ExplicitLeft = 456
    end
    inherited bnCancel: TcxButton
      Left = 537
      ExplicitLeft = 537
    end
  end
  inherited DialogLayout: TdxLayoutControl
    Width = 626
    Height = 532
    ExplicitWidth = 626
    ExplicitHeight = 532
    inherited ddVisibleCondition: TcxDBImageComboBox
      TabOrder = 13
    end
    inherited ddEnabledCondition: TcxDBImageComboBox
      TabOrder = 14
    end
    inherited chbReadOnly: TcxCheckBox
      TabOrder = 15
    end
    inherited cbCaption: TcxDBComboBox
      ExplicitWidth = 300
      Width = 300
    end
    inherited edControlName: TcxDBButtonEdit
      ExplicitWidth = 300
      Width = 300
    end
    object edKeyField: TcxTextEdit [7]
      Left = 143
      Top = 218
      Style.BorderColor = clWindowFrame
      Style.BorderStyle = ebs3D
      Style.HotTrack = False
      TabOrder = 5
      Width = 428
    end
    object edParentIdField: TcxTextEdit [8]
      Left = 143
      Top = 245
      Style.BorderColor = clWindowFrame
      Style.BorderStyle = ebs3D
      Style.HotTrack = False
      TabOrder = 6
      Width = 428
    end
    inline ColorEditor: TMiceGridColorEditorFrame [9]
      Left = 10000
      Top = 10000
      Width = 540
      Height = 316
      TabOrder = 12
      Visible = False
      ExplicitLeft = 10000
      ExplicitTop = 10000
      ExplicitWidth = 540
      ExplicitHeight = 316
      inherited gridColumns: TcxGrid
        Width = 540
        Height = 316
        ExplicitWidth = 540
        ExplicitHeight = 316
      end
    end
    inline ColumnEditor: TColumnEditorFrame [10]
      Left = 10000
      Top = 10000
      Width = 540
      Height = 316
      TabOrder = 11
      Visible = False
      ExplicitLeft = 10000
      ExplicitTop = 10000
      ExplicitWidth = 540
      ExplicitHeight = 316
      inherited gridColumns: TcxGrid
        Width = 540
        Height = 316
        ExplicitWidth = 540
        ExplicitHeight = 316
      end
    end
    object edProviderName: TcxButtonEdit [11]
      Left = 143
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
      Width = 428
    end
    object edOrderIdField: TcxTextEdit [12]
      Left = 143
      Top = 272
      Style.BorderColor = clWindowFrame
      Style.BorderStyle = ebs3D
      Style.HotTrack = False
      TabOrder = 7
      Width = 428
    end
    object edImageIndexField: TcxTextEdit [13]
      Left = 143
      Top = 299
      Style.BorderColor = clWindowFrame
      Style.BorderStyle = ebs3D
      Style.HotTrack = False
      TabOrder = 8
      Width = 428
    end
    object cbAutoWidth: TcxCheckBox [14]
      Left = 55
      Top = 326
      AutoSize = False
      Caption = 'Auto column width'
      Style.BorderColor = clWindowFrame
      Style.BorderStyle = ebs3D
      Style.HotTrack = False
      TabOrder = 9
      Height = 21
      Width = 112
    end
    object cbSorting: TcxCheckBox [15]
      Left = 173
      Top = 326
      Caption = 'Sorting'
      Style.BorderColor = clWindowFrame
      Style.BorderStyle = ebs3D
      Style.HotTrack = False
      TabOrder = 10
    end
    inherited DialogLayoutGroup_Root: TdxLayoutGroup [16]
    end
    inherited AllPropertiesGroup: TdxLayoutGroup [17]
      ItemIndex = 1
    end
    inherited CommonPropertiesGroup: TdxLayoutGroup [18]
    end
    inherited ControlActivityGroup: TdxLayoutGroup [19]
    end
    inherited ddVisibleCondition_Item: TdxLayoutItem [20]
    end
    inherited ddEnabledCondition_Item: TdxLayoutItem [21]
    end
    inherited ExtendedPropertiesGroup: TdxLayoutGroup [22]
      LayoutDirection = ldTabbed
    end
    inherited RuntimePropertiesGroup: TdxLayoutGroup [23]
    end
    inherited cbDBName_Item: TdxLayoutItem [24]
    end
    inherited chbReadOnly_Item: TdxLayoutItem [25]
    end
    inherited cbCaption_Item: TdxLayoutItem [26]
    end
    inherited edControlName_Item: TdxLayoutItem [27]
    end
    inherited cbDataField_Item: TdxLayoutItem [28]
    end
    object dxLayoutGroup1: TdxLayoutGroup
      Parent = ExtendedPropertiesGroup
      AlignVert = avClient
      CaptionOptions.Text = 'Common'
      ButtonOptions.Buttons = <>
      ItemIndex = 5
      Index = 0
    end
    object dxLayoutGroup2: TdxLayoutGroup
      Parent = ExtendedPropertiesGroup
      CaptionOptions.Text = 'Columns'
      ButtonOptions.Buttons = <>
      Index = 1
    end
    object dxLayoutGroup3: TdxLayoutGroup
      Parent = ExtendedPropertiesGroup
      CaptionOptions.Text = 'Colors'
      ButtonOptions.Buttons = <>
      Index = 2
    end
    object Item_KeyField: TdxLayoutItem
      Parent = dxLayoutGroup1
      CaptionOptions.Text = 'KeyField'
      Control = edKeyField
      ControlOptions.OriginalHeight = 21
      ControlOptions.OriginalWidth = 121
      ControlOptions.ShowBorder = False
      Index = 1
    end
    object Item_ParentIdField: TdxLayoutItem
      Parent = dxLayoutGroup1
      CaptionOptions.Text = 'ParentId Field'
      Control = edParentIdField
      ControlOptions.OriginalHeight = 21
      ControlOptions.OriginalWidth = 121
      ControlOptions.ShowBorder = False
      Index = 2
    end
    object Item_ColorEditor: TdxLayoutItem
      Parent = dxLayoutGroup3
      AlignVert = avClient
      CaptionOptions.Visible = False
      Control = ColorEditor
      ControlOptions.AutoColor = True
      ControlOptions.OriginalHeight = 296
      ControlOptions.OriginalWidth = 523
      ControlOptions.ShowBorder = False
      Index = 0
    end
    object Item_ColumnEditor: TdxLayoutItem
      Parent = dxLayoutGroup2
      AlignVert = avClient
      CaptionOptions.Visible = False
      Control = ColumnEditor
      ControlOptions.AutoColor = True
      ControlOptions.OriginalHeight = 296
      ControlOptions.OriginalWidth = 523
      ControlOptions.ShowBorder = False
      Index = 0
    end
    object Item_edProviderName: TdxLayoutItem
      Parent = dxLayoutGroup1
      CaptionOptions.Text = 'ProviderName'
      Control = edProviderName
      ControlOptions.OriginalHeight = 21
      ControlOptions.OriginalWidth = 121
      ControlOptions.ShowBorder = False
      Index = 0
    end
    object item_OrderIdField: TdxLayoutItem
      Parent = dxLayoutGroup1
      CaptionOptions.Text = 'OrderId Field'
      Control = edOrderIdField
      ControlOptions.OriginalHeight = 21
      ControlOptions.OriginalWidth = 121
      ControlOptions.ShowBorder = False
      Index = 3
    end
    object Item_ImageIndexField: TdxLayoutItem
      Parent = dxLayoutGroup1
      CaptionOptions.Text = 'ImageIndex Field'
      Control = edImageIndexField
      ControlOptions.OriginalHeight = 21
      ControlOptions.OriginalWidth = 121
      ControlOptions.ShowBorder = False
      Index = 4
    end
    object dxLayoutItem1: TdxLayoutItem
      Parent = dxLayoutAutoCreatedGroup3
      AlignHorz = ahLeft
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
    object dxLayoutAutoCreatedGroup3: TdxLayoutAutoCreatedGroup
      Parent = dxLayoutGroup1
      LayoutDirection = ldHorizontal
      Index = 5
    end
  end
end
