using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Data;
using System.Drawing;
using System.Text;
using System.Windows.Forms;
using Microsoft.DirectX.Direct3D;

namespace DXEngine
{
    public partial class D3DSettingsForm : Form
    {
        private D3DEnumeration enumeration;
        public D3DSettings settings; // Potential new D3D settings

        public D3DSettingsForm(D3DEnumeration enumerationParam, D3DSettings settingsParam)
        {
            enumeration = enumerationParam;
            settings = settingsParam.Clone();

            // Required for Windows Form Designer support
            InitializeComponent();

            // Fill adapter combo box.  Updating the selected adapter will trigger
            // updates of the rest of the dialog.
            foreach (GraphicsAdapterInfo adapterInfo in enumeration.AdapterInfoList)
            {
                adapterComboBox.Items.Add(adapterInfo);
                if (adapterInfo.AdapterOrdinal == settings.AdapterOrdinal)
                    adapterComboBox.SelectedItem = adapterInfo;
            }
            if (adapterComboBox.SelectedItem == null && adapterComboBox.Items.Count > 0)
                adapterComboBox.SelectedIndex = 0;
        }

        /// <summary>
        /// Respond to a change of selected adapter by rebuilding the device 
        /// list.  Updating the selected device will trigger updates of the 
        /// rest of the dialog.
        /// </summary>
        private void AdapterChanged(object sender, EventArgs e)
        {
            GraphicsAdapterInfo adapterInfo = (GraphicsAdapterInfo)adapterComboBox.SelectedItem;
            settings.AdapterInfo = adapterInfo;

            // Update device combo box
            deviceComboBox.Items.Clear();
            foreach (GraphicsDeviceInfo deviceInfo in adapterInfo.DeviceInfoList)
            {
                deviceComboBox.Items.Add(deviceInfo);
                if (deviceInfo.DevType == settings.DevType)
                    deviceComboBox.SelectedItem = deviceInfo;
            }
            if (deviceComboBox.SelectedItem == null && deviceComboBox.Items.Count > 0)
                deviceComboBox.SelectedIndex = 0;
        }

        /// <summary>
        /// Respond to a change of selected device by resetting the 
        /// fullscreen/windowed radio buttons.  Updating these buttons
        /// will trigger updates of the rest of the dialog.
        /// </summary>
        private void DeviceChanged(object sender, System.EventArgs e)
        {
            GraphicsAdapterInfo adapterInfo = (GraphicsAdapterInfo)adapterComboBox.SelectedItem;
            GraphicsDeviceInfo deviceInfo = (GraphicsDeviceInfo)deviceComboBox.SelectedItem;

            settings.DeviceInfo = deviceInfo;

            // Update fullscreen/windowed radio buttons
            bool HasWindowedDeviceCombo = false;
            bool HasFullscreenDeviceCombo = false;
            foreach (DeviceCombo deviceCombo in deviceInfo.DeviceComboList)
            {
                if (deviceCombo.IsWindowed)
                    HasWindowedDeviceCombo = true;
                else
                    HasFullscreenDeviceCombo = true;
            }
            windowedRadioButton.Enabled = HasWindowedDeviceCombo;
            fullscreenRadioButton.Enabled = HasFullscreenDeviceCombo;
            if (settings.IsWindowed && HasWindowedDeviceCombo)
            {
                windowedRadioButton.Checked = true;
            }
            else
            {
                fullscreenRadioButton.Checked = true;
            }
            WindowedFullscreenChanged(null, null);
        }

