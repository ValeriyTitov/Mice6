inherited ManagerEditorDocFlowScheme: TManagerEditorDocFlowScheme
  Caption = 'Edit Document Schema'
  ClientHeight = 667
  ClientWidth = 884
  StyleElements = [seFont, seClient, seBorder]
  ExplicitWidth = 900
  ExplicitHeight = 706
  TextHeight = 13
  inherited pnBottomButtons: TPanel
    Top = 626
    Width = 884
    StyleElements = [seFont, seClient, seBorder]
    ExplicitTop = 626
    ExplicitWidth = 884
    object lbInfo: TLabel [1]
      Left = 56
      Top = 16
      Width = 3
      Height = 13
    end
    inherited bnOK: TcxButton
      Left = 716
      ExplicitLeft = 716
    end
    inherited bnCancel: TcxButton
      Left = 797
      ExplicitLeft = 797
    end
  end
  inherited DialogLayout: TdxLayoutControl
    Left = 704
    Top = 512
    Width = 180
    Height = 114
    Align = alNone
    Visible = False
    ExplicitLeft = 704
    ExplicitTop = 512
    ExplicitWidth = 180
    ExplicitHeight = 114
    inherited DialogLayoutGroup_Root: TdxLayoutGroup
      LayoutDirection = ldHorizontal
    end
  end
  object Chart: TdxFlowChart [2]
    Left = 137
    Top = 26
    Width = 747
    Height = 600
    Align = alClient
    GridLineOptions.ShowLines = True
    OnSelected = ChartSelected
    Options = [fcoCanDrag, fcoCanSelect, fcoMultiSelect, fcoHideSelection, fcoDelOnClick, fcoDynamicSizing, fcoDynamicMoving, fcoAlignWithGrid, fcoUseShapeParameters, fcoSnapToGuides]
    OnDblClick = acPropertiesExecute
    OnDragOver = ChartDragOver
    OnKeyDown = ChartKeyDown
    OnMouseDown = ChartMouseDown
    OnMouseMove = ChartMouseMove
    OnMouseUp = ChartMouseUp
  end
  object Panel3: TPanel [3]
    Left = 0
    Top = 26
    Width = 137
    Height = 600
    Align = alLeft
    Caption = 'Panel3'
    TabOrder = 7
    object gcStencils: TdxGalleryControl
      Left = 1
      Top = 1
      Width = 135
      Height = 27
      Align = alTop
      AutoSizeMode = asAutoHeight
      BorderStyle = cxcbsNone
      OptionsBehavior.ItemCheckMode = icmSingleRadio
      OptionsView.ColumnAutoWidth = True
      OptionsView.ColumnCount = 1
      OptionsView.Item.Image.ShowFrame = False
      OptionsView.Item.Text.AlignHorz = taLeftJustify
      OptionsView.Item.Text.AlignVert = vaCenter
      OptionsView.Item.Text.Position = posLeft
      TabOrder = 0
      object gcgStencils: TdxGalleryControlGroup
        Caption = 'New folder'
      end
    end
    object gcShapes: TdxGalleryControl
      Left = 1
      Top = 28
      Width = 135
      Height = 571
      Align = alClient
      BorderStyle = cxcbsNone
      Images = ImageContainer.Images32
      OptionsBehavior.ItemCheckMode = icmSingleRadio
      OptionsView.ColumnAutoWidth = True
      OptionsView.Item.Image.ShowFrame = False
      OptionsView.Item.Image.Size.Height = 34
      OptionsView.Item.Image.Size.Width = 34
      OptionsView.Item.Text.AlignHorz = taLeftJustify
      OptionsView.Item.Text.AlignVert = vaCenter
      OptionsView.Item.Text.Position = posRight
      TabOrder = 1
      object gcgShapes: TdxGalleryControlGroup
        Caption = 'Shapes'
        ShowCaption = False
      end
    end
  end
  inherited MainSource: TDataSource
    Left = 256
    Top = 409
  end
  inherited BalloonHint: TBalloonHint
    Left = 168
    Top = 472
  end
  inherited PopupMenu: TPopupMenu
    Left = 256
    Top = 472
  end
  object dxBarManager: TdxBarManager
    AllowReset = False
    AutoDockColor = False
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -12
    Font.Name = 'Segoe UI'
    Font.Style = []
    CanCustomize = False
    Categories.Strings = (
      'Default')
    Categories.ItemsVisibles = (
      2)
    Categories.Visibles = (
      True)
    DockColor = clBtnFace
    ImageOptions.Images = ImageContainer.Images16
    NotDocking = [dsNone, dsLeft, dsTop, dsRight, dsBottom]
    PopupMenuLinks = <
      item
      end>
    Style = bmsFlat
    UseSystemFont = True
    Left = 260
    Top = 537
    PixelsPerInch = 96
    DockControlHeights = (
      0
      0
      26
      0)
    object dxBarManagerBar1: TdxBar
      AllowClose = False
      AllowCustomizing = False
      AllowQuickCustomizing = False
      AllowReset = False
      Caption = 'Default'
      CaptionButtons = <>
      DockedDockingStyle = dsTop
      DockedLeft = 0
      DockedTop = 0
      DockingStyle = dsTop
      FloatLeft = 458
      FloatTop = 346
      FloatClientWidth = 23
      FloatClientHeight = 22
      ItemLinks = <
        item
          Visible = True
          ItemName = 'bnNewItem'
        end
        item
          Visible = True
          ItemName = 'bnView'
        end
        item
          Visible = True
          ItemName = 'bnEditSubMenu'
        end>
      OldName = 'Default'
      OneOnRow = True
      Row = 0
      UseOwnFont = False
      Visible = True
      WholeRow = False
    end
    object bnNewFolder: TdxBarButton
      Caption = 'New folder'
      Category = 0
      Hint = 'New folder'
      Visible = ivAlways
      ImageIndex = 131
    end
    object bnEdit: TdxBarButton
      Action = acProperties
      Category = 0
    end
    object bnDelete: TdxBarButton
      Action = acDelete
      Category = 0
    end
    object bnNewItem: TdxBarSubItem
      Caption = 'New'
      Category = 0
      Visible = ivAlways
      ImageIndex = 430
      ItemLinks = <
        item
          Visible = True
          ItemName = 'bnNewMethod'
        end
        item
          Visible = True
          ItemName = 'bnNewCommentGroup'
        end
        item
          Visible = True
          ItemName = 'bnNewLabel'
        end>
    end
    object bnNewMethod: TdxBarButton
      Action = acNewMethod
      Category = 0
      PaintStyle = psCaptionGlyph
    end
    object bnAutoRoute: TdxBarButton
      Caption = 'Auto route'
      Category = 0
      Hint = 'Auto route'
      Visible = ivAlways
      ButtonStyle = bsChecked
      ImageIndex = 267
      PaintStyle = psCaptionGlyph
      OnClick = bnAutoRouteClick
    end
    object bnPointer: TdxBarButton
      Action = acPointerTool
      Category = 0
    end
    object bnNewCommentGroup: TdxBarButton
      Caption = 'New Comment Group'
      Category = 0
      Hint = 'New Comment Group'
      Visible = ivAlways
      ImageIndex = 139
      OnClick = bnNewCommentGroupClick
    end
    object bnSaveAs: TdxBarButton
      Caption = 'Save as Xml...'
      Category = 0
      Hint = 'Save as Xml'
      Visible = ivAlways
      ImageIndex = 505
      LargeImageIndex = 505
      OnClick = bnSaveAsClick
    end
    object bnShowGrid: TdxBarButton
      Caption = 'Grid'
      Category = 0
      Hint = 'Grid'
      Visible = ivAlways
      ButtonStyle = bsChecked
      Down = True
      ImageIndex = 164
      OnClick = bnShowGridClick
    end
    object bnNewLabel: TdxBarButton
      Caption = 'New label'
      Category = 0
      Hint = 'New label'
      Visible = ivAlways
      ImageIndex = 223
      OnClick = bnNewLabelClick
    end
    object dxBarButton1: TdxBarButton
      Caption = 'New Button'
      Category = 0
      Hint = 'New Button'
      Visible = ivAlways
    end
    object bnView: TdxBarSubItem
      Caption = 'View'
      Category = 0
      Visible = ivAlways
      ItemLinks = <
        item
          Visible = True
          ItemName = 'bnEdit'
        end
        item
          Visible = True
          ItemName = 'bnPointer'
        end
        item
          Visible = True
          ItemName = 'bnShowGrid'
        end>
    end
    object bnEditSubMenu: TdxBarSubItem
      Caption = 'Edit'
      Category = 0
      Visible = ivAlways
      ItemLinks = <
        item
          Visible = True
          ItemName = 'bnDelete'
        end
        item
          Visible = True
          ItemName = 'bnAutoRoute'
        end
        item
          Visible = True
          ItemName = 'bnSaveAs'
        end>
    end
  end
  object FlowActions: TActionList
    Images = ImageContainer.Images16
    Left = 168
    Top = 537
    object acProperties: TAction
      Caption = 'Properties'
      ImageIndex = 28
      OnExecute = acPropertiesExecute
    end
    object acPointerTool: TAction
      AutoCheck = True
      Caption = 'Pointer Tool'
      GroupIndex = 3
      Hint = 'Pointer Tool'
      ImageIndex = 82
      OnExecute = acPointerToolExecute
    end
    object acNewMethod: TAction
      AutoCheck = True
      Caption = 'New Method'
      GroupIndex = 3
      Hint = 'Connector'
      ImageIndex = 595
      OnExecute = acNewMethodExecute
    end
    object acDelete: TAction
      Caption = 'Delete Item'
      ImageIndex = 228
      ShortCut = 16430
      OnExecute = acDeleteExecute
    end
  end
  object SaveDialog1: TSaveDialog
    Options = [ofOverwritePrompt, ofHideReadOnly, ofEnableSizing]
    Left = 168
    Top = 408
  end
end
