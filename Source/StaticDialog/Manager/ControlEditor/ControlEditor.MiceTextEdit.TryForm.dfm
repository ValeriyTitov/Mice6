inherited MiceTextEditTryForm: TMiceTextEditTryForm
  Caption = 'Try TMiceTextEdit Behavior'
  ClientHeight = 198
  ClientWidth = 408
  OnCreate = FormCreate
  ExplicitWidth = 424
  ExplicitHeight = 236
  PixelsPerInch = 96
  TextHeight = 13
  object Label1: TLabel [0]
    Left = 8
    Top = 63
    Width = 56
    Height = 13
    Caption = 'Information'
  end
  object Label2: TLabel [1]
    Left = 8
    Top = 5
    Width = 68
    Height = 13
    Caption = 'Try input here'
  end
  inherited pnBottomButtons: TPanel
    Top = 157
    Width = 408
    TabOrder = 2
    inherited bnOK: TcxButton
      Left = 238
    end
    inherited bnCancel: TcxButton
      Left = 319
      OnClick = bnCancelClick
    end
  end
  object memoInfo: TMemo
    Left = 0
    Top = 84
    Width = 408
    Height = 73
    Align = alBottom
    TabOrder = 1
    ExplicitTop = 168
    ExplicitWidth = 418
  end
  object FEdit: TcxDBMaskEdit
    Left = 8
    Top = 24
    DataBinding.DataField = 'SampleField'
    DataBinding.DataSource = DataSource
    TabOrder = 0
    Width = 281
  end
  object DataSource: TDataSource
    DataSet = FakeDataSet
    Left = 328
    Top = 24
  end
  object FakeDataSet: TdxMemData
    Indexes = <>
    SortOptions = []
    Left = 328
    Top = 80
    object FakeDataSetSampleField: TStringField
      FieldName = 'SampleField'
      Size = 255
    end
  end
end
