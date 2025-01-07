inherited BasicLayoutDialog: TBasicLayoutDialog
  Caption = 'BasicLayoutDialog'
  KeyPreview = True
  OnKeyDown = FormKeyDown
  TextHeight = 13
  object DialogLayout: TdxLayoutControl [1]
    Left = 0
    Top = 0
    Width = 418
    Height = 241
    Align = alClient
    TabOrder = 1
    LayoutLookAndFeel = DefaultLookAndFeel.ManagerDialog
    OptionsImage.Images = ImageContainer.Images16
    object DialogLayoutGroup_Root: TdxLayoutGroup
      AlignHorz = ahClient
      AlignVert = avClient
      LayoutLookAndFeel = DefaultLookAndFeel.ManagerDialog
      AllowRemove = False
      Hidden = True
      LayoutDirection = ldTabbed
      ShowBorder = False
      Index = -1
    end
  end
  object BalloonHint: TBalloonHint
    Delay = 50
    Left = 304
    Top = 8
  end
end
