inherited FlowCommentPropertiesDialog: TFlowCommentPropertiesDialog
  Caption = 'Comment properties'
  ClientHeight = 429
  ClientWidth = 480
  ExplicitWidth = 496
  ExplicitHeight = 467
  PixelsPerInch = 96
  TextHeight = 13
  inherited pnBottomButtons: TPanel
    Top = 388
    Width = 480
    ExplicitTop = 388
    ExplicitWidth = 480
    inherited bnOK: TcxButton
      Left = 310
      ExplicitLeft = 310
    end
    inherited bnCancel: TcxButton
      Left = 391
      ExplicitLeft = 391
    end
  end
  inline ShapeFrame: TShapePropertiesFrame
    Left = 0
    Top = 0
    Width = 480
    Height = 388
    Align = alClient
    TabOrder = 1
    ExplicitWidth = 480
    ExplicitHeight = 388
    inherited Panel1: TPanel
      Width = 480
      ExplicitWidth = 480
      inherited cbTransparent: TcxCheckBox
        ExplicitWidth = 83
      end
    end
    inherited Panel2: TPanel
      Width = 480
      Height = 139
      Visible = True
      ExplicitWidth = 480
      ExplicitHeight = 139
      inherited memoText: TcxMemo
        ExplicitWidth = 480
        ExplicitHeight = 139
        Height = 139
        Width = 480
      end
    end
    inherited ColorDialog: TColorDialog
      Left = 384
      Top = 126
    end
  end
  object dxColorDialog1: TdxColorDialog
    Left = 384
    Top = 32
  end
  object dxColorDialog2: TdxColorDialog
    Left = 264
    Top = 184
  end
end
