using System;
using System.Collections.Generic;
using System.Text;
using Microsoft.DirectX.Direct3D;
using System.Collections;
using Microsoft.DirectX;

public struct DeviceInfo
{
    public Matrix World;
    public Matrix View;
    public Matrix Projection;
    public bool FogEnabled;
    public bool ZEnabled;
}

public interface IRenderable
{
    void InitDevice(Microsoft.DirectX.Direct3D.Device device, bool isReset);
    void LostDevice(Microsoft.DirectX.Direct3D.Device device);
    void Render(Microsoft.DirectX.Direct3D.Device device, DeviceInfo deviceInfo);
}

/// <summary>
/// Enumeration of all possible D3D vertex processing types
/// </summary>
public enum VertexProcessingType
{
    Software,
    Mixed,
    Hardware,
    PureHardware
}

public class GraphicsAdapterInfo
{
    public int AdapterOrdinal;
    public AdapterDetails AdapterDetails;
    public List<DisplayMode> DisplayModeList = new List<DisplayMode>();
    public List<GraphicsDeviceInfo> DeviceInfoList = new List<GraphicsDeviceInfo>();
    public override string ToString() { return AdapterDetails.Description; }
}

public class GraphicsDeviceInfo
{
    public int AdapterOrdinal;
    public DeviceType DevType;
    public Caps Caps;
    public List<DeviceCombo> DeviceComboList = new List<DeviceCombo>(); 
    public override string ToString() { return DevType.ToString(); }
}

public class DeviceCombo
{
    public int AdapterOrdinal;
    public DeviceType DevType;
    public Format AdapterFormat;
    public Format BackBufferFormat;
    public bool IsWindowed;
    public List<DepthFormat> DepthStencilFormatList = new List<DepthFormat>();
    public List<MultiSampleType> MultiSampleTypeList = new List<MultiSampleType>();
    public List<int> MultiSampleQualityList = new List<int>(); // maxQuality per multisample type
    public List<DepthStencilMultiSampleConflict> DepthStencilMultiSampleConflictList = new List<DepthStencilMultiSampleConflict>();
    public List<VertexProcessingType> VertexProcessingTypeList = new List<VertexProcessingType>(); 
    public List<PresentInterval> PresentIntervalList = new List<PresentInterval>(); 
}

public class DepthStencilMultiSampleConflict
{
    public DepthFormat DepthStencilFormat;
    public MultiSampleType MultiSampleType;
}

class DisplayModeComparer : System.Collections.Generic.IComparer<DisplayMode>
{
    public int Compare(DisplayMode dx, DisplayMode dy)
    {
        if (dx.Width > dy.Width) return 1;
        if (dx.Width < dy.Width) return -1;
        if (dx.Height > dy.Height) return 1;
        if (dx.Height < dy.Height) return -1;
        if (dx.Format > dy.Format) return 1;
        if (dx.Format < dy.Format) return -1;
        if (dx.RefreshRate > dy.RefreshRate) return 1;
        if (dx.RefreshRate < dy.RefreshRate) return -1;
        return 0;
    }
}

public class D3DEnumeration
{
    /// <summary>
    /// The confirm device delegate which is used to determine if a device 
    /// meets the needs of the simulation
    /// </summary>
    public delegate bool ConfirmDeviceCallbackType(Caps caps, VertexProcessingType vertexProcessingType, Format backBufferFormat);

    public ConfirmDeviceCallbackType ConfirmDeviceCallback;
    public List<GraphicsAdapterInfo> AdapterInfoList = new List<GraphicsAdapterInfo>(); // List of D3DAdapterInfos

    // The following variables can be used to limit what modes, formats, 
    // etc. are enumerated.  Set them to the values you want before calling
    // Enumerate().
    public int AppMinFullscreenWidth = 640;
    public int AppMinFullscreenHeight = 480;
    public int AppMinColorChannelBits = 5; // min color bits per channel in adapter format
    public int AppMinAlphaChannelBits = 0; // min alpha bits per pixel in back buffer format
    public int AppMinDepthBits = 15;
    public int AppMinStencilBits = 0;
    public bool AppUsesDepthBuffer = true;
    public bool AppUsesMixedVP = false; // whether app can take advantage of mixed vp mode
    public bool AppRequiresWindowed = false;
    public bool AppRequiresFullscreen = false;