        /// <summary>
        /// Respond to a change of windowed/fullscreen state by rebuilding the
        /// adapter format list, resolution list, and refresh rate list.
        /// Updating the selected adapter format will trigger updates of the 
        /// rest of the dialog.
        /// </summary>
        private void WindowedFullscreenChanged(object sender, System.EventArgs e)
        {
            GraphicsAdapterInfo adapterInfo = (GraphicsAdapterInfo)adapterComboBox.SelectedItem;
            GraphicsDeviceInfo deviceInfo = (GraphicsDeviceInfo)deviceComboBox.SelectedItem;

            if (windowedRadioButton.Checked)
            {
                settings.IsWindowed = true;
                settings.WindowedAdapterInfo = adapterInfo;
                settings.WindowedDeviceInfo = deviceInfo;

                // Update adapter format combo box
                adapterFormatComboBox.Items.Clear();
                adapterFormatComboBox.Items.Add(settings.WindowedDisplayMode.Format);
                adapterFormatComboBox.SelectedIndex = 0;
                adapterFormatComboBox.Enabled = false;

                // Update resolution combo box
                resolutionComboBox.Items.Clear();
                resolutionComboBox.Items.Add(FormatResolution(settings.WindowedDisplayMode.Width,
                    settings.WindowedDisplayMode.Height));
                resolutionComboBox.SelectedIndex = 0;
                resolutionComboBox.Enabled = false;

                // Update refresh rate combo box
                refreshRateComboBox.Items.Clear();
                refreshRateComboBox.Items.Add(FormatRefreshRate(settings.WindowedDisplayMode.RefreshRate));
                refreshRateComboBox.SelectedIndex = 0;
                refreshRateComboBox.Enabled = false;
            }
            else
            {
                settings.IsWindowed = false;
                settings.FullscreenAdapterInfo = adapterInfo;
                settings.FullscreenDeviceInfo = deviceInfo;

                // Update adapter format combo box
                adapterFormatComboBox.Items.Clear();
                foreach (DeviceCombo deviceCombo in deviceInfo.DeviceComboList)
                {
                    if (!adapterFormatComboBox.Items.Contains(deviceCombo.AdapterFormat))
                    {
                        adapterFormatComboBox.Items.Add(deviceCombo.AdapterFormat);
                        if (deviceCombo.AdapterFormat == (settings.IsWindowed ?
                            settings.WindowedDisplayMode.Format : settings.FullscreenDisplayMode.Format))
                        {
                            adapterFormatComboBox.SelectedItem = deviceCombo.AdapterFormat;
                        }
                    }
                }
                if (adapterFormatComboBox.SelectedItem == null && adapterFormatComboBox.Items.Count > 0)
                    adapterFormatComboBox.SelectedIndex = 0;
                adapterFormatComboBox.Enabled = true;

                // Update resolution combo box
                resolutionComboBox.Enabled = true;

                // Update refresh rate combo box
                refreshRateComboBox.Enabled = true;
            }
        }

        /// <summary>
        /// Converts the given width and height into a formatted string
        /// </summary>
        private string FormatResolution(int width, int height)
        {
            System.Text.StringBuilder sb = new System.Text.StringBuilder(20);
            sb.AppendFormat("{0} by {1}", width, height);
            return sb.ToString();
        }

        /// <summary>
        /// Converts the given refresh rate into a formatted string
        /// </summary>
        private string FormatRefreshRate(int refreshRate)
        {
            if (refreshRate == 0)
            {
                return "Default Rate";
            }
            else
            {
                System.Text.StringBuilder sb = new System.Text.StringBuilder(20);
                sb.AppendFormat("{0} Hz", refreshRate);
                return sb.ToString();
            }
        }

        /// <summary>
        /// Respond to a change of selected adapter format by rebuilding the
        /// resolution list and back buffer format list.  Updating the selected 
        /// resolution and back buffer format will trigger updates of the rest 
        /// of the dialog.
        /// </summary>
        private void AdapterFormatChanged(object sender, System.EventArgs e)
        {
            if (!windowedRadioButton.Checked)
            {
                GraphicsAdapterInfo adapterInfo = (GraphicsAdapterInfo)adapterComboBox.SelectedItem;
                Format adapterFormat = (Format)adapterFormatComboBox.SelectedItem;
                settings.FullscreenDisplayMode.Format = adapterFormat;
                System.Text.StringBuilder sb = new System.Text.StringBuilder(20);

                resolutionComboBox.Items.Clear();
                foreach (DisplayMode displayMode in adapterInfo.DisplayModeList)
                {
                    if (displayMode.Format == adapterFormat)
                    {
                        string resolutionString = FormatResolution(displayMode.Width, displayMode.Height);
                        if (!resolutionComboBox.Items.Contains(resolutionString))
                        {
                            resolutionComboBox.Items.Add(resolutionString);
                            if (settings.FullscreenDisplayMode.Width == displayMode.Width &&
                                settings.FullscreenDisplayMode.Height == displayMode.Height)
                            {
                                resolutionComboBox.SelectedItem = resolutionString;
                            }
                        }
                    }
                }
                if (resolutionComboBox.SelectedItem == null && resolutionComboBox.Items.Count > 0)
                    resolutionComboBox.SelectedIndex = 0;
            }

            // Update backbuffer format combo box
            GraphicsDeviceInfo deviceInfo = (GraphicsDeviceInfo)deviceComboBox.SelectedItem;
            backBufferFormatComboBox.Items.Clear();
            foreach (DeviceCombo deviceCombo in deviceInfo.DeviceComboList)
            {
                if (deviceCombo.IsWindowed == settings.IsWindowed &&
                    deviceCombo.AdapterFormat == settings.DisplayMode.Format)
                {
                    if (!backBufferFormatComboBox.Items.Contains(deviceCombo.BackBufferFormat))
                    {
                        backBufferFormatComboBox.Items.Add(deviceCombo.BackBufferFormat);
                        if (deviceCombo.BackBufferFormat == settings.BackBufferFormat)
                            backBufferFormatComboBox.SelectedItem = deviceCombo.BackBufferFormat;
                    }
                }
            }
            if (backBufferFormatComboBox.SelectedItem == null && backBufferFormatComboBox.Items.Count > 0)
                backBufferFormatComboBox.SelectedIndex = 0;
        }

        /// <summary>
        /// Respond to a change of selected resolution by rebuilding the
        /// refresh rate list.
        /// </summary>
        private void ResolutionChanged(object sender, System.EventArgs e)
        {
            if (settings.IsWindowed)
                return;

            GraphicsAdapterInfo adapterInfo = (GraphicsAdapterInfo)adapterComboBox.SelectedItem;

            // Update settings with new resolution
            string resolution = (string)resolutionComboBox.SelectedItem;
            string[] resolutionSplitStringArray = resolution.Split();
            int width = int.Parse(resolutionSplitStringArray[0]);
            int height = int.Parse(resolutionSplitStringArray[2]);
            settings.FullscreenDisplayMode.Width = width;
            settings.FullscreenDisplayMode.Height = height;

            // Update refresh rate list based on new resolution
            Format adapterFormat = (Format)adapterFormatComboBox.SelectedItem;
            refreshRateComboBox.Items.Clear();
            foreach (DisplayMode displayMode in adapterInfo.DisplayModeList)
            {
                if (displayMode.Format == adapterFormat &&
                    displayMode.Width == width &&
                    displayMode.Height == height)
                {
                    string refreshRateString = FormatRefreshRate(displayMode.RefreshRate);
                    if (!refreshRateComboBox.Items.Contains(refreshRateString))
                    {
                        refreshRateComboBox.Items.Add(refreshRateString);
                        if (settings.FullscreenDisplayMode.RefreshRate == displayMode.RefreshRate)
                            refreshRateComboBox.SelectedItem = refreshRateString;
                    }
                }
            }
            if (refreshRateComboBox.SelectedItem == null && refreshRateComboBox.Items.Count > 0)
                refreshRateComboBox.SelectedIndex = refreshRateComboBox.Items.Count - 1;
        }

