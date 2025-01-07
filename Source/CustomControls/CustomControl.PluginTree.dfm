object PluginTree: TPluginTree
  Left = 330
  Top = 173
  BorderStyle = bsNone
  Caption = 'Plugin Tree'
  ClientHeight = 560
  ClientWidth = 279
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -14
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  KeyPreview = True
  OldCreateOrder = False
  OnKeyDown = FormKeyDown
  PixelsPerInch = 120
  TextHeight = 16
  object MainPanel: TPanel
    Left = 0
    Top = 0
    Width = 279
    Height = 560
    Align = alClient
    BorderWidth = 2
    Caption = ' '
    Color = clSkyBlue
    ParentBackground = False
    TabOrder = 0
    object PluginTreeList: TcxDBTreeList
      Left = 3
      Top = 26
      Width = 273
      Height = 531
      Align = alClient
      Bands = <
        item
        end>
      DataController.ImageIndexField = 'ImageIndex'
      DataController.ParentField = 'ParentId'
      DataController.KeyField = 'appMainTreeId'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -9
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      Navigator.Buttons.CustomButtons = <>
      OptionsBehavior.CellHints = True
      OptionsBehavior.ImmediateEditor = False
      OptionsBehavior.ConfirmDelete = False
      OptionsBehavior.CopyCaptionsToClipboard = False
      OptionsData.Editing = False
      OptionsData.Deleting = False
      OptionsView.ColumnAutoWidth = True
      OptionsView.Headers = False
      OptionsView.TreeLineStyle = tllsSolid
      ParentFont = False
      PopupMenu = PopupMenu
      RootValue = -1
      TabOrder = 0
      OnDblClick = PluginTreeListDblClick
      OnFocusedNodeChanged = PluginTreeListFocusedNodeChanged
      object colName: TcxDBTreeListColumn
        DataBinding.FieldName = 'Description'
        Options.Editing = False
        Options.Moving = False
        Width = 95
        Position.ColIndex = 0
        Position.RowIndex = 0
        Position.BandIndex = 0
        Summary.FooterSummaryItems = <>
        Summary.GroupFooterSummaryItems = <>
      end
    end
    object pnPath: TPanel
      Left = 3
      Top = 3
      Width = 273
      Height = 23
      Align = alTop
      BevelOuter = bvNone
      TabOrder = 1
      object edPath: TcxTextEdit
        Left = 0
        Top = 0
        Align = alClient
        ParentFont = False
        Style.Font.Charset = DEFAULT_CHARSET
        Style.Font.Color = clWindowText
        Style.Font.Height = -9
        Style.Font.Name = 'MS Sans Serif'
        Style.Font.Style = []
        Style.IsFontAssigned = True
        TabOrder = 0
        OnKeyPress = edPathKeyPress
        Width = 273
      end
    end
  end
  object PopupMenu: TPopupMenu
    Images = ImageContainer.Images16
    Left = 184
    Top = 400
    object miRefresh: TMenuItem
      Caption = 'Refresh'
      ImageIndex = 44
      OnClick = miRefreshClick
    end
  end
end
