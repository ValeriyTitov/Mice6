program Mice;

uses
  Vcl.Forms,
  MiceTileMain in 'MiceTileMain.pas' {MiceMainTileForm},
  DAC.XDataSet in '..\DAC\DAC.XDataSet.Pas',
  DAC.XDataSetHelper in '..\DAC\DAC.XDataSetHelper.pas',
  DAC.BaseDataSet in '..\DAC\DAC.BaseDataSet.pas',
  DAC.History in '..\DAC\DAC.History.pas',
  DAC.CSB in '..\DAC\DAC.CSB.pas',
  DAC.XParams.Utils in '..\DAC\DAC.XParams.Utils.pas',
  DAC.DatabaseUtils in '..\DAC\DAC.DatabaseUtils.pas',
  DAC.ConnectionMngr in '..\DAC\DAC.ConnectionMngr.pas',
  DAC.XParams in '..\DAC\DAC.XParams.pas',
  DAC.XParams.Mapper in '..\DAC\DAC.XParams.Mapper.pas',
  DAC.History.Form in '..\DAC\DAC.History.Form.pas' {SQLHistoryForm},
  Common.Images in '..\Common\Common.Images.pas' {ImageContainer},
  Common.StringUtils in '..\Common\Common.StringUtils.pas',
  Common.VariantComparator in '..\Common\Common.VariantComparator.pas',
  Common.VariantUtils in '..\Common\Common.VariantUtils.pas',
  Common.DateUtils in '..\Common\Common.DateUtils.pas',
  Common.ActivityCondition in '..\Common\Common.ActivityCondition.pas',
  Common.ResourceStrings in '..\Common\Common.ResourceStrings.pas',
  Common.GlobalSettings in '..\Common\Common.GlobalSettings.pas',
  Common.LookAndFeel in '..\Common\Common.LookAndFeel.pas' {DefaultLookAndFeel},
  Dialog.Layout.Builder in '..\Dialog\Dialog.Layout.Builder.pas',
  Dialog.Basic in '..\Dialog\Dialog.Basic.pas' {BasicDialog},
  Dialog.DB in '..\Dialog\Dialog.DB.pas' {BasicDBDialog},
  Dialog.Layout in '..\Dialog\Dialog.Layout.pas' {BasicLayoutDialog},
  Dialog.Adaptive in '..\Dialog\Dialog.Adaptive.pas' {AdaptiveDialog},
  Dialog.Adaptive.Helper in '..\Dialog\Dialog.Adaptive.Helper.pas',
  Dialog.Embedded in '..\Dialog\Dialog.Embedded.pas' {EmbeddedDialog},
  Plugin.SaveLoad in '..\Plugin\Plugin.SaveLoad.pas',
  Plugin.Properties in '..\Plugin\Plugin.Properties.pas',
  Plugin.Base in '..\Plugin\Plugin.Base.pas' {BasePlugin},
  Plugin.Grid in '..\Plugin\Plugin.Grid.pas' {GridPlugin},
  Plugin.TreeGrid in '..\Plugin\Plugin.TreeGrid.pas' {TreeGridPlugin},
  Plugin.PivotGrid in '..\Plugin\Plugin.PivotGrid.pas' {PivotPlugin: TFrame},
  Plugin.TileBuilder in '..\Plugin\Plugin.TileBuilder.pas',
  Plugin.List in '..\Plugin\Plugin.List.pas',
  Plugin.Container in '..\Plugin\Plugin.Container.pas',
  StaticDialog.ItemSelector.Common in '..\StaticDialog\StaticDialog.ItemSelector.Common.pas' {CommonItemSelectorDlg},
  CustomControl.TreeGrid in '..\CustomControls\Grids\CustomControl.TreeGrid.pas',
  CustomControl.MiceAction in '..\CustomControls\CustomControl.MiceAction.pas',
  CustomControl.MiceActionList in '..\CustomControls\CustomControl.MiceActionList.pas',
  CustomControl.Interfaces in '..\CustomControls\CustomControl.Interfaces.pas',
  CustomControl.PluginTree in '..\CustomControls\CustomControl.PluginTree.pas' {PluginTree},
  CustomControl.MiceTableView in '..\CustomControls\Grids\CustomControl.MiceTableView.pas',
  CustomControl.MiceGrid in '..\CustomControls\Grids\CustomControl.MiceGrid.pas',
  CustomControl.MiceGrid.ColumnBuilder in '..\CustomControls\Grids\CustomControl.MiceGrid.ColumnBuilder.pas',
  CustomControl.MiceGrid.Helper in '..\CustomControls\Grids\CustomControl.MiceGrid.Helper.pas',
  CustomControl.Bar.MiceDateEdit in '..\CustomControls\Bar\CustomControl.Bar.MiceDateEdit.pas',
  CustomControl.Bar.MiceDateRangeEdit in '..\CustomControls\Bar\CustomControl.Bar.MiceDateRangeEdit.pas',
  CustomControl.Bar.MiceLargeButton in '..\CustomControls\Bar\CustomControl.Bar.MiceLargeButton.pas',
  CustomControl.Bar.MiceButton in '..\CustomControls\Bar\CustomControl.Bar.MiceButton.pas',
  CustomControl.Bar.MiceCheckBoxButton in '..\CustomControls\Bar\CustomControl.Bar.MiceCheckBoxButton.pas',
  CustomControl.Bar.MiceDropDown in '..\CustomControls\Bar\CustomControl.Bar.MiceDropDown.pas',
  CustomControl.Bar.MiceTextEdit in '..\CustomControls\Bar\CustomControl.Bar.MiceTextEdit.pas',
  CustomControl.Bar.MiceClientEditor in '..\CustomControls\Bar\CustomControl.Bar.MiceClientEditor.pas',
  CustomControl.Bar.MiceSubAccountEditor in '..\CustomControls\Bar\CustomControl.Bar.MiceSubAccountEditor.pas',
  CustomControl.Bar.MiceValuePicker in '..\CustomControls\Bar\CustomControl.Bar.MiceValuePicker.pas',
  CustomControl.Bar.MiceOptionBox in '..\CustomControls\Bar\CustomControl.Bar.MiceOptionBox.pas',
  CustomControl.Bar.MiceStatic in '..\CustomControls\Bar\CustomControl.Bar.MiceStatic.pas',
  CustomControl.Bar.MiceTreeViewCombo in '..\CustomControls\Bar\CustomControl.Bar.MiceTreeViewCombo.pas',
  CustomControl.Bar.CommonObject in '..\CustomControls\Bar\CustomControl.Bar.CommonObject.pas',
  CustomControl.Bar.MiceBasicControl in '..\CustomControls\Bar\CustomControl.Bar.MiceBasicControl.pas',
  CustomControl.Bar.MiceFileButton in '..\CustomControls\Bar\CustomControl.Bar.MiceFileButton.pas',
  CustomControl.AutoCompleteDropDown in '..\CustomControls\Controls\CustomControl.AutoCompleteDropDown.pas',
  CustomControl.LinkLabel in '..\CustomControls\Controls\CustomControl.LinkLabel.pas',
  CustomControl.MiceButton in '..\CustomControls\Controls\CustomControl.MiceButton.pas',
  CustomControl.MiceCheckBox in '..\CustomControls\Controls\CustomControl.MiceCheckBox.pas',
  CustomControl.MiceDateEdit in '..\CustomControls\Controls\CustomControl.MiceDateEdit.pas',
  CustomControl.MiceDateRangeEdit in '..\CustomControls\Controls\CustomControl.MiceDateRangeEdit.pas',
  CustomControl.MiceDropDown.Builder in '..\CustomControls\Controls\CustomControl.MiceDropDown.Builder.pas',
  CustomControl.MiceDropDown.ObjectModel in '..\CustomControls\Controls\CustomControl.MiceDropDown.ObjectModel.pas',
  CustomControl.MiceDropDown in '..\CustomControls\Controls\CustomControl.MiceDropDown.pas',
  CustomControl.MiceEditableGridFrame in '..\CustomControls\Controls\CustomControl.MiceEditableGridFrame.pas',
  CustomControl.MiceGridFrame in '..\CustomControls\Controls\CustomControl.MiceGridFrame.pas',
  CustomControl.MiceMemo in '..\CustomControls\Controls\CustomControl.MiceMemo.pas',
  CustomControl.MiceSyntaxEdit in '..\CustomControls\Controls\CustomControl.MiceSyntaxEdit.pas',
  CustomControl.MiceTextEdit in '..\CustomControls\Controls\CustomControl.MiceTextEdit.pas',
  CustomControl.MiceTreeGridFrame in '..\CustomControls\Controls\CustomControl.MiceTreeGridFrame.pas' {Dialog.Layout.ControlList in '..\Dialog\Dialog.Layout.ControlList.pas'},
  CustomControl.MiceBalloons in '..\CustomControls\CustomControl.MiceBalloons.pas',
  CustomControl.MiceTreeGrid.ColumnBuilder in '..\CustomControls\Grids\CustomControl.MiceTreeGrid.ColumnBuilder.pas',
  CustomControl.CommonGrid.ColumnBuilder in '..\CustomControls\Grids\CustomControl.CommonGrid.ColumnBuilder.pas',
  CustomControl.MiceGrid.ColorBuilder in '..\CustomControls\Grids\CustomControl.MiceGrid.ColorBuilder.pas',
  CustomControl.MiceValuePicker in '..\CustomControls\Controls\CustomControl.MiceValuePicker.pas',
  CustomControl.MiceValuePicker.SelectItemDlg in '..\CustomControls\Controls\CustomControl.MiceValuePicker.SelectItemDlg.pas' {SelectItemDialog},
  CustomControl.MiceRadioGroup in '..\CustomControls\Controls\CustomControl.MiceRadioGroup.pas',
  CustomControl.MiceValuePicker.SelectTreeDlg in '..\CustomControls\Controls\CustomControl.MiceValuePicker.SelectTreeDlg.pas' {SelectTreeDlg},
  Dialog.Layout.ControlList in '..\Dialog\Dialog.Layout.ControlList.pas',
  Dialog.Adaptive.ControlFlags in '..\Dialog\Dialog.Adaptive.ControlFlags.pas',
  Mice.Script in '..\Common\Mice.Script.pas',
  Mice.Script.ClassTree in '..\Common\Mice.Script.ClassTree.pas',
  Mice.Script.Reg in '..\Common\Mice.Script.Reg.pas',
  StartUp.LoginDlg in '..\Startup\StartUp.LoginDlg.pas' {StartupLoginDialog},
  Plugin.InfoDialog in '..\Plugin\Plugin.InfoDialog.pas' {PluginInfoDialog},
  Plugin.SideTreeFilter in '..\Plugin\Plugin.SideTreeFilter.pas' {SideTreeFilter: TFrame},
  Plugin.MultiPagePlugin in '..\Plugin\Plugin.MultiPagePlugin.pas' {MultiPagePlugin: TFrame},
  Plugin.Page in '..\Plugin\Plugin.Page.pas' {PagePlugin: TFrame},
  Mice.Report in '..\Common\Mice.Report.pas',
  AppTemplate.Builder.Abstract in '..\Common\AppTemplate.Builder.Abstract.pas',
  AppTemplate.Builder.Xml in '..\Common\AppTemplate.Builder.Xml.pas',
  AppTemplate.Builder.Json in '..\Common\AppTemplate.Builder.Json.pas',
  AppTemplate.Builder.Xbrl in '..\Common\AppTemplate.Builder.Xbrl.pas',
  AppTemplate.Builder in '..\Common\AppTemplate.Builder.pas',
  AppTemplate.Builder.Thread in '..\Common\AppTemplate.Builder.Thread.pas',
  CustomControl.HidingModalForm in '..\CustomControls\Controls\CustomControl.HidingModalForm.pas' {HidingModalForm},
  Dialog.Adaptive.FieldMonitor in '..\Dialog\Dialog.Adaptive.FieldMonitor.pas',
  DAC.ProviderNamePattern.Parser in '..\DAC\DAC.ProviderNamePattern.Parser.pas',
  DAC.DataSnap in '..\DAC\DAC.DataSnap.pas',
  DAC.DataSetList in '..\DAC\DAC.DataSetList.pas',
  DocFlow.Manager.Helper in '..\DocFlow\DocFlow.Manager.Helper.pas',
  DocFlow.Manager in '..\DocFlow\DocFlow.Manager.pas',
  DocFlow.Schema.Form in '..\DocFlow\DocFlow.Schema.Form.pas' {DocFlowSchemaForm},
  StaticDialog.ItemTreeSelector.Common in '..\StaticDialog\StaticDialog.ItemTreeSelector.Common.pas' {CommonSelectTreeDialog},
  DocFlow.NewDocument.SelectionDialog in '..\DocFlow\DocFlow.NewDocument.SelectionDialog.pas' {DocFlowNewDocDialog},
  DocFlow.Manager.MessageWindow in '..\DocFlow\DocFlow.Manager.MessageWindow.pas' {DocFlowMessageWindow},
  Plugin.Action.OpenFile in '..\Plugin\Plugin.Action.OpenFile.pas',
  MiceTile.ContentFrame in 'MiceTile.ContentFrame.pas' {TileContentFrame: TFrame},
  Plugin.TileCommandBuilder in '..\Plugin\Plugin.TileCommandBuilder.pas',
  CustomControl.MiceGrid.MenuBuilder in '..\CustomControls\Grids\CustomControl.MiceGrid.MenuBuilder.pas';

{$R *.res}

begin
  ReportMemoryLeaksOnShutDown:=True;
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  if not TStartupLoginDialog.Execute then
   Exit;

  Application.CreateForm(TMiceMainTileForm, MiceMainTileForm);
  Application.Run;

end.