        /// <summary>
        /// Respond to a change of selected refresh rate.
        /// </summary>
        private void RefreshRateChanged(object sender, System.EventArgs e)
        {
            if (settings.IsWindowed)
                return;

            // Update settings with new refresh rate
            string refreshRateString = (string)refreshRateComboBox.SelectedItem;
            int refreshRate = 0;
            if (refreshRateString != "Default Rate")
            {
                string[] refreshRateSplitStringArray = refreshRateString.Split();
                refreshRate = int.Parse(refreshRateSplitStringArray[0]);
            }
            settings.FullscreenDisplayMode.RefreshRate = refreshRate;
        }

        /// <summary>
        /// Respond to a change of selected back buffer format by rebuilding
        /// the depth/stencil format list, multisample type list, and vertex
        /// processing type list.
        /// </summary>
        private void BackBufferFormatChanged(object sender, System.EventArgs e)
        {
            GraphicsDeviceInfo deviceInfo = (GraphicsDeviceInfo)deviceComboBox.SelectedItem;
            Format adapterFormat = (Format)adapterFormatComboBox.SelectedItem;
            Format backBufferFormat = (Format)backBufferFormatComboBox.SelectedItem;

            foreach (DeviceCombo deviceCombo in deviceInfo.DeviceComboList)
            {
                if (deviceCombo.IsWindowed == settings.IsWindowed &&
                    deviceCombo.AdapterFormat == settings.DisplayMode.Format &&
                    deviceCombo.BackBufferFormat == settings.BackBufferFormat)
                {
                    deviceCombo.BackBufferFormat = backBufferFormat;
                    settings.DeviceCombo = deviceCombo;

                    depthStencilBufferComboBox.Items.Clear();
                    if (enumeration.AppUsesDepthBuffer)
                    {
                        foreach (DepthFormat format in deviceCombo.DepthStencilFormatList)
                        {
                            depthStencilBufferComboBox.Items.Add(format);
                            if (format == settings.DepthStencilBufferFormat)
                                depthStencilBufferComboBox.SelectedItem = format;
                        }
                        if (depthStencilBufferComboBox.SelectedItem == null && depthStencilBufferComboBox.Items.Count > 0)
                            depthStencilBufferComboBox.SelectedIndex = 0;
                    }
                    else
                    {
                        depthStencilBufferComboBox.Enabled = false;
                        depthStencilBufferComboBox.Items.Add("(not used)");
                        depthStencilBufferComboBox.SelectedIndex = 0;
                    }

                    vertexProcComboBox.Items.Clear();
                    foreach (VertexProcessingType vpt in deviceCombo.VertexProcessingTypeList)
                    {
                        vertexProcComboBox.Items.Add(vpt);
                        if (vpt == settings.VertexProcessingType)
                            vertexProcComboBox.SelectedItem = vpt;
                    }
                    if (vertexProcComboBox.SelectedItem == null && vertexProcComboBox.Items.Count > 0)
                        vertexProcComboBox.SelectedIndex = 0;

                    presentIntervalComboBox.Items.Clear();
                    foreach (PresentInterval pi in deviceCombo.PresentIntervalList)
                    {
                        presentIntervalComboBox.Items.Add(pi);
                        if (pi == settings.PresentInterval)
                            presentIntervalComboBox.SelectedItem = pi;
                    }
                    if (presentIntervalComboBox.SelectedItem == null && presentIntervalComboBox.Items.Count > 0)
                        presentIntervalComboBox.SelectedIndex = 0;

                    break;
                }
            }
        }

