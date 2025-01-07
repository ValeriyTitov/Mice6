inherited CommonItemSelectorDlg: TCommonItemSelectorDlg
  Caption = 'Select object'
  ClientHeight = 346
  ClientWidth = 496
  Constraints.MinHeight = 384
  Constraints.MinWidth = 512
  OnShow = FormShow
  ExplicitWidth = 512
  ExplicitHeight = 384
  TextHeight = 13
  inherited pnBottomButtons: TPanel
    Top = 305
    Width = 496
    ExplicitTop = 305
    ExplicitWidth = 496
    DesignSize = (
      496
      41)
    inherited bnOK: TcxButton
      Left = 326
      Enabled = False
      ExplicitLeft = 326
    end
    inherited bnCancel: TcxButton
      Left = 407
      ExplicitLeft = 407
    end
    object memoDesc: TMemo
      Left = 0
      Top = 0
      Width = 320
      Height = 41
      Align = alLeft
      ReadOnly = True
      ScrollBars = ssVertical
      TabOrder = 2
    end
  end
  object MainListView: TListView
    Left = 0
    Top = 35
    Width = 496
    Height = 270
    Align = alClient
    Columns = <>
    LargeImages = ImageContainer.Images32
    OwnerData = True
    ReadOnly = True
    ShowColumnHeaders = False
    SmallImages = ImageContainer.Images16
    TabOrder = 1
    ViewStyle = vsList
    OnChange = MainListViewChange
    OnData = MainListViewData
    OnDblClick = MainListViewDblClick
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
    object lbCategory: TLabel
      Left = 90
      Top = 11
      Width = 45
      Height = 13
      Anchors = [akTop, akRight]
      Caption = 'Category'
    end
    object lbIDDesc: TLabel
      Left = 7
      Top = 11
      Width = 15
      Height = 13
      Caption = 'ID:'
    end
    object lbID: TLabel
      Left = 28
      Top = 11
      Width = 33
      Height = 13
      Caption = '%ID%'
    end
    object cbCategory: TcxImageComboBox
      Left = 141
      Top = 8
      Anchors = [akTop, akRight]
      Properties.Images = ImageContainer.Images16
      Properties.Items = <>
      TabOrder = 0
      Width = 173
    end
    object edSearch: TSearchBox
      Left = 326
      Top = 8
      Width = 156
      Height = 21
      Anchors = [akTop, akRight]
      TabOrder = 1
      OnChange = edSearchChange
    end
  end
  object Timer1: TTimer
    Enabled = False
    OnTimer = Timer1Timer
    Left = 456
    Top = 48
  end
end
