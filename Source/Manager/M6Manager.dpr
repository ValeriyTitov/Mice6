program M6Manager;


uses
  Vcl.Forms,
  MainForm.Manager in 'MainForm.Manager.pas' {ManagerMainForm},
  MainForm.ItemDelete in 'MainForm.ItemDelete.pas',
  MainForm.TreeRefresher in 'MainForm.TreeRefresher.pas',
  MainForm.Actions in 'MainForm.Actions.pas',
  MainForm.CaptionUpdater in 'MainForm.CaptionUpdater.pas',
  DAC.XDataSet in '..\DAC\DAC.XDataSet.Pas',
  DAC.XParams in '..\DAC\DAC.XParams.pas',
  DAC.XDataSetHelper in '..\DAC\DAC.XDataSetHelper.pas',
  DAC.BaseDataSet in '..\DAC\DAC.BaseDataSet.pas',
  DAC.History in '..\DAC\DAC.History.pas',
  DAC.CSB in '..\DAC\DAC.CSB.pas',
  DAC.DataSnap in '..\DAC\DAC.DataSnap.pas',
  DAC.Data.Convert in '..\DAC\DAC.Data.Convert.pas',
  DAC.XParams.Utils in '..\DAC\DAC.XParams.Utils.pas',
  DAC.DatabaseUtils in '..\DAC\DAC.DatabaseUtils.pas',
  DAC.ConnectionMngr in '..\DAC\DAC.ConnectionMngr.pas',
  DAC.ObjectModels.MiceUser in '..\DAC\ObjectModels\DAC.ObjectModels.MiceUser.pas',
  DAC.DatasetList in '..\DAC\DAC.DatasetList.pas',
  DAC.History.Form in '..\DAC\DAC.History.Form.pas' {SQLHistoryForm},
  DAC.XParams.Mapper in '..\DAC\DAC.XParams.Mapper.pas',
  DAC.ObjectModels.ApplyContent in '..\DAC\ObjectModels\DAC.ObjectModels.ApplyContent.pas',
  DAC.ObjectModels.ApplyUpdates.Request in '..\DAC\ObjectModels\DAC.ObjectModels.ApplyUpdates.Request.pas',
  DAC.ObjectModels.ApplyUpdates.Response in '..\DAC\ObjectModels\DAC.ObjectModels.ApplyUpdates.Response.pas',
  DAC.ObjectModels.Authorization.Request in '..\DAC\ObjectModels\DAC.ObjectModels.Authorization.Request.pas',
  DAC.ObjectModels.Authorization.Response in '..\DAC\ObjectModels\DAC.ObjectModels.Authorization.Response.pas',
  DAC.ObjectModels.DataSetMessage in '..\DAC\ObjectModels\DAC.ObjectModels.DataSetMessage.pas',
  DAC.ObjectModels.Exception in '..\DAC\ObjectModels\DAC.ObjectModels.Exception.pas',
  DAC.ObjectModels.ExecutionContext in '..\DAC\ObjectModels\DAC.ObjectModels.ExecutionContext.pas',
  DAC.ObjectModels.MiceData.Request in '..\DAC\ObjectModels\DAC.ObjectModels.MiceData.Request.pas',
  DAC.ObjectModels.MiceData.Response in '..\DAC\ObjectModels\DAC.ObjectModels.MiceData.Response.pas',
  DAC.ObjectModels.Token in '..\DAC\ObjectModels\DAC.ObjectModels.Token.pas',
  DAC.Provider.Columns.Finder in '..\DAC\DAC.Provider.Columns.Finder.pas',
  Params.SourceSelectorFrame in '..\StaticDialog\Manager\Params.SourceSelectorFrame.pas' {CommandPropertiesFrame: TFrame},
  Common.Images in '..\Common\Common.Images.pas' {ImageContainer},
  Common.StringUtils in '..\Common\Common.StringUtils.pas',
  Common.VariantComparator in '..\Common\Common.VariantComparator.pas',
  Common.VariantUtils in '..\Common\Common.VariantUtils.pas',
  Common.ResourceStrings in '..\Common\Common.ResourceStrings.pas',
  Common.LookAndFeel in '..\Common\Common.LookAndFeel.pas' {DefaultLookAndFeel},
  Common.JsonUtils in '..\Common\Common.JsonUtils.pas',
  Common.Images.SelectDialog in '..\Common\Common.Images.SelectDialog.pas' {SelectImageDialog},
  Common.ResourceStrings.Manager in '..\Common\Common.ResourceStrings.Manager.pas',
  Common.DBFile in '..\Common\Common.DBFile.pas',
  Common.GlobalSettings in '..\Common\Common.GlobalSettings.pas',
  Common.Config.ApplicationSettings in '..\Common\Common.Config.ApplicationSettings.pas',
  Common.Registry in '..\Common\Common.Registry.pas',
  Common.ShellUtils in '..\Common\Common.ShellUtils.pas',
  Mice.Report in '..\Common\Mice.Report.pas',
  Mice.Script in '..\Common\Mice.Script.pas',
  Mice.Script.ClassTree in '..\Common\Mice.Script.ClassTree.pas',
  Mice.Script.Reg in '..\Common\Mice.Script.Reg.pas',
  StaticDialog.MiceInputBox in '..\StaticDialog\StaticDialog.MiceInputBox.pas' {MiceInputBox},
  StaticDialog.CheckBoxItemSelector in '..\StaticDialog\StaticDialog.CheckBoxItemSelector.pas' {CheckBoxItemSelector},
  StaticDialog.ItemSelector.Common in '..\StaticDialog\StaticDialog.ItemSelector.Common.pas' {CommonItemSelectorDlg},
  StaticDialog.ItemTreeSelector.Common in '..\StaticDialog\StaticDialog.ItemTreeSelector.Common.pas' {CommonSelectTreeDialog},
  Dialog.Basic in '..\Dialog\Dialog.Basic.pas' {BasicDialog},
  Dialog.DB in '..\Dialog\Dialog.DB.pas' {BasicDBDialog},
  Dialog.Layout in '..\Dialog\Dialog.Layout.pas' {BasicLayoutDialog},
  Dialog.Layout.CustomizationForm in '..\Dialog\Dialog.Layout.CustomizationForm.pas',
  Dialog.Layout.Builder in '..\Dialog\Dialog.Layout.Builder.pas',
  Dialog.Layout.ControlList in '..\Dialog\Dialog.Layout.ControlList.pas',
  Dialog.Layout.ControlList.SelectorDialog in '..\StaticDialog\Dialog.Layout.ControlList.SelectorDialog.pas' {NewControlSelectorDialog},
  Manager.WindowManager in 'Manager.WindowManager.pas',
  Manager.CommonCommandsList in 'Manager.CommonCommandsList.pas' {CommonCommands},
  ControlEditor.MiceMemo in '..\StaticDialog\Manager\ControlEditor\ControlEditor.MiceMemo.pas' {ControlEditorMiceMemo},
  ControlEditor.MiceCheckBox in '..\StaticDialog\Manager\ControlEditor\ControlEditor.MiceCheckBox.pas' {ControlEditorMiceCheckBox},
  ControlEditor.MiceDateEdit in '..\StaticDialog\Manager\ControlEditor\ControlEditor.MiceDateEdit.pas' {ControlEditorMiceDateEdit},
  ControlEditor.MiceDropDown in '..\StaticDialog\Manager\ControlEditor\ControlEditor.MiceDropDown.pas' {ControlEditorMiceDropDown},
  ControlEditor.MiceButton in '..\StaticDialog\Manager\ControlEditor\ControlEditor.MiceButton.pas' {ControlEditorMiceButton},
  ControlEditor.MiceGridFrame in '..\StaticDialog\Manager\ControlEditor\ControlEditor.MiceGridFrame.pas' {ControlEditorMiceGridFrame},
  ControlEditor.MiceTreeGridFrame in '..\StaticDialog\Manager\ControlEditor\ControlEditor.MiceTreeGridFrame.pas' {ControlEditorMiceTreeGridFrame},
  ControlEditor.MiceEditableGridFrame in '..\StaticDialog\Manager\ControlEditor\ControlEditor.MiceEditableGridFrame.pas' {ControlEditorMiceEditableGridFrame},
  ControlEditor.MiceCurrencyEdit in '..\StaticDialog\Manager\ControlEditor\ControlEditor.MiceCurrencyEdit.pas' {ControlEditorMiceCurrencyEdit},
  ControlEditor.MiceValuePicker in '..\StaticDialog\Manager\ControlEditor\ControlEditor.MiceValuePicker.pas' {ControlEditorMiceValuePicker},
  ControlEditor.Common in '..\StaticDialog\Manager\ControlEditor\ControlEditor.Common.pas' {ControlEditorBase},
  ControlEditor.MiceTextEdit in '..\StaticDialog\Manager\ControlEditor\ControlEditor.MiceTextEdit.pas' {ControlEditorBase1},
  ControlEditor.MiceRadioGroup in '..\StaticDialog\Manager\ControlEditor\ControlEditor.MiceRadioGroup.pas' {ControlEditMiceRadioGroup},
  ControlEditor.MiceTextEdit.TryForm in '..\StaticDialog\Manager\ControlEditor\ControlEditor.MiceTextEdit.TryForm.pas' {MiceTextEditTryForm},
  CustomControl.MiceRadioGroup in '..\CustomControls\Controls\CustomControl.MiceRadioGroup.pas',
  CustomControl.MiceDropDown in '..\CustomControls\Controls\CustomControl.MiceDropDown.pas',
  CustomControl.MiceMemo in '..\CustomControls\Controls\CustomControl.MiceMemo.pas',
  CustomControl.MiceCurrencyEdit in '..\CustomControls\Controls\CustomControl.MiceCurrencyEdit.pas',
  CustomControl.MiceVerticalGrid in '..\CustomControls\Controls\CustomControl.MiceVerticalGrid.pas',
  CustomControl.MiceValuePicker in '..\CustomControls\Controls\CustomControl.MiceValuePicker.pas' {SelectTreeDialog},
  CustomControl.MiceGrid.ColumnEditor.BandDialog in '..\CustomControls\Grids\CustomControl.MiceGrid.ColumnEditor.BandDialog.pas' {BandPropetiesDlg},
  CustomControl.AppObject.Properties in '..\CustomControls\CustomControl.AppObject.Properties.pas',
  CustomControl.MiceGrid.ColorEditor in '..\CustomControls\Grids\CustomControl.MiceGrid.ColorEditor.pas' {MiceGridColorEditorFrame: TFrame},
  CustomControl.MiceFlowChart in '..\CustomControls\Controls\CustomControl.MiceFlowChart.pas',
  CustomControl.MiceGridFrame in '..\CustomControls\Controls\CustomControl.MiceGridFrame.pas' {MiceGridFrame: TFrame},
  CustomControl.MiceTreeGridFrame in '..\CustomControls\Controls\CustomControl.MiceTreeGridFrame.pas' {MiceTreeGridFrame: TFrame},
  CustomControl.MiceEditableGridFrame in '..\CustomControls\Controls\CustomControl.MiceEditableGridFrame.pas' {MiceEditableGridFrame: TFrame},
  CustomControl.MiceSyntaxEdit in '..\CustomControls\Controls\CustomControl.MiceSyntaxEdit.pas',
  CustomControl.TreeGrid in '..\CustomControls\Grids\CustomControl.TreeGrid.pas',
  CustomControl.MiceGrid in '..\CustomControls\Grids\CustomControl.MiceGrid.pas',
  CustomControl.MiceGrid.ColumnEditor in '..\CustomControls\Grids\CustomControl.MiceGrid.ColumnEditor.pas' {ColumnEditorFrame: TFrame},
  CustomControl.MiceGrid.ColumnEditor.ColumnDialog in '..\CustomControls\Grids\CustomControl.MiceGrid.ColumnEditor.ColumnDialog.pas' {ColumnPropetiesDlg},
  CustomControl.MiceDropDown.ObjectModel in '..\CustomControls\Controls\CustomControl.MiceDropDown.ObjectModel.pas',
  CustomControl.MiceDropDown.EditorFrame in '..\CustomControls\Controls\CustomControl.MiceDropDown.EditorFrame.pas' {DropDownEditorFrame: TFrame},
  CustomControl.AppObject in '..\CustomControls\CustomControl.AppObject.pas',
  CustomControl.LinkLabel in '..\CustomControls\Controls\CustomControl.LinkLabel.pas',
  CustomControl.AutoCompleteTextEdit in '..\CustomControls\CustomControl.AutoCompleteTextEdit.pas',
  CustomControl.MiceLayout in '..\CustomControls\CustomControl.MiceLayout.pas',
  CustomControl.MiceGrid.ColumnEditor.AutoFill in '..\CustomControls\Grids\CustomControl.MiceGrid.ColumnEditor.AutoFill.pas',
  CustomControl.MiceValuePicker.Base in '..\CustomControls\Controls\CustomControl.MiceValuePicker.Base.pas',
  CustomControl.MiceValuePicker.SelectItemDlg in '..\CustomControls\Controls\CustomControl.MiceValuePicker.SelectItemDlg.pas' {VPickSelectItemDialog},
  CustomControl.MiceValuePicker.Settings in '..\CustomControls\Controls\CustomControl.MiceValuePicker.Settings.pas',
  ManagerEditor.Common in '..\StaticDialog\Manager\ManagerEditor.Common.pas' {CommonManagerDialog},
  ManagerEditor.Plugin in '..\StaticDialog\Manager\ManagerEditor.Plugin.pas' {ManagerEditorPlugin},
  ManagerEditor.Script in '..\StaticDialog\Manager\ManagerEditor.Script.pas' {ManagerEditorScript},
  ManagerEditor.Script.SyntaxFrame in '..\StaticDialog\Manager\ManagerEditor.Script.SyntaxFrame.pas' {SyntaxFrame: TFrame},
  ManagerEditor.Script.Runner in '..\StaticDialog\Manager\ManagerEditor.Script.Runner.pas',
  ManagerEditor.Filter in '..\StaticDialog\Manager\ManagerEditor.Filter.pas' {ManagerEditorFilter},
  ManagerEditor.Script.Runner.CSharp in '..\StaticDialog\Manager\ScriptRunners\ManagerEditor.Script.Runner.CSharp.pas',
  ManagerEditor.Script.Runner.Pascal in '..\StaticDialog\Manager\ScriptRunners\ManagerEditor.Script.Runner.Pascal.pas',
  ManagerEditor.Script.Runner.Xml in '..\StaticDialog\Manager\ScriptRunners\ManagerEditor.Script.Runner.Xml.pas',
  ManagerEditor.Script.Runner.Json in '..\StaticDialog\Manager\ScriptRunners\ManagerEditor.Script.Runner.Json.pas',
  ManagerEditor.Script.Runner.SQL in '..\StaticDialog\Manager\ScriptRunners\ManagerEditor.Script.Runner.SQL.pas',
  ManagerEditor.AppTemplate in '..\StaticDialog\Manager\ManagerEditor.AppTemplate.pas' {ManagerEditorAppTemplate},
  ManagerEditor.AppDataSet in '..\StaticDialog\Manager\ManagerEditor.AppDataSet.pas' {ManagerDialogAppDataSet},
  ManagerEditor.dfClass in '..\StaticDialog\Manager\ManagerEditor.dfClass.pas' {ManagerEditorDfClass},
  ManagerEditor.dfTypes in '..\StaticDialog\Manager\ManagerEditor.dfTypes.pas' {ManagerEditorDfTypes},
  ManagerEditor.Command in '..\StaticDialog\Manager\ManagerEditor.Command.pas' {ManagerEditorCommand},
  ManagerEditor.AppDialog in '..\StaticDialog\Manager\ManagerEditor.AppDialog.pas' {ManagerEditorAppDialog},
  ManagerEditor.AppDialogLayout in '..\StaticDialog\Manager\ManagerEditor.AppDialogLayout.pas' {ManagerEditorAppDialogLayout},
  ManagerEditor.dfPathFolder in '..\StaticDialog\Manager\ManagerEditor.dfPathFolder.pas' {ManagerEditorDfPathFolder},
  ManagerEditor.dfMethod in '..\StaticDialog\Manager\ManagerEditor.dfMethod.pas' {ManagerEditorDfMethod},
  ManagerEditor.AppTemplate.DataSourceListDlg in '..\StaticDialog\Manager\ManagerEditor.AppTemplate.DataSourceListDlg.pas' {DataSourceListDlg},
  ManagerEditor.AppTemplate.ParamsSelectionDlg in '..\StaticDialog\Manager\ManagerEditor.AppTemplate.ParamsSelectionDlg.pas' {ParamSourceDlg},
  ManagerEditor.Script.PascalScript in '..\StaticDialog\Manager\ManagerEditor.Script.PascalScript.pas' {ManagerEditorPascalScript},
  ManagerEditor.Script.SQL in '..\StaticDialog\Manager\ManagerEditor.Script.SQL.pas' {ManagerEditorSQLScript},
  ManagerEditor.Script.Json in '..\StaticDialog\Manager\ManagerEditor.Script.Json.pas' {ManagerEditorJson},
  ManagerEditor.Script.Xml in '..\StaticDialog\Manager\ManagerEditor.Script.Xml.pas' {ManagerEditorXml},
  ManagerEditor.DocFlowSchema in '..\StaticDialog\Manager\ManagerEditor.DocFlowSchema.pas' {ManagerEditorDocFlowScheme},
  ManagerEditor.Script.DataScript in '..\StaticDialog\Manager\ManagerEditor.Script.DataScript.pas' {ManagerEditorCSharpScript},
  ManagerEditor.Script.PascalScript.DataTreeBuilder in '..\StaticDialog\Manager\ManagerEditor.Script.PascalScript.DataTreeBuilder.pas',
  ManagerEditor.AppDialogLayout.FlagEditor in '..\StaticDialog\Manager\ManagerEditor.AppDialogLayout.FlagEditor.pas' {FlagEditor},
  ManagerDialog.ExternalFile in '..\StaticDialog\Manager\ManagerDialog.ExternalFile.pas' {ExternalFileDlg},
  AppTemplate.FileImport in '..\StaticDialog\Manager\AppTemplate.FileImport.pas',
  AppTemplate.Builder.Xml in '..\Common\AppTemplate.Builder.Xml.pas',
  AppTemplate.Builder.Json in '..\Common\AppTemplate.Builder.Json.pas',
  AppTemplate.Builder.Xbrl in '..\Common\AppTemplate.Builder.Xbrl.pas',
  AppTemplate.FileImport.Xml in '..\StaticDialog\Manager\AppTemplate.FileImport.Xml.pas',
  AppTemplate.FileImport.Json in '..\StaticDialog\Manager\AppTemplate.FileImport.Json.pas',
  AppTemplate.FileImport.DBObject in '..\StaticDialog\Manager\AppTemplate.FileImport.DBObject.pas',
  AppTemplate.FileImport.Xsd in '..\StaticDialog\Manager\AppTemplate.FileImport.Xsd.pas',
  AppTemplate.Builder.Thread in '..\Common\AppTemplate.Builder.Thread.pas',
  AppTemplate.FileImport.Xbrl in '..\StaticDialog\Manager\AppTemplate.FileImport.Xbrl.pas',
  Thread.Basic in '..\Common\Thread.Basic.pas',
  DocFlow.Schema.Helper in '..\DocFlow\DocFlow.Schema.Helper.pas',
  Thread.WaitingForm in '..\Common\Thread.WaitingForm.pas' {ThreadWaitingForm},
  DataScript.InputBox in '..\StaticDialog\Manager\DataScript.InputBox.pas' {DataScriptInputBox},
  StartUp.LoginDlg in '..\Startup\StartUp.LoginDlg.pas' {ProjectLoginDialog},
  Flags.Frame in '..\StaticDialog\Manager\Flags.Frame.pas' {FlagsFrame: TFrame},
  ManagerEditor.dfPathFolder.RulesFrame in '..\StaticDialog\Manager\ManagerEditor.dfPathFolder.RulesFrame.pas' {dfPathFoldersIncomingRulesFrame: TFrame},
  ManagerEditor.dfPathFolder.InitFrame in '..\StaticDialog\Manager\ManagerEditor.dfPathFolder.InitFrame.pas' {dfPathFoldersInitFrame: TFrame},
  ManagerEditor.dfPathFolder.ActionsFrame in '..\StaticDialog\Manager\ManagerEditor.dfPathFolder.ActionsFrame.pas' {dfPathFoldersActionsFrame: TFrame},
  ManagerEditor.dfPathFolder.DecisionFrame in '..\StaticDialog\Manager\ManagerEditor.dfPathFolder.DecisionFrame.pas' {dfPathFoldersDecisionFrame: TFrame},
  Permissions.Frame in '..\StaticDialog\Permissions.Frame.pas' {PermissionsFrame: TFrame},
  CustomControl.MiceValuePicker.SelectTreeDlg in '..\CustomControls\Controls\CustomControl.MiceValuePicker.SelectTreeDlg.pas' {VPickSelectTreeDialog},
  ManagerEditor.dfPathFolder.RulesFrame.Dialog in '..\StaticDialog\Manager\ManagerEditor.dfPathFolder.RulesFrame.Dialog.pas' {PathFolderRuleDialog},
  ManagerEditor.dfPathFolder.ActionsFrame.CommonDialog in '..\StaticDialog\Manager\dfActions\ManagerEditor.dfPathFolder.ActionsFrame.CommonDialog.pas' {CommonDfActionsDialog},
  ManagerEditor.dfPathFolder.ActionsFrame.ExecuteStoredProcedure in '..\StaticDialog\Manager\dfActions\ManagerEditor.dfPathFolder.ActionsFrame.ExecuteStoredProcedure.pas' {dfActionsExecuteStoredProcedureDialog},
  ManagerEditor.dfPathFolder.ActionsFrame.HttpRequest in '..\StaticDialog\Manager\dfActions\ManagerEditor.dfPathFolder.ActionsFrame.HttpRequest.pas' {DfActionsHttpRequest},
  ManagerEditor.dfPathFolder.ActionsFrame.SendEmail in '..\StaticDialog\Manager\dfActions\ManagerEditor.dfPathFolder.ActionsFrame.SendEmail.pas' {DfActionsEmailDialog},
  ManagerEditor.Script.PascalScript.DataTreeDescriptions in '..\StaticDialog\Manager\ManagerEditor.Script.PascalScript.DataTreeDescriptions.pas',
  Common.DateUtils in '..\Common\Common.DateUtils.pas',
  ManagerEditor.DocFlowSchema.Validate in '..\StaticDialog\Manager\ManagerEditor.DocFlowSchema.Validate.pas',
  CustomControl.MiceClientEdit in '..\CustomControls\Controls\CustomControl.MiceClientEdit.pas',
  ControlEditor.ClientEdit in '..\StaticDialog\Manager\ControlEditor\ControlEditor.ClientEdit.pas' {ControlEditorClientEdit},
  StaticDialog.DBNameSelector in '..\StaticDialog\StaticDialog.DBNameSelector.pas' {DBNameSelectorDialog},
  CustomControl.MiceFlowChart.Shapes in '..\CustomControls\Controls\CustomControl.MiceFlowChart.Shapes.pas',
  CustomControl.MiceFlowChart.PropertiesFrame in '..\CustomControls\Controls\CustomControl.MiceFlowChart.PropertiesFrame.pas' {ShapePropertiesFrame: TFrame},
  CustomControl.MiceFlowChart.FlowCommentPropertiesDialog in '..\CustomControls\Controls\CustomControl.MiceFlowChart.FlowCommentPropertiesDialog.pas' {FlowCommentPropertiesDialog},
  ManagerEditor.AppDialog.DetailDataSetProperties in '..\StaticDialog\Manager\ManagerEditor.AppDialog.DetailDataSetProperties.pas' {DetailsDataSetPropertiesDlg},
  Dialog.MShowMessage in '..\Dialog\Dialog.MShowMessage.pas' {MessageDialog},
  Dialog.ShowDataSet in '..\Dialog\Dialog.ShowDataSet.pas' {ShowDatasetDialog},
  ImportExport.Entity in 'ImportExport\ImportExport.Entity.pas',
  ImportExport.Manager in 'ImportExport\ImportExport.Manager.pas',
  ImportExport.JsonToDataSet in 'ImportExport\ImportExport.JsonToDataSet.pas',
  ImportExport.ItemLists in 'ImportExport\ImportExport.ItemLists.pas',
  ImportExport.AppPlugin in 'ImportExport\ImportExport.AppPlugin.pas',
  ImportExport.Folder in 'ImportExport\ImportExport.Folder.pas',
  ImportExport.AppDialog in 'ImportExport\ImportExport.AppDialog.pas',
  ImportExport.AppTemplate in 'ImportExport\ImportExport.AppTemplate.pas',
  ImportExport.AppDialogLayout in 'ImportExport\ImportExport.AppDialogLayout.pas',
  ImportExport.Dialogs.ObjectSelection in 'ImportExport\Dialogs\ImportExport.Dialogs.ObjectSelection.pas' {AppObjectExportDlg},
  ImportExport.Dialogs.ObjectFrame in 'ImportExport\Dialogs\ImportExport.Dialogs.ObjectFrame.pas' {AppObjectExportFrame: TFrame},
  ImportExport.VersionReader in 'ImportExport\ImportExport.VersionReader.pas',
  ImportExport.CommandGroup in 'ImportExport\ImportExport.CommandGroup.pas',
  ImportExport.StatisticList in 'ImportExport\ImportExport.StatisticList.pas',
  ImportExport.Dialogs.ImportConfirmation in 'ImportExport\Dialogs\ImportExport.Dialogs.ImportConfirmation.pas' {ImportConfirmDialog},
  ImportExport.ExternalFile in 'ImportExport\ImportExport.ExternalFile.pas',
  ImportExport.AppScripts in 'ImportExport\ImportExport.AppScripts.pas',
  ImportExport.AppDataSet in 'ImportExport\ImportExport.AppDataSet.pas',
  ImportExport.AppCmd in 'ImportExport\ImportExport.AppCmd.pas',
  ImportExport.dfClass in 'ImportExport\ImportExport.dfClass.pas',
  ImportExport.dfSchema in 'ImportExport\ImportExport.dfSchema.pas',
  ImportExport.dfTypes in 'ImportExport\ImportExport.dfTypes.pas',
  ImportExport.Dialogs.LoadProgress in 'ImportExport\Dialogs\ImportExport.Dialogs.LoadProgress.pas' {LoadProgressForm},
  ManagerEditor.Script.Runner.SQL.ObjectDetails in '..\StaticDialog\Manager\ScriptRunners\ManagerEditor.Script.Runner.SQL.ObjectDetails.pas';

{$R *.res}

begin
  ReportMemoryLeaksOnShutdown:=True;

  Application.Initialize;
  Application.Title:='Mice 6 Manager';
  Application.HintHidePause:=15000;
  Application.MainFormOnTaskbar := True;

  if TStartupLoginDialog.Execute then
   Application.CreateForm(TManagerMainForm, ManagerMainForm);
  Application.Run;
end.
