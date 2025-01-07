inherited ManagerEditorSQLScript: TManagerEditorSQLScript
  Caption = 'SQL Script'
  StyleElements = [seFont, seClient, seBorder]
  TextHeight = 13
  inherited pnBottomButtons: TPanel
    StyleElements = [seFont, seClient, seBorder]
  end
  inherited MainBar: TdxBarManager
    AlwaysSaveText = True
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
          ItemName = 'cbDBName'
        end
        item
          Visible = True
          ItemName = 'dxBarSubItem1'
        end>
    end
    object cbDBName: TdxBarCombo [4]
      Caption = 'DBName'
      Category = 0
      Hint = 'DBName'
      Visible = ivAlways
      OnChange = cbDBNameChange
      ShowCaption = True
      ItemIndex = -1
    end
    object dxBarSubItem1: TdxBarSubItem [5]
      Caption = 'Other'
      Category = 0
      Visible = ivAlways
      ItemLinks = <
        item
          Visible = True
          ItemName = 'bnImportSqlObject'
        end
        item
          Visible = True
          ItemName = 'bnObjectDetails'
        end>
    end
    object bnImportSqlObject: TdxBarButton [6]
      Caption = 'Import SQL Object'
      Category = 0
      Hint = 'Import SQL Object'
      Visible = ivAlways
      OnClick = bnImportSqlObjectClick
    end
    object bnObjectDetails: TdxBarButton [7]
      Caption = 'Object details at cursor'
      Category = 0
      Hint = 'Object details at cursor'
      Visible = ivAlways
      DropDownEnabled = False
    end
  end
end
