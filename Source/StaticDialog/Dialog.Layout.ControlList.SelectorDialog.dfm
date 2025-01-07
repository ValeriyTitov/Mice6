inherited NewControlSelectorDialog: TNewControlSelectorDialog
  Caption = 'Select control'
  ClientHeight = 575
  ClientWidth = 346
  Constraints.MinHeight = 250
  ExplicitWidth = 362
  ExplicitHeight = 613
  PixelsPerInch = 96
  TextHeight = 13
  inherited pnBottomButtons: TPanel
    Top = 534
    Width = 346
    ExplicitTop = 534
    ExplicitWidth = 346
    inherited bnOK: TcxButton
      Left = 176
      Enabled = False
      ExplicitLeft = 176
    end
    inherited bnCancel: TcxButton
      Left = 257
      ExplicitLeft = 257
    end
  end
  object Panel1: TPanel
    Left = 0
    Top = 0
    Width = 346
    Height = 25
    Align = alTop
    BevelOuter = bvNone
    ShowCaption = False
    TabOrder = 1
    DesignSize = (
      346
      25)
    object lbSearch: TLabel
      Left = 8
      Top = 6
      Width = 37
      Height = 13
      Caption = 'Search:'
    end
    object edSearch: TSearchBox
      Left = 88
      Top = 2
      Width = 252
      Height = 21
      Anchors = [akLeft, akTop, akRight]
      TabOrder = 0
      OnChange = edSearchPropertiesChange
    end
  end
  object lvItems: TListView
    Left = 0
    Top = 25
    Width = 346
    Height = 420
    ParentCustomHint = False
    Align = alClient
    Columns = <
      item
        AutoSize = True
        Caption = 'Class name'
      end>
    LargeImages = ImageContainer.Images32
    ReadOnly = True
    RowSelect = True
    SmallImages = ImageContainer.Images16
    TabOrder = 2
    ViewStyle = vsReport
    OnChange = lvItemsChange
    OnDblClick = lvItemsDblClick
    ExplicitHeight = 392
  end
  object memDescription: TcxMemo
    Left = 0
    Top = 445
    Align = alBottom
    Properties.ReadOnly = True
    TabOrder = 3
    ExplicitLeft = 176
    ExplicitTop = 423
    ExplicitWidth = 185
    Height = 89
    Width = 346
  end
  object Timer1: TTimer
    Interval = 500
    OnTimer = Timer1Timer
    Left = 312
    Top = 32
  end
end
