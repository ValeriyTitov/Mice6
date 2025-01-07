inherited ManagerEditorScript: TManagerEditorScript
  Caption = 'Edit Script'
  ClientHeight = 572
  ClientWidth = 861
  OnCloseQuery = FormCloseQuery
  ExplicitWidth = 877
  ExplicitHeight = 611
  TextHeight = 13
  inherited pnBottomButtons: TPanel
    Top = 531
    Width = 861
    Visible = False
    ExplicitTop = 531
    ExplicitWidth = 861
    DesignSize = (
      861
      41)
    inherited bnOK: TcxButton
      Left = 693
      ExplicitLeft = 693
    end
    inherited bnCancel: TcxButton
      Left = 774
      ExplicitLeft = 774
    end
  end
  inherited DialogLayout: TdxLayoutControl
    Top = 26
    Width = 0
    Height = 0
    Align = alNone
    Enabled = False
    Visible = False
    ExplicitTop = 26
    ExplicitWidth = 0
    ExplicitHeight = 0
    inherited DialogLayoutGroup_Root: TdxLayoutGroup
      CaptionOptions.Visible = False
      LayoutDirection = ldHorizontal
    end
  end
  object pgMain: TcxPageControl [2]
    Left = 0
    Top = 26
    Width = 861
    Height = 505
    Align = alClient
    TabOrder = 6
    Properties.CustomButtons.Buttons = <>
    OnChange = pgMainChange
    ClientRectBottom = 501
    ClientRectLeft = 4
    ClientRectRight = 857
    ClientRectTop = 4
  end
  inherited MainSource: TDataSource
    Left = 632
    Top = 57
  end
  object MainBar: TdxBarManager
    AllowReset = False
    Scaled = False
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -12
    Font.Name = 'Segoe UI'
    Font.Style = []
    CanCustomize = False
    Categories.Strings = (
      'Default'
      'Main')
    Categories.ItemsVisibles = (
      2
      2)
    Categories.Visibles = (
      True
      True)
    ImageOptions.Images = ImageContainer.Images16
    MenusShowRecentItemsFirst = False
    PopupMenuLinks = <>
    Style = bmsFlat
    UseSystemFont = True
    Left = 576
    Top = 56
    PixelsPerInch = 96
    DockControlHeights = (
      0
      0
      26
      0)
    object MainMenuBar: TdxBar
      AllowClose = False
      AllowCustomizing = False
      AllowQuickCustomizing = False
      AllowReset = False
      Caption = 'MainMenu'
      CaptionButtons = <>
      DockedDockingStyle = dsTop
      DockedLeft = 0
      DockedTop = 0
      DockingStyle = dsTop
      FloatLeft = 374
      FloatTop = 8
      FloatClientWidth = 0
      FloatClientHeight = 0
      IsMainMenu = True
      ItemLinks = <
        item
          Visible = True
          ItemName = 'bnRun'
        end
        item
          Visible = True
          ItemName = 'bnSave'
        end
        item
          Visible = True
          ItemName = 'bnSaveAsFile'
        end
        item
          Visible = True
          ItemName = 'bnFormat'
        end
        item
          Visible = True
          ItemName = 'bnCloseCurrentPage'
        end>
      MultiLine = True
      NotDocking = [dsNone, dsLeft, dsTop, dsRight, dsBottom]
      OneOnRow = True
      Row = 0
      UseOwnFont = False
      UseRecentItems = False
      Visible = True
      WholeRow = True
    end
    object bnCloseCurrentPage: TdxBarButton
      Caption = 'Close Page'
      Category = 0
      Hint = 'Close Page'
      Visible = ivAlways
      ImageIndex = 698
      PaintStyle = psCaptionGlyph
      ShortCut = 16499
      OnClick = bnCloseCurrentPageClick
    end
    object bnSaveAsFile: TdxBarButton
      Caption = 'Save as..'
      Category = 0
      Hint = 'Save as file..'
      Visible = ivAlways
      ImageIndex = 505
      PaintStyle = psCaptionGlyph
      OnClick = bnSaveAsFileClick
    end
    object bnFormat: TdxBarButton
      Caption = 'Format Text'
      Category = 0
      Hint = 'Format Text'
      Visible = ivAlways
      ImageIndex = 647
      PaintStyle = psCaptionGlyph
      OnClick = bnFormatClick
    end
    object bnRun: TdxBarButton
      Caption = 'Run'
      Category = 1
      Hint = 'Run'
      Visible = ivAlways
      ImageIndex = 469
      PaintStyle = psCaptionGlyph
      ShortCut = 116
      OnClick = bnRunClick
    end
    object bnSave: TdxBarButton
      Caption = 'Save'
      Category = 1
      Hint = 'Save to database'
      Visible = ivAlways
      ImageIndex = 504
      PaintStyle = psCaptionGlyph
      ShortCut = 16467
      OnClick = bnSaveClick
    end
  end
  object SaveDialog: TSaveDialog
    Left = 696
    Top = 58
  end
end
