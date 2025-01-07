inherited ControlEditMiceRadioGroup: TControlEditMiceRadioGroup
  Caption = 'Radio Group Properties'
  ClientHeight = 597
  ClientWidth = 635
  ExplicitWidth = 651
  ExplicitHeight = 635
  PixelsPerInch = 96
  TextHeight = 13
  inherited pnBottomButtons: TPanel
    Top = 556
    Width = 635
    ExplicitTop = 556
    ExplicitWidth = 635
    inherited bnOK: TcxButton
      Left = 465
      ExplicitLeft = 465
    end
    inherited bnCancel: TcxButton
      Left = 546
      ExplicitLeft = 546
    end
  end
  inherited DialogLayout: TdxLayoutControl
    Width = 635
    Height = 556
    ExplicitWidth = 635
    ExplicitHeight = 556
    inherited ddVisibleCondition: TcxDBImageComboBox
      TabOrder = 6
    end
    inherited ddEnabledCondition: TcxDBImageComboBox
      TabOrder = 7
    end
    inherited chbReadOnly: TcxCheckBox
      TabOrder = 8
    end
    inherited cbCaption: TcxDBComboBox
      ExplicitWidth = 327
      Width = 327
    end
    inherited edControlName: TcxDBButtonEdit
      ExplicitWidth = 327
      Width = 327
    end
    inline ddFrame: TDropDownEditorFrame [7]
      Left = 29
      Top = 166
      Width = 577
      Height = 361
      TabOrder = 5
      ExplicitLeft = 29
      ExplicitTop = 166
      ExplicitWidth = 577
      ExplicitHeight = 361
      inherited ddLayout: TdxLayoutControl
        Width = 577
        Height = 361
        ExplicitWidth = 577
        ExplicitHeight = 352
        inherited gridItems: TcxTreeList
          Width = 571
          Height = 244
          ExplicitWidth = 571
          ExplicitHeight = 244
          inherited gridItemsColumn5: TcxTreeListColumn
            Visible = False
          end
          inherited colImageIndex: TcxTreeListColumn
            Visible = False
          end
        end
        inherited edDDProviderName: TcxButtonEdit
          Top = 325
          ExplicitTop = 325
          ExplicitWidth = 300
          Width = 300
        end
        inherited cbDBName: TcxComboBox
          Left = 441
          Top = 325
          ExplicitLeft = 441
          ExplicitTop = 325
        end
        inherited cbAddAll: TcxCheckBox
          Top = 271
          ExplicitTop = 271
        end
        inherited cbAddNone: TcxCheckBox
          Top = 298
          ExplicitTop = 298
        end
        inherited edAllValue: TcxTextEdit
          Left = 441
          Top = 271
          ExplicitLeft = 441
          ExplicitTop = 271
        end
        inherited edNoneValue: TcxTextEdit
          Left = 441
          Top = 298
          ExplicitLeft = 441
          ExplicitTop = 298
        end
        inherited FrmGrpBottom: TdxLayoutGroup
          Visible = False
        end
        inherited item_ddDBName: TdxLayoutItem
          Visible = False
        end
      end
    end
    object seColumnsN: TcxSpinEdit [8]
      Left = 82
      Top = 139
      Properties.MaxValue = 10.000000000000000000
      Properties.MinValue = 1.000000000000000000
      Style.BorderColor = clWindowFrame
      Style.BorderStyle = ebs3D
      Style.HotTrack = False
      Style.ButtonStyle = bts3D
      TabOrder = 4
      Value = 1
      Width = 524
    end
    inherited DialogLayoutGroup_Root: TdxLayoutGroup [9]
    end
    inherited AllPropertiesGroup: TdxLayoutGroup [10]
      ItemIndex = 1
    end
    inherited CommonPropertiesGroup: TdxLayoutGroup [11]
    end
    inherited ControlActivityGroup: TdxLayoutGroup [12]
    end
    inherited ddVisibleCondition_Item: TdxLayoutItem [13]
    end
    inherited ddEnabledCondition_Item: TdxLayoutItem [14]
    end
    inherited ExtendedPropertiesGroup: TdxLayoutGroup [15]
    end
    inherited RuntimePropertiesGroup: TdxLayoutGroup [16]
    end
    inherited cbDBName_Item: TdxLayoutItem [17]
    end
    inherited chbReadOnly_Item: TdxLayoutItem [18]
    end
    inherited cbCaption_Item: TdxLayoutItem [19]
    end
    inherited edControlName_Item: TdxLayoutItem [20]
    end
    inherited cbDataField_Item: TdxLayoutItem [21]
    end
    inherited dxLayoutAutoCreatedGroup1: TdxLayoutAutoCreatedGroup [22]
    end
    object item_ddFrame: TdxLayoutItem
      Parent = ExtendedPropertiesGroup
      AlignVert = avClient
      CaptionOptions.Text = 'New Item'
      CaptionOptions.Visible = False
      Control = ddFrame
      ControlOptions.AutoColor = True
      ControlOptions.OriginalHeight = 300
      ControlOptions.OriginalWidth = 492
      ControlOptions.ShowBorder = False
      Index = 1
    end
    object dxLayoutGroup1: TdxLayoutGroup
      Parent = ExtendedPropertiesGroup
      CaptionOptions.Text = 'New Group'
      CaptionOptions.Visible = False
      ButtonOptions.Buttons = <>
      ShowBorder = False
      Index = 0
    end
    object item_seColumnsN: TdxLayoutItem
      Parent = dxLayoutGroup1
      CaptionOptions.Text = 'Columns'
      Control = seColumnsN
      ControlOptions.OriginalHeight = 21
      ControlOptions.OriginalWidth = 121
      ControlOptions.ShowBorder = False
      Index = 0
    end
  end
end