    /// <summary>
    /// Enumerates available D3D adapters, devices, modes, etc.
    /// </summary>
    public void Enumerate()
    {
        foreach (AdapterInformation ai in Manager.Adapters)
        {
            List<Format> adapterFormatList = new List<Format>();
            GraphicsAdapterInfo adapterInfo = new GraphicsAdapterInfo();
            adapterInfo.AdapterOrdinal = ai.Adapter;
            adapterInfo.AdapterDetails = ai.Information;

            // Get list of all display modes on this adapter.  
            // Also build a temporary list of all display adapter formats.
            foreach (DisplayMode displayMode in ai.SupportedDisplayModes)
            {
                if (displayMode.Width < AppMinFullscreenWidth) continue;
                if (displayMode.Height < AppMinFullscreenHeight) continue;
                if (Utils.GetColorChannelBits(displayMode.Format) < AppMinColorChannelBits) continue;
                adapterInfo.DisplayModeList.Add(displayMode);
                if (!adapterFormatList.Contains(displayMode.Format)) adapterFormatList.Add(displayMode.Format);
            }

            // Sort displaymode list
            adapterInfo.DisplayModeList.Sort(new DisplayModeComparer());

            // Get info for each device on this adapter
            EnumerateDevices(adapterInfo, adapterFormatList);

            // If at least one device on this adapter is available and compatible
            // with the app, add the adapterInfo to the list
            if (adapterInfo.DeviceInfoList.Count == 0) continue;
            AdapterInfoList.Add(adapterInfo);
        }
    }

    /// <summary>
    /// Enumerates D3D devices for a particular adapter
    /// </summary>
    protected void EnumerateDevices(GraphicsAdapterInfo adapterInfo, List<Format> adapterFormatList)
    {
        DeviceType[] devTypeArray = new DeviceType[] { DeviceType.Hardware, DeviceType.Software, DeviceType.Reference };

        foreach (DeviceType devType in devTypeArray)
        {
            GraphicsDeviceInfo deviceInfo = new GraphicsDeviceInfo();
            deviceInfo.AdapterOrdinal = adapterInfo.AdapterOrdinal;
            deviceInfo.DevType = devType;
            try
            {
                deviceInfo.Caps = Manager.GetDeviceCaps(adapterInfo.AdapterOrdinal, devType);
            }
            catch (DirectXException)
            {
                continue;
            }
            // Get info for each devicecombo on this device
            EnumerateDeviceCombos(deviceInfo, adapterFormatList);

            // If at least one devicecombo for this device is found, 
            // add the deviceInfo to the list
            if (deviceInfo.DeviceComboList.Count == 0) continue;
            adapterInfo.DeviceInfoList.Add(deviceInfo);
        }
    }

