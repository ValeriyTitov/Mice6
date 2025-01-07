inherited FlagEditor: TFlagEditor
  Caption = 'FlagEditor'
  ClientHeight = 476
  ClientWidth = 606
  ExplicitWidth = 622
  ExplicitHeight = 514
  PixelsPerInch = 96
  TextHeight = 13
  inherited pnBottomButtons: TPanel
    Top = 435
    Width = 606
    ExplicitTop = 435
    ExplicitWidth = 606
    inherited bnOK: TcxButton
      Left = 436
      ExplicitLeft = 436
    end
    inherited bnCancel: TcxButton
      Left = 517
      ExplicitLeft = 517
    end
  end
  inline FlagsFrame1: TFlagsFrame
    Left = 0
    Top = 0
    Width = 606
    Height = 435
    Align = alClient
    TabOrder = 1
    ExplicitLeft = 112
    ExplicitTop = 128
    inherited EuqtionGrid: TcxGrid
      Width = 606
      Height = 435
      inherited MainView: TcxGridDBTableView
        inherited colItemName: TcxGridDBColumn
          Caption = 'Control or Flag'
        end
      end
    end
  end
end
