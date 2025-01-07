inherited SelectImageDialog: TSelectImageDialog
  Caption = 'Select image'
  ClientHeight = 442
  ClientWidth = 496
  Constraints.MinHeight = 480
  Constraints.MinWidth = 512
  OnResize = FormResize
  ExplicitWidth = 512
  ExplicitHeight = 480
  PixelsPerInch = 96
  TextHeight = 13
  inherited pnBottomButtons: TPanel
    Top = 400
    Width = 496
    Height = 42
    ExplicitTop = 399
    ExplicitWidth = 496
    ExplicitHeight = 42
    object Label1: TLabel [0]
      Left = 68
      Top = 22
      Width = 63
      Height = 13
      Caption = 'Image index:'
    end
    object lbIndex: TLabel [1]
      Left = 137
      Top = 22
      Width = 25
      Height = 13
      Caption = 'None'
    end
    object Label2: TLabel [2]
      Left = 68
      Top = 6
      Width = 27
      Height = 13
      Caption = 'Tags:'
    end
    object lbTags: TLabel [3]
      Left = 100
      Top = 6
      Width = 25
      Height = 13
      Caption = 'None'
    end
    object Preview: TImage [4]
      Left = 6
      Top = 1
      Width = 40
      Height = 40
    end
    inherited bnOK: TcxButton
      Left = 326
      Top = 9
      ExplicitLeft = 326
      ExplicitTop = 9
    end
    inherited bnCancel: TcxButton
      Left = 407
      Top = 9
      ExplicitLeft = 407
      ExplicitTop = 9
    end
    object bnClear: TcxButton
      Left = 235
      Top = 9
      Width = 75
      Height = 25
      Anchors = [akRight, akBottom]
      Caption = 'Clear'
      Default = True
      ModalResult = 1
      TabOrder = 2
      Visible = False
      OnClick = bnClearClick
    end
  end
  object Grid: TDrawGrid
    Left = 0
    Top = 35
    Width = 496
    Height = 365
    Align = alClient
    DefaultColWidth = 24
    DefaultDrawing = False
    FixedCols = 0
    FixedRows = 0
    Options = [goFixedVertLine, goFixedHorzLine]
    TabOrder = 1
    OnDblClick = GridDblClick
    OnDrawCell = GridDrawCell
    OnSelectCell = GridSelectCell
    ColWidths = (
      24
      24
      24
      24
      24)
    RowHeights = (
      24
      24
      24
      24
      24)
  end
  object Panel1: TPanel
    Left = 0
    Top = 0
    Width = 496
    Height = 35
    Align = alTop
    BevelOuter = bvNone
    ShowCaption = False
    TabOrder = 2
    DesignSize = (
      496
      35)
    object Label3: TLabel
      Left = 272
      Top = 11
      Width = 37
      Height = 13
      Anchors = [akTop, akRight]
      Caption = 'Search:'
    end
    object edSearch: TcxTextEdit
      Left = 326
      Top = 8
      Anchors = [akTop, akRight]
      Properties.OnChange = edSearchPropertiesChange
      TabOrder = 0
      Width = 156
    end
  end
  object Timer1: TTimer
    Enabled = False
    Interval = 750
    OnTimer = Timer1Timer
    Left = 456
    Top = 48
  end
end
