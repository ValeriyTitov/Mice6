inherited EmbeddedDialog: TEmbeddedDialog
  BorderIcons = []
  BorderStyle = bsNone
  Caption = 'Embedded Dialog'
  ClientHeight = 320
  ClientWidth = 434
  PixelsPerInch = 96
  TextHeight = 13
  inherited pnBottomButtons: TPanel
    Top = 279
    Width = 434
    Visible = False
    ExplicitTop = 279
    ExplicitWidth = 434
    inherited bnOK: TcxButton
      Left = 264
      ExplicitLeft = 264
    end
    inherited bnCancel: TcxButton
      Left = 345
      ExplicitLeft = 345
    end
  end
  inherited DialogLayout: TdxLayoutControl
    Width = 434
    Height = 279
    ExplicitWidth = 434
    ExplicitHeight = 279
  end
end
