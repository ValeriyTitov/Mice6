inherited PagePlugin: TPagePlugin
  object lbCaption: TLabel [0]
    Left = 56
    Top = 16
    Width = 145
    Height = 19
    Caption = '<Plugin Caption>'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -16
    Font.Name = 'Tahoma'
    Font.Style = [fsBold]
    ParentFont = False
  end
  inherited SideTreePanel: TPanel
    Width = 3
    ExplicitWidth = 3
    inherited SideTreeFilterFrame: TSideTreeFilter
      Width = 3
      ExplicitWidth = 3
      inherited TreeFilter: TcxDBTreeList
        Width = 3
        ExplicitWidth = 3
      end
    end
  end
  inherited TreeSplitter: TcxSplitter
    Left = 3
    ExplicitLeft = 3
  end
  object lbDescription: TdxFormattedLabel [3]
    Left = 56
    Top = 64
    Caption = 'lbDescription'
  end
  inherited PopupBarManager: TdxBarManager
    PixelsPerInch = 96
  end
  inherited GridPopupMenu: TdxBarPopupMenu
    PixelsPerInch = 96
  end
end
