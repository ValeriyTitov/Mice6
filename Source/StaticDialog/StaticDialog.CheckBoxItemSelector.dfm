inherited CheckBoxItemSelector: TCheckBoxItemSelector
  Caption = 'Select items'
  ClientHeight = 206
  ClientWidth = 307
  ExplicitWidth = 323
  ExplicitHeight = 244
  PixelsPerInch = 96
  TextHeight = 13
  inherited pnBottomButtons: TPanel
    Top = 165
    Width = 307
    ExplicitTop = 165
    ExplicitWidth = 307
    inherited bnOK: TcxButton
      Left = 137
      Enabled = False
      ExplicitLeft = 137
    end
    inherited bnCancel: TcxButton
      Left = 218
      ExplicitLeft = 218
    end
  end
  object CheckItems: TcxCheckListBox
    Left = 0
    Top = 0
    Width = 307
    Height = 165
    Align = alClient
    Items = <>
    TabOrder = 1
    OnEditValueChanged = CheckItemsEditValueChanged
  end
end
