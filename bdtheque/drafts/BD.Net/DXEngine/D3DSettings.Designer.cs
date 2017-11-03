namespace DXEngine
{
    partial class D3DSettingsForm
    {
        private System.Windows.Forms.GroupBox adapterDeviceGroupBox;
        private System.Windows.Forms.Label displayAdapterLabel;
        private System.Windows.Forms.ComboBox adapterComboBox;
        private System.Windows.Forms.Label deviceLabel;
        private System.Windows.Forms.ComboBox deviceComboBox;
        private System.Windows.Forms.GroupBox modeSettingsGroupBox;
        private System.Windows.Forms.RadioButton windowedRadioButton;
        private System.Windows.Forms.RadioButton fullscreenRadioButton;
        private System.Windows.Forms.Label adapterFormatLabel;
        private System.Windows.Forms.ComboBox adapterFormatComboBox;
        private System.Windows.Forms.Label resolutionLabel;
        private System.Windows.Forms.ComboBox resolutionComboBox;
        private System.Windows.Forms.Label refreshRateLabel;
        private System.Windows.Forms.ComboBox refreshRateComboBox;
        private System.Windows.Forms.GroupBox otherSettingsGroupBox;
        private System.Windows.Forms.Label backBufferFormatLabel;
        private System.Windows.Forms.ComboBox backBufferFormatComboBox;
        private System.Windows.Forms.Label depthStencilBufferLabel;
        private System.Windows.Forms.ComboBox depthStencilBufferComboBox;
        private System.Windows.Forms.Label multisampleLabel;
        private System.Windows.Forms.ComboBox multisampleComboBox;
        private System.Windows.Forms.Label vertexProcLabel;
        private System.Windows.Forms.ComboBox vertexProcComboBox;
        private System.Windows.Forms.Label presentIntervalLabel;
        private System.Windows.Forms.ComboBox presentIntervalComboBox;
        private System.Windows.Forms.Button okButton;
        private System.Windows.Forms.Button cancelButton;
        private System.Windows.Forms.ComboBox multisampleQualityComboBox;
        private System.Windows.Forms.Label multisampleQualityLabel;

        /// <summary>
        /// Variable nécessaire au concepteur.
        /// </summary>
        private System.ComponentModel.IContainer components = null;

        /// <summary>
        /// Nettoyage des ressources utilisées.
        /// </summary>
        /// <param name="disposing">true si les ressources managées doivent être supprimées ; sinon, false.</param>
        protected override void Dispose(bool disposing)
        {
            if (disposing && (components != null))
            {
                components.Dispose();
            }
            base.Dispose(disposing);
        }

        #region Code généré par le Concepteur Windows Form

        /// <summary>
        /// Méthode requise pour la prise en charge du concepteur - ne modifiez pas
        /// le contenu de cette méthode avec l'éditeur de code.
        /// </summary>
        private void InitializeComponent()
        {
            this.adapterDeviceGroupBox = new System.Windows.Forms.GroupBox();
            this.deviceComboBox = new System.Windows.Forms.ComboBox();
            this.deviceLabel = new System.Windows.Forms.Label();
            this.adapterComboBox = new System.Windows.Forms.ComboBox();
            this.displayAdapterLabel = new System.Windows.Forms.Label();
            this.fullscreenRadioButton = new System.Windows.Forms.RadioButton();
            this.cancelButton = new System.Windows.Forms.Button();
            this.otherSettingsGroupBox = new System.Windows.Forms.GroupBox();
            this.multisampleQualityComboBox = new System.Windows.Forms.ComboBox();
            this.multisampleQualityLabel = new System.Windows.Forms.Label();
            this.multisampleComboBox = new System.Windows.Forms.ComboBox();
            this.backBufferFormatComboBox = new System.Windows.Forms.ComboBox();
            this.multisampleLabel = new System.Windows.Forms.Label();
            this.depthStencilBufferLabel = new System.Windows.Forms.Label();
            this.backBufferFormatLabel = new System.Windows.Forms.Label();
            this.depthStencilBufferComboBox = new System.Windows.Forms.ComboBox();
            this.vertexProcComboBox = new System.Windows.Forms.ComboBox();
            this.vertexProcLabel = new System.Windows.Forms.Label();
            this.presentIntervalComboBox = new System.Windows.Forms.ComboBox();
            this.presentIntervalLabel = new System.Windows.Forms.Label();
            this.resolutionComboBox = new System.Windows.Forms.ComboBox();
            this.windowedRadioButton = new System.Windows.Forms.RadioButton();
            this.resolutionLabel = new System.Windows.Forms.Label();
            this.refreshRateComboBox = new System.Windows.Forms.ComboBox();
            this.adapterFormatLabel = new System.Windows.Forms.Label();
            this.refreshRateLabel = new System.Windows.Forms.Label();
            this.okButton = new System.Windows.Forms.Button();
            this.modeSettingsGroupBox = new System.Windows.Forms.GroupBox();
            this.adapterFormatComboBox = new System.Windows.Forms.ComboBox();
            this.adapterDeviceGroupBox.SuspendLayout();
            this.otherSettingsGroupBox.SuspendLayout();
            this.modeSettingsGroupBox.SuspendLayout();
            this.SuspendLayout();
            // 
            // adapterDeviceGroupBox
            // 
            this.adapterDeviceGroupBox.Controls.Add(this.deviceComboBox);
            this.adapterDeviceGroupBox.Controls.Add(this.deviceLabel);
            this.adapterDeviceGroupBox.Controls.Add(this.adapterComboBox);
            this.adapterDeviceGroupBox.Controls.Add(this.displayAdapterLabel);
            this.adapterDeviceGroupBox.Location = new System.Drawing.Point(16, 8);
            this.adapterDeviceGroupBox.Name = "adapterDeviceGroupBox";
            this.adapterDeviceGroupBox.Size = new System.Drawing.Size(400, 80);
            this.adapterDeviceGroupBox.TabIndex = 0;
            this.adapterDeviceGroupBox.TabStop = false;
            this.adapterDeviceGroupBox.Text = "Adapter and device";
            // 
            // deviceComboBox
            // 
            this.deviceComboBox.DropDownStyle = System.Windows.Forms.ComboBoxStyle.DropDownList;
            this.deviceComboBox.DropDownWidth = 121;
            this.deviceComboBox.Location = new System.Drawing.Point(160, 48);
            this.deviceComboBox.Name = "deviceComboBox";
            this.deviceComboBox.Size = new System.Drawing.Size(232, 21);
            this.deviceComboBox.TabIndex = 3;
            this.deviceComboBox.SelectedIndexChanged += new System.EventHandler(this.DeviceChanged);
            // 
            // deviceLabel
            // 
            this.deviceLabel.Location = new System.Drawing.Point(8, 48);
            this.deviceLabel.Name = "deviceLabel";
            this.deviceLabel.Size = new System.Drawing.Size(152, 23);
            this.deviceLabel.TabIndex = 2;
            this.deviceLabel.Text = "Render &Device:";
            // 
            // adapterComboBox
            // 
            this.adapterComboBox.DropDownStyle = System.Windows.Forms.ComboBoxStyle.DropDownList;
            this.adapterComboBox.DropDownWidth = 121;
            this.adapterComboBox.Location = new System.Drawing.Point(160, 24);
            this.adapterComboBox.Name = "adapterComboBox";
            this.adapterComboBox.Size = new System.Drawing.Size(232, 21);
            this.adapterComboBox.TabIndex = 1;
            this.adapterComboBox.SelectedIndexChanged += new System.EventHandler(this.AdapterChanged);
            // 
            // displayAdapterLabel
            // 
            this.displayAdapterLabel.Location = new System.Drawing.Point(8, 24);
            this.displayAdapterLabel.Name = "displayAdapterLabel";
            this.displayAdapterLabel.Size = new System.Drawing.Size(152, 23);
            this.displayAdapterLabel.TabIndex = 0;
            this.displayAdapterLabel.Text = "Display &Adapter:";
            // 
            // fullscreenRadioButton
            // 
            this.fullscreenRadioButton.Location = new System.Drawing.Point(9, 38);
            this.fullscreenRadioButton.Name = "fullscreenRadioButton";
            this.fullscreenRadioButton.Size = new System.Drawing.Size(152, 24);
            this.fullscreenRadioButton.TabIndex = 1;
            this.fullscreenRadioButton.Text = "&Fullscreen";
            // 
            // cancelButton
            // 
            this.cancelButton.DialogResult = System.Windows.Forms.DialogResult.Cancel;
            this.cancelButton.Location = new System.Drawing.Point(248, 464);
            this.cancelButton.Name = "cancelButton";
            this.cancelButton.Size = new System.Drawing.Size(75, 23);
            this.cancelButton.TabIndex = 4;
            this.cancelButton.Text = "Cancel";
            // 
            // otherSettingsGroupBox
            // 
            this.otherSettingsGroupBox.Controls.Add(this.multisampleQualityComboBox);
            this.otherSettingsGroupBox.Controls.Add(this.multisampleQualityLabel);
            this.otherSettingsGroupBox.Controls.Add(this.multisampleComboBox);
            this.otherSettingsGroupBox.Controls.Add(this.backBufferFormatComboBox);
            this.otherSettingsGroupBox.Controls.Add(this.multisampleLabel);
            this.otherSettingsGroupBox.Controls.Add(this.depthStencilBufferLabel);
            this.otherSettingsGroupBox.Controls.Add(this.backBufferFormatLabel);
            this.otherSettingsGroupBox.Controls.Add(this.depthStencilBufferComboBox);
            this.otherSettingsGroupBox.Controls.Add(this.vertexProcComboBox);
            this.otherSettingsGroupBox.Controls.Add(this.vertexProcLabel);
            this.otherSettingsGroupBox.Controls.Add(this.presentIntervalComboBox);
            this.otherSettingsGroupBox.Controls.Add(this.presentIntervalLabel);
            this.otherSettingsGroupBox.Location = new System.Drawing.Point(16, 264);
            this.otherSettingsGroupBox.Name = "otherSettingsGroupBox";
            this.otherSettingsGroupBox.Size = new System.Drawing.Size(400, 176);
            this.otherSettingsGroupBox.TabIndex = 2;
            this.otherSettingsGroupBox.TabStop = false;
            this.otherSettingsGroupBox.Text = "Device settings";
            // 
            // multisampleQualityComboBox
            // 
            this.multisampleQualityComboBox.DropDownStyle = System.Windows.Forms.ComboBoxStyle.DropDownList;
            this.multisampleQualityComboBox.DropDownWidth = 144;
            this.multisampleQualityComboBox.Location = new System.Drawing.Point(160, 96);
            this.multisampleQualityComboBox.Name = "multisampleQualityComboBox";
            this.multisampleQualityComboBox.Size = new System.Drawing.Size(232, 21);
            this.multisampleQualityComboBox.TabIndex = 7;
            this.multisampleQualityComboBox.SelectedIndexChanged += new System.EventHandler(this.MultisampleQualityChanged);
            // 
            // multisampleQualityLabel
            // 
            this.multisampleQualityLabel.Location = new System.Drawing.Point(8, 96);
            this.multisampleQualityLabel.Name = "multisampleQualityLabel";
            this.multisampleQualityLabel.Size = new System.Drawing.Size(152, 23);
            this.multisampleQualityLabel.TabIndex = 6;
            this.multisampleQualityLabel.Text = "Multisample &Quality:";
            // 
            // multisampleComboBox
            // 
            this.multisampleComboBox.DropDownStyle = System.Windows.Forms.ComboBoxStyle.DropDownList;
            this.multisampleComboBox.DropDownWidth = 144;
            this.multisampleComboBox.Location = new System.Drawing.Point(160, 72);
            this.multisampleComboBox.Name = "multisampleComboBox";
            this.multisampleComboBox.Size = new System.Drawing.Size(232, 21);
            this.multisampleComboBox.TabIndex = 5;
            this.multisampleComboBox.SelectedIndexChanged += new System.EventHandler(this.MultisampleTypeChanged);
            // 
            // backBufferFormatComboBox
            // 
            this.backBufferFormatComboBox.DropDownStyle = System.Windows.Forms.ComboBoxStyle.DropDownList;
            this.backBufferFormatComboBox.DropDownWidth = 144;
            this.backBufferFormatComboBox.Location = new System.Drawing.Point(160, 24);
            this.backBufferFormatComboBox.Name = "backBufferFormatComboBox";
            this.backBufferFormatComboBox.Size = new System.Drawing.Size(232, 21);
            this.backBufferFormatComboBox.TabIndex = 1;
            this.backBufferFormatComboBox.SelectedIndexChanged += new System.EventHandler(this.BackBufferFormatChanged);
            // 
            // multisampleLabel
            // 
            this.multisampleLabel.Location = new System.Drawing.Point(8, 72);
            this.multisampleLabel.Name = "multisampleLabel";
            this.multisampleLabel.Size = new System.Drawing.Size(152, 23);
            this.multisampleLabel.TabIndex = 4;
            this.multisampleLabel.Text = "&Multisample Type:";
            // 
            // depthStencilBufferLabel
            // 
            this.depthStencilBufferLabel.Location = new System.Drawing.Point(8, 48);
            this.depthStencilBufferLabel.Name = "depthStencilBufferLabel";
            this.depthStencilBufferLabel.Size = new System.Drawing.Size(152, 23);
            this.depthStencilBufferLabel.TabIndex = 2;
            this.depthStencilBufferLabel.Text = "De&pth/Stencil Buffer Format:";
            // 
            // backBufferFormatLabel
            // 
            this.backBufferFormatLabel.Location = new System.Drawing.Point(8, 24);
            this.backBufferFormatLabel.Name = "backBufferFormatLabel";
            this.backBufferFormatLabel.Size = new System.Drawing.Size(152, 23);
            this.backBufferFormatLabel.TabIndex = 0;
            this.backBufferFormatLabel.Text = "&Back Buffer Format:";
            // 
            // depthStencilBufferComboBox
            // 
            this.depthStencilBufferComboBox.DropDownStyle = System.Windows.Forms.ComboBoxStyle.DropDownList;
            this.depthStencilBufferComboBox.DropDownWidth = 144;
            this.depthStencilBufferComboBox.Location = new System.Drawing.Point(160, 48);
            this.depthStencilBufferComboBox.Name = "depthStencilBufferComboBox";
            this.depthStencilBufferComboBox.Size = new System.Drawing.Size(232, 21);
            this.depthStencilBufferComboBox.TabIndex = 3;
            this.depthStencilBufferComboBox.SelectedIndexChanged += new System.EventHandler(this.DepthStencilBufferFormatChanged);
            // 
            // vertexProcComboBox
            // 
            this.vertexProcComboBox.DropDownStyle = System.Windows.Forms.ComboBoxStyle.DropDownList;
            this.vertexProcComboBox.DropDownWidth = 121;
            this.vertexProcComboBox.Location = new System.Drawing.Point(160, 120);
            this.vertexProcComboBox.Name = "vertexProcComboBox";
            this.vertexProcComboBox.Size = new System.Drawing.Size(232, 21);
            this.vertexProcComboBox.TabIndex = 9;
            this.vertexProcComboBox.SelectedIndexChanged += new System.EventHandler(this.VertexProcessingChanged);
            // 
            // vertexProcLabel
            // 
            this.vertexProcLabel.Location = new System.Drawing.Point(8, 120);
            this.vertexProcLabel.Name = "vertexProcLabel";
            this.vertexProcLabel.Size = new System.Drawing.Size(152, 23);
            this.vertexProcLabel.TabIndex = 8;
            this.vertexProcLabel.Text = "&Vertex Processing:";
            // 
            // presentIntervalComboBox
            // 
            this.presentIntervalComboBox.DropDownStyle = System.Windows.Forms.ComboBoxStyle.DropDownList;
            this.presentIntervalComboBox.DropDownWidth = 121;
            this.presentIntervalComboBox.Location = new System.Drawing.Point(160, 144);
            this.presentIntervalComboBox.Name = "presentIntervalComboBox";
            this.presentIntervalComboBox.Size = new System.Drawing.Size(232, 21);
            this.presentIntervalComboBox.TabIndex = 11;
            this.presentIntervalComboBox.SelectedValueChanged += new System.EventHandler(this.PresentIntervalChanged);
            // 
            // presentIntervalLabel
            // 
            this.presentIntervalLabel.Location = new System.Drawing.Point(8, 144);
            this.presentIntervalLabel.Name = "presentIntervalLabel";
            this.presentIntervalLabel.Size = new System.Drawing.Size(152, 23);
            this.presentIntervalLabel.TabIndex = 10;
            this.presentIntervalLabel.Text = "Present &Interval:";
            // 
            // resolutionComboBox
            // 
            this.resolutionComboBox.DropDownStyle = System.Windows.Forms.ComboBoxStyle.DropDownList;
            this.resolutionComboBox.DropDownWidth = 144;
            this.resolutionComboBox.Location = new System.Drawing.Point(161, 94);
            this.resolutionComboBox.MaxDropDownItems = 14;
            this.resolutionComboBox.Name = "resolutionComboBox";
            this.resolutionComboBox.Size = new System.Drawing.Size(232, 21);
            this.resolutionComboBox.TabIndex = 5;
            this.resolutionComboBox.SelectedIndexChanged += new System.EventHandler(this.ResolutionChanged);
            // 
            // windowedRadioButton
            // 
            this.windowedRadioButton.Location = new System.Drawing.Point(9, 14);
            this.windowedRadioButton.Name = "windowedRadioButton";
            this.windowedRadioButton.Size = new System.Drawing.Size(152, 24);
            this.windowedRadioButton.TabIndex = 0;
            this.windowedRadioButton.Text = "&Windowed";
            this.windowedRadioButton.CheckedChanged += new System.EventHandler(this.WindowedFullscreenChanged);
            // 
            // resolutionLabel
            // 
            this.resolutionLabel.Location = new System.Drawing.Point(8, 94);
            this.resolutionLabel.Name = "resolutionLabel";
            this.resolutionLabel.Size = new System.Drawing.Size(152, 23);
            this.resolutionLabel.TabIndex = 4;
            this.resolutionLabel.Text = "&Resolution:";
            // 
            // refreshRateComboBox
            // 
            this.refreshRateComboBox.DropDownStyle = System.Windows.Forms.ComboBoxStyle.DropDownList;
            this.refreshRateComboBox.DropDownWidth = 144;
            this.refreshRateComboBox.Location = new System.Drawing.Point(161, 118);
            this.refreshRateComboBox.MaxDropDownItems = 14;
            this.refreshRateComboBox.Name = "refreshRateComboBox";
            this.refreshRateComboBox.Size = new System.Drawing.Size(232, 21);
            this.refreshRateComboBox.TabIndex = 7;
            this.refreshRateComboBox.SelectedIndexChanged += new System.EventHandler(this.RefreshRateChanged);
            // 
            // adapterFormatLabel
            // 
            this.adapterFormatLabel.Location = new System.Drawing.Point(8, 72);
            this.adapterFormatLabel.Name = "adapterFormatLabel";
            this.adapterFormatLabel.Size = new System.Drawing.Size(152, 23);
            this.adapterFormatLabel.TabIndex = 2;
            this.adapterFormatLabel.Text = "Adapter F&ormat:";
            // 
            // refreshRateLabel
            // 
            this.refreshRateLabel.Location = new System.Drawing.Point(8, 118);
            this.refreshRateLabel.Name = "refreshRateLabel";
            this.refreshRateLabel.Size = new System.Drawing.Size(152, 23);
            this.refreshRateLabel.TabIndex = 6;
            this.refreshRateLabel.Text = "R&efresh Rate:";
            // 
            // okButton
            // 
            this.okButton.DialogResult = System.Windows.Forms.DialogResult.OK;
            this.okButton.Location = new System.Drawing.Point(112, 464);
            this.okButton.Name = "okButton";
            this.okButton.Size = new System.Drawing.Size(75, 23);
            this.okButton.TabIndex = 3;
            this.okButton.Text = "OK";
            // 
            // modeSettingsGroupBox
            // 
            this.modeSettingsGroupBox.Controls.Add(this.adapterFormatLabel);
            this.modeSettingsGroupBox.Controls.Add(this.refreshRateLabel);
            this.modeSettingsGroupBox.Controls.Add(this.resolutionComboBox);
            this.modeSettingsGroupBox.Controls.Add(this.adapterFormatComboBox);
            this.modeSettingsGroupBox.Controls.Add(this.resolutionLabel);
            this.modeSettingsGroupBox.Controls.Add(this.refreshRateComboBox);
            this.modeSettingsGroupBox.Controls.Add(this.windowedRadioButton);
            this.modeSettingsGroupBox.Controls.Add(this.fullscreenRadioButton);
            this.modeSettingsGroupBox.Location = new System.Drawing.Point(16, 96);
            this.modeSettingsGroupBox.Name = "modeSettingsGroupBox";
            this.modeSettingsGroupBox.Size = new System.Drawing.Size(400, 160);
            this.modeSettingsGroupBox.TabIndex = 1;
            this.modeSettingsGroupBox.TabStop = false;
            this.modeSettingsGroupBox.Text = "Display mode settings";
            // 
            // adapterFormatComboBox
            // 
            this.adapterFormatComboBox.DropDownStyle = System.Windows.Forms.ComboBoxStyle.DropDownList;
            this.adapterFormatComboBox.DropDownWidth = 121;
            this.adapterFormatComboBox.Location = new System.Drawing.Point(161, 70);
            this.adapterFormatComboBox.MaxDropDownItems = 14;
            this.adapterFormatComboBox.Name = "adapterFormatComboBox";
            this.adapterFormatComboBox.Size = new System.Drawing.Size(232, 21);
            this.adapterFormatComboBox.TabIndex = 3;
            this.adapterFormatComboBox.SelectedValueChanged += new System.EventHandler(this.AdapterFormatChanged);
            // 
            // D3DSettingsForm
            // 
            this.AcceptButton = this.okButton;
            this.AutoScaleBaseSize = new System.Drawing.Size(5, 13);
            this.CancelButton = this.cancelButton;
            this.ClientSize = new System.Drawing.Size(438, 512);
            this.Controls.Add(this.cancelButton);
            this.Controls.Add(this.okButton);
            this.Controls.Add(this.adapterDeviceGroupBox);
            this.Controls.Add(this.modeSettingsGroupBox);
            this.Controls.Add(this.otherSettingsGroupBox);
            this.FormBorderStyle = System.Windows.Forms.FormBorderStyle.FixedDialog;
            this.MaximizeBox = false;
            this.Name = "D3DSettingsForm";
            this.Text = "Options Direct3D";
            this.adapterDeviceGroupBox.ResumeLayout(false);
            this.otherSettingsGroupBox.ResumeLayout(false);
            this.modeSettingsGroupBox.ResumeLayout(false);
            this.ResumeLayout(false);

        }

        #endregion
    }
}