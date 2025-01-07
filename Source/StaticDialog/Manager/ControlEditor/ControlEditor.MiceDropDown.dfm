inherited ControlEditorMiceDropDown: TControlEditorMiceDropDown
  Caption = 'TMiceDropDown Properites'
  ClientHeight = 610
  ClientWidth = 526
  ExplicitWidth = 542
  ExplicitHeight = 648
  PixelsPerInch = 96
  TextHeight = 13
  inherited pnBottomButtons: TPanel
    Top = 569
    Width = 526
    ExplicitTop = 569
    ExplicitWidth = 526
    inherited bnOK: TcxButton
      Left = 356
      ExplicitLeft = 356
    end
    inherited bnCancel: TcxButton
      Left = 437
      ExplicitLeft = 437
    end
  end
  inherited DialogLayout: TdxLayoutControl
    Width = 526
    Height = 569
    ExplicitWidth = 526
    ExplicitHeight = 569
    inherited ddVisibleCondition: TcxDBImageComboBox
      TabOrder = 5
    end
    inherited ddEnabledCondition: TcxDBImageComboBox
      Left = 295
      TabOrder = 6
      ExplicitLeft = 295
    end
    inherited chbReadOnly: TcxCheckBox
      Left = 426
      TabOrder = 7
      ExplicitLeft = 426
    end
    inherited cbCaption: TcxDBComboBox
      ExplicitWidth = 218
      Width = 218
    end
    inherited edControlName: TcxDBButtonEdit
      ExplicitWidth = 218
      Width = 218
    end
    inline ddFrame: TDropDownEditorFrame [7]
      Left = 17
      Top = 121
      Width = 492
      Height = 431
      TabOrder = 4
      ExplicitLeft = 17
      ExplicitTop = 121
      ExplicitWidth = 492
      ExplicitHeight = 431
      inherited ddLayout: TdxLayoutControl
        Width = 492
        Height = 431
        ExplicitWidth = 492
        ExplicitHeight = 431
        inherited gridItems: TcxTreeList
          Width = 486
          Height = 314
          ExplicitWidth = 486
          ExplicitHeight = 314
        end
        inherited edDDProviderName: TcxButtonEdit
          Top = 395
          ExplicitTop = 395
          ExplicitWidth = 215
          Width = 215
        end
        inherited cbDBName: TcxComboBox
          Left = 356
          Top = 395
          ExplicitLeft = 356
          ExplicitTop = 395
        end
        inherited cbAddAll: TcxCheckBox
          Top = 341
          ExplicitTop = 341
        end
        inherited cbAddNone: TcxCheckBox
          Top = 368
          ExplicitTop = 368
        end
        inherited edAllValue: TcxTextEdit
          Left = 356
          Top = 341
          ExplicitLeft = 356
          ExplicitTop = 341
        end
        inherited edNoneValue: TcxTextEdit
          Left = 356
          Top = 368
          ExplicitLeft = 356
          ExplicitTop = 368
        end
        inherited item_ddDBName: TdxLayoutItem
          Visible = False
        end
      end
    end
    inherited DialogLayoutGroup_Root: TdxLayoutGroup [8]
    end
    inherited AllPropertiesGroup: TdxLayoutGroup [9]
      ItemIndex = 1
    end
    inherited CommonPropertiesGroup: TdxLayoutGroup [10]
    end
    inherited ControlActivityGroup: TdxLayoutGroup [11]
    end
    inherited ddVisibleCondition_Item: TdxLayoutItem [12]
    end
    inherited ddEnabledCondition_Item: TdxLayoutItem [13]
    end
    inherited ExtendedPropertiesGroup: TdxLayoutGroup [14]
      Parent = nil
      Index = -1
    end
    inherited RuntimePropertiesGroup: TdxLayoutGroup [15]
    end
    inherited cbDBName_Item: TdxLayoutItem [16]
    end
    inherited chbReadOnly_Item: TdxLayoutItem [17]
    end
    inherited cbCaption_Item: TdxLayoutItem [18]
    end
    inherited edControlName_Item: TdxLayoutItem [19]
    end
    inherited cbDataField_Item: TdxLayoutItem [20]
    end
    inherited dxLayoutAutoCreatedGroup1: TdxLayoutAutoCreatedGroup [21]
    end
    object dxLayoutItem1: TdxLayoutItem
      Parent = AllPropertiesGroup
      AlignVert = avClient
      Control = ddFrame
      ControlOptions.AutoColor = True
      ControlOptions.OriginalHeight = 369
      ControlOptions.OriginalWidth = 439
      ControlOptions.ShowBorder = False
      Index = 1
    end
  end
end
