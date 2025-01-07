inherited ManagerEditorPascalScript: TManagerEditorPascalScript
  Caption = 'Pascal Script'
  StyleElements = [seFont, seClient, seBorder]
  TextHeight = 13
  inherited pnBottomButtons: TPanel
    StyleElements = [seFont, seClient, seBorder]
  end
  inherited MainBar: TdxBarManager
    PixelsPerInch = 96
    inherited MainMenuBar: TdxBar
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
        end
        item
          Visible = True
          ItemName = 'bnDataTree'
        end>
    end
    object bnDataTree: TdxBarButton [4]
      Caption = 'Data Tree'
      Category = 0
      Hint = 'Data Tree'
      Visible = ivAlways
      ButtonStyle = bsChecked
      ImageIndex = 652
      PaintStyle = psCaptionGlyph
      OnClick = bnDataTreeClick
    end
  end
end
