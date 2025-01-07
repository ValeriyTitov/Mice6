object BasePlugin: TBasePlugin
  Left = 0
  Top = 0
  Width = 511
  Height = 358
  TabOrder = 0
  object SideTreePanel: TPanel
    Left = 0
    Top = 0
    Width = 185
    Height = 358
    Align = alLeft
    BevelOuter = bvNone
    ParentShowHint = False
    ShowHint = True
    TabOrder = 0
    Visible = False
    inline SideTreeFilterFrame: TSideTreeFilter
      Left = 0
      Top = 0
      Width = 185
      Height = 358
      Align = alClient
      TabOrder = 0
      ExplicitWidth = 185
      ExplicitHeight = 358
      inherited TreeFilter: TcxDBTreeList
        Width = 185
        Height = 358
        OnFocusedNodeChanged = NodeChanged
        ExplicitWidth = 185
        ExplicitHeight = 358
      end
    end
  end
  object TreeSplitter: TcxSplitter
    Left = 185
    Top = 0
    Width = 8
    Height = 358
    Visible = False
  end
  object DataSource: TDataSource
    Left = 464
    Top = 16
  end
  object PopupBarManager: TdxBarManager
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -12
    Font.Name = 'Segoe UI'
    Font.Style = []
    Categories.Strings = (
      'Default')
    Categories.ItemsVisibles = (
      2)
    Categories.Visibles = (
      True)
    ImageOptions.Images = ImageContainer.Images16
    ImageOptions.LargeImages = ImageContainer.Images32
    PopupMenuLinks = <>
    UseSystemFont = True
    Left = 280
    Top = 160
    PixelsPerInch = 96
    object miColumns: TdxBarSubItem
      Caption = 'Columns'
      Category = 0
      Visible = ivAlways
      ImageIndex = 12
      ItemLinks = <>
    end
  end
  object GridPopupMenu: TdxBarPopupMenu
    BarManager = PopupBarManager
    ItemLinks = <
      item
        Visible = True
        ItemName = 'miColumns'
      end>
    UseOwnFont = False
    Left = 384
    Top = 160
    PixelsPerInch = 96
  end
end
