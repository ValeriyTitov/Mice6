object ShapePropertiesFrame: TShapePropertiesFrame
  Left = 0
  Top = 0
  Width = 376
  Height = 379
  TabOrder = 0
  DesignSize = (
    376
    379)
  object Panel1: TPanel
    Left = 0
    Top = 0
    Width = 376
    Height = 249
    Align = alTop
    Anchors = [akRight, akBottom]
    BevelOuter = bvNone
    TabOrder = 0
    DesignSize = (
      376
      249)
    object Label5: TLabel
      Left = 20
      Top = 183
      Width = 69
      Height = 13
      Caption = 'Text postion Y'
    end
    object Label4: TLabel
      Left = 21
      Top = 103
      Width = 48
      Height = 13
      Caption = 'Line width'
    end
    object Label3: TLabel
      Left = 24
      Top = 223
      Width = 30
      Height = 13
      Caption = 'Shape'
    end
    object Label2: TLabel
      Left = 20
      Top = 143
      Width = 69
      Height = 13
      Caption = 'Text postion X'
    end
    object Label1: TLabel
      Left = 24
      Top = 64
      Width = 45
      Height = 13
      Caption = 'Line color'
    end
    object Color: TLabel
      Left = 24
      Top = 24
      Width = 25
      Height = 13
      Caption = 'Color'
    end
    object ddShapeStyle: TcxImageComboBox
      Left = 94
      Top = 223
      Properties.Items = <>
      TabOrder = 0
      Width = 144
    end
    object cbTextPositionY: TcxComboBox
      Left = 94
      Top = 180
      Properties.DropDownListStyle = lsFixedList
      Properties.Items.Strings = (
        'Top'
        'Center'
        'Bottom')
      Style.HotTrack = False
      Style.TransparentBorder = False
      TabOrder = 1
      Text = 'Top'
      Width = 144
    end
    object seLineWidth: TcxSpinEdit
      Left = 94
      Top = 100
      Properties.MinValue = 1.000000000000000000
      Style.HotTrack = False
      Style.TransparentBorder = False
      TabOrder = 2
      Value = 1
      Width = 144
    end
    object cbTextPositionX: TcxComboBox
      Left = 94
      Top = 140
      Properties.DropDownListStyle = lsFixedList
      Properties.Items.Strings = (
        'Left'
        'Center'
        'Right')
      Style.HotTrack = False
      Style.TransparentBorder = False
      TabOrder = 3
      Text = 'Left'
      Width = 144
    end
    object cbTransparent: TcxCheckBox
      Left = 290
      Top = 20
      Caption = 'Transparent'
      Style.HotTrack = False
      TabOrder = 4
      Transparent = True
    end
    object ceColor: TdxColorEdit
      Left = 94
      Top = 20
      Style.BorderColor = clWindowFrame
      Style.BorderStyle = ebs3D
      Style.HotTrack = False
      Style.ButtonStyle = bts3D
      Style.PopupBorderStyle = epbsFrame3D
      TabOrder = 5
      Width = 144
    end
    object ceLineColor: TdxColorEdit
      Left = 94
      Top = 60
      Style.BorderColor = clWindowFrame
      Style.BorderStyle = ebs3D
      Style.HotTrack = False
      Style.ButtonStyle = bts3D
      Style.PopupBorderStyle = epbsFrame3D
      TabOrder = 6
      Width = 144
    end
    object sbFont: TcxButton
      Left = 344
      Top = 215
      Width = 29
      Height = 28
      Hint = 'Font'
      Anchors = [akTop, akRight]
      OptionsImage.ImageIndex = 258
      OptionsImage.Images = ImageContainer.Images16
      ParentShowHint = False
      ShowHint = True
      SpeedButtonOptions.CanBeFocused = False
      SpeedButtonOptions.Flat = True
      SpeedButtonOptions.Transparent = True
      TabOrder = 7
      OnClick = sbFontClick
    end
  end
  object Panel2: TPanel
    Left = 0
    Top = 249
    Width = 376
    Height = 130
    Align = alClient
    BevelOuter = bvNone
    TabOrder = 1
    Visible = False
    object memoText: TcxMemo
      Left = 0
      Top = 0
      Align = alClient
      Style.HotTrack = False
      Style.TransparentBorder = False
      TabOrder = 0
      Height = 130
      Width = 376
    end
  end
  object cxButton1: TcxButton
    Left = 244
    Top = 18
    Width = 29
    Height = 28
    Hint = 'Font'
    Anchors = [akTop, akRight]
    OptionsImage.ImageIndex = 135
    OptionsImage.Images = ImageContainer.Images16
    ParentShowHint = False
    ShowHint = True
    SpeedButtonOptions.CanBeFocused = False
    SpeedButtonOptions.Flat = True
    SpeedButtonOptions.Transparent = True
    TabOrder = 2
    OnClick = cxButton1Click
  end
  object cxButton2: TcxButton
    Left = 244
    Top = 58
    Width = 29
    Height = 28
    Hint = 'Font'
    Anchors = [akTop, akRight]
    OptionsImage.ImageIndex = 135
    OptionsImage.Images = ImageContainer.Images16
    ParentShowHint = False
    ShowHint = True
    SpeedButtonOptions.CanBeFocused = False
    SpeedButtonOptions.Flat = True
    SpeedButtonOptions.Transparent = True
    TabOrder = 3
    OnClick = cxButton2Click
  end
  object FontDialog: TFontDialog
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    Left = 334
    Top = 62
  end
  object ColorDialog: TColorDialog
    Left = 280
    Top = 64
  end
end
