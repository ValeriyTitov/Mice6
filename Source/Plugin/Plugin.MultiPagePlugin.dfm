inherited MultiPagePlugin: TMultiPagePlugin
  Width = 701
  Height = 524
  ExplicitWidth = 701
  ExplicitHeight = 524
  inherited SideTreePanel: TPanel
    Height = 524
    ExplicitHeight = 524
    inherited SideTreeFilterFrame: TSideTreeFilter
      Height = 524
      ExplicitHeight = 524
      inherited TreeFilter: TcxDBTreeList
        Height = 524
        ExplicitHeight = 524
      end
    end
  end
  inherited TreeSplitter: TcxSplitter
    Height = 524
    ExplicitHeight = 524
  end
  object pgMain: TcxPageControl [2]
    Left = 193
    Top = 0
    Width = 508
    Height = 524
    Align = alClient
    TabOrder = 2
    Properties.ActivePage = NullPage
    Properties.CustomButtons.Buttons = <>
    LookAndFeel.Kind = lfStandard
    LookAndFeel.NativeStyle = False
    ClientRectBottom = 522
    ClientRectLeft = 2
    ClientRectRight = 506
    ClientRectTop = 24
    object NullPage: TcxTabSheet
      Caption = 'NullPage'
      ImageIndex = 0
      ExplicitLeft = 0
      ExplicitTop = 0
      ExplicitWidth = 0
      ExplicitHeight = 0
    end
  end
  inherited PopupBarManager: TdxBarManager
    PixelsPerInch = 96
  end
  inherited GridPopupMenu: TdxBarPopupMenu
    PixelsPerInch = 96
  end
end
