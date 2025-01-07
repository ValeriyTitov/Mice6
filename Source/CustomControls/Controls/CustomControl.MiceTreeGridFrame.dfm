object MiceTreeGridFrame: TMiceTreeGridFrame
  Left = 0
  Top = 0
  Width = 492
  Height = 349
  TabOrder = 0
  object TreeGrid: TcxDBTreeList
    Left = 0
    Top = 0
    Width = 492
    Height = 349
    Align = alClient
    Bands = <>
    Images = ImageContainer.Images16
    Navigator.Buttons.CustomButtons = <>
    OptionsData.Editing = False
    OptionsData.CaseInsensitive = True
    OptionsData.Deleting = False
    OptionsView.ColumnAutoWidth = True
    OptionsView.TreeLineStyle = tllsSolid
    RootValue = -1
    TabOrder = 0
    OnClick = TreeGridClick
    OnCustomDrawDataCell = TreeGridCustomDrawDataCell
    OnDblClick = TreeGridDblClick
    OnFocusedNodeChanged = TreeGridFocusedNodeChanged
  end
end
