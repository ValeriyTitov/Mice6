inherited MiceLayoutEditForm: TMiceLayoutEditForm
  ActiveControl = nil
  Caption = 'Layout Manager'
  ClientHeight = 499
  ClientWidth = 562
  StyleElements = [seFont, seClient, seBorder]
  OnCloseQuery = FormCloseQuery
  OnShow = FormShow
  ExplicitWidth = 578
  ExplicitHeight = 538
  TextHeight = 13
  inherited lcMain: TdxLayoutControl
    Width = 562
    Height = 499
    ExplicitWidth = 562
    ExplicitHeight = 499
    inherited tvVisibleItems: TdxTreeViewControl
      Top = 132
      Width = 236
      Height = 320
      TabOrder = 9
      OnFocusedNodeChanged = tvAvailableItemsFocusedNodeChanged
      ExplicitTop = 132
      ExplicitWidth = 236
      ExplicitHeight = 320
    end
    inherited tvAvailableItems: TdxTreeViewControl
      Left = 300
      Top = 132
      Width = 238
      Height = 320
      TabOrder = 18
      OnFocusedNodeChanged = tvAvailableItemsFocusedNodeChanged
      ExplicitLeft = 300
      ExplicitTop = 132
      ExplicitWidth = 238
      ExplicitHeight = 320
    end
    inherited btnClose: TcxButton
      Left = 10000
      Top = 10000
      TabOrder = 26
      Visible = False
      ExplicitLeft = 10000
      ExplicitTop = 10000
    end
    inherited cbTabbedView: TcxCheckBox
      Top = 471
      TabOrder = 19
      ExplicitTop = 471
      ExplicitWidth = 84
      ExplicitHeight = 17
    end
    inherited btnShowDesignSelectors: TcxButton
      Left = 10000
      Top = 10000
      TabOrder = 22
      Visible = False
      ExplicitLeft = 10000
      ExplicitTop = 10000
    end
    inherited btnHighlightRoot: TcxButton
      Left = 10000
      Top = 10000
      Default = True
      TabOrder = 20
      Visible = False
      ExplicitLeft = 10000
      ExplicitTop = 10000
    end
    inherited btnRestore: TcxButton
      Left = 10000
      Top = 10000
      Default = True
      TabOrder = 21
      Visible = False
      ExplicitLeft = 10000
      ExplicitTop = 10000
    end
    inherited btnStore: TcxButton
      Left = 10000
      Top = 10000
      Default = True
      TabOrder = 23
      Visible = False
      ExplicitLeft = 10000
      ExplicitTop = 10000
    end
    inherited btnRedo: TcxButton
      Left = 174
      Top = 104
      TabOrder = 8
      ExplicitLeft = 174
      ExplicitTop = 104
    end
    inherited btnUndo: TcxButton
      Left = 151
      Top = 104
      TabOrder = 7
      ExplicitLeft = 151
      ExplicitTop = 104
    end
    inherited btnAlignBy: TcxButton
      Top = 104
      TabOrder = 6
      ExplicitTop = 104
    end
    inherited btnTreeViewItemsDelete: TcxButton
      Top = 104
      TabOrder = 4
      ExplicitTop = 104
    end
    inherited btnTreeViewCollapseAll: TcxButton
      Left = 47
      Top = 104
      TabOrder = 3
      ExplicitLeft = 47
      ExplicitTop = 104
    end
    inherited btnTreeViewExpandAll: TcxButton
      Top = 104
      TabOrder = 2
      ExplicitTop = 104
    end
    inherited btnAvailableItemsViewAsList: TcxButton
      Left = 473
      Top = 104
      TabOrder = 17
      ExplicitLeft = 473
      ExplicitTop = 104
    end
    inherited btnAvailableItemsDelete: TcxButton
      Left = 421
      Top = 104
      TabOrder = 15
      ExplicitLeft = 421
      ExplicitTop = 104
    end
    inherited btnAddItem: TcxButton
      Left = 398
      Top = 104
      TabOrder = 14
      ExplicitLeft = 398
      ExplicitTop = 104
    end
    inherited btnAddGroup: TcxButton
      Left = 352
      Top = 104
      TabOrder = 12
      ExplicitLeft = 352
      ExplicitTop = 104
    end
    inherited btnAvailableItemsCollapseAll: TcxButton
      Left = 323
      Top = 104
      TabOrder = 11
      ExplicitLeft = 323
      ExplicitTop = 104
    end
    inherited btnAvailableItemsExpandAll: TcxButton
      Left = 300
      Top = 104
      TabOrder = 10
      ExplicitLeft = 300
      ExplicitTop = 104
    end
    inherited cxButton1: TcxButton
      Left = 375
      Top = 104
      TabOrder = 13
      ExplicitLeft = 375
      ExplicitTop = 104
    end
    inherited cxButton2: TcxButton
      Left = 99
      Top = 104
      TabOrder = 5
      ExplicitLeft = 99
      ExplicitTop = 104
    end
    inherited cxButton3: TcxButton
      Left = 444
      Top = 104
      TabOrder = 16
      ExplicitLeft = 444
      ExplicitTop = 104
    end
    inherited cxButton4: TcxButton
      Left = 10000
      Top = 10000
      TabOrder = 24
      Visible = False
      ExplicitLeft = 10000
      ExplicitTop = 10000
    end
    inherited cxButton5: TcxButton
      Left = 10000
      Top = 10000
      TabOrder = 25
      Visible = False
      ExplicitLeft = 10000
      ExplicitTop = 10000
    end
    object edDatafield: TcxTextEdit [25]
      Left = 88
      Top = 31
      Properties.ReadOnly = True
      Style.BorderColor = clWindowFrame
      Style.BorderStyle = ebs3D
      Style.HotTrack = False
      TabOrder = 0
      Width = 463
    end
    object edControlName: TcxTextEdit [26]
      Left = 88
      Top = 58
      Properties.ReadOnly = True
      Style.BorderColor = clWindowFrame
      Style.BorderStyle = ebs3D
      Style.HotTrack = False
      TabOrder = 1
      Width = 463
    end
    inherited lcMainGroup2: TdxLayoutGroup
      CaptionOptions.Visible = False
      LayoutDirection = ldVertical
    end
    inherited liUndo: TdxLayoutItem
      Parent = lgTreeView
      AlignVert = avClient
      Index = 7
    end
    inherited liRedo: TdxLayoutItem
      Parent = lgTreeView
      Index = 8
    end
    inherited lsSeparator4: TdxLayoutSeparatorItem
      Parent = nil
      Index = -1
    end
    inherited liStore: TdxLayoutItem
      Parent = nil
      Visible = False
      Index = -1
    end
    inherited liRestore: TdxLayoutItem
      Parent = nil
      Visible = False
      Index = -1
    end
    inherited liHighlightRoot: TdxLayoutItem
      Parent = nil
      Visible = False
      Index = -1
    end
    inherited liShowDesignSelectors: TdxLayoutItem
      Parent = nil
      Index = -1
    end
    inherited lcMainGroup1: TdxLayoutGroup
      Index = 2
    end
    inherited lgTreeView: TdxLayoutGroup
      CaptionOptions.Visible = False
    end
    inherited lgAvailableItems: TdxLayoutGroup
      CaptionOptions.Visible = False
    end
    inherited lcMainGroup3: TdxLayoutGroup
      CaptionOptions.Visible = False
      Index = 3
    end
    inherited lcMainItem4: TdxLayoutItem
      Visible = False
    end
    inherited lcMainItem1: TdxLayoutItem
      Parent = nil
      Visible = False
      Index = -1
    end
    inherited liShowItemNames: TdxLayoutItem
      Parent = nil
      Index = -1
    end
    inherited liTransparentBorders: TdxLayoutItem
      Parent = nil
      Index = -1
    end
    object dxLayoutGroup1: TdxLayoutGroup
      Parent = lcMainGroup_Root
      AlignHorz = ahClient
      CaptionOptions.Text = 'Information'
      ItemIndex = 1
      ShowBorder = False
      Index = 1
    end
    object lbClassName: TdxLayoutItem
      Parent = lcMainGroup2
      CaptionOptions.Text = 'Class:'
      Index = 0
    end
    object edDatafield_Item: TdxLayoutItem
      Parent = dxLayoutGroup1
      CaptionOptions.Text = 'Datafield:'
      Control = edDatafield
      ControlOptions.OriginalHeight = 21
      ControlOptions.OriginalWidth = 121
      ControlOptions.ShowBorder = False
      Index = 0
    end
    object edControlName_Item: TdxLayoutItem
      Parent = dxLayoutGroup1
      CaptionOptions.Text = 'Control Name'
      Control = edControlName
      ControlOptions.OriginalHeight = 21
      ControlOptions.OriginalWidth = 121
      ControlOptions.ShowBorder = False
      Index = 1
    end
  end
  inherited ilActions: TcxImageList
    FormatVersion = 1
  end
  inherited ilItems: TcxImageList
    FormatVersion = 1
  end
  inherited pmTreeViewActions: TPopupMenu
    object Width1: TMenuItem [23]
      Caption = 'Change width...'
      OnClick = Width1Click
    end
    object Changeheight1: TMenuItem [24]
      Caption = 'Change height...'
      OnClick = Changeheight1Click
    end
    object miImageIndex: TMenuItem [26]
      Caption = 'ImageIndex...'
      OnClick = miImageIndexClick
    end
    inherited miTreeViewItemRename: TMenuItem
      Caption = 'Change caption'
    end
    object miRenameItem: TMenuItem
      Caption = 'Rename Item'
      OnClick = miRenameItemClick
    end
  end
end
