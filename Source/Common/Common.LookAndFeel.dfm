object DefaultLookAndFeel: TDefaultLookAndFeel
  Left = 0
  Top = 0
  Caption = 'Default LookAndFeel Settings for entire project'
  ClientHeight = 365
  ClientWidth = 561
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  TextHeight = 13
  object DefaultLayoutLookAndFeel: TdxLayoutLookAndFeelList
    Left = 96
    Top = 8
    object ManagerDialog: TdxLayoutStandardLookAndFeel
      GroupOptions.Padding.AssignedValues = [lpavBottom, lpavLeft, lpavRight, lpavTop]
      GroupOptions.Padding.Bottom = 3
      GroupOptions.Padding.Left = 3
      GroupOptions.Padding.Right = 3
      GroupOptions.Padding.Top = 3
      ItemOptions.ControlBorderStyle = lbsFlat
      Offsets.RootItemsAreaOffsetHorz = 2
      Offsets.RootItemsAreaOffsetVert = 2
      PixelsPerInch = 96
    end
  end
  object GridRepository: TcxStyleRepository
    Left = 96
    Top = 128
    PixelsPerInch = 96
    object StyleGridBand: TcxStyle
      AssignedValues = [svFont]
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Tahoma'
      Font.Style = [fsBold]
    end
    object StyleGridBack: TcxStyle
    end
    object StyleGridColumn: TcxStyle
    end
    object StyleBarItem: TcxStyle
    end
  end
  object DefaultLookAndFeel: TcxLookAndFeelController
    ScrollbarMode = sbmClassic
    Left = 96
    Top = 64
  end
end