        /// <summary>
        /// Respond to a change of selected depth/stencil buffer format.
        /// </summary>
        private void DepthStencilBufferFormatChanged(object sender, System.EventArgs e)
        {
            if (enumeration.AppUsesDepthBuffer)
                settings.DepthStencilBufferFormat = (DepthFormat)depthStencilBufferComboBox.SelectedItem;

            multisampleComboBox.Items.Clear();
            foreach (MultiSampleType msType in settings.DeviceCombo.MultiSampleTypeList)
            {
                // Check for DS/MS conflict
                bool conflictFound = false;
                foreach (DepthStencilMultiSampleConflict DSMSConflict in settings.DeviceCombo.DepthStencilMultiSampleConflictList)
                {
                    if (DSMSConflict.DepthStencilFormat == settings.DepthStencilBufferFormat &&
                        DSMSConflict.MultiSampleType == msType)
                    {
                        conflictFound = true;
                        break;
                    }
                }
                if (!conflictFound)
                {
                    multisampleComboBox.Items.Add(msType);
                    if (msType == settings.MultisampleType)
                        multisampleComboBox.SelectedItem = msType;
                }
            }
            if (multisampleComboBox.SelectedItem == null && multisampleComboBox.Items.Count > 0)
                multisampleComboBox.SelectedIndex = 0;

        }

        /// <summary>
        /// Respond to a change of selected multisample type.
        /// </summary>
        private void MultisampleTypeChanged(object sender, System.EventArgs e)
        {
            settings.MultisampleType = (MultiSampleType)multisampleComboBox.SelectedItem;

            // Find current max multisample quality
            int maxQuality = 0;
            DeviceCombo deviceCombo = settings.DeviceCombo;
            for (int i = 0; i < deviceCombo.MultiSampleQualityList.Count; i++)
            {
                if ((MultiSampleType)deviceCombo.MultiSampleTypeList[i] == settings.MultisampleType)
                {
                    maxQuality = (int)deviceCombo.MultiSampleQualityList[i];
                    break;
                }
            }

            // Update multisample quality list based on new type
            multisampleQualityComboBox.Items.Clear();
            for (int iLevel = 0; iLevel < maxQuality; iLevel++)
            {
                multisampleQualityComboBox.Items.Add(iLevel);
                if (settings.MultisampleQuality == iLevel)
                    multisampleQualityComboBox.SelectedItem = iLevel;
            }
            if (multisampleQualityComboBox.SelectedItem == null && multisampleQualityComboBox.Items.Count > 0)
                multisampleQualityComboBox.SelectedIndex = 0;
        }

        /// <summary>
        /// Respond to a change of selected multisample quality.
        /// </summary>
        private void MultisampleQualityChanged(object sender, System.EventArgs e)
        {
            settings.MultisampleQuality = (int)multisampleQualityComboBox.SelectedItem;
        }

        /// <summary>
        /// Respond to a change of selected vertex processing type.
        /// </summary>
        private void VertexProcessingChanged(object sender, System.EventArgs e)
        {
            settings.VertexProcessingType = (VertexProcessingType)vertexProcComboBox.SelectedItem;
        }

        /// <summary>
        /// Respond to a change of selected vertex processing type.
        /// </summary>
        private void PresentIntervalChanged(object sender, System.EventArgs e)
        {
            settings.PresentInterval = (PresentInterval)presentIntervalComboBox.SelectedItem;
        }
    }

    public class D3DSettings
    {
        public bool IsWindowed;

        public GraphicsAdapterInfo WindowedAdapterInfo;
        public GraphicsDeviceInfo WindowedDeviceInfo;
        public DeviceCombo WindowedDeviceCombo;
        public DisplayMode WindowedDisplayMode; // not changable by the user
        public DepthFormat WindowedDepthStencilBufferFormat;
        public MultiSampleType WindowedMultisampleType;
        public int WindowedMultisampleQuality;
        public VertexProcessingType WindowedVertexProcessingType;
        public PresentInterval WindowedPresentInterval;
        public int WindowedWidth;
        public int WindowedHeight;

        public GraphicsAdapterInfo FullscreenAdapterInfo;
        public GraphicsDeviceInfo FullscreenDeviceInfo;
        public DeviceCombo FullscreenDeviceCombo;
        public DisplayMode FullscreenDisplayMode; // changable by the user
        public DepthFormat FullscreenDepthStencilBufferFormat;
        public MultiSampleType FullscreenMultisampleType;
        public int FullscreenMultisampleQuality;
        public VertexProcessingType FullscreenVertexProcessingType;
        public PresentInterval FullscreenPresentInterval;

