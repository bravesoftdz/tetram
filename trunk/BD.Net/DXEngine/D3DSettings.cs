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