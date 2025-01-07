inherited ManagerEditorAppDialog: TManagerEditorAppDialog
  Caption = 'Edit Dialog'
  ClientHeight = 649
  ClientWidth = 629
  ExplicitWidth = 645
  ExplicitHeight = 688
  TextHeight = 13
  inherited pnBottomButtons: TPanel
    Top = 608
    Width = 629
    ExplicitTop = 608
    ExplicitWidth = 629
    inherited bnAdvanced: TSpeedButton
      Visible = True
    end
    inherited bnOK: TcxButton
      Left = 461
      ExplicitLeft = 461
    end
    inherited bnCancel: TcxButton
      Left = 542
      ExplicitLeft = 542
    end
  end
  inherited DialogLayout: TdxLayoutControl
    Width = 629
    Height = 608
    ExplicitWidth = 629
    ExplicitHeight = 608
    object Image1: TImage [0]
      Left = 23
      Top = 43
      Width = 32
      Height = 32
    end
    object Label1: TLabel [1]
      Left = 61
      Top = 43
      Width = 180
      Height = 32
      Caption = 'Dialog properties'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -13
      Font.Name = 'Tahoma'
      Font.Style = [fsBold]
      ParentFont = False
    end
    object Image2: TImage [2]
      Left = 10000
      Top = 10000
      Width = 32
      Height = 32
      Visible = False
    end
    object Label2: TLabel [3]
      Left = 10000
      Top = 10000
      Width = 180
      Height = 32
      Caption = 'Dialog controls'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -13
      Font.Name = 'Tahoma'
      Font.Style = [fsBold]
      ParentFont = False
      Visible = False
    end
    object memDescription: TcxDBMemo [4]
      Left = 81
      Top = 120
      DataBinding.DataField = 'Description'
      DataBinding.DataSource = MainSource
      Style.BorderColor = clWindowFrame
      Style.BorderStyle = ebs3D
      Style.HotTrack = False
      TabOrder = 2
      Height = 40
      Width = 525
    end
    object edCaption: TcxDBTextEdit [5]
      Left = 81
      Top = 93
      AutoSize = False
      DataBinding.DataField = 'Caption'
      DataBinding.DataSource = MainSource
      Style.BorderColor = clWindowFrame
      Style.BorderStyle = ebs3D
      Style.HotTrack = False
      TabOrder = 1
      Height = 21
      Width = 525
    end
    object edKeyfield: TcxDBTextEdit [6]
      Left = 127
      Top = 241
      DataBinding.DataField = 'Keyfield'
      DataBinding.DataSource = MainSource
      Style.BorderColor = clWindowFrame
      Style.BorderStyle = ebs3D
      Style.HotTrack = False
      TabOrder = 7
      Width = 464
    end
    object gridDetails: TcxGrid [7]
      Left = 38
      Top = 358
      Width = 553
      Height = 212
      TabOrder = 10
      object DetailsView: TcxGridDBBandedTableView
        PopupMenu = PopupMenu1
        Navigator.Buttons.CustomButtons = <>
        Navigator.Buttons.First.Visible = True
        Navigator.Buttons.PriorPage.Visible = True
        Navigator.Buttons.Prior.Visible = True
        Navigator.Buttons.Next.Visible = True
        Navigator.Buttons.NextPage.Visible = True
        Navigator.Buttons.Last.Visible = True
        Navigator.Buttons.Insert.Visible = True
        Navigator.Buttons.Append.Visible = False
        Navigator.Buttons.Delete.Visible = True
        Navigator.Buttons.Edit.Visible = True
        Navigator.Buttons.Post.Visible = True
        Navigator.Buttons.Cancel.Visible = True
        Navigator.Buttons.Refresh.Visible = True
        Navigator.Buttons.SaveBookmark.Visible = True
        Navigator.Buttons.GotoBookmark.Visible = True
        Navigator.Buttons.Filter.Visible = True
        ScrollbarAnnotations.CustomAnnotations = <>
        OnCustomDrawCell = ControlsViewCustomDrawCell
        DataController.Summary.DefaultGroupSummaryItems = <>
        DataController.Summary.FooterSummaryItems = <>
        DataController.Summary.SummaryGroups = <>
        OptionsView.NoDataToDisplayInfoText = ' '
        OptionsView.ColumnAutoWidth = True
        OptionsView.GroupByBox = False
        OptionsView.BandHeaders = False
        Bands = <
          item
          end>
        object colDetailsProviderName: TcxGridDBBandedColumn
          Caption = 'ProviderName Pattern'
          DataBinding.FieldName = 'ProviderPattern'
          DataBinding.IsNullValueType = True
          Visible = False
          HeaderHint = 
            'Override standart query SELECT * FROM [%s] WITH (NOLOCK) WHERE %' +
            's=%d'
          Options.Filtering = False
          Options.Moving = False
          Options.Sorting = False
          Width = 180
          Position.BandIndex = 0
          Position.ColIndex = 1
          Position.RowIndex = 0
        end
        object colDetailsReadOnly: TcxGridDBBandedColumn
          Caption = 'Read Only'
          DataBinding.FieldName = 'ReadOnly'
          DataBinding.IsNullValueType = True
          PropertiesClassName = 'TcxCheckBoxProperties'
          Visible = False
          Options.Filtering = False
          Options.Moving = False
          Options.Sorting = False
          Width = 60
          Position.BandIndex = 0
          Position.ColIndex = 3
          Position.RowIndex = 0
        end
        object colDetailsTableName: TcxGridDBBandedColumn
          Caption = 'Table Name'
          DataBinding.FieldName = 'TableName'
          DataBinding.IsNullValueType = True
          PropertiesClassName = 'TcxButtonEditProperties'
          Properties.Buttons = <
            item
              Default = True
              Kind = bkEllipsis
            end>
          Properties.OnButtonClick = DetailsViewColumn1PropertiesButtonClick
          Options.Filtering = False
          Options.Moving = False
          Options.Sorting = False
          Width = 257
          Position.BandIndex = 0
          Position.ColIndex = 0
          Position.RowIndex = 0
        end
        object colDetailsDBName: TcxGridDBBandedColumn
          DataBinding.FieldName = 'DBName'
          DataBinding.IsNullValueType = True
          PropertiesClassName = 'TcxComboBoxProperties'
          Options.Filtering = False
          Options.Moving = False
          Options.Sorting = False
          Width = 230
          Position.BandIndex = 0
          Position.ColIndex = 2
          Position.RowIndex = 0
        end
        object colDetailsSequence: TcxGridDBBandedColumn
          AlternateCaption = 'Initialize key field with this sequence when adding records'
          Caption = 'Sequence'
          DataBinding.FieldName = 'SequenceName'
          DataBinding.IsNullValueType = True
          PropertiesClassName = 'TcxButtonEditProperties'
          Properties.Buttons = <
            item
              Default = True
              Kind = bkEllipsis
            end>
          Properties.OnButtonClick = ButtonEdit
          Visible = False
          HeaderHint = 'Initialize key field with this sequence when adding records'
          Width = 80
          Position.BandIndex = 0
          Position.ColIndex = 4
          Position.RowIndex = 0
        end
        object colMore: TcxGridDBBandedColumn
          Caption = 'More'
          DataBinding.IsNullValueType = True
          PropertiesClassName = 'TcxButtonEditProperties'
          Properties.Buttons = <
            item
              Default = True
              Kind = bkEllipsis
            end>
          Properties.ViewStyle = vsHideCursor
          Properties.OnButtonClick = colMorePropertiesButtonClick
          Options.Filtering = False
          Width = 64
          Position.BandIndex = 0
          Position.ColIndex = 5
          Position.RowIndex = 0
        end
      end
      object gridDetailsLevel1: TcxGridLevel
        GridView = DetailsView
      end
    end
    object edTableName: TcxDBButtonEdit [8]
      Left = 127
      Top = 187
      DataBinding.DataField = 'TableName'
      DataBinding.DataSource = MainSource
      Properties.Buttons = <
        item
          Default = True
          Kind = bkEllipsis
        end>
      Properties.OnButtonClick = edTableNamePropertiesButtonClick
      Style.BorderColor = clWindowFrame
      Style.BorderStyle = ebs3D
      Style.HotTrack = False
      Style.ButtonStyle = bts3D
      TabOrder = 3
      OnExit = edTableNameExit
      Width = 292
    end
    object edValidateSP: TcxDBButtonEdit [9]
      Left = 127
      Top = 268
      DataBinding.DataField = 'CheckSPName'
      DataBinding.DataSource = MainSource
      Properties.Buttons = <
        item
          Default = True
          Kind = bkEllipsis
        end>
      Properties.OnButtonClick = edValidateSPPropertiesButtonClick
      Style.BorderColor = clWindowFrame
      Style.BorderStyle = ebs3D
      Style.HotTrack = False
      Style.ButtonStyle = bts3D
      TabOrder = 8
      Width = 464
    end
    object edUpdateSP: TcxDBButtonEdit [10]
      Left = 127
      Top = 295
      DataBinding.DataField = 'UpdateSPName'
      DataBinding.DataSource = MainSource
      Properties.Buttons = <
        item
          Default = True
          Kind = bkEllipsis
        end>
      Properties.OnButtonClick = edUpdateSPPropertiesButtonClick
      Style.BorderColor = clWindowFrame
      Style.BorderStyle = ebs3D
      Style.HotTrack = False
      Style.ButtonStyle = bts3D
      TabOrder = 9
      Width = 464
    end
    object edAppDialogsId: TcxDBTextEdit [11]
      Left = 485
      Top = 43
      DataBinding.DataField = 'AppDialogsId'
      DataBinding.DataSource = MainSource
      Style.BorderColor = clWindowFrame
      Style.BorderStyle = ebs3D
      Style.HotTrack = False
      TabOrder = 0
      Width = 121
    end
    object gridControls: TcxGrid [12]
      Left = 10000
      Top = 10000
      Width = 457
      Height = 468
      TabOrder = 11
      Visible = False
      object ControlsView: TcxGridDBBandedTableView
        OnDblClick = ControlsViewDblClick
        Navigator.Buttons.CustomButtons = <>
        Navigator.Buttons.First.Visible = True
        Navigator.Buttons.PriorPage.Visible = True
        Navigator.Buttons.Prior.Visible = True
        Navigator.Buttons.Next.Visible = True
        Navigator.Buttons.NextPage.Visible = True
        Navigator.Buttons.Last.Visible = True
        Navigator.Buttons.Insert.Visible = True
        Navigator.Buttons.Append.Visible = False
        Navigator.Buttons.Delete.Visible = True
        Navigator.Buttons.Edit.Visible = True
        Navigator.Buttons.Post.Visible = True
        Navigator.Buttons.Cancel.Visible = True
        Navigator.Buttons.Refresh.Visible = True
        Navigator.Buttons.SaveBookmark.Visible = True
        Navigator.Buttons.GotoBookmark.Visible = True
        Navigator.Buttons.Filter.Visible = True
        ScrollbarAnnotations.CustomAnnotations = <>
        OnCustomDrawCell = ControlsViewCustomDrawCell
        DataController.Summary.DefaultGroupSummaryItems = <>
        DataController.Summary.FooterSummaryItems = <>
        DataController.Summary.SummaryGroups = <>
        OptionsData.CancelOnExit = False
        OptionsData.Deleting = False
        OptionsData.DeletingConfirmation = False
        OptionsData.Editing = False
        OptionsData.Inserting = False
        OptionsView.NoDataToDisplayInfoText = ' '
        OptionsView.ColumnAutoWidth = True
        OptionsView.BandHeaders = False
        Bands = <
          item
          end>
        object colClassName: TcxGridDBBandedColumn
          DataBinding.FieldName = 'ClassName'
          DataBinding.IsNullValueType = True
          Visible = False
          GroupIndex = 0
          Options.Filtering = False
          Options.Moving = False
          SortIndex = 0
          SortOrder = soAscending
          Width = 104
          Position.BandIndex = 0
          Position.ColIndex = 0
          Position.RowIndex = 0
        end
        object colName: TcxGridDBBandedColumn
          Caption = 'Name'
          DataBinding.FieldName = 'ControlName'
          DataBinding.IsNullValueType = True
          Options.Filtering = False
          Options.Moving = False
          Width = 87
          Position.BandIndex = 0
          Position.ColIndex = 2
          Position.RowIndex = 0
        end
        object colCaption: TcxGridDBBandedColumn
          DataBinding.FieldName = 'Caption'
          DataBinding.IsNullValueType = True
          Options.Filtering = False
          Options.Moving = False
          Width = 105
          Position.BandIndex = 0
          Position.ColIndex = 1
          Position.RowIndex = 0
        end
        object colDataField: TcxGridDBBandedColumn
          DataBinding.FieldName = 'Datafield'
          DataBinding.IsNullValueType = True
          Options.Editing = False
          Options.Filtering = False
          Width = 105
          Position.BandIndex = 0
          Position.ColIndex = 3
          Position.RowIndex = 0
        end
      end
      object cxGridLevel1: TcxGridLevel
        GridView = ControlsView
      end
    end
    object cbDBName: TcxDBComboBox [13]
      Left = 470
      Top = 187
      AutoSize = False
      DataBinding.DataField = 'DBName'
      DataBinding.DataSource = MainSource
      Style.BorderColor = clWindowFrame
      Style.BorderStyle = ebs3D
      Style.HotTrack = False
      Style.ButtonStyle = bts3D
      Style.PopupBorderStyle = epbsFrame3D
      TabOrder = 4
      Height = 21
      Width = 121
    end
    object bnControlEdit: TcxButton [14]
      Left = 10000
      Top = 10000
      Width = 90
      Height = 25
      Caption = 'Edit'
      TabOrder = 13
      Visible = False
    end
    object bnControlDelete: TcxButton [15]
      Left = 10000
      Top = 10000
      Width = 90
      Height = 25
      Caption = 'Delete'
      TabOrder = 14
      Visible = False
    end
    object bnControlAdd: TcxButton [16]
      Left = 10000
      Top = 10000
      Width = 90
      Height = 25
      Caption = 'Add'
      TabOrder = 12
      Visible = False
    end
    object bnControlChangeType: TcxButton [17]
      Left = 10000
      Top = 10000
      Width = 90
      Height = 25
      Caption = 'Change Type'
      TabOrder = 15
      Visible = False
    end
    object bnAutoFill: TcxButton [18]
      Left = 10000
      Top = 10000
      Width = 90
      Height = 25
      Caption = 'Auto fill'
      TabOrder = 16
      Visible = False
      OnClick = bnAutoFillClick
    end
    object edSequenceName: TcxDBButtonEdit [19]
      Left = 127
      Top = 214
      Hint = 'Initialize key field with this sequence when adding records'
      DataBinding.DataField = 'SequenceName'
      DataBinding.DataSource = MainSource
      Properties.Buttons = <
        item
          Default = True
          Kind = bkEllipsis
        end>
      Properties.OnButtonClick = edSequenceNamePropertiesButtonClick
      Style.BorderColor = clWindowFrame
      Style.BorderStyle = ebs3D
      Style.HotTrack = False
      Style.ButtonStyle = bts3D
      TabOrder = 5
      Width = 292
    end
    object cbSeqenceDBName: TcxDBComboBox [20]
      Left = 470
      Top = 214
      AutoSize = False
      DataBinding.DataField = 'SequenceDBName'
      DataBinding.DataSource = MainSource
      Style.BorderColor = clWindowFrame
      Style.BorderStyle = ebs3D
      Style.HotTrack = False
      Style.ButtonStyle = bts3D
      Style.PopupBorderStyle = epbsFrame3D
      TabOrder = 6
      Height = 21
      Width = 121
    end
    inherited DialogLayoutGroup_Root: TdxLayoutGroup
      CaptionOptions.Visible = False
    end
    object Tab1: TdxLayoutGroup
      Parent = DialogLayoutGroup_Root
      CaptionOptions.Text = 'Controls'
      ItemIndex = 1
      Index = 1
    end
    object Tab2: TdxLayoutGroup
      CaptionOptions.Text = 'Flags'
      Index = -1
    end
    object Tab3: TdxLayoutGroup
      CaptionOptions.Text = 'Initialization'
      Index = -1
    end
    object Tab0: TdxLayoutGroup
      Parent = DialogLayoutGroup_Root
      CaptionOptions.Text = 'Common'
      ItemIndex = 4
      Index = 0
    end
    object dxLayoutItem7: TdxLayoutItem
      Parent = Tab0
      CaptionOptions.Text = 'Description'
      Control = memDescription
      ControlOptions.OriginalHeight = 40
      ControlOptions.OriginalWidth = 185
      ControlOptions.ShowBorder = False
      Index = 3
    end
    object dxLayoutItem8: TdxLayoutItem
      Parent = dxLayoutAutoCreatedGroup1
      AlignHorz = ahLeft
      CaptionOptions.Text = 'Image1'
      CaptionOptions.Visible = False
      Control = Image1
      ControlOptions.OriginalHeight = 32
      ControlOptions.OriginalWidth = 32
      ControlOptions.ShowBorder = False
      Index = 0
    end
    object dxLayoutItem9: TdxLayoutItem
      Parent = dxLayoutAutoCreatedGroup1
      AlignVert = avClient
      CaptionOptions.Text = 'Dialog properties'
      CaptionOptions.Visible = False
      CaptionOptions.WordWrap = True
      Control = Label1
      ControlOptions.AutoColor = True
      ControlOptions.OriginalHeight = 16
      ControlOptions.OriginalWidth = 180
      ControlOptions.ShowBorder = False
      Index = 1
    end
    object dxLayoutAutoCreatedGroup1: TdxLayoutAutoCreatedGroup
      Parent = Tab0
      LayoutDirection = ldHorizontal
      Index = 0
    end
    object dxLayoutItem2: TdxLayoutItem
      Parent = Tab0
      AlignHorz = ahClient
      AlignVert = avTop
      CaptionOptions.Text = 'Caption'
      Control = edCaption
      ControlOptions.OriginalHeight = 21
      ControlOptions.OriginalWidth = 121
      ControlOptions.ShowBorder = False
      Index = 2
    end
    object dxLayoutGroup1: TdxLayoutGroup
      Parent = Tab0
      AlignHorz = ahClient
      AlignVert = avTop
      CaptionOptions.Text = 'Data'
      ItemIndex = 1
      Index = 4
    end
    object dxLayoutItem4: TdxLayoutItem
      Parent = dxLayoutGroup1
      AlignHorz = ahClient
      AlignVert = avTop
      CaptionOptions.Text = 'Keyfield'
      Control = edKeyfield
      ControlOptions.OriginalHeight = 21
      ControlOptions.OriginalWidth = 121
      ControlOptions.ShowBorder = False
      Index = 2
    end
    object dxLayoutGroup2: TdxLayoutGroup
      Parent = Tab0
      AlignVert = avClient
      CaptionOptions.Text = 'Details Tables'
      Index = 5
    end
    object dxLayoutItem6: TdxLayoutItem
      Parent = dxLayoutGroup2
      AlignVert = avClient
      CaptionOptions.Visible = False
      Control = gridDetails
      ControlOptions.OriginalHeight = 120
      ControlOptions.OriginalWidth = 450
      ControlOptions.ShowBorder = False
      Index = 0
    end
    object dxLayoutItem3: TdxLayoutItem
      Parent = dxLayoutAutoCreatedGroup5
      AlignHorz = ahClient
      AlignVert = avTop
      CaptionOptions.Text = 'Table'
      Control = edTableName
      ControlOptions.OriginalHeight = 21
      ControlOptions.OriginalWidth = 121
      ControlOptions.ShowBorder = False
      Index = 0
    end
    object dxLayoutItem5: TdxLayoutItem
      Parent = dxLayoutGroup1
      CaptionOptions.Text = 'Validation SP'
      Control = edValidateSP
      ControlOptions.OriginalHeight = 21
      ControlOptions.OriginalWidth = 121
      ControlOptions.ShowBorder = False
      Index = 3
    end
    object dxLayoutItem11: TdxLayoutItem
      Parent = dxLayoutGroup1
      CaptionOptions.Text = 'Update SP'
      Control = edUpdateSP
      ControlOptions.OriginalHeight = 21
      ControlOptions.OriginalWidth = 121
      ControlOptions.ShowBorder = False
      Index = 4
    end
    object item_edAppDialogsId: TdxLayoutItem
      Parent = dxLayoutAutoCreatedGroup1
      AlignHorz = ahRight
      CaptionOptions.Text = 'AppDialogsId'
      Control = edAppDialogsId
      ControlOptions.OriginalHeight = 21
      ControlOptions.OriginalWidth = 121
      ControlOptions.ShowBorder = False
      Index = 2
    end
    object dxLayoutSeparatorItem1: TdxLayoutSeparatorItem
      Parent = Tab0
      CaptionOptions.Text = 'Separator'
      Index = 1
    end
    object dxLayoutGroup3: TdxLayoutGroup
      Parent = Tab1
      AlignHorz = ahClient
      AlignVert = avClient
      CaptionOptions.Text = 'Data'
      CaptionOptions.Visible = False
      LayoutDirection = ldHorizontal
      Index = 1
    end
    object dxLayoutItem12: TdxLayoutItem
      Parent = dxLayoutGroup3
      AlignHorz = ahClient
      AlignVert = avClient
      CaptionOptions.AlignVert = tavTop
      Control = gridControls
      ControlOptions.OriginalHeight = 134
      ControlOptions.OriginalWidth = 290
      ControlOptions.ShowBorder = False
      Index = 0
    end
    object dxLayoutItem14: TdxLayoutItem
      Parent = dxLayoutAutoCreatedGroup3
      AlignHorz = ahLeft
      AlignVert = avTop
      Control = Image2
      ControlOptions.OriginalHeight = 32
      ControlOptions.OriginalWidth = 32
      ControlOptions.ShowBorder = False
      Index = 0
    end
    object dxLayoutItem15: TdxLayoutItem
      Parent = dxLayoutAutoCreatedGroup3
      AlignVert = avClient
      CaptionOptions.Text = 'Dialog controls'
      CaptionOptions.Visible = False
      Control = Label2
      ControlOptions.AutoColor = True
      ControlOptions.OriginalHeight = 16
      ControlOptions.OriginalWidth = 180
      ControlOptions.ShowBorder = False
      Index = 1
    end
    object dxLayoutAutoCreatedGroup3: TdxLayoutAutoCreatedGroup
      Parent = Tab1
      AlignVert = avTop
      LayoutDirection = ldHorizontal
      Index = 0
    end
    object dxLayoutItem20: TdxLayoutItem
      Parent = dxLayoutAutoCreatedGroup5
      AlignVert = avClient
      CaptionOptions.Text = 'DBName'
      Control = cbDBName
      ControlOptions.OriginalHeight = 21
      ControlOptions.OriginalWidth = 121
      ControlOptions.ShowBorder = False
      Index = 1
    end
    object dxLayoutItem13: TdxLayoutItem
      Parent = dxLayoutAutoCreatedGroup4
      CaptionOptions.AlignVert = tavTop
      CaptionOptions.Text = 'cxButton2'
      CaptionOptions.Visible = False
      Control = bnControlEdit
      ControlOptions.OriginalHeight = 25
      ControlOptions.OriginalWidth = 75
      ControlOptions.ShowBorder = False
      Index = 1
    end
    object dxLayoutAutoCreatedGroup4: TdxLayoutAutoCreatedGroup
      Parent = dxLayoutGroup3
      Index = 1
    end
    object dxLayoutItem17: TdxLayoutItem
      Parent = dxLayoutAutoCreatedGroup4
      CaptionOptions.AlignVert = tavTop
      CaptionOptions.Text = 'cxButton3'
      CaptionOptions.Visible = False
      Control = bnControlDelete
      ControlOptions.OriginalHeight = 25
      ControlOptions.OriginalWidth = 75
      ControlOptions.ShowBorder = False
      Index = 2
    end
    object dxLayoutItem16: TdxLayoutItem
      Parent = dxLayoutAutoCreatedGroup4
      CaptionOptions.AlignVert = tavTop
      CaptionOptions.Text = 'Add'
      CaptionOptions.Visible = False
      Control = bnControlAdd
      ControlOptions.OriginalHeight = 25
      ControlOptions.OriginalWidth = 75
      ControlOptions.ShowBorder = False
      Index = 0
    end
    object dxLayoutItem18: TdxLayoutItem
      Parent = dxLayoutAutoCreatedGroup4
      CaptionOptions.AlignVert = tavTop
      CaptionOptions.Text = 'cxButton4'
      CaptionOptions.Visible = False
      Control = bnControlChangeType
      ControlOptions.OriginalHeight = 25
      ControlOptions.OriginalWidth = 90
      ControlOptions.ShowBorder = False
      Index = 3
    end
    object dxLayoutItem19: TdxLayoutItem
      Parent = dxLayoutAutoCreatedGroup4
      CaptionOptions.AlignVert = tavTop
      CaptionOptions.Text = 'cxButton5'
      CaptionOptions.Visible = False
      Control = bnAutoFill
      ControlOptions.OriginalHeight = 25
      ControlOptions.OriginalWidth = 75
      ControlOptions.ShowBorder = False
      Index = 4
    end
    object Tab4: TdxLayoutGroup
      CaptionOptions.Text = 'Validation'
      Index = -1
    end
    object item_Sequence: TdxLayoutItem
      Parent = dxLayoutAutoCreatedGroup6
      AlignHorz = ahClient
      CaptionOptions.Text = 'Default sequence'
      Control = edSequenceName
      ControlOptions.OriginalHeight = 21
      ControlOptions.OriginalWidth = 121
      ControlOptions.ShowBorder = False
      Index = 0
    end
    object dxLayoutItem10: TdxLayoutItem
      Parent = dxLayoutAutoCreatedGroup6
      AlignVert = avClient
      CaptionOptions.Text = 'DBName'
      Control = cbSeqenceDBName
      ControlOptions.OriginalHeight = 21
      ControlOptions.OriginalWidth = 121
      ControlOptions.ShowBorder = False
      Index = 1
    end
    object dxLayoutAutoCreatedGroup5: TdxLayoutAutoCreatedGroup
      Parent = dxLayoutGroup1
      AlignVert = avTop
      LayoutDirection = ldHorizontal
      Index = 0
    end
    object dxLayoutAutoCreatedGroup6: TdxLayoutAutoCreatedGroup
      Parent = dxLayoutGroup1
      LayoutDirection = ldHorizontal
      Index = 1
    end
  end
  inherited MainSource: TDataSource
    Left = 312
    Top = 585
  end
  inherited PopupMenu: TPopupMenu
    inherited miCopyFrom: TMenuItem
      Enabled = True
      OnClick = miCopyFromClick
    end
  end
  object PopupMenu1: TPopupMenu
    Images = ImageContainer.Images16
    OnPopup = PopupMenu1Popup
    Left = 368
    Top = 592
    object Add1: TMenuItem
      Caption = 'Add'
      ImageIndex = 8
      OnClick = Add1Click
    end
    object Delete1: TMenuItem
      Caption = 'Delete'
      Enabled = False
      ImageIndex = 228
      OnClick = Delete1Click
    end
  end
end