        /// <summary>
        /// The adapter information
        /// </summary>
        public GraphicsAdapterInfo AdapterInfo
        {
            get { return IsWindowed ? WindowedAdapterInfo : FullscreenAdapterInfo; }
            set { if (IsWindowed) WindowedAdapterInfo = value; else FullscreenAdapterInfo = value; }
        }


        /// <summary>
        /// The device information
        /// </summary>
        public GraphicsDeviceInfo DeviceInfo
        {
            get { return IsWindowed ? WindowedDeviceInfo : FullscreenDeviceInfo; }
            set { if (IsWindowed) WindowedDeviceInfo = value; else FullscreenDeviceInfo = value; }
        }


        /// <summary>
        /// The device combo
        /// </summary>
        public DeviceCombo DeviceCombo
        {
            get { return IsWindowed ? WindowedDeviceCombo : FullscreenDeviceCombo; }
            set { if (IsWindowed) WindowedDeviceCombo = value; else FullscreenDeviceCombo = value; }
        }


        /// <summary>
        /// The adapters ordinal
        /// </summary>
        public int AdapterOrdinal
        {
            get { return DeviceCombo.AdapterOrdinal; }
        }


        /// <summary>
        /// The type of device this is
        /// </summary>
        public DeviceType DevType
        {
            get { return DeviceCombo.DevType; }
        }


        /// <summary>
        /// The back buffers format
        /// </summary>
        public Format BackBufferFormat
        {
            get { return DeviceCombo.BackBufferFormat; }
        }


        // The display mode
        public DisplayMode DisplayMode
        {
            get { return IsWindowed ? WindowedDisplayMode : FullscreenDisplayMode; }
            set { if (IsWindowed) WindowedDisplayMode = value; else FullscreenDisplayMode = value; }
        }


        // The Depth stencils format
        public DepthFormat DepthStencilBufferFormat
        {
            get { return IsWindowed ? WindowedDepthStencilBufferFormat : FullscreenDepthStencilBufferFormat; }
            set { if (IsWindowed) WindowedDepthStencilBufferFormat = value; else FullscreenDepthStencilBufferFormat = value; }
        }


        /// <summary>
        /// The multisample type
        /// </summary>
        public MultiSampleType MultisampleType
        {
            get { return IsWindowed ? WindowedMultisampleType : FullscreenMultisampleType; }
            set { if (IsWindowed) WindowedMultisampleType = value; else FullscreenMultisampleType = value; }
        }


        /// <summary>
        /// The multisample quality
        /// </summary>
        public int MultisampleQuality
        {
            get { return IsWindowed ? WindowedMultisampleQuality : FullscreenMultisampleQuality; }
            set { if (IsWindowed) WindowedMultisampleQuality = value; else FullscreenMultisampleQuality = value; }
        }


        /// <summary>
        /// The vertex processing type
        /// </summary>
        public VertexProcessingType VertexProcessingType
        {
            get { return IsWindowed ? WindowedVertexProcessingType : FullscreenVertexProcessingType; }
            set { if (IsWindowed) WindowedVertexProcessingType = value; else FullscreenVertexProcessingType = value; }
        }


        /// <summary>
        /// The presentation interval
        /// </summary>
        public PresentInterval PresentInterval
        {
            get { return IsWindowed ? WindowedPresentInterval : FullscreenPresentInterval; }
            set { if (IsWindowed) WindowedPresentInterval = value; else FullscreenPresentInterval = value; }
        }


        /// <summary>
        /// Clone the d3d settings class
        /// </summary>
        public D3DSettings Clone()
        {
            return (D3DSettings)MemberwiseClone();
        }
    }
}