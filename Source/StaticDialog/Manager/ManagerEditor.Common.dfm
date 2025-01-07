inherited CommonManagerDialog: TCommonManagerDialog
  Caption = 'Common Manger Dialog'
  ClientHeight = 412
  ClientWidth = 484
  Constraints.MinHeight = 450
  Constraints.MinWidth = 500
  ExplicitWidth = 500
  ExplicitHeight = 450
  PixelsPerInch = 96
  TextHeight = 13
  inherited pnBottomButtons: TPanel
    Top = 371
    Width = 484
    ExplicitTop = 371
    ExplicitWidth = 484
    DesignSize = (
      484
      41)
    object bnAdvanced: TSpeedButton [0]
      Left = 8
      Top = 6
      Width = 23
      Height = 22
      ImageIndex = 67
      Images = ImageContainer.Images16
      Visible = False
      OnClick = bnAdvancedClick
    end
    inherited bnOK: TcxButton
      Left = 316
      Top = 6
      OnClick = bnOKClick
      ExplicitLeft = 316
      ExplicitTop = 6
    end
    inherited bnCancel: TcxButton
      Left = 397
      Top = 6
      OnClick = bnCancelClick
      ExplicitLeft = 397
      ExplicitTop = 6
    end
  end
  inherited DialogLayout: TdxLayoutControl
    Width = 484
    Height = 371
    ExplicitWidth = 484
    ExplicitHeight = 371
  end
  object PopupMenu: TPopupMenu
    Images = ImageContainer.Images16
    Left = 432
    Top = 8
    object miCopyFrom: TMenuItem
      Caption = 'Copy from...'
      Enabled = False
      ImageIndex = 439
    end
  end
end
