inherited ManagerEditorCommand: TManagerEditorCommand
  Caption = 'Edit Command'
  ClientHeight = 719
  ClientWidth = 663
  Constraints.MinHeight = 500
  ExplicitWidth = 679
  ExplicitHeight = 757
  PixelsPerInch = 96
  TextHeight = 13
  inherited pnBottomButtons: TPanel
    Top = 678
    Width = 663
    ExplicitTop = 678
    ExplicitWidth = 663
    inherited bnOK: TcxButton
      Left = 495
      ExplicitLeft = 495
    end
    inherited bnCancel: TcxButton
      Left = 576
      ExplicitLeft = 576
    end
  end
  inherited DialogLayout: TdxLayoutControl
    Width = 663
    Height = 678
    ExplicitWidth = 663
    ExplicitHeight = 678
    object Label1: TLabel [0]
      Left = 61
      Top = 43
      Width = 436
      Height = 52
      Caption = 'Command properties'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -13
      Font.Name = 'Tahoma'
      Font.Style = [fsBold]
      ParentFont = False
    end
    object Image1: TImage [1]
      Left = 23
      Top = 43
      Width = 32
      Height = 32
    end
    object Image2: TImage [2]
      Left = 10000
      Top = 10000
      Width = 32
      Height = 32
      Visible = False
    end
    object edAppCmdId: TcxDBTextEdit [3]
      Left = 519
      Top = 43
      DataBinding.DataField = 'AppCmdId'
      DataBinding.DataSource = MainSource
      Style.BorderColor = clWindowFrame
      Style.BorderStyle = ebs3D
      Style.HotTrack = False
      TabOrder = 0
      Width = 121
    end
    object edEnabledFieldName: TcxDBTextEdit [4]
      Left = 95
      Top = 517
      DataBinding.DataField = 'EnabledFieldName'
      DataBinding.DataSource = MainSource
      Enabled = False
      Style.BorderColor = clWindowFrame
      Style.BorderStyle = ebs3D
      Style.HotTrack = False
      TabOrder = 9
      Width = 88
    end
    object memoDescr: TcxDBMemo [5]
      Left = 38
      Top = 332
      DataBinding.DataField = 'Description'
      DataBinding.DataSource = MainSource
      Style.BorderColor = clWindowFrame
      Style.BorderStyle = ebs3D
      Style.HotTrack = False
      TabOrder = 6
      Height = 89
      Width = 587
    end
    object edName: TcxDBTextEdit [6]
      Left = 38
      Top = 152
      AutoSize = False
      DataBinding.DataField = 'Name'
      DataBinding.DataSource = MainSource
      Style.BorderColor = clWindowFrame
      Style.BorderStyle = ebs3D
      Style.HotTrack = False
      TabOrder = 2
      Height = 21
      Width = 587
    end
    object edLocation: TcxDBTextEdit [7]
      Left = 38
      Top = 287
      Hint = 
        'Specify location of command "GroupName\Submenu" or single "Group' +
        '". If Submenu is specified, item is forced to standart button.'
      DataBinding.DataField = 'Location'
      DataBinding.DataSource = MainSource
      Style.BorderColor = clWindowFrame
      Style.BorderStyle = ebs3D
      Style.HotTrack = False
      TabOrder = 5
      Width = 587
    end
    object edHint: TcxDBTextEdit [8]
      Left = 38
      Top = 242
      AutoSize = False
      DataBinding.DataField = 'Hint'
      DataBinding.DataSource = MainSource
      Style.BorderColor = clWindowFrame
      Style.BorderStyle = ebs3D
      Style.HotTrack = False
      TabOrder = 4
      Height = 21
      Width = 587
    end
    object edEnabledSign: TcxDBImageComboBox [9]
      Left = 189
      Top = 517
      DataBinding.DataField = 'EnabledSign'
      DataBinding.DataSource = MainSource
      Enabled = False
      Properties.Items = <
        item
          Description = '='
          ImageIndex = 0
          Value = 0
        end
        item
          Description = '<>'
          Value = 1
        end
        item
          Description = '>'
          Value = 2
        end
        item
          Description = '>='
          Value = 3
        end
        item
          Description = '<'
          Value = 4
        end
        item
          Description = '<='
          Value = 5
        end
        item
          Description = 'IS NULL'
          Value = 6
        end
        item
          Description = 'IS NOT NULL'
          Value = 7
        end
        item
          Description = 'IN CASE'
          Value = 8
        end
        item
          Description = 'NOT IN CASE'
          Value = 9
        end>
      Properties.OnChange = edEnabledSignPropertiesChange
      Style.BorderColor = clWindowFrame
      Style.BorderStyle = ebs3D
      Style.HotTrack = False
      Style.ButtonStyle = bts3D
      Style.PopupBorderStyle = epbsFrame3D
      TabOrder = 10
      Width = 100
    end
    object edEnabledValue: TcxDBTextEdit [10]
      Left = 326
      Top = 517
      DataBinding.DataField = 'EnabledValue'
      DataBinding.DataSource = MainSource
      Enabled = False
      Style.BorderColor = clWindowFrame
      Style.BorderStyle = ebs3D
      Style.HotTrack = False
      TabOrder = 11
      Width = 121
    end
    object ddExecuteAction: TcxDBImageComboBox [11]
      Left = 10000
      Top = 10000
      DataBinding.DataField = 'ActionType'
      DataBinding.DataSource = MainSource
      Properties.Images = ImageContainer.Images16
      Properties.Items = <
        item
          Description = '<NONE>'
          ImageIndex = 0
          Value = 0
        end
        item
          Description = 'Execute dialog'
          ImageIndex = 25
          Value = 1
        end
        item
          Description = 'Execute script'
          ImageIndex = 392
          Value = 2
        end
        item
          Description = 'Open plugin'
          ImageIndex = 32
          Value = 3
        end
        item
          Description = 'Plugin method'
          ImageIndex = 267
          Value = 4
        end
        item
          Description = 'Execute stored proc'
          ImageIndex = 396
          Value = 5
        end
        item
          Description = 'Export template'
          ImageIndex = 319
          Value = 6
        end
        item
          Description = 'Open File'
          ImageIndex = 429
          Value = 7
        end
        item
          Description = 'Report'
          ImageIndex = 194
          Value = 8
        end>
      Properties.OnChange = ddExecuteActionPropertiesChange
      Style.BorderColor = clWindowFrame
      Style.BorderStyle = ebs3D
      Style.HotTrack = False
      Style.ButtonStyle = bts3D
      Style.PopupBorderStyle = epbsFrame3D
      TabOrder = 17
      Visible = False
      Width = 195
    end
    object pgActionType: TcxPageControl [12]
      Left = 10000
      Top = 10000
      Width = 617
      Height = 546
      TabOrder = 21
      Visible = False
      Properties.ActivePage = ATab0
      Properties.CustomButtons.Buttons = <>
      OnPageChanging = pgActionTypePageChanging
      ClientRectBottom = 542
      ClientRectLeft = 4
      ClientRectRight = 613
      ClientRectTop = 24
      object ATab0: TcxTabSheet
        Caption = 'NONE'
        ImageIndex = 0
      end
      object ATab1: TcxTabSheet
        Caption = 'Dialog'
        ImageIndex = 1
        object pnDialog: TPanel
          Left = 0
          Top = 0
          Width = 609
          Height = 90
          Align = alTop
          BevelOuter = bvNone
          ShowCaption = False
          TabOrder = 0
          object Label2: TLabel
            Left = 4
            Top = 2
            Width = 63
            Height = 13
            Caption = 'AppDialogsId'
          end
          object Label4: TLabel
            Left = 266
            Top = 2
            Width = 49
            Height = 13
            Caption = 'Placement'
          end
          object Label3: TLabel
            Left = 4
            Top = 44
            Width = 42
            Height = 13
            Caption = 'Behavior'
          end
          object edDialogID: TcxDBButtonEdit
            Left = 4
            Top = 21
            DataBinding.DataField = 'RunAppDialogsId'
            DataBinding.DataSource = MainSource
            Properties.Buttons = <
              item
                Default = True
                Kind = bkEllipsis
              end>
            Properties.OnButtonClick = edDialogIDPropertiesButtonClick
            TabOrder = 0
            Width = 250
          end
          object ddDialogPlacement: TcxDBImageComboBox
            Left = 266
            Top = 21
            DataBinding.DataField = 'RunAppDialogPlacement'
            DataBinding.DataSource = MainSource
            Properties.Images = ImageContainer.Images16
            Properties.Items = <
              item
                Description = 'Modal'
                ImageIndex = 637
                Value = 0
              end
              item
                Description = 'Bottom'
                ImageIndex = 67
                Value = 1
              end
              item
                Description = 'Right'
                ImageIndex = 66
                Value = 2
              end>
            TabOrder = 1
            Width = 121
          end
          object ddDialogBehavior: TcxDBImageComboBox
            Left = 4
            Top = 63
            DataBinding.DataField = 'AppDialogShowBehavior'
            DataBinding.DataSource = MainSource
            Properties.Images = ImageContainer.Images16
            Properties.Items = <
              item
                Description = 'Standart'
                Value = '0'
              end
              item
                Description = 'Before any action executed'
                ImageIndex = 286
                Value = '1'
              end>
            Style.BorderColor = clWindowFrame
            Style.BorderStyle = ebs3D
            Style.HotTrack = False
            Style.ButtonStyle = bts3D
            Style.PopupBorderStyle = epbsFrame3D
            TabOrder = 2
            Width = 250
          end
        end
        object Panel3: TPanel
          Left = 0
          Top = 90
          Width = 609
          Height = 428
          Align = alClient
          BevelOuter = bvNone
          Caption = 'Panel3'
          ShowCaption = False
          TabOrder = 1
          object Panel4: TPanel
            Left = 0
            Top = 0
            Width = 609
            Height = 17
            Align = alTop
            BevelOuter = bvNone
            ShowCaption = False
            TabOrder = 0
            object Label9: TLabel
              Left = 2
              Top = 0
              Width = 55
              Height = 13
              Caption = 'Parameters'
            end
          end
          inline AParams1: TCommandPropertiesFrame
            Left = 0
            Top = 17
            Width = 609
            Height = 411
            Align = alClient
            TabOrder = 1
            ExplicitTop = 17
            ExplicitWidth = 609
            ExplicitHeight = 411
            inherited ParamGrid: TcxGrid
              Width = 609
              Height = 411
              ExplicitWidth = 609
              ExplicitHeight = 411
              inherited MainView: TcxGridDBTableView
                inherited colName: TcxGridDBColumn
                  MinWidth = 80
                  Width = 115
                end
                inherited colSource: TcxGridDBColumn
                  MinWidth = 80
                  Width = 192
                end
                inherited colValue: TcxGridDBColumn
                  MinWidth = 80
                  Width = 119
                end
              end
            end
          end
        end
      end
      object ATab2: TcxTabSheet
        Caption = 'Script'
        ImageIndex = 2
        DesignSize = (
          609
          518)
        object bnEditScript: TcxButton
          Left = 11
          Top = 27
          Width = 75
          Height = 25
          Anchors = [akTop, akRight]
          Caption = 'Edit'
          TabOrder = 0
          OnClick = bnEditScriptClick
        end
      end
      object ATab3: TcxTabSheet
        Caption = 'Plugin'
        ImageIndex = 3
        object pnPlugin: TPanel
          Left = 0
          Top = 0
          Width = 609
          Height = 90
          Align = alTop
          BevelOuter = bvNone
          ShowCaption = False
          TabOrder = 0
          object Label5: TLabel
            Left = 4
            Top = 2
            Width = 57
            Height = 13
            Caption = 'AppPluginId'
          end
          object edPluginID: TcxDBButtonEdit
            Left = 4
            Top = 21
            DataBinding.DataField = 'RunAppPluginsId'
            DataBinding.DataSource = MainSource
            Properties.Buttons = <
              item
                Default = True
                Kind = bkEllipsis
              end>
            Properties.OnButtonClick = edPluginIDPropertiesButtonClick
            TabOrder = 0
            Width = 250
          end
        end
        object Panel6: TPanel
          Left = 0
          Top = 90
          Width = 609
          Height = 428
          Align = alClient
          BevelOuter = bvNone
          Caption = 'Panel3'
          ShowCaption = False
          TabOrder = 1
          object Panel7: TPanel
            Left = 0
            Top = 0
            Width = 609
            Height = 17
            Align = alTop
            BevelOuter = bvNone
            ShowCaption = False
            TabOrder = 0
            object Label11: TLabel
              Left = 2
              Top = 0
              Width = 55
              Height = 13
              Caption = 'Parameters'
            end
          end
          inline AParams2: TCommandPropertiesFrame
            Left = 0
            Top = 17
            Width = 609
            Height = 411
            Align = alClient
            TabOrder = 1
            ExplicitTop = 17
            ExplicitWidth = 609
            ExplicitHeight = 411
            inherited ParamGrid: TcxGrid
              Width = 609
              Height = 411
              ExplicitWidth = 609
              ExplicitHeight = 411
              inherited MainView: TcxGridDBTableView
                inherited colName: TcxGridDBColumn
                  MinWidth = 80
                  Width = 115
                end
                inherited colSource: TcxGridDBColumn
                  MinWidth = 80
                  Width = 192
                end
                inherited colValue: TcxGridDBColumn
                  MinWidth = 80
                  Width = 119
                end
              end
            end
          end
        end
      end
      object ATab4: TcxTabSheet
        Caption = 'PluginMethod'
        ImageIndex = 4
        object pnPluginMethod: TPanel
          Left = 0
          Top = 0
          Width = 609
          Height = 90
          Align = alTop
          BevelOuter = bvNone
          ShowCaption = False
          TabOrder = 0
          object Label7: TLabel
            Left = 4
            Top = 2
            Width = 67
            Height = 13
            Caption = 'Plugin method'
          end
          object ddPluginMethod: TcxDBImageComboBox
            Left = 4
            Top = 21
            DataBinding.DataField = 'PluginMethod'
            DataBinding.DataSource = MainSource
            Properties.Images = ImageContainer.Images16
            Properties.Items = <
              item
              end
              item
                Description = 'AddRecord'
                ImageIndex = 437
                Value = 'AddRecord'
              end
              item
                Description = 'DelRecord'
                ImageIndex = 109
                Value = 'DelRecord'
              end
              item
                Description = 'EditRecord'
                ImageIndex = 212
                Value = 'EditRecord'
              end
              item
                Description = 'PushDocument'
                ImageIndex = 39
                Value = 'PushDocument'
              end
              item
                Description = 'RollbackDocument'
                ImageIndex = 41
                Value = 'RollbackDocument'
              end
              item
                Description = 'CopyRecord'
                ImageIndex = 439
                Value = 'CopyRecord'
              end
              item
                Description = 'RefreshData'
                ImageIndex = 44
                Value = 'RefreshData'
              end
              item
                Description = 'ViewRecord'
                ImageIndex = 231
                Value = 'ViewRecord'
              end>
            TabOrder = 0
            Width = 250
          end
        end
        object Panel9: TPanel
          Left = 0
          Top = 90
          Width = 609
          Height = 428
          Align = alClient
          BevelOuter = bvNone
          Caption = 'Panel3'
          ShowCaption = False
          TabOrder = 1
          object Panel10: TPanel
            Left = 0
            Top = 0
            Width = 609
            Height = 17
            Align = alTop
            BevelOuter = bvNone
            ShowCaption = False
            TabOrder = 0
            object Label12: TLabel
              Left = 2
              Top = 0
              Width = 55
              Height = 13
              Caption = 'Parameters'
            end
          end
          inline AParams3: TCommandPropertiesFrame
            Left = 0
            Top = 17
            Width = 609
            Height = 411
            Align = alClient
            TabOrder = 1
            ExplicitTop = 17
            ExplicitWidth = 609
            ExplicitHeight = 411
            inherited ParamGrid: TcxGrid
              Width = 609
              Height = 411
              ExplicitWidth = 609
              ExplicitHeight = 411
              inherited MainView: TcxGridDBTableView
                inherited colName: TcxGridDBColumn
                  MinWidth = 80
                  Width = 115
                end
                inherited colSource: TcxGridDBColumn
                  MinWidth = 80
                  Width = 192
                end
                inherited colValue: TcxGridDBColumn
                  MinWidth = 80
                  Width = 119
                end
              end
            end
          end
        end
      end
      object ATab5: TcxTabSheet
        Caption = 'SP'
        ImageIndex = 5
        object pnStoredProcedure: TPanel
          Left = 0
          Top = 0
          Width = 609
          Height = 90
          Align = alTop
          BevelOuter = bvNone
          TabOrder = 0
          object Label8: TLabel
            Left = 4
            Top = 2
            Width = 84
            Height = 13
            Caption = 'Stored procedure'
          end
          object Label21: TLabel
            Left = 282
            Top = 2
            Width = 40
            Height = 13
            Caption = 'DBName'
          end
          object edStoredProc: TcxDBButtonEdit
            Left = 4
            Top = 21
            DataBinding.DataField = 'SPValue'
            DataBinding.DataSource = MainSource
            Properties.Buttons = <
              item
                Default = True
                Kind = bkEllipsis
              end>
            Properties.OnButtonClick = edStoredProcPropertiesButtonClick
            TabOrder = 0
            Width = 250
          end
          object edspDBName: TcxDBComboBox
            Left = 282
            Top = 21
            DataBinding.DataField = 'SPValue1'
            DataBinding.DataSource = MainSource
            TabOrder = 1
            Width = 119
          end
        end
        object Panel1: TPanel
          Left = 0
          Top = 90
          Width = 609
          Height = 428
          Align = alClient
          BevelOuter = bvNone
          Caption = 'Panel3'
          ShowCaption = False
          TabOrder = 1
          object Panel8: TPanel
            Left = 0
            Top = 0
            Width = 609
            Height = 17
            Align = alTop
            BevelOuter = bvNone
            ShowCaption = False
            TabOrder = 0
            object Label13: TLabel
              Left = 2
              Top = 0
              Width = 55
              Height = 13
              Caption = 'Parameters'
            end
          end
          inline AParams4: TCommandPropertiesFrame
            Left = 0
            Top = 17
            Width = 609
            Height = 411
            Align = alClient
            TabOrder = 1
            ExplicitTop = 17
            ExplicitWidth = 609
            ExplicitHeight = 411
            inherited ParamGrid: TcxGrid
              Width = 609
              Height = 411
              ExplicitWidth = 609
              ExplicitHeight = 411
              inherited MainView: TcxGridDBTableView
                inherited colName: TcxGridDBColumn
                  MinWidth = 80
                  Width = 115
                end
                inherited colSource: TcxGridDBColumn
                  MinWidth = 80
                  Width = 192
                end
                inherited colValue: TcxGridDBColumn
                  MinWidth = 80
                  Width = 119
                end
              end
            end
          end
        end
      end
      object ATab6: TcxTabSheet
        Caption = 'Template'
        ImageIndex = 6
        object pnAppTemplate: TPanel
          Left = 0
          Top = 0
          Width = 609
          Height = 90
          Align = alTop
          BevelOuter = bvNone
          ShowCaption = False
          TabOrder = 0
          object Label10: TLabel
            Left = 4
            Top = 2
            Width = 73
            Height = 13
            Caption = 'AppTemplateId'
          end
          object edTemplatesID: TcxDBButtonEdit
            Left = 4
            Top = 21
            DataBinding.DataField = 'RunAppTemplatesId'
            DataBinding.DataSource = MainSource
            Properties.Buttons = <
              item
                Default = True
                Kind = bkEllipsis
              end>
            Properties.OnButtonClick = edTemplatesIDPropertiesButtonClick
            TabOrder = 0
            Width = 250
          end
          object Panel12: TPanel
            Left = 273
            Top = 11
            Width = 302
            Height = 49
            BevelOuter = bvNone
            ShowCaption = False
            TabOrder = 1
          end
          object memoInfoTemplate: TcxMemo
            Left = 273
            Top = 0
            Align = alRight
            Lines.Strings = (
              'AppTemplatesId - Assign custom AppTemplatesId'
              'DefaultFileName - Assign file name to "Save as dialog"'
              'FileName - Assign file name without user prompt')
            Properties.ReadOnly = True
            TabOrder = 2
            Height = 90
            Width = 336
          end
        end
        object Panel11: TPanel
          Left = 0
          Top = 90
          Width = 609
          Height = 428
          Align = alClient
          BevelOuter = bvNone
          Caption = 'Panel3'
          ShowCaption = False
          TabOrder = 1
          object Panel2: TPanel
            Left = 0
            Top = 0
            Width = 609
            Height = 428
            Align = alClient
            BevelOuter = bvNone
            Caption = 'Panel3'
            ShowCaption = False
            TabOrder = 0
            object Panel5: TPanel
              Left = 0
              Top = 0
              Width = 609
              Height = 17
              Align = alTop
              BevelOuter = bvNone
              ShowCaption = False
              TabOrder = 0
              object Label15: TLabel
                Left = 2
                Top = 0
                Width = 55
                Height = 13
                Caption = 'Parameters'
              end
            end
            inline AParams5: TCommandPropertiesFrame
              Left = 0
              Top = 17
              Width = 609
              Height = 411
              Align = alClient
              TabOrder = 1
              ExplicitTop = 17
              ExplicitWidth = 609
              ExplicitHeight = 411
              inherited ParamGrid: TcxGrid
                Width = 609
                Height = 411
                ExplicitWidth = 609
                ExplicitHeight = 411
                inherited MainView: TcxGridDBTableView
                  inherited colName: TcxGridDBColumn
                    MinWidth = 80
                    Width = 115
                  end
                  inherited colSource: TcxGridDBColumn
                    MinWidth = 80
                    Width = 192
                  end
                  inherited colValue: TcxGridDBColumn
                    MinWidth = 80
                    Width = 119
                  end
                end
              end
            end
          end
        end
      end
      object ATab7: TcxTabSheet
        Caption = 'Open File'
        ImageIndex = 7
        object Label14: TLabel
          Left = 16
          Top = 95
          Width = 24
          Height = 13
          Caption = 'Filter'
        end
        object Label17: TLabel
          Left = 16
          Top = 68
          Width = 57
          Height = 13
          Caption = 'ParamName'
        end
        object Label18: TLabel
          Left = 16
          Top = 14
          Width = 67
          Height = 13
          Caption = 'ProviderName'
        end
        object Label19: TLabel
          Left = 16
          Top = 41
          Width = 40
          Height = 13
          Caption = 'DBName'
        end
        object Label22: TLabel
          Left = 16
          Top = 123
          Width = 42
          Height = 13
          Caption = 'Behavior'
        end
        object Label23: TLabel
          Left = 16
          Top = 150
          Width = 43
          Height = 13
          Caption = 'Encoding'
        end
        object cbValidateFile: TCheckBox
          Left = 16
          Top = 178
          Width = 185
          Height = 17
          Caption = 'Validate Json/Xml file before open'
          TabOrder = 5
        end
        object edOpenFileCmdProviderName: TcxDBButtonEdit
          Left = 89
          Top = 11
          DataBinding.DataField = 'SPValue'
          DataBinding.DataSource = MainSource
          Properties.Buttons = <
            item
              Default = True
              Kind = bkEllipsis
            end>
          Properties.OnButtonClick = edStoredProcPropertiesButtonClick
          TabOrder = 0
          Width = 339
        end
        object cbOpenFileDBName: TcxDBComboBox
          Left = 89
          Top = 38
          DataBinding.DataField = 'SPValue1'
          DataBinding.DataSource = MainSource
          TabOrder = 1
          Width = 339
        end
        object edOpenFileParamName: TcxDBTextEdit
          Left = 89
          Top = 65
          DataBinding.DataField = 'ParamName'
          DataBinding.DataSource = MainSource
          TabOrder = 2
          Width = 339
        end
        object cbFilter: TcxDBComboBox
          Left = 89
          Top = 92
          DataBinding.DataField = 'SPValue2'
          DataBinding.DataSource = MainSource
          TabOrder = 3
          Width = 339
        end
        object ddOpenFileBehavior: TcxImageComboBox
          Left = 89
          Top = 119
          EditValue = '0'
          Properties.Images = ImageContainer.Images16
          Properties.Items = <
            item
              Description = '<None>'
              ImageIndex = 0
              Value = 0
            end
            item
              Description = 'Convert to Base64'
              ImageIndex = 166
              Value = 1
            end
            item
              Description = 'Convert Excel to Json Dataset'
              ImageIndex = 360
              Value = 2
            end
            item
              Description = 'Convert Excel to Json Dataset (excluding 1st row)'
              ImageIndex = 359
              Value = 3
            end
            item
              Description = 'Excel - Upload all rows by name (UserName=Value)'
              ImageIndex = 4
              Value = 4
            end
            item
              Description = 'Excel - Upload all rows by index (Field1=Value)'
              ImageIndex = 5
              Value = 5
            end>
          TabOrder = 4
          Width = 339
        end
        object ddEncoding: TcxImageComboBox
          Left = 89
          Top = 146
          EditValue = '0'
          Properties.Items = <
            item
              Description = 'Auto'
              ImageIndex = 0
              Value = 0
            end
            item
              Description = 'Utf8'
              ImageIndex = 166
              Value = 1
            end
            item
              Description = 'Ansi'
              ImageIndex = 360
              Value = 2
            end
            item
              Description = 'Unicode'
              ImageIndex = 359
              Value = 3
            end>
          TabOrder = 6
          Width = 339
        end
      end
      object ATab8: TcxTabSheet
        Caption = 'Report'
        ImageIndex = 8
        object Panel14: TPanel
          Left = 0
          Top = 0
          Width = 609
          Height = 90
          Align = alTop
          BevelOuter = bvNone
          ShowCaption = False
          TabOrder = 0
          object Label6: TLabel
            Left = 4
            Top = 2
            Width = 67
            Height = 13
            Caption = 'AppReportsId'
          end
          object edAppReportsId: TcxDBButtonEdit
            Left = 4
            Top = 21
            DataBinding.DataField = 'RunAppReportsId'
            DataBinding.DataSource = MainSource
            Properties.Buttons = <
              item
                Default = True
                Kind = bkEllipsis
              end>
            Properties.OnButtonClick = edAppReportsIdPropertiesButtonClick
            TabOrder = 0
            Width = 250
          end
        end
        object Panel13: TPanel
          Left = 0
          Top = 90
          Width = 609
          Height = 428
          Align = alClient
          BevelOuter = bvNone
          Caption = 'Panel3'
          ShowCaption = False
          TabOrder = 1
          object Panel15: TPanel
            Left = 0
            Top = 0
            Width = 609
            Height = 17
            Align = alTop
            BevelOuter = bvNone
            ShowCaption = False
            TabOrder = 0
            object Label16: TLabel
              Left = 2
              Top = 0
              Width = 55
              Height = 13
              Caption = 'Parameters'
            end
          end
          inline AParams6: TCommandPropertiesFrame
            Left = 0
            Top = 17
            Width = 609
            Height = 411
            Align = alClient
            TabOrder = 1
            ExplicitTop = 17
            ExplicitWidth = 609
            ExplicitHeight = 411
            inherited ParamGrid: TcxGrid
              Width = 609
              Height = 411
              ExplicitWidth = 609
              ExplicitHeight = 411
              inherited MainView: TcxGridDBTableView
                inherited colName: TcxGridDBColumn
                  MinWidth = 80
                  Width = 115
                end
                inherited colSource: TcxGridDBColumn
                  MinWidth = 80
                  Width = 192
                end
                inherited colValue: TcxGridDBColumn
                  MinWidth = 80
                  Width = 119
                end
              end
            end
          end
        end
      end
    end
    object cbEnabledWhenNoRecords: TcxDBCheckBox [13]
      Left = 38
      Top = 490
      Caption = 'Enabled when no records'
      DataBinding.DataField = 'EnabledNoRecords'
      DataBinding.DataSource = MainSource
      Enabled = False
      Style.BorderColor = clWindowFrame
      Style.BorderStyle = ebs3D
      Style.HotTrack = False
      TabOrder = 8
    end
    object chboxAlwaysEnabled: TcxDBCheckBox [14]
      Left = 38
      Top = 463
      Caption = 'Always enabled'
      DataBinding.DataField = 'AlwaysEnabled'
      DataBinding.DataSource = MainSource
      Style.BorderColor = clWindowFrame
      Style.BorderStyle = ebs3D
      Style.HotTrack = False
      TabOrder = 7
      OnClick = chboxAlwaysEnabledClick
    end
    object edCaption: TcxDBTextEdit [15]
      Left = 38
      Top = 197
      DataBinding.DataField = 'Caption'
      DataBinding.DataSource = MainSource
      Style.BorderColor = clWindowFrame
      Style.BorderStyle = ebs3D
      Style.HotTrack = False
      TabOrder = 3
      Width = 587
    end
    object edCreateOrder: TcxDBTextEdit [16]
      Left = 165
      Top = 598
      DataBinding.DataField = 'CreateOrder'
      DataBinding.DataSource = MainSource
      Style.BorderColor = clWindowFrame
      Style.BorderStyle = ebs3D
      Style.HotTrack = False
      TabOrder = 13
      Width = 65
    end
    object edWidth: TcxDBTextEdit [17]
      Left = 236
      Top = 598
      AutoSize = False
      DataBinding.DataField = 'Width'
      DataBinding.DataSource = MainSource
      Style.BorderColor = clWindowFrame
      Style.BorderStyle = ebs3D
      Style.HotTrack = False
      TabOrder = 14
      Height = 21
      Width = 40
    end
    object bnImageIndex: TcxButton [18]
      Left = 570
      Top = 70
      Width = 70
      Height = 25
      Caption = 'Image'
      OptionsImage.Images = ImageContainer.Images16
      TabOrder = 1
      OnClick = bnImageIndexClick
    end
    object ddStyle: TcxImageComboBox [19]
      Left = 282
      Top = 598
      EditValue = 0
      Properties.Images = ImageContainer.Images16
      Properties.Items = <
        item
          Description = 'Large Button'
          ImageIndex = 94
          Value = 0
        end
        item
          Description = 'Button'
          ImageIndex = 146
          Value = 1
        end>
      Style.BorderColor = clWindowFrame
      Style.BorderStyle = ebs3D
      Style.HotTrack = False
      Style.ButtonStyle = bts3D
      Style.PopupBorderStyle = epbsFrame3D
      TabOrder = 15
      Width = 169
    end
    object cbAutoRefresh: TcxDBCheckBox [20]
      Left = 10000
      Top = 10000
      AutoSize = False
      Caption = 'Autorefresh'
      DataBinding.DataField = 'AutoRefresh'
      DataBinding.DataSource = MainSource
      Style.BorderColor = clWindowFrame
      Style.BorderStyle = ebs3D
      Style.HotTrack = False
      TabOrder = 19
      Visible = False
      Height = 21
      Width = 82
    end
    object edShortCut: TcxDBTextEdit [21]
      Left = 38
      Top = 598
      DataBinding.DataField = 'ShortCut'
      DataBinding.DataSource = MainSource
      Style.BorderColor = clWindowFrame
      Style.BorderStyle = ebs3D
      Style.HotTrack = False
      TabOrder = 12
      Width = 121
    end
    object ddMultiSelect: TcxDBImageComboBox [22]
      Left = 10000
      Top = 10000
      DataBinding.DataField = 'MultiSelectBehavior'
      DataBinding.DataSource = MainSource
      Enabled = False
      Properties.Images = ImageContainer.Images16
      Properties.Items = <
        item
          Description = 'None'
          ImageIndex = 0
          Value = 0
        end
        item
          Description = 'Standart multiselect'
          ImageIndex = 599
          Value = 1
        end
        item
          Description = 'Create keyfield json array and execute with "IDs" param'
          ImageIndex = 590
          Value = 2
        end>
      Properties.LargeImages = ImageContainer.Images16
      Properties.OnChange = ddMultiSelectPropertiesChange
      Style.BorderColor = clWindowFrame
      Style.BorderStyle = ebs3D
      Style.HotTrack = False
      Style.ButtonStyle = bts3D
      Style.PopupBorderStyle = epbsFrame3D
      TabOrder = 18
      Visible = False
      Width = 195
    end
    object cbContinueOnError: TDBCheckBox [23]
      Left = 10000
      Top = 10000
      Width = 120
      Height = 17
      Caption = 'Continue on error'
      DataField = 'ContinueOnError'
      DataSource = MainSource
      Enabled = False
      TabOrder = 20
      Visible = False
    end
    object ddAppearsOn: TcxDBImageComboBox [24]
      Left = 457
      Top = 598
      AutoSize = False
      DataBinding.DataField = 'AppearsOn'
      DataBinding.DataSource = MainSource
      Properties.Images = ImageContainer.Images16
      Properties.Items = <
        item
          Description = 'Main Menu Only'
          ImageIndex = 1
          Value = 0
        end
        item
          Description = 'Popup Menu Only'
          ImageIndex = 345
          Value = 1
        end
        item
          Description = 'Both'
          ImageIndex = 340
          Value = 2
        end>
      Style.BorderColor = clWindowFrame
      Style.BorderStyle = ebs3D
      Style.HotTrack = False
      Style.ButtonStyle = bts3D
      Style.PopupBorderStyle = epbsFrame3D
      TabOrder = 16
      Height = 21
      Width = 168
    end
    inherited DialogLayoutGroup_Root: TdxLayoutGroup
      CaptionOptions.Visible = False
    end
    object Tab0: TdxLayoutGroup
      Parent = DialogLayoutGroup_Root
      CaptionOptions.Text = 'Common'
      ButtonOptions.Buttons = <>
      ItemIndex = 4
      Index = 0
    end
    object edAppCmdId_item: TdxLayoutItem
      Parent = dxLayoutAutoCreatedGroup8
      AlignHorz = ahRight
      AlignVert = avTop
      CaptionOptions.Text = 'ID'
      Control = edAppCmdId
      ControlOptions.OriginalHeight = 21
      ControlOptions.OriginalWidth = 121
      ControlOptions.ShowBorder = False
      Index = 0
    end
    object dxLayoutItem1: TdxLayoutItem
      Parent = dxLayoutAutoCreatedGroup2
      AlignHorz = ahClient
      AlignVert = avClient
      CaptionOptions.Text = 'Command properties'
      CaptionOptions.Visible = False
      Control = Label1
      ControlOptions.AutoColor = True
      ControlOptions.OriginalHeight = 52
      ControlOptions.OriginalWidth = 134
      ControlOptions.ShowBorder = False
      Index = 2
    end
    object dxLayoutAutoCreatedGroup2: TdxLayoutAutoCreatedGroup
      Parent = Tab0
      AlignHorz = ahClient
      AlignVert = avTop
      LayoutDirection = ldHorizontal
      Index = 0
    end
    object Image1_Item: TdxLayoutItem
      Parent = dxLayoutAutoCreatedGroup2
      AlignVert = avTop
      Control = Image1
      ControlOptions.OriginalHeight = 32
      ControlOptions.OriginalWidth = 32
      ControlOptions.ShowBorder = False
      Index = 0
    end
    object dxLayoutSeparatorItem1: TdxLayoutSeparatorItem
      Parent = Tab0
      AlignHorz = ahClient
      AlignVert = avTop
      CaptionOptions.Text = 'Separator'
      Index = 1
    end
    object dxLayoutGroup1: TdxLayoutGroup
      Parent = Tab0
      CaptionOptions.Text = 'General'
      ButtonOptions.Buttons = <>
      ItemIndex = 2
      Index = 2
    end
    object dxLayoutGroup2: TdxLayoutGroup
      Parent = Tab0
      CaptionOptions.Text = 'Activity condition'
      ButtonOptions.Buttons = <>
      ItemIndex = 1
      LayoutDirection = ldHorizontal
      Index = 3
    end
    object edEnabledFieldName_Item: TdxLayoutItem
      Parent = dxLayoutAutoCreatedGroup7
      AlignHorz = ahClient
      CaptionOptions.Text = 'Field Name'
      Control = edEnabledFieldName
      ControlOptions.OriginalHeight = 21
      ControlOptions.OriginalWidth = 88
      ControlOptions.ShowBorder = False
      Enabled = False
      Index = 2
    end
    object memoDescr_Item: TdxLayoutItem
      Parent = dxLayoutGroup1
      AlignHorz = ahClient
      AlignVert = avTop
      CaptionOptions.Text = 'Description'
      CaptionOptions.Layout = clTop
      Control = memoDescr
      ControlOptions.OriginalHeight = 89
      ControlOptions.OriginalWidth = 185
      ControlOptions.ShowBorder = False
      Index = 4
    end
    object edName_Item: TdxLayoutItem
      Parent = dxLayoutGroup1
      AlignHorz = ahClient
      AlignVert = avTop
      CaptionOptions.Text = 'Name'
      CaptionOptions.Layout = clTop
      Control = edName
      ControlOptions.OriginalHeight = 21
      ControlOptions.OriginalWidth = 121
      ControlOptions.ShowBorder = False
      Index = 0
    end
    object edLocation_Item: TdxLayoutItem
      Parent = dxLayoutGroup1
      AlignHorz = ahClient
      AlignVert = avTop
      CaptionOptions.Text = 'Location'
      CaptionOptions.Layout = clTop
      Control = edLocation
      ControlOptions.OriginalHeight = 21
      ControlOptions.OriginalWidth = 121
      ControlOptions.ShowBorder = False
      Index = 3
    end
    object edHint_Item: TdxLayoutItem
      Parent = dxLayoutGroup1
      CaptionOptions.Text = 'Hint'
      CaptionOptions.Layout = clTop
      Control = edHint
      ControlOptions.OriginalHeight = 21
      ControlOptions.OriginalWidth = 121
      ControlOptions.ShowBorder = False
      Index = 2
    end
    object dxLayoutAutoCreatedGroup7: TdxLayoutAutoCreatedGroup
      Parent = dxLayoutGroup2
      AlignHorz = ahLeft
      AlignVert = avClient
      Index = 0
    end
    object edEnabledSign_Item: TdxLayoutItem
      Parent = dxLayoutGroup2
      AlignHorz = ahLeft
      AlignVert = avBottom
      Control = edEnabledSign
      ControlOptions.OriginalHeight = 21
      ControlOptions.OriginalWidth = 100
      ControlOptions.ShowBorder = False
      Enabled = False
      Index = 1
    end
    object edEnabledValue_Item: TdxLayoutItem
      Parent = dxLayoutGroup2
      AlignHorz = ahLeft
      AlignVert = avBottom
      CaptionOptions.Text = 'Value'
      Control = edEnabledValue
      ControlOptions.OriginalHeight = 21
      ControlOptions.OriginalWidth = 121
      ControlOptions.ShowBorder = False
      Enabled = False
      Index = 2
    end
    object Tab2: TdxLayoutGroup
      Parent = DialogLayoutGroup_Root
      CaptionOptions.Text = 'Permissions'
      ButtonOptions.Buttons = <>
      Index = 2
    end
    object Tab1: TdxLayoutGroup
      Parent = DialogLayoutGroup_Root
      CaptionOptions.Text = 'Action'
      ButtonOptions.Buttons = <>
      ItemIndex = 2
      Index = 1
    end
    object dxLayoutGroup3: TdxLayoutGroup
      Parent = Tab1
      AlignHorz = ahClient
      AlignVert = avTop
      CaptionOptions.Text = 'New Group'
      CaptionOptions.Visible = False
      ButtonOptions.Buttons = <>
      LayoutDirection = ldHorizontal
      ShowBorder = False
      Index = 0
    end
    object dxLayoutItem3: TdxLayoutItem
      Parent = dxLayoutGroup3
      AlignHorz = ahLeft
      AlignVert = avTop
      Control = Image2
      ControlOptions.OriginalHeight = 32
      ControlOptions.OriginalWidth = 32
      ControlOptions.ShowBorder = False
      Index = 1
    end
    object item_ddExecuteAction: TdxLayoutItem
      Parent = dxLayoutAutoCreatedGroup6
      CaptionOptions.AlignHorz = taRightJustify
      CaptionOptions.Text = 'Execute action'
      Control = ddExecuteAction
      ControlOptions.OriginalHeight = 21
      ControlOptions.OriginalWidth = 175
      ControlOptions.ShowBorder = False
      Index = 0
    end
    object dxLayoutSeparatorItem2: TdxLayoutSeparatorItem
      Parent = Tab1
      AlignHorz = ahClient
      AlignVert = avTop
      CaptionOptions.Text = 'Separator'
      Index = 1
    end
    object pgActionType_Item: TdxLayoutItem
      Parent = Tab1
      AlignVert = avClient
      CaptionOptions.Text = 'cxPageControl1'
      CaptionOptions.Visible = False
      Control = pgActionType
      ControlOptions.AutoColor = True
      ControlOptions.OriginalHeight = 315
      ControlOptions.OriginalWidth = 436
      ControlOptions.ShowBorder = False
      Index = 2
    end
    object dxLayoutItem2: TdxLayoutItem
      Parent = dxLayoutAutoCreatedGroup7
      AlignHorz = ahClient
      AlignVert = avTop
      CaptionOptions.Text = 'cxDBCheckBox1'
      CaptionOptions.Visible = False
      Control = cbEnabledWhenNoRecords
      ControlOptions.OriginalHeight = 21
      ControlOptions.OriginalWidth = 121
      ControlOptions.ShowBorder = False
      Enabled = False
      Index = 1
    end
    object chboxAlwaysEnabled_Item: TdxLayoutItem
      Parent = dxLayoutAutoCreatedGroup7
      AlignHorz = ahClient
      AlignVert = avTop
      CaptionOptions.Text = 'Always enabled'
      CaptionOptions.Visible = False
      Control = chboxAlwaysEnabled
      ControlOptions.OriginalHeight = 21
      ControlOptions.OriginalWidth = 121
      ControlOptions.ShowBorder = False
      Index = 0
    end
    object edCaption_Item: TdxLayoutItem
      Parent = dxLayoutGroup1
      AlignHorz = ahClient
      AlignVert = avTop
      CaptionOptions.Text = 'Caption'
      CaptionOptions.Layout = clTop
      Control = edCaption
      ControlOptions.OriginalHeight = 21
      ControlOptions.OriginalWidth = 121
      ControlOptions.ShowBorder = False
      Index = 1
    end
    object edCreateOrder_Item: TdxLayoutItem
      Parent = dxLayoutAutoCreatedGroup5
      AlignHorz = ahLeft
      AlignVert = avTop
      CaptionOptions.Text = 'Create Order'
      CaptionOptions.Layout = clTop
      Control = edCreateOrder
      ControlOptions.OriginalHeight = 21
      ControlOptions.OriginalWidth = 65
      ControlOptions.ShowBorder = False
      Index = 0
    end
    object item_Width: TdxLayoutItem
      Parent = dxLayoutAutoCreatedGroup5
      AlignHorz = ahClient
      AlignVert = avClient
      CaptionOptions.Text = 'Width'
      CaptionOptions.Layout = clTop
      Control = edWidth
      ControlOptions.OriginalHeight = 21
      ControlOptions.OriginalWidth = 40
      ControlOptions.ShowBorder = False
      Index = 1
    end
    object dxLayoutAutoCreatedGroup8: TdxLayoutAutoCreatedGroup
      Parent = dxLayoutAutoCreatedGroup3
      AlignHorz = ahRight
      AlignVert = avClient
      LayoutDirection = ldHorizontal
      Index = 0
    end
    object dxLayoutItem4: TdxLayoutItem
      Parent = dxLayoutAutoCreatedGroup3
      AlignHorz = ahRight
      AlignVert = avTop
      CaptionOptions.Text = 'cxButton1'
      CaptionOptions.Visible = False
      CaptionOptions.Layout = clTop
      Control = bnImageIndex
      ControlOptions.OriginalHeight = 25
      ControlOptions.OriginalWidth = 70
      ControlOptions.ShowBorder = False
      Index = 1
    end
    object dxLayoutAutoCreatedGroup3: TdxLayoutAutoCreatedGroup
      Parent = dxLayoutAutoCreatedGroup2
      AlignHorz = ahRight
      Index = 1
    end
    object item_ddStyle: TdxLayoutItem
      Parent = dxLayoutAutoCreatedGroup10
      AlignHorz = ahClient
      CaptionOptions.Text = 'Command style'
      CaptionOptions.Layout = clTop
      Control = ddStyle
      ControlOptions.OriginalHeight = 21
      ControlOptions.OriginalWidth = 121
      ControlOptions.ShowBorder = False
      Index = 0
    end
    object item_cbAutoRefresh: TdxLayoutItem
      Parent = dxLayoutAutoCreatedGroup9
      AlignHorz = ahLeft
      AlignVert = avTop
      CaptionOptions.Text = 'AutoRefresh'
      CaptionOptions.Visible = False
      Control = cbAutoRefresh
      ControlOptions.OriginalHeight = 21
      ControlOptions.OriginalWidth = 82
      ControlOptions.ShowBorder = False
      Index = 0
    end
    object Other: TdxLayoutGroup
      Parent = Tab0
      AlignVert = avClient
      CaptionOptions.Text = 'Other'
      ButtonOptions.Buttons = <>
      ItemIndex = 2
      LayoutDirection = ldHorizontal
      Index = 4
    end
    object dxLayoutAutoCreatedGroup5: TdxLayoutAutoCreatedGroup
      Parent = Other
      AlignHorz = ahLeft
      AlignVert = avTop
      LayoutDirection = ldHorizontal
      Index = 1
    end
    object edShortCut_Item: TdxLayoutItem
      Parent = Other
      AlignHorz = ahLeft
      AlignVert = avTop
      CaptionOptions.Text = 'Hotkey'
      CaptionOptions.Layout = clTop
      Control = edShortCut
      ControlOptions.OriginalHeight = 21
      ControlOptions.OriginalWidth = 121
      ControlOptions.ShowBorder = False
      Index = 0
    end
    object item_MultiSelect: TdxLayoutItem
      Parent = dxLayoutAutoCreatedGroup4
      AlignHorz = ahLeft
      AlignVert = avTop
      CaptionOptions.AlignHorz = taRightJustify
      CaptionOptions.Text = 'Multiselect'
      Control = ddMultiSelect
      ControlOptions.OriginalHeight = 21
      ControlOptions.OriginalWidth = 195
      ControlOptions.ShowBorder = False
      Enabled = False
      Index = 1
    end
    object dxLayoutItem5: TdxLayoutItem
      Parent = dxLayoutAutoCreatedGroup9
      AlignHorz = ahLeft
      AlignVert = avBottom
      CaptionOptions.Text = 'Continue On Error'
      CaptionOptions.Visible = False
      Control = cbContinueOnError
      ControlOptions.AutoColor = True
      ControlOptions.OriginalHeight = 17
      ControlOptions.OriginalWidth = 120
      ControlOptions.ShowBorder = False
      Enabled = False
      Index = 1
    end
    object GroupActionOptions: TdxLayoutGroup
      Parent = dxLayoutGroup3
      AlignHorz = ahRight
      CaptionOptions.Text = 'CommonActionOptions'
      CaptionOptions.Visible = False
      ButtonOptions.Buttons = <>
      ShowBorder = False
      Index = 0
    end
    object dxLayoutAutoCreatedGroup1: TdxLayoutAutoCreatedGroup
      Parent = GroupActionOptions
      AlignVert = avTop
      LayoutDirection = ldHorizontal
      Index = 0
    end
    object dxLayoutAutoCreatedGroup6: TdxLayoutAutoCreatedGroup
      Parent = dxLayoutAutoCreatedGroup4
      AlignHorz = ahClient
      AlignVert = avClient
      Index = 0
    end
    object dxLayoutAutoCreatedGroup4: TdxLayoutAutoCreatedGroup
      Parent = dxLayoutAutoCreatedGroup1
      AlignHorz = ahClient
      Index = 0
    end
    object dxLayoutAutoCreatedGroup9: TdxLayoutAutoCreatedGroup
      Parent = dxLayoutAutoCreatedGroup1
      AlignHorz = ahLeft
      Index = 1
    end
    object Item_ddAppearsOn: TdxLayoutItem
      Parent = dxLayoutAutoCreatedGroup10
      AlignHorz = ahClient
      AlignVert = avClient
      CaptionOptions.Text = 'Appears on'
      CaptionOptions.Layout = clTop
      Control = ddAppearsOn
      ControlOptions.OriginalHeight = 21
      ControlOptions.OriginalWidth = 121
      ControlOptions.ShowBorder = False
      Index = 1
    end
    object dxLayoutAutoCreatedGroup10: TdxLayoutAutoCreatedGroup
      Parent = Other
      AlignHorz = ahClient
      AlignVert = avTop
      LayoutDirection = ldHorizontal
      Index = 2
    end
  end
  inherited MainSource: TDataSource
    Left = 480
    Top = 361
  end
end