    /// <summary>
    /// Enumerates DeviceCombos for a particular device
    /// </summary>
    protected void EnumerateDeviceCombos(GraphicsDeviceInfo deviceInfo, List<Format> adapterFormatList)
    {
        Format[] backBufferFormatArray = new Format[] 
			{	Format.R8G8B8, Format.A8R8G8B8, Format.X8R8G8B8, 
				Format.R5G6B5, Format.A1R5G5B5, Format.X1R5G5B5,
				Format.R3G3B2, Format.A8R3G3B2,
				Format.X4R4G4B4, Format.A4R4G4B4,
				Format.A2B10G10R10 };
        bool[] isWindowedArray = new bool[] { false, true };

        // See which adapter formats are supported by this device
        foreach (Format adapterFormat in adapterFormatList)
            foreach (Format backBufferFormat in backBufferFormatArray)
            {
                if (Utils.GetAlphaChannelBits(backBufferFormat) < AppMinAlphaChannelBits) continue;
                foreach (bool isWindowed in isWindowedArray)
                {
                    if (!isWindowed && AppRequiresWindowed) continue;
                    if (isWindowed && AppRequiresFullscreen) continue;
                    if (!Manager.CheckDeviceType(deviceInfo.AdapterOrdinal, deviceInfo.DevType, adapterFormat, backBufferFormat, isWindowed)) continue;

                    // At this point, we have an adapter/device/adapterformat/backbufferformat/iswindowed
                    // DeviceCombo that is supported by the system.  We still need to confirm that it's 
                    // compatible with the app, and find one or more suitable depth/stencil buffer format,
                    // multisample type, vertex processing type, and present interval.
                    DeviceCombo deviceCombo = new DeviceCombo();
                    deviceCombo.AdapterOrdinal = deviceInfo.AdapterOrdinal;
                    deviceCombo.DevType = deviceInfo.DevType;
                    deviceCombo.AdapterFormat = adapterFormat;
                    deviceCombo.BackBufferFormat = backBufferFormat;
                    deviceCombo.IsWindowed = isWindowed;
                    if (AppUsesDepthBuffer)
                    {
                        BuildDepthStencilFormatList(deviceCombo);
                        if (deviceCombo.DepthStencilFormatList.Count == 0) continue;
                    }
                    BuildMultiSampleTypeList(deviceCombo);
                    if (deviceCombo.MultiSampleTypeList.Count == 0) continue;
                    BuildDepthStencilMultiSampleConflictList(deviceCombo);
                    BuildVertexProcessingTypeList(deviceInfo, deviceCombo);
                    if (deviceCombo.VertexProcessingTypeList.Count == 0) continue;
                    BuildPresentIntervalList(deviceInfo, deviceCombo);
                    if (deviceCombo.PresentIntervalList.Count == 0) continue;

                    deviceInfo.DeviceComboList.Add(deviceCombo);
                }
            }
    }

    /// <summary>
    /// Adds all depth/stencil formats that are compatible with the device and app to
    /// the given deviceCombo
    /// </summary>
    public void BuildDepthStencilFormatList(DeviceCombo deviceCombo)
    {
        DepthFormat[] depthStencilFormatArray = 
		{
			DepthFormat.D16,
			DepthFormat.D15S1,
			DepthFormat.D24X8,
			DepthFormat.D24S8,
			DepthFormat.D24X4S4,
			DepthFormat.D32,
		};

        foreach (DepthFormat depthStencilFmt in depthStencilFormatArray)
        {
            if (Utils.GetDepthBits(depthStencilFmt) < AppMinDepthBits) continue;
            if (Utils.GetStencilBits(depthStencilFmt) < AppMinStencilBits) continue;
            if (Manager.CheckDeviceFormat(deviceCombo.AdapterOrdinal, deviceCombo.DevType, deviceCombo.AdapterFormat, Usage.DepthStencil, ResourceType.Surface, depthStencilFmt))
                if (Manager.CheckDepthStencilMatch(deviceCombo.AdapterOrdinal, deviceCombo.DevType, deviceCombo.AdapterFormat, deviceCombo.BackBufferFormat, depthStencilFmt))
                    deviceCombo.DepthStencilFormatList.Add(depthStencilFmt);
        }
    }

    /// <summary>
    /// Adds all multisample types that are compatible with the device and app to
    /// the given deviceCombo
    /// </summary>
    public void BuildMultiSampleTypeList(DeviceCombo deviceCombo)
    {
        MultiSampleType[] msTypeArray = { 
			MultiSampleType.None,
			MultiSampleType.NonMaskable,
			MultiSampleType.TwoSamples,
			MultiSampleType.ThreeSamples,
			MultiSampleType.FourSamples,
			MultiSampleType.FiveSamples,
			MultiSampleType.SixSamples,
			MultiSampleType.SevenSamples,
			MultiSampleType.EightSamples,
			MultiSampleType.NineSamples,
			MultiSampleType.TenSamples,
			MultiSampleType.ElevenSamples,
			MultiSampleType.TwelveSamples,
			MultiSampleType.ThirteenSamples,
			MultiSampleType.FourteenSamples,
			MultiSampleType.FifteenSamples,
			MultiSampleType.SixteenSamples,
		};

        foreach (MultiSampleType msType in msTypeArray)
        {
            int result;
            int qualityLevels = 0;
            if (Manager.CheckDeviceMultiSampleType(deviceCombo.AdapterOrdinal, deviceCombo.DevType,                deviceCombo.BackBufferFormat, deviceCombo.IsWindowed, msType, out result, out qualityLevels))
            {
                deviceCombo.MultiSampleTypeList.Add(msType);
                deviceCombo.MultiSampleQualityList.Add(qualityLevels);
            }
        }
    }

