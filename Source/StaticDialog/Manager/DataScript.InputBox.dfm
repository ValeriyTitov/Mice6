inherited DataScriptInputBox: TDataScriptInputBox
  Caption = 'Input script name'
  ClientHeight = 116
  OnCreate = FormCreate
  ExplicitHeight = 144
  PixelsPerInch = 96
  TextHeight = 13
  inherited bnOK: TcxButton
    Top = 83
    ExplicitTop = 83
  end
  inherited bnCancel: TcxButton
    Top = 83
    ExplicitTop = 83
  end
  object lbExitsts: TcxLabel [5]
    Left = 62
    Top = 58
    Caption = 'Script with such name already exists'
    ParentFont = False
    Style.Font.Charset = DEFAULT_CHARSET
    Style.Font.Color = clRed
    Style.Font.Height = -11
    Style.Font.Name = 'Tahoma'
    Style.Font.Style = [fsBold]
    Style.IsFontAssigned = True
    Visible = False
  end
end
