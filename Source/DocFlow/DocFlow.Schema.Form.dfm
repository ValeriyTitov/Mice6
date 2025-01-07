inherited DocFlowSchemaForm: TDocFlowSchemaForm
  Caption = 'Document flow schema'
  ClientHeight = 591
  ClientWidth = 856
  Constraints.MinHeight = 480
  Constraints.MinWidth = 640
  OnClose = FormClose
  OnCreate = FormCreate
  ExplicitWidth = 872
  ExplicitHeight = 630
  TextHeight = 13
  inherited pnBottomButtons: TPanel
    Top = 550
    Width = 856
    ExplicitTop = 550
    ExplicitWidth = 856
    object lbSteps: TLabel [0]
      Left = 8
      Top = 23
      Width = 75
      Height = 13
      Caption = 'Step %d of %d'
      Visible = False
    end
    object lbInfo: TLabel [1]
      Left = 8
      Top = 6
      Width = 66
      Height = 13
      Caption = '<FolderInfo>'
    end
    inherited bnOK: TcxButton
      Left = 686
      ExplicitLeft = 686
    end
    inherited bnCancel: TcxButton
      Left = 767
      ExplicitLeft = 767
    end
  end
  object Chart: TdxFlowChart
    Left = 0
    Top = 26
    Width = 856
    Height = 524
    Align = alClient
    GridLineOptions.ShowLines = True
    OnSelected = ChartSelected
    Options = [fcoCanSelect, fcoMultiSelect]
    OnMouseDown = ChartMouseDown
  end
  object BlinkTimer: TTimer
    Interval = 750
    OnTimer = BlinkTimerTimer
    Left = 96
    Top = 72
  end
  object dxBarManager: TdxBarManager
    AllowReset = False
    AutoDockColor = False
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -12
    Font.Name = 'Segoe UI'
    Font.Style = []
    CanCustomize = False
    Categories.Strings = (
      'Default')
    Categories.ItemsVisibles = (
      2)
    Categories.Visibles = (
      True)
    DockColor = clBtnFace
    ImageOptions.Images = ImageContainer.Images16
    NotDocking = [dsNone, dsLeft, dsTop, dsRight, dsBottom]
    PopupMenuLinks = <
      item
      end>
    Style = bmsFlat
    UseSystemFont = True
    Left = 524
    Top = 196
    PixelsPerInch = 96
    DockControlHeights = (
      0
      0
      26
      0)
    object dxBarManagerBar1: TdxBar
      AllowClose = False
      AllowCustomizing = False
      AllowQuickCustomizing = False
      AllowReset = False
      Caption = 'Default'
      CaptionButtons = <>
      DockedDockingStyle = dsTop
      DockedLeft = 0
      DockedTop = 0
      DockingStyle = dsTop
      FloatLeft = 458
      FloatTop = 346
      FloatClientWidth = 23
      FloatClientHeight = 22
      ItemLinks = <
        item
          Visible = True
          ItemName = 'bnRefresh'
        end
        item
          Visible = True
          ItemName = 'bnPlay'
        end
        item
          Visible = True
          ItemName = 'bnStop'
        end
        item
          Visible = True
          ItemName = 'bnFastForward'
        end>
      OldName = 'Default'
      OneOnRow = True
      Row = 0
      UseOwnFont = False
      Visible = True
      WholeRow = False
    end
    object bnRefresh: TdxBarButton
      Caption = 'Refresh'
      Category = 0
      Hint = 'Refresh'
      Visible = ivAlways
      ImageIndex = 43
      PaintStyle = psCaptionGlyph
      ShortCut = 116
      OnClick = bnRefreshClick
    end
    object bnPlay: TdxBarButton
      Caption = 'Play'
      Category = 0
      Hint = 'Start step-by-step visualization process'
      Visible = ivAlways
      ImageIndex = 469
      LargeImageIndex = 469
      PaintStyle = psCaptionInMenu
      OnClick = bnPlayClick
    end
    object bnStop: TdxBarButton
      Caption = 'Stop'
      Category = 0
      Enabled = False
      Hint = 'Stop'
      Visible = ivAlways
      ImageIndex = 588
      LargeImageIndex = 588
      PaintStyle = psCaptionInMenu
      OnClick = bnStopClick
    end
    object bnForward: TdxBarButton
      Caption = 'Forward'
      Category = 0
      Hint = 'Forward'
      Visible = ivAlways
      ImageIndex = 66
      LargeImageIndex = 66
      PaintStyle = psCaptionInMenu
    end
    object bnBackward: TdxBarButton
      Caption = 'Backward'
      Category = 0
      Hint = 'Backward'
      Visible = ivAlways
      ImageIndex = 65
      LargeImageIndex = 65
      PaintStyle = psCaptionInMenu
    end
    object bnFastForward: TdxBarButton
      Caption = 'Fast forward'
      Category = 0
      Hint = 'Fast forward'
      Visible = ivAlways
      ImageIndex = 268
      LargeImageIndex = 268
      OnClick = bnFastForwardClick
    end
  end
  object PlayTimer: TTimer
    Enabled = False
    Interval = 750
    OnTimer = PlayTimerTimer
    Left = 96
    Top = 136
  end
end