    /// <summary>
    /// Finds any depthstencil formats that are incompatible with multisample types and
    /// builds a list of them.
    /// </summary>
    public void BuildDepthStencilMultiSampleConflictList(DeviceCombo deviceCombo)
    {
        DepthStencilMultiSampleConflict DSMSConflict;

        foreach (DepthFormat dsFmt in deviceCombo.DepthStencilFormatList)
            foreach (MultiSampleType msType in deviceCombo.MultiSampleTypeList)
                if (!Manager.CheckDeviceMultiSampleType(deviceCombo.AdapterOrdinal, deviceCombo.DevType, (Format)dsFmt, deviceCombo.IsWindowed, msType))
                {
                    DSMSConflict = new DepthStencilMultiSampleConflict();
                    DSMSConflict.DepthStencilFormat = dsFmt;
                    DSMSConflict.MultiSampleType = msType;
                    deviceCombo.DepthStencilMultiSampleConflictList.Add(DSMSConflict);
                }

    }

    /// <summary>
    /// Adds all vertex processing types that are compatible with the device and app to
    /// the given deviceCombo
    /// </summary>
    public void BuildVertexProcessingTypeList(GraphicsDeviceInfo deviceInfo, DeviceCombo deviceCombo)
    {
        if (deviceInfo.Caps.DeviceCaps.SupportsHardwareTransformAndLight)
        {
            if (deviceInfo.Caps.DeviceCaps.SupportsPureDevice)
                if (ConfirmDeviceCallback == null || ConfirmDeviceCallback(deviceInfo.Caps, VertexProcessingType.PureHardware, deviceCombo.BackBufferFormat))
                    deviceCombo.VertexProcessingTypeList.Add(VertexProcessingType.PureHardware);


            if (ConfirmDeviceCallback == null || ConfirmDeviceCallback(deviceInfo.Caps, VertexProcessingType.Hardware, deviceCombo.BackBufferFormat))
                deviceCombo.VertexProcessingTypeList.Add(VertexProcessingType.Hardware);

            if (AppUsesMixedVP && (ConfirmDeviceCallback == null || ConfirmDeviceCallback(deviceInfo.Caps, VertexProcessingType.Mixed, deviceCombo.BackBufferFormat)))
                deviceCombo.VertexProcessingTypeList.Add(VertexProcessingType.Mixed);
        }
        if (ConfirmDeviceCallback == null || ConfirmDeviceCallback(deviceInfo.Caps, VertexProcessingType.Software, deviceCombo.BackBufferFormat))
            deviceCombo.VertexProcessingTypeList.Add(VertexProcessingType.Software);
    }

    /// <summary>
    /// Adds all present intervals that are compatible with the device and app to
    /// the given deviceCombo
    /// </summary>
    public void BuildPresentIntervalList(GraphicsDeviceInfo deviceInfo, DeviceCombo deviceCombo)
    {
        PresentInterval[] piArray = { 
			PresentInterval.Immediate,
			PresentInterval.Default,
			PresentInterval.One,
			PresentInterval.Two,
			PresentInterval.Three,
			PresentInterval.Four,
		};

        foreach (PresentInterval pi in piArray)
        {
            if (deviceCombo.IsWindowed)
                if (pi == PresentInterval.Two || pi == PresentInterval.Three || pi == PresentInterval.Four)
                    // These intervals are not supported in windowed mode.
                    continue;

            // Note that PresentInterval.Default is zero, so you
            // can't do a caps check for it -- it is always available.
            if (pi == PresentInterval.Default || (deviceInfo.Caps.PresentationIntervals & pi) != (PresentInterval)0)
                deviceCombo.PresentIntervalList.Add(pi);
        }
    }
}