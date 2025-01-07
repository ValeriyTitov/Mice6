inherited ManagerEditorAppTemplate: TManagerEditorAppTemplate
  Left = 530
  Top = 233
  Caption = 'Edit Template'
  ClientHeight = 817
  ClientWidth = 1024
  Constraints.MinHeight = 300
  Constraints.MinWidth = 400
  OnCloseQuery = FormCloseQuery
  ExplicitWidth = 1040
  ExplicitHeight = 855
  TextHeight = 13
  inherited pnBottomButtons: TPanel
    Top = 776
    Width = 1024
    ExplicitTop = 776
    ExplicitWidth = 1024
    inherited bnOK: TcxButton
      Left = 856
      ExplicitLeft = 856
    end
    inherited bnCancel: TcxButton
      Left = 937
      ExplicitLeft = 937
    end
  end
  inherited DialogLayout: TdxLayoutControl
    Top = 26
    Width = 1024
    Height = 750
    ExplicitTop = 26
    ExplicitWidth = 1024
    ExplicitHeight = 750
    object gridProps: TcxDBVerticalGrid [0]
      Left = 6
      Top = 272
      Width = 240
      Height = 472
      OptionsView.ScrollBars = ssNone
      OptionsView.RowHeaderWidth = 108
      Navigator.Buttons.CustomButtons = <>
      ScrollbarAnnotations.CustomAnnotations = <>
      TabOrder = 6
      OnItemChanged = gridPropsItemChanged
      Version = 1
      object colAppTemplatesDataId: TcxDBEditorRow
        Properties.EditPropertiesClassName = 'TcxTextEditProperties'
        Properties.EditProperties.ReadOnly = True
        Properties.DataBinding.FieldName = 'AppTemplatesDataId'
        ID = 0
        ParentID = -1
        Index = 0
        Version = 1
      end
      object colParentId: TcxDBEditorRow
        Properties.EditPropertiesClassName = 'TcxTextEditProperties'
        Properties.EditProperties.ReadOnly = False
        Properties.DataBinding.FieldName = 'ParentId'
        ID = 1
        ParentID = 0
        Index = 0
        Version = 1
      end
      object colActive: TcxDBEditorRow
        Properties.EditPropertiesClassName = 'TcxCheckBoxProperties'
        Properties.DataBinding.FieldName = 'Active'
        ID = 2
        ParentID = -1
        Index = 1
        Version = 1
      end
      object colTagName: TcxDBEditorRow
        Height = 32
        Properties.Caption = 'Name'
        Properties.EditPropertiesClassName = 'TcxMemoProperties'
        Properties.DataBinding.FieldName = 'TagName'
        ID = 3
        ParentID = -1
        Index = 2
        Version = 1
      end
      object colTagType: TcxDBEditorRow
        Properties.Caption = 'Type'
        Properties.EditPropertiesClassName = 'TcxImageComboBoxProperties'
        Properties.EditProperties.Images = ImageContainer.Images16
        Properties.EditProperties.Items = <
          item
            Description = 'Xml Tag/JsonPair'
            ImageIndex = 600
            Value = 0
          end
          item
            Description = 'Xml Attribute/JsonPair'
            ImageIndex = 87
            Value = 1
          end
          item
            Description = 'Json Item'
            ImageIndex = 255
            Value = 2
          end
          item
            Description = 'List Through DataSet'
            ImageIndex = 5
            Value = 3
          end
          item
            Description = 'Group. Attach childs to parent'
            ImageIndex = 51
            Value = 4
          end>
        Properties.DataBinding.FieldName = 'TagType'
        ID = 4
        ParentID = -1
        Index = 3
        Version = 1
      end
      object colValueType: TcxDBEditorRow
        Properties.Caption = 'Json Type'
        Properties.EditPropertiesClassName = 'TcxImageComboBoxProperties'
        Properties.EditProperties.Images = ImageContainer.Images16
        Properties.EditProperties.Items = <
          item
            Description = 'String'
            ImageIndex = 191
            Value = 0
          end
          item
            Description = 'Number'
            ImageIndex = 170
            Value = 1
          end
          item
            Description = 'Boolean'
            ImageIndex = 124
            Value = 2
          end
          item
            Description = 'Null'
            ImageIndex = 233
            Value = 3
          end
          item
            Description = 'Json Object'
            ImageIndex = 6
            Value = 4
          end
          item
            Description = 'Json Array'
            ImageIndex = 7
            Value = 5
          end
          item
            Description = 'Create Value Pair'
            ImageIndex = 136
            Value = 6
          end>
        Properties.DataBinding.FieldName = 'ValueType'
        ID = 5
        ParentID = -1
        Index = 4
        Version = 1
      end
      object colDataSetName: TcxDBEditorRow
        Properties.Caption = 'Dataset'
        Properties.EditPropertiesClassName = 'TcxComboBoxProperties'
        Properties.EditProperties.OnChange = colDataSetNameEditPropertiesChange
        Properties.DataBinding.FieldName = 'DatasetName'
        ID = 6
        ParentID = -1
        Index = 5
        Version = 1
      end
      object colFilter: TcxDBEditorRow
        Properties.Caption = 'Filter'
        Properties.EditPropertiesClassName = 'TcxTextEditProperties'
        Properties.DataBinding.FieldName = 'DataSetFilter'
        ID = 7
        ParentID = 6
        Index = 0
        Version = 1
      end
      object colGroupValueProperties: TcxCategoryRow
        Properties.Caption = 'Value properties'
        Visible = False
        ID = 8
        ParentID = -1
        Index = 6
        Version = 1
      end
      object colValue: TcxDBEditorRow
        Height = 32
        Properties.EditPropertiesClassName = 'TcxMemoProperties'
        Properties.DataBinding.FieldName = 'Value'
        ID = 9
        ParentID = -1
        Index = 7
        Version = 1
      end
      object colValueSource: TcxDBEditorRow
        Properties.Caption = 'Source'
        Properties.EditPropertiesClassName = 'TcxImageComboBoxProperties'
        Properties.EditProperties.Images = ImageContainer.Images16
        Properties.EditProperties.Items = <
          item
            Description = 'Constant value'
            ImageIndex = 462
            Value = '0'
          end
          item
            Description = 'Datafield'
            ImageIndex = 164
            Value = '1'
          end
          item
            Description = 'Parameter'
            ImageIndex = 284
            Value = '2'
          end
          item
            Description = 'Global setting'
            ImageIndex = 73
            Value = '3'
          end>
        Properties.EditProperties.OnChange = colValueSourceEditPropertiesChange
        Properties.DataBinding.FieldName = 'ValueSource'
        ID = 10
        ParentID = 9
        Index = 0
        Version = 1
      end
      object colGroupCreateConditions: TcxCategoryRow
        Properties.Caption = 'Create condtion'
        ID = 11
        ParentID = -1
        Index = 8
        Version = 1
      end
      object colSign: TcxDBEditorRow
        Properties.Caption = 'Sign'
        Properties.EditPropertiesClassName = 'TcxImageComboBoxProperties'
        Properties.EditProperties.Items = <
          item
            Description = '<None> (Always create)'
            ImageIndex = 0
            Value = 0
          end
          item
            Description = '='
            Value = 1
          end
          item
            Description = '<>'
            Value = 2
          end
          item
            Description = '>'
            Value = 3
          end
          item
            Description = '>='
            Value = 4
          end
          item
            Description = '<'
            Value = 5
          end
          item
            Description = '<='
            Value = 6
          end
          item
            Description = 'IS NULL'
            Value = 7
          end
          item
            Description = 'IS NOT NULL'
            Value = 8
          end
          item
            Description = 'IN'
            Value = 9
          end
          item
            Description = 'NOT IN'
            Value = 10
          end>
        Properties.EditProperties.OnChange = colSignEditPropertiesChange
        Properties.DataBinding.FieldName = 'CreateCondition'
        ID = 12
        ParentID = 11
        Index = 0
        Version = 1
      end
      object colCompareValue: TcxDBEditorRow
        Properties.Caption = 'Compare value'
        Properties.EditPropertiesClassName = 'TcxTextEditProperties'
        Properties.DataBinding.FieldName = 'CreateConditionValue'
        ID = 13
        ParentID = 11
        Index = 1
        Version = 1
      end
      object colGroupOther: TcxCategoryRow
        Properties.Caption = 'Other'
        ID = 14
        ParentID = -1
        Index = 9
        Version = 1
      end
      object colFormat: TcxDBEditorRow
        Properties.EditPropertiesClassName = 'TcxTextEditProperties'
        Properties.DataBinding.FieldName = 'Format'
        ID = 15
        ParentID = 14
        Index = 0
        Version = 1
      end
      object colDefaultValue: TcxDBEditorRow
        Height = 17
        Properties.EditPropertiesClassName = 'TcxTextEditProperties'
        Properties.DataBinding.FieldName = 'DefaultValue'
        ID = 16
        ParentID = 14
        Index = 1
        Version = 1
      end
      object colDescription: TcxDBEditorRow
        Height = 60
        Properties.EditPropertiesClassName = 'TcxMemoProperties'
        Properties.DataBinding.FieldName = 'Description'
        ID = 17
        ParentID = 14
        Index = 2
        Version = 1
      end
    end
    object edName: TcxDBTextEdit [1]
      Left = 53
      Top = 54
      AutoSize = False
      DataBinding.DataField = 'Name'
      DataBinding.DataSource = MainSource
      Style.BorderColor = clWindowFrame
      Style.BorderStyle = ebs3D
      Style.HotTrack = False
      TabOrder = 1
      Height = 21
      Width = 794
    end
    object memoDescription: TcxDBMemo [2]
      Left = 21
      Top = 99
      DataBinding.DataField = 'Description'
      DataBinding.DataSource = MainSource
      Style.BorderColor = clWindowFrame
      Style.BorderStyle = ebs3D
      Style.HotTrack = False
      TabOrder = 3
      Height = 89
      Width = 982
    end
    object ddTemplateType: TcxDBImageComboBox [3]
      Left = 882
      Top = 54
      AutoSize = False
      DataBinding.DataField = 'TemplateType'
      DataBinding.DataSource = MainSource
      Properties.Images = ImageContainer.Images16
      Properties.Items = <
        item
          Description = 'Xml'
          ImageIndex = 402
          Value = 0
        end
        item
          Description = 'Xbrl'
          ImageIndex = 699
          Value = 1
        end
        item
          Description = 'Json'
          ImageIndex = 381
          Value = 2
        end>
      Style.BorderColor = clWindowFrame
      Style.BorderStyle = ebs3D
      Style.HotTrack = False
      Style.ButtonStyle = bts3D
      Style.PopupBorderStyle = epbsFrame3D
      TabOrder = 2
      Height = 21
      Width = 121
    end
    object cbActive: TcxDBCheckBox [4]
      Left = 6
      Top = 6
      Caption = 'Active'
      DataBinding.DataField = 'Active'
      DataBinding.DataSource = MainSource
      Style.BorderColor = clWindowFrame
      Style.BorderStyle = ebs3D
      Style.HotTrack = False
      TabOrder = 0
      OnClick = cbActiveClick
    end
    object cbFormatAfterCreate: TcxDBCheckBox [5]
      Left = 871
      Top = 215
      Caption = 'Format AfterCreate'
      DataBinding.DataField = 'FormatAfterCreate'
      DataBinding.DataSource = MainSource
      Style.BorderColor = clWindowFrame
      Style.BorderStyle = ebs3D
      Style.HotTrack = False
      TabOrder = 5
    end
    object edDefaultDateTimeFormat: TcxDBTextEdit [6]
      Left = 156
      Top = 215
      DataBinding.DataField = 'DefaultDateTimeFormat'
      DataBinding.DataSource = MainSource
      Style.BorderColor = clWindowFrame
      Style.BorderStyle = ebs3D
      Style.HotTrack = False
      TabOrder = 4
      Width = 709
    end
    object Schema: TdxDbOrgChart [7]
      Left = 262
      Top = 274
      Width = 754
      Height = 468
      KeyFieldName = 'AppTemplatesDataId'
      ParentFieldName = 'ParentId'
      TextFieldName = 'TagName'
      OrderFieldName = 'OrderId'
      LineColor = clGray
      DefaultNodeWidth = 90
      DefaultNodeHeight = 80
      Options = [ocSelect, ocFocus, ocButtons, ocDblClick, ocEdit, ocCanDrag, ocShowDrag, ocAnimate]
      EditMode = [emCenter, emVCenter, emWrap]
      Images = ImageContainer.Images16
      DefaultImageAlign = iaLT
      BorderStyle = bsNone
      Rotated = True
      OnCreateNode = SchemaCreateNode
      OnDeletion = SchemaDeletion
      Color = clDefault
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -13
      Font.Name = 'Tahoma'
      Font.Style = []
      OnKeyDown = SchemaKeyDown
      ParentFont = False
    end
    inherited DialogLayoutGroup_Root: TdxLayoutGroup
      ItemIndex = 1
      LayoutDirection = ldVertical
    end
    object groupHeader: TdxLayoutGroup
      Parent = groupCommon
      CaptionOptions.Text = 'Properties'
      ButtonOptions.Buttons = <>
      ItemIndex = 2
      Index = 0
    end
    object groupSchema: TdxLayoutGroup
      Parent = DialogLayoutGroup_Root
      AlignVert = avClient
      CaptionOptions.Text = 'New Group'
      CaptionOptions.Visible = False
      ButtonOptions.Buttons = <>
      ShowBorder = False
      Index = 2
    end
    object item_Properties: TdxLayoutItem
      Parent = groupSchemaEditors
      AlignVert = avClient
      CaptionOptions.Text = 'cxDBVerticalGrid1'
      CaptionOptions.Visible = False
      Control = gridProps
      ControlOptions.OriginalHeight = 200
      ControlOptions.OriginalWidth = 240
      ControlOptions.ShowBorder = False
      Index = 0
    end
    object item_edName: TdxLayoutItem
      Parent = dxLayoutAutoCreatedGroup1
      AlignHorz = ahClient
      AlignVert = avClient
      CaptionOptions.Text = 'Name'
      Control = edName
      ControlOptions.OriginalHeight = 21
      ControlOptions.OriginalWidth = 247
      ControlOptions.ShowBorder = False
      Index = 0
    end
    object item_memoDescription: TdxLayoutItem
      Parent = groupHeader
      CaptionOptions.Text = 'Description'
      CaptionOptions.Layout = clTop
      Control = memoDescription
      ControlOptions.OriginalHeight = 89
      ControlOptions.OriginalWidth = 185
      ControlOptions.ShowBorder = False
      Index = 1
    end
    object item_ddTemplateType: TdxLayoutItem
      Parent = dxLayoutAutoCreatedGroup1
      AlignHorz = ahRight
      AlignVert = avClient
      CaptionOptions.Text = 'Type'
      Control = ddTemplateType
      ControlOptions.OriginalHeight = 21
      ControlOptions.OriginalWidth = 121
      ControlOptions.ShowBorder = False
      Index = 1
    end
    object dxLayoutAutoCreatedGroup1: TdxLayoutAutoCreatedGroup
      Parent = groupHeader
      LayoutDirection = ldHorizontal
      Index = 0
    end
    object item_cbActive: TdxLayoutItem
      Parent = DialogLayoutGroup_Root
      CaptionOptions.Text = 'Active'
      CaptionOptions.Visible = False
      Control = cbActive
      ControlOptions.OriginalHeight = 21
      ControlOptions.OriginalWidth = 54
      ControlOptions.ShowBorder = False
      Index = 0
    end
    object item_FormatAfterCreate: TdxLayoutItem
      Parent = groupSettings
      AlignHorz = ahLeft
      AlignVert = avClient
      CaptionOptions.Text = 'FormatAfterCreate'
      CaptionOptions.Visible = False
      Control = cbFormatAfterCreate
      ControlOptions.OriginalHeight = 21
      ControlOptions.OriginalWidth = 117
      ControlOptions.ShowBorder = False
      Index = 1
    end
    object groupSettings: TdxLayoutGroup
      Parent = groupHeader
      CaptionOptions.Text = 'Settings'
      ButtonOptions.Buttons = <>
      ItemIndex = 1
      LayoutDirection = ldHorizontal
      Index = 2
    end
    object item_edDefaultDateTimeFormat: TdxLayoutItem
      Parent = groupSettings
      AlignHorz = ahClient
      AlignVert = avTop
      CaptionOptions.Text = 'Default datetime format'
      Control = edDefaultDateTimeFormat
      ControlOptions.OriginalHeight = 21
      ControlOptions.OriginalWidth = 202
      ControlOptions.ShowBorder = False
      Index = 0
    end
    object groupCommon: TdxLayoutGroup
      Parent = DialogLayoutGroup_Root
      CaptionOptions.Text = 'New Group'
      CaptionOptions.Visible = False
      ButtonOptions.Buttons = <>
      ShowBorder = False
      Index = 1
    end
    object groupSchemaEditors: TdxLayoutGroup
      Parent = groupSchema
      AlignHorz = ahClient
      AlignVert = avClient
      CaptionOptions.Text = 'New Group'
      CaptionOptions.Visible = False
      ButtonOptions.Buttons = <>
      ItemIndex = 1
      LayoutDirection = ldHorizontal
      ShowBorder = False
      Index = 0
    end
    object item_Schema: TdxLayoutItem
      Parent = groupSchemaEditors
      AlignHorz = ahClient
      AlignVert = avClient
      CaptionOptions.Text = 'New Item'
      CaptionOptions.Visible = False
      Control = Schema
      ControlOptions.OriginalHeight = 300
      ControlOptions.OriginalWidth = 400
      Index = 2
    end
    object Splitter: TdxLayoutSplitterItem
      Parent = groupSchemaEditors
      SizeOptions.AssignedValues = [sovSizableHorz, sovSizableVert]
      SizeOptions.SizableHorz = False
      SizeOptions.SizableVert = False
      CaptionOptions.Text = 'Splitter'
      Index = 1
    end
  end
  inherited MainSource: TDataSource
    Left = 168
    Top = 425
  end
  inherited PopupMenu: TPopupMenu
    Left = 968
    Top = 96
    inherited miCopyFrom: TMenuItem
      Enabled = True
    end
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
    PopupMenuLinks = <
      item
      end>
    Style = bmsFlat
    UseSystemFont = True
    Left = 52
    Top = 116
    PixelsPerInch = 96
    DockControlHeights = (
      0
      0
      26
      0)
    object topMenu: TdxBar
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
          ItemName = 'bnNewItemGroup'
        end
        item
          Visible = True
          ItemName = 'bnDelete'
        end
        item
          Visible = True
          ItemName = 'bnActivity'
        end
        item
          BeginGroup = True
          Visible = True
          ItemName = 'bnRefresh'
        end
        item
          Visible = True
          ItemName = 'bnSave'
        end
        item
          Visible = True
          ItemName = 'bnCollapseAll'
        end
        item
          Visible = True
          ItemName = 'bnExpandAll'
        end
        item
          BeginGroup = True
          Visible = True
          ItemName = 'bnRise'
        end
        item
          Visible = True
          ItemName = 'bnLower'
        end
        item
          Visible = True
          ItemName = 'bnApplyToChildren'
        end
        item
          BeginGroup = True
          Visible = True
          ItemName = 'bnRun'
        end
        item
          Visible = True
          ItemName = 'bnMore'
        end
        item
          Visible = True
          ItemName = 'bnProps'
        end
        item
          BeginGroup = True
          Visible = True
          ItemName = 'bnImpotGroup'
        end>
      NotDocking = [dsNone, dsLeft, dsTop, dsRight, dsBottom]
      OldName = 'Default'
      OneOnRow = True
      Row = 0
      UseOwnFont = False
      Visible = True
      WholeRow = False
    end
    object bnNewRootItem: TdxBarButton
      Caption = 'New root item'
      Category = 0
      Hint = 'New root item'
      Visible = ivAlways
      ImageIndex = 652
    end
    object bnDelete: TdxBarButton
      Caption = 'Delete'
      Category = 0
      Hint = 'Delete'
      Visible = ivAlways
      ImageIndex = 228
      ShortCut = 16430
    end
    object bnRefresh: TdxBarButton
      Caption = 'Refresh'
      Category = 0
      Hint = 'Refresh'
      Visible = ivAlways
      ImageIndex = 43
      PaintStyle = psCaptionGlyph
      ShortCut = 116
    end
    object bnActivity: TdxBarButton
      Caption = 'Activity'
      Category = 0
      Hint = 'Activity'
      Visible = ivAlways
      ImageIndex = 124
      PaintStyle = psCaptionGlyph
      ShortCut = 114
    end
    object bnNewItemGroup: TdxBarSubItem
      Caption = 'New'
      Category = 0
      Visible = ivAlways
      ImageIndex = 430
      ShowCaption = False
      ItemLinks = <
        item
          Visible = True
          ItemName = 'bnNewRootItem'
        end
        item
          Visible = True
          ItemName = 'bnNewItem'
        end
        item
          Visible = True
          ItemName = 'bnInsertDataSet'
        end>
    end
    object bnNewItem: TdxBarButton
      Caption = 'New item'
      Category = 0
      Hint = 'New item'
      Visible = ivAlways
      ImageIndex = 653
    end
    object bnSave: TdxBarButton
      Caption = 'Save'
      Category = 0
      Hint = 'Save'
      Visible = ivAlways
      ImageIndex = 505
      PaintStyle = psCaptionGlyph
    end
    object bnProps: TdxBarSubItem
      Caption = 'Properties'
      Category = 0
      Visible = ivAlways
      ItemLinks = <
        item
          Visible = True
          ItemName = 'bnDataSetList'
        end
        item
          Visible = True
          ItemName = 'bnParams'
        end>
    end
    object bnImpotGroup: TdxBarSubItem
      Caption = 'Import'
      Category = 0
      Visible = ivAlways
      ItemLinks = <
        item
          Visible = True
          ItemName = 'bnImportXml'
        end
        item
          Visible = True
          ItemName = 'bnImportXbrl'
        end
        item
          Visible = True
          ItemName = 'bnImportJson'
        end
        item
          Visible = True
          ItemName = 'bnImportDatabaseObject'
        end
        item
          Visible = True
          ItemName = 'bnImportTemplate'
        end
        item
          BeginGroup = True
          Visible = True
          ItemName = 'cbImportToRoot'
        end>
    end
    object bnDataSetList: TdxBarButton
      Caption = 'DataSets'
      Category = 0
      Hint = 'DataSets'
      Visible = ivAlways
      OnClick = bnDataSetListClick
    end
    object bnImportXml: TdxBarButton
      Caption = 'Xml'
      Category = 0
      Hint = 'Xml'
      Visible = ivAlways
      ImageIndex = 401
      OnClick = bnImportXmlClick
    end
    object bnImportXbrl: TdxBarButton
      Caption = 'Xbrl'
      Category = 0
      Hint = 'Xbrl'
      Visible = ivAlways
      ImageIndex = 699
      OnClick = bnImportXbrlClick
    end
    object bnImportDatabaseObject: TdxBarButton
      Caption = 'Database object'
      Category = 0
      Hint = 'Database object'
      Visible = ivAlways
      ImageIndex = 166
      OnClick = bnImportDatabaseObjectClick
    end
    object bnImportJson: TdxBarButton
      Caption = 'Json'
      Category = 0
      Hint = 'Json'
      Visible = ivAlways
      ImageIndex = 381
      OnClick = bnImportJsonClick
    end
    object cbImportToRoot: TcxBarEditItem
      Caption = 'Import to Root'
      Category = 0
      Hint = 'Import to Root'
      Visible = ivAlways
      OnChange = cbImportToRootChange
      PropertiesClassName = 'TcxCheckBoxProperties'
    end
    object bnNodeList: TdxBarSubItem
      Caption = 'Nodes'
      Category = 0
      Visible = ivAlways
      ItemLinks = <>
    end
    object bnCollapseAll: TdxBarButton
      Caption = 'Collapse All'
      Category = 0
      Hint = 'Collapse All'
      Visible = ivAlways
      ImageIndex = 49
      OnClick = bnCollapseAllClick
    end
    object bnExpandAll: TdxBarButton
      Caption = 'Expand All'
      Category = 0
      Hint = 'Expand All'
      Visible = ivAlways
      ImageIndex = 50
      OnClick = bnExpandAllClick
    end
    object dxBarButton1: TdxBarButton
      Caption = 'More'
      Category = 0
      Hint = 'More'
      Visible = ivAlways
    end
    object bnMore: TdxBarSubItem
      Caption = 'More'
      Category = 0
      Visible = ivAlways
      ItemLinks = <
        item
          Visible = True
          ItemName = 'bnGoto'
        end
        item
          Visible = True
          ItemName = 'bnFind'
        end>
    end
    object bnGoto: TdxBarButton
      Caption = 'Goto AppTemplatesDataId'
      Category = 0
      Hint = 'Goto AppTemplatesDataId'
      Visible = ivAlways
    end
    object bnFind: TdxBarButton
      Caption = 'Find tag...'
      Category = 0
      Hint = 'Find tag'
      Visible = ivAlways
    end
    object bnInsertDataSet: TdxBarButton
      Caption = 'Insert DataSet'
      Category = 0
      Hint = 'Insert DataSet in current nodee andd assume as dataset'
      Visible = ivAlways
      ImageIndex = 184
    end
    object bnRun: TdxBarButton
      Caption = 'Run'
      Category = 0
      Hint = 'Run'
      Visible = ivAlways
      ImageIndex = 469
      PaintStyle = psCaptionGlyph
    end
    object bnParams: TdxBarButton
      Caption = 'Parameters...'
      Category = 0
      Hint = 'Parameters'
      Visible = ivAlways
      OnClick = bnParamsClick
    end
    object bnRise: TdxBarButton
      Caption = 'Rise'
      Category = 0
      Hint = 'Rise'
      Visible = ivAlways
      ImageIndex = 68
    end
    object bnLower: TdxBarButton
      Caption = 'Lower'
      Category = 0
      Hint = 'Lower'
      Visible = ivAlways
      ImageIndex = 67
    end
    object bnApplyToChildren: TdxBarButton
      Caption = 'Apply to all children'
      Category = 0
      Hint = 
        'Apply current value to all children (or hold CTRL when changing ' +
        'fields)'
      Visible = ivAlways
      ImageIndex = 284
      OnClick = bnApplyToChildrenClick
    end
    object bnImportTemplate: TdxBarButton
      Caption = 'From another template'
      Category = 0
      Hint = 'From another template'
      Visible = ivAlways
      ImageIndex = 95
      OnClick = bnImportTemplateClick
    end
  end
  object DataSetParams: TdxMemData
    Indexes = <>
    SortOptions = []
    Left = 568
    Top = 106
    object DataSetParamsParamName: TStringField
      FieldName = 'Name'
      Size = 32
    end
    object DataSetParamsParamValue: TStringField
      FieldName = 'Value'
      Size = 255
    end
  end
  object dsParams: TDataSource
    DataSet = DataSetParams
    Left = 640
    Top = 106
  end
end
