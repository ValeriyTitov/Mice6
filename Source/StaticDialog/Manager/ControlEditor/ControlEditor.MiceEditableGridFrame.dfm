inherited ControlEditorMiceEditableGridFrame: TControlEditorMiceEditableGridFrame
  Caption = 'Mice Editable GridFrame'
  ClientHeight = 577
  ClientWidth = 501
  ExplicitWidth = 517
  ExplicitHeight = 615
  PixelsPerInch = 96
  TextHeight = 13
  inherited pnBottomButtons: TPanel
    Top = 536
    Width = 501
    ExplicitTop = 536
    ExplicitWidth = 501
    inherited bnOK: TcxButton
      Left = 331
      ExplicitLeft = 331
    end
    inherited bnCancel: TcxButton
      Left = 412
      ExplicitLeft = 412
    end
  end
  inherited DialogLayout: TdxLayoutControl
    Width = 501
    Height = 536
    ExplicitWidth = 501
    ExplicitHeight = 536
    inherited ddVisibleCondition: TcxDBImageComboBox
      TabOrder = 10
    end
    inherited ddEnabledCondition: TcxDBImageComboBox
      TabOrder = 11
    end
    inherited chbReadOnly: TcxCheckBox
      TabOrder = 12
    end
    inherited cbCaption: TcxDBComboBox
      ExplicitWidth = 175
      Width = 175
    end
    inherited edControlName: TcxDBButtonEdit
      ExplicitWidth = 175
      Width = 175
    end
    inherited cbDataField: TcxDBComboBox
      Enabled = False
    end
    inherited cbDBName: TcxDBComboBox
      Enabled = False
    end
    inline ColumnEditor: TColumnEditorFrame [7]
      Left = 10000
      Top = 10000
      Width = 538
      Height = 329
      TabOrder = 8
      Visible = False
      ExplicitLeft = 10000
      ExplicitTop = 10000
      ExplicitWidth = 538
      ExplicitHeight = 329
      inherited gridColumns: TcxGrid
        Width = 538
        Height = 329
        ExplicitWidth = 538
        ExplicitHeight = 329
      end
    end
    object cbDataSource: TcxComboBox [8]
      Left = 95
      Top = 188
      Properties.DropDownListStyle = lsFixedList
      Properties.OnChange = cbDataSourcePropertiesChange
      Style.BorderColor = clWindowFrame
      Style.BorderStyle = ebs3D
      Style.HotTrack = False
      Style.ButtonStyle = bts3D
      Style.PopupBorderStyle = epbsFrame3D
      TabOrder = 4
      Width = 354
    end
    object cbGroupBy: TcxCheckBox [9]
      Left = 234
      Top = 215
      Caption = 'Group by box'
      Style.BorderColor = clWindowFrame
      Style.BorderStyle = ebs3D
      Style.HotTrack = False
      TabOrder = 7
    end
    object cbAutoWidth: TcxCheckBox [10]
      Left = 52
      Top = 215
      Caption = 'Auto column width'
      Style.BorderColor = clWindowFrame
      Style.BorderStyle = ebs3D
      Style.HotTrack = False
      TabOrder = 5
    end
    object cbSorting: TcxCheckBox [11]
      Left = 170
      Top = 215
      Caption = 'Sorting'
      Style.BorderColor = clWindowFrame
      Style.BorderStyle = ebs3D
      Style.HotTrack = False
      TabOrder = 6
    end
    inline ColorEditor: TMiceGridColorEditorFrame [12]
      Left = 10000
      Top = 10000
      Width = 538
      Height = 329
      TabOrder = 9
      Visible = False
      ExplicitLeft = 10000
      ExplicitTop = 10000
      ExplicitWidth = 538
      ExplicitHeight = 329
      inherited gridColumns: TcxGrid
        Width = 538
        Height = 329
        ExplicitWidth = 538
        ExplicitHeight = 329
      end
    end
    inherited DialogLayoutGroup_Root: TdxLayoutGroup [13]
    end
    inherited AllPropertiesGroup: TdxLayoutGroup [14]
      ItemIndex = 1
    end
    inherited CommonPropertiesGroup: TdxLayoutGroup [15]
    end
    inherited ControlActivityGroup: TdxLayoutGroup [16]
    end
    inherited ddVisibleCondition_Item: TdxLayoutItem [17]
    end
    inherited ddEnabledCondition_Item: TdxLayoutItem [18]
    end
    inherited ExtendedPropertiesGroup: TdxLayoutGroup [19]
      LayoutDirection = ldTabbed
    end
    inherited RuntimePropertiesGroup: TdxLayoutGroup [20]
    end
    inherited cbDBName_Item: TdxLayoutItem [21]
      Enabled = False
    end
    inherited chbReadOnly_Item: TdxLayoutItem [22]
    end
    inherited cbCaption_Item: TdxLayoutItem [23]
    end
    inherited edControlName_Item: TdxLayoutItem [24]
    end
    inherited cbDataField_Item: TdxLayoutItem [25]
      Enabled = False
    end
    object grpMain: TdxLayoutGroup
      Parent = ExtendedPropertiesGroup
      CaptionOptions.Text = 'Properties'
      ButtonOptions.Buttons = <>
      ShowBorder = False
      Index = 0
    end
    object grpColumns: TdxLayoutGroup
      Parent = ExtendedPropertiesGroup
      AlignVert = avClient
      CaptionOptions.Text = 'Columns'
      ButtonOptions.Buttons = <>
      ShowBorder = False
      Index = 1
    end
    object item_ColumnEditor: TdxLayoutItem
      Parent = grpColumns
      AlignHorz = ahClient
      AlignVert = avClient
      CaptionOptions.Text = 'New Item'
      CaptionOptions.Visible = False
      Control = ColumnEditor
      ControlOptions.AutoColor = True
      ControlOptions.OriginalHeight = 319
      ControlOptions.OriginalWidth = 450
      ControlOptions.ShowBorder = False
      Index = 0
    end
    object item_cbDataSource: TdxLayoutItem
      Parent = grpMain
      CaptionOptions.Text = 'Dataset'
      Control = cbDataSource
      ControlOptions.OriginalHeight = 21
      ControlOptions.OriginalWidth = 121
      ControlOptions.ShowBorder = False
      Index = 0
    end
    object dxLayoutItem1: TdxLayoutItem
      Parent = dxLayoutAutoCreatedGroup3
      AlignHorz = ahClient
      CaptionOptions.Text = 'cxCheckBox1'
      CaptionOptions.Visible = False
      Control = cbGroupBy
      ControlOptions.OriginalHeight = 21
      ControlOptions.OriginalWidth = 88
      ControlOptions.ShowBorder = False
      Index = 2
    end
    object dxLayoutItem2: TdxLayoutItem
      Parent = dxLayoutAutoCreatedGroup3
      AlignVert = avClient
      CaptionOptions.Text = 'cxCheckBox2'
      CaptionOptions.Visible = False
      Control = cbAutoWidth
      ControlOptions.OriginalHeight = 21
      ControlOptions.OriginalWidth = 112
      ControlOptions.ShowBorder = False
      Index = 0
    end
    object dxLayoutItem3: TdxLayoutItem
      Parent = dxLayoutAutoCreatedGroup3
      AlignVert = avClient
      CaptionOptions.Text = 'cxCheckBox3'
      CaptionOptions.Visible = False
      Control = cbSorting
      ControlOptions.OriginalHeight = 21
      ControlOptions.OriginalWidth = 58
      ControlOptions.ShowBorder = False
      Index = 1
    end
    object dxLayoutAutoCreatedGroup3: TdxLayoutAutoCreatedGroup
      Parent = grpMain
      LayoutDirection = ldHorizontal
      Index = 1
    end
    object Colors: TdxLayoutGroup
      Parent = ExtendedPropertiesGroup
      AlignVert = avClient
      CaptionOptions.Text = 'Colors'
      ButtonOptions.Buttons = <>
      Index = 2
    end
    object dxLayoutItem4: TdxLayoutItem
      Parent = Colors
      AlignHorz = ahClient
      AlignVert = avClient
      Control = ColorEditor
      ControlOptions.AutoColor = True
      ControlOptions.OriginalHeight = 287
      ControlOptions.OriginalWidth = 549
      ControlOptions.ShowBorder = False
      Index = 0
    end
  end
end
