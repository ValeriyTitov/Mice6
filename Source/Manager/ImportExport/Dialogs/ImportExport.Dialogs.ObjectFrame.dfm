object AppObjectExportFrame: TAppObjectExportFrame
  Left = 0
  Top = 0
  Width = 640
  Height = 480
  Align = alClient
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -12
  Font.Name = 'Segoe UI'
  Font.Style = []
  ParentFont = False
  TabOrder = 0
  object Tree: TcxTreeList
    Left = 0
    Top = 0
    Width = 640
    Height = 480
    Align = alClient
    Bands = <
      item
        Options.Customizing = False
        Options.Moving = False
      end>
    Navigator.Buttons.CustomButtons = <>
    OptionsView.Buttons = False
    OptionsView.ColumnAutoWidth = True
    OptionsView.ShowRoot = False
    OptionsView.TreeLineStyle = tllsNone
    OptionsView.UseNodeColorForIndent = False
    ScrollbarAnnotations.CustomAnnotations = <>
    TabOrder = 0
    OnCustomDrawDataCell = TreeCustomDrawDataCell
  end
end
