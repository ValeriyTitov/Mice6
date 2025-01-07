inherited TreeGridPlugin: TTreeGridPlugin
  object TreeGrid: TcxDBTreeList [0]
    Left = 193
    Top = 0
    Width = 318
    Height = 358
    Align = alClient
    Bands = <>
    DataController.DataSource = DataSource
    Images = ImageContainer.Images16
    Navigator.Buttons.CustomButtons = <>
    OptionsData.Editing = False
    OptionsData.CaseInsensitive = True
    OptionsData.Deleting = False
    OptionsView.ColumnAutoWidth = True
    OptionsView.TreeLineStyle = tllsSolid
    RootValue = -1
    TabOrder = 2
    OnCustomDrawDataCell = TreeGridCustomDrawDataCell
    OnDblClick = TreeGridDblClick
    OnFocusedNodeChanged = TreeGridFocusedNodeChanged
  end
end
