object MiceMainTileForm: TMiceMainTileForm
  Left = 0
  Top = 0
  Caption = 'Mice 6'
  ClientHeight = 694
  ClientWidth = 842
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object pnTop: TPanel
    Left = 0
    Top = 0
    Width = 842
    Height = 24
    Align = alTop
    BevelOuter = bvNone
    Color = clWhite
    ParentBackground = False
    TabOrder = 0
    object MainButton: TcxButton
      Left = 0
      Top = 0
      Width = 75
      Height = 25
      Caption = 'Main Menu'
      TabOrder = 0
      OnClick = MainButtonClick
    end
    object bnTheme: TButton
      Left = 81
      Top = 0
      Width = 75
      Height = 25
      Caption = 'Theme'
      DropDownMenu = ThemePopupMenu
      PopupMenu = ThemePopupMenu
      TabOrder = 1
      OnClick = bnThemeClick
    end
  end
  object dxTile: TdxTileControl
    Left = 0
    Top = 24
    Width = 842
    Height = 670
    Margins.Left = 0
    Margins.Top = 0
    Margins.Right = 0
    Margins.Bottom = 0
    AutoSize = True
    Images = ImageContainer.Images32
    OptionsBehavior.ItemMoving = False
    OptionsBehavior.ItemPressAnimation = False
    OptionsDetailAnimate.AnimationInterval = 100
    OptionsDetailAnimate.AnimationMode = damScrollFade
    OptionsView.GroupIndent = 150
    OptionsView.GroupLayout = glVertical
    OptionsView.IndentHorz = 0
    OptionsView.IndentVert = 0
    OptionsView.ItemIndent = 50
    OptionsView.ItemWidth = 250
    TabOrder = 1
    Title.IndentHorz = 0
    Title.Text = 'Mice 6'
    object dxTileActionBarItem1: TdxTileControlActionBarItem
    end
    object dxTileActionBarItem2: TdxTileControlActionBarItem
      Position = abipTopBar
    end
    object gWorkPlace: TdxTileControlGroup
      Caption.Text = 'Desktop'
      Index = 0
    end
    object gActiveItems: TdxTileControlGroup
      Caption.Text = 'Active plugins'
      Index = 1
    end
  end
  object ThemePopupMenu: TPopupMenu
    Left = 168
    object miWhiteTheme: TMenuItem
      Caption = 'White'
      OnClick = miWhiteThemeClick
    end
    object miBlackTheme: TMenuItem
      Caption = 'Black'
      OnClick = miBlackThemeClick
    end
    object miSkyBlueTheme: TMenuItem
      Caption = 'Sky Blue'
      OnClick = miSkyBlueThemeClick
    end
  end
end
