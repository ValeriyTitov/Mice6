inherited ParamSourceDlg: TParamSourceDlg
  Caption = 'Select param values'
  ClientHeight = 307
  ClientWidth = 406
  ExplicitWidth = 422
  ExplicitHeight = 345
  PixelsPerInch = 96
  TextHeight = 13
  inherited pnBottomButtons: TPanel
    Top = 266
    Width = 406
    ExplicitTop = 266
    ExplicitWidth = 406
    inherited bnOK: TcxButton
      Left = 236
      ExplicitLeft = 236
    end
    inherited bnCancel: TcxButton
      Left = 317
      ExplicitLeft = 317
    end
  end
  inline ParamsFrame: TCommandPropertiesFrame
    Left = 0
    Top = 0
    Width = 406
    Height = 266
    Align = alClient
    TabOrder = 1
    ExplicitWidth = 406
    ExplicitHeight = 266
    inherited ParamGrid: TcxGrid
      Width = 406
      Height = 266
      ExplicitWidth = 406
      ExplicitHeight = 266
      inherited MainView: TcxGridDBTableView
        inherited colName: TcxGridDBColumn
          MinWidth = 80
          Width = 174
        end
        inherited colSource: TcxGridDBColumn
          Visible = False
          MinWidth = 80
          Width = 192
        end
        inherited colValue: TcxGridDBColumn
          MinWidth = 80
          Width = 309
        end
      end
    end
  end
end
