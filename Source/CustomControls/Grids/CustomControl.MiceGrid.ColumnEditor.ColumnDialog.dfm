inherited ColumnPropetiesDlg: TColumnPropetiesDlg
  Caption = 'Column properties'
  ClientHeight = 604
  ClientWidth = 451
  Constraints.MinHeight = 350
  Constraints.MinWidth = 310
  StyleElements = [seFont, seClient, seBorder]
  OnClose = FormClose
  OnCreate = FormCreate
  OnShow = FormShow
  ExplicitWidth = 467
  ExplicitHeight = 643
  TextHeight = 13
  inherited pnBottomButtons: TPanel
    Top = 563
    Width = 451
    StyleElements = [seFont, seClient, seBorder]
    ExplicitTop = 563
    ExplicitWidth = 451
    inherited bnOK: TcxButton
      Left = 281
      ExplicitLeft = 281
    end
    inherited bnCancel: TcxButton
      Left = 362
      ExplicitLeft = 362
    end
  end
  object Panel1: TPanel
    Left = 0
    Top = 0
    Width = 451
    Height = 257
    Align = alTop
    BevelOuter = bvNone
    ShowCaption = False
    TabOrder = 1
    DesignSize = (
      451
      257)
    object lbColType: TLabel
      Left = 10
      Top = 56
      Width = 60
      Height = 13
      Caption = 'Column type'
    end
    object Image1: TImage
      Left = 16
      Top = 9
      Width = 32
      Height = 32
      Transparent = True
    end
    object Label1: TLabel
      Left = 64
      Top = 19
      Width = 119
      Height = 13
      Caption = 'Additional properties'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Tahoma'
      Font.Style = [fsBold]
      ParentFont = False
    end
    object Label3: TLabel
      Left = 10
      Top = 80
      Width = 34
      Height = 13
      Caption = 'Sorting'
    end
    object Label4: TLabel
      Left = 9
      Top = 185
      Width = 97
      Height = 13
      Caption = 'Column header hint:'
    end
    object Label5: TLabel
      Left = 10
      Top = 162
      Width = 61
      Height = 13
      Caption = 'Cell hint field'
    end
    object Label6: TLabel
      Left = 8
      Top = 102
      Width = 23
      Height = 13
      Caption = 'Align'
    end
    object Label7: TLabel
      Left = 10
      Top = 136
      Width = 65
      Height = 13
      Caption = 'Column Name'
    end
    object cbMoving: TcxDBCheckBox
      Left = 379
      Top = 130
      Hint = 'Allow user to move column'
      Caption = 'Moving'
      DataBinding.DataField = 'Moving'
      DataBinding.DataSource = DataSource
      TabOrder = 5
    end
    object cbReadOnly: TcxDBCheckBox
      Left = 303
      Top = 130
      Caption = 'Read Only'
      DataBinding.DataField = 'Readonly'
      DataBinding.DataSource = DataSource
      TabOrder = 4
    end
    object cbSortOrder: TcxDBImageComboBox
      Left = 176
      Top = 76
      Anchors = [akLeft, akTop, akRight]
      DataBinding.DataField = 'SortOrder'
      DataBinding.DataSource = DataSource
      Properties.Images = ImageContainer.Images16
      Properties.Items = <
        item
          Description = 'None'
          ImageIndex = 77
          Value = 0
        end
        item
          Description = 'Ascending'
          ImageIndex = 578
          Value = 1
        end
        item
          Description = 'Descending'
          ImageIndex = 579
          Value = 2
        end
        item
          Description = 'Disabled'
          ImageIndex = 482
          Value = 3
        end>
      TabOrder = 1
      Width = 261
    end
    object cbColType: TcxDBImageComboBox
      Left = 176
      Top = 49
      Anchors = [akLeft, akTop, akRight]
      DataBinding.DataField = 'colType'
      DataBinding.DataSource = DataSource
      Properties.Images = ImageContainer.Images16
      Properties.Items = <
        item
          Description = 'Default (Text)'
          ImageIndex = 87
          Value = 0
        end
        item
          Description = 'Checkbox'
          ImageIndex = 124
          Value = 1
        end
        item
          Description = 'ImageIndex'
          ImageIndex = 299
          Value = 2
        end
        item
          Description = 'Dropdown'
          ImageIndex = 199
          Value = 3
        end
        item
          Description = 'Subaccount'
          ImageIndex = 3
          Value = 4
        end
        item
          Description = 'PictureColumn'
          ImageIndex = 463
          Value = 5
        end
        item
          Description = 'PopupPicture'
          ImageIndex = 464
          Value = 6
        end
        item
          Description = 'Currency'
          ImageIndex = 153
          Value = 7
        end
        item
          Description = 'Date'
          ImageIndex = 169
          Value = 8
        end
        item
          Description = 'Currency Number'
          ImageIndex = 341
          Value = 9
        end>
      Properties.OnChange = cbColTypePropertiesChange
      TabOrder = 0
      Width = 262
    end
    object edCellHintField: TcxDBTextEdit
      Left = 176
      Top = 158
      DataBinding.DataField = 'CellHintField'
      DataBinding.DataSource = DataSource
      TabOrder = 7
      Width = 121
    end
    object Panel2: TPanel
      Left = 0
      Top = 198
      Width = 451
      Height = 4
      Align = alBottom
      BevelOuter = bvNone
      TabOrder = 6
    end
    object cbAlign: TcxDBImageComboBox
      Left = 176
      Top = 103
      DataBinding.DataField = 'Align'
      DataBinding.DataSource = DataSource
      Properties.Images = ImageContainer.Images16
      Properties.Items = <
        item
          Description = 'Left'
          ImageIndex = 37
          Value = 0
        end
        item
          Description = 'Right'
          ImageIndex = 45
          Value = 1
        end
        item
          Description = 'Center'
          ImageIndex = 34
          Value = 2
        end>
      TabOrder = 2
      Width = 261
    end
    object Panel3: TPanel
      Left = 0
      Top = 202
      Width = 451
      Height = 55
      Align = alBottom
      BevelOuter = bvNone
      BorderWidth = 2
      ShowCaption = False
      TabOrder = 8
      object memoHint: TcxDBMemo
        Left = 2
        Top = 2
        Align = alClient
        DataBinding.DataField = 'HeaderHint'
        DataBinding.DataSource = DataSource
        TabOrder = 0
        Height = 51
        Width = 447
      end
    end
    object edColumnName: TcxDBTextEdit
      Left = 176
      Top = 132
      DataBinding.DataField = 'ColumnName'
      DataBinding.DataSource = DataSource
      TabOrder = 3
      Width = 121
    end
  end
  object pgProp: TcxPageControl
    Left = 0
    Top = 257
    Width = 451
    Height = 306
    Align = alClient
    TabOrder = 2
    Properties.ActivePage = cxTabSheet1
    Properties.CustomButtons.Buttons = <>
    ClientRectBottom = 302
    ClientRectLeft = 4
    ClientRectRight = 447
    ClientRectTop = 24
    object cxTabSheet1: TcxTabSheet
      Caption = 'Text'
      ImageIndex = 0
    end
    object cxTabSheet2: TcxTabSheet
      Caption = 'Checkbox'
      ImageIndex = 1
    end
    object cxTabSheet3: TcxTabSheet
      Caption = 'ImangeIndex'
      ImageIndex = 2
    end
    object cxTabSheet4: TcxTabSheet
      Caption = 'Dropdown'
      ImageIndex = 3
      inline ddFrame: TDropDownEditorFrame
        Left = 0
        Top = 0
        Width = 443
        Height = 278
        Align = alClient
        TabOrder = 0
        ExplicitWidth = 443
        ExplicitHeight = 278
        inherited ddLayout: TdxLayoutControl
          Width = 443
          Height = 278
          ExplicitWidth = 443
          ExplicitHeight = 278
          inherited gridItems: TcxTreeList
            Width = 431
            Height = 149
            ExplicitWidth = 431
            ExplicitHeight = 149
          end
          inherited edDDProviderName: TcxButtonEdit
            Left = 96
            Top = 236
            ExplicitLeft = 96
            ExplicitTop = 236
            ExplicitWidth = 154
            ExplicitHeight = 21
            Width = 154
          end
          inherited cbDBName: TcxComboBox
            Left = 301
            Top = 236
            ExplicitLeft = 301
            ExplicitTop = 236
            ExplicitHeight = 21
            Height = 21
          end
          inherited cbAddAll: TcxCheckBox
            Left = 21
            Top = 182
            ExplicitLeft = 21
            ExplicitTop = 182
            ExplicitWidth = 71
            ExplicitHeight = 21
          end
          inherited cbAddNone: TcxCheckBox
            Left = 21
            Top = 209
            ExplicitLeft = 21
            ExplicitTop = 209
            ExplicitWidth = 85
            ExplicitHeight = 21
          end
          inherited edAllValue: TcxTextEdit
            Left = 301
            Top = 182
            ExplicitLeft = 301
            ExplicitTop = 182
            ExplicitHeight = 21
            Height = 21
          end
          inherited edNoneValue: TcxTextEdit
            Left = 301
            Top = 209
            ExplicitLeft = 301
            ExplicitTop = 209
            ExplicitHeight = 21
            Height = 21
          end
          inherited FrmGrpBottom: TdxLayoutGroup
            AlignVert = avBottom
          end
          inherited item_edDDProviderName: TdxLayoutItem
            ControlOptions.OriginalHeight = 21
          end
          inherited item_cbAddAll: TdxLayoutItem
            ControlOptions.OriginalHeight = 21
            ControlOptions.OriginalWidth = 71
          end
          inherited item_cbAddNone: TdxLayoutItem
            ControlOptions.OriginalHeight = 21
            ControlOptions.OriginalWidth = 85
          end
        end
      end
    end
    object cxTabSheet5: TcxTabSheet
      Caption = 'SubAccount'
      ImageIndex = 4
    end
    object cxTabSheet6: TcxTabSheet
      Caption = 'Picture'
      ImageIndex = 5
    end
    object cxTabSheet7: TcxTabSheet
      Caption = 'PopupPicture'
      ImageIndex = 6
    end
    object cxTabSheet8: TcxTabSheet
      Caption = 'Currency'
      ImageIndex = 7
      DesignSize = (
        443
        278)
      object Label2: TLabel
        Left = 10
        Top = 33
        Width = 106
        Height = 13
        Caption = 'Custom ProviderName'
      end
      object DBName: TLabel
        Left = 10
        Top = 11
        Width = 40
        Height = 13
        Caption = 'DBName'
      end
      object edProviderNameCurr: TcxTextEdit
        Left = 135
        Top = 30
        Anchors = [akLeft, akTop, akRight]
        TabOrder = 1
        Width = 305
      end
      object edDBNameCurr: TcxComboBox
        Left = 135
        Top = 3
        Anchors = [akLeft, akTop, akRight]
        TabOrder = 0
        Width = 305
      end
    end
    object cxTabSheet9: TcxTabSheet
      Caption = 'Date'
      ImageIndex = 8
    end
    object cxTabSheet10: TcxTabSheet
      Caption = 'CurrencyNumber'
      ImageIndex = 9
    end
  end
  object DataSource: TDataSource
    Left = 384
    Top = 216
  end
end
