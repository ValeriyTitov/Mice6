inherited ManagerEditorAppDialogLayout: TManagerEditorAppDialogLayout
  Caption = 'Layout Editor'
  Constraints.MinHeight = 170
  Constraints.MinWidth = 250
  OnShow = FormShow
  TextHeight = 13
  inherited pnBottomButtons: TPanel
    inherited bnAdvanced: TSpeedButton
      Visible = True
    end
  end
  inherited PopupMenu: TPopupMenu
    object Sizeable1: TMenuItem [0]
      AutoCheck = True
      Caption = 'Sizeable'
    end
    object Readonly1: TMenuItem [1]
      AutoCheck = True
      Caption = 'Readonly'
    end
    object Active1: TMenuItem [2]
      AutoCheck = True
      Caption = 'Active'
    end
    object Flags1: TMenuItem [3]
      Caption = 'Flags...'
      ImageIndex = 240
      OnClick = Flags1Click
    end
    object ShowasJson1: TMenuItem [4]
      Caption = 'Show as Json...'
      ImageIndex = 381
      OnClick = ShowasJson1Click
    end
  end
end
