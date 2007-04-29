using System;
using System.Collections.Generic;
using System.Text;
using Microsoft.DirectX.Direct3D;

namespace BDX.Engine
{
    class Engine
    {
        protected D3DEnumeration enumerationSettings = new D3DEnumeration();
        protected D3DSettings graphicsSettings = new D3DSettings();

        public bool Prepare()
        {
            if (!ChooseInitialSettings()) return false;
            InitializeEnvironment();
            return true;
        }

        public bool ChooseInitialSettings()
        {
            bool foundFullscreenMode = FindBestFullscreenMode(false, false);
            bool foundWindowedMode = FindBestWindowedMode(false, false);
            //if (startFullscreen && foundFullscreenMode)
            //    graphicsSettings.IsWindowed = false;

            if (!foundFullscreenMode && !foundWindowedMode)
                throw new NoCompatibleDevicesException();

            return (foundFullscreenMode || foundWindowedMode);
        }

        public bool FindBestFullscreenMode(bool doesRequireHardware, bool doesRequireReference)
        {
            DisplayMode adapterDesktopDisplayMode = new DisplayMode();
            DisplayMode bestAdapterDesktopDisplayMode = new DisplayMode();
            DisplayMode bestDisplayMode = new DisplayMode();
            bestAdapterDesktopDisplayMode.Width = 0;
            bestAdapterDesktopDisplayMode.Height = 0;
            bestAdapterDesktopDisplayMode.Format = 0;
            bestAdapterDesktopDisplayMode.RefreshRate = 0;

            GraphicsAdapterInfo bestAdapterInfo = null;
            GraphicsDeviceInfo bestDeviceInfo = null;
            DeviceCombo bestDeviceCombo = null;

            foreach (GraphicsAdapterInfo adapterInfo in enumerationSettings.AdapterInfoList)
            {
                adapterDesktopDisplayMode = Manager.Adapters[adapterInfo.AdapterOrdinal].CurrentDisplayMode;
                foreach (GraphicsDeviceInfo deviceInfo in adapterInfo.DeviceInfoList)
                {
                    if (doesRequireHardware && deviceInfo.DevType != DeviceType.Hardware)
                        continue;
                    if (doesRequireReference && deviceInfo.DevType != DeviceType.Reference)
                        continue;
                    foreach (DeviceCombo deviceCombo in deviceInfo.DeviceComboList)
                    {
                        bool adapterMatchesBackBuffer = (deviceCombo.BackBufferFormat == deviceCombo.AdapterFormat);
                        bool adapterMatchesDesktop = (deviceCombo.AdapterFormat == adapterDesktopDisplayMode.Format);
                        if (deviceCombo.IsWindowed)
                            continue;
                        // If we haven't found a compatible set yet, or if this set
                        // is better (because it's a HAL, and/or because formats match better),
                        // save it
                        if (bestDeviceCombo == null ||
                            bestDeviceCombo.DevType != DeviceType.Hardware && deviceInfo.DevType == DeviceType.Hardware ||
                            bestDeviceCombo.DevType == DeviceType.Hardware && bestDeviceCombo.AdapterFormat != adapterDesktopDisplayMode.Format && adapterMatchesDesktop ||
                            bestDeviceCombo.DevType == DeviceType.Hardware && adapterMatchesDesktop && adapterMatchesBackBuffer)
                        {
                            bestAdapterDesktopDisplayMode = adapterDesktopDisplayMode;
                            bestAdapterInfo = adapterInfo;
                            bestDeviceInfo = deviceInfo;
                            bestDeviceCombo = deviceCombo;
                            if (deviceInfo.DevType == DeviceType.Hardware && adapterMatchesDesktop && adapterMatchesBackBuffer)
                            {
                                // This fullscreen device combo looks great -- take it
                                goto EndFullscreenDeviceComboSearch;
                            }
                            // Otherwise keep looking for a better fullscreen device combo
                        }
                    }
                }
            }
        EndFullscreenDeviceComboSearch:
            if (bestDeviceCombo == null)
                return false;

            // Need to find a display mode on the best adapter that uses pBestDeviceCombo->AdapterFormat
            // and is as close to bestAdapterDesktopDisplayMode's res as possible
            bestDisplayMode.Width = 0;
            bestDisplayMode.Height = 0;
            bestDisplayMode.Format = 0;
            bestDisplayMode.RefreshRate = 0;
            foreach (DisplayMode displayMode in bestAdapterInfo.DisplayModeList)
            {
                if (displayMode.Format != bestDeviceCombo.AdapterFormat)
                    continue;
                if (displayMode.Width == bestAdapterDesktopDisplayMode.Width &&
                    displayMode.Height == bestAdapterDesktopDisplayMode.Height &&
                    displayMode.RefreshRate == bestAdapterDesktopDisplayMode.RefreshRate)
                {
                    // found a perfect match, so stop
                    bestDisplayMode = displayMode;
                    break;
                }
                else if (displayMode.Width == bestAdapterDesktopDisplayMode.Width &&
                    displayMode.Height == bestAdapterDesktopDisplayMode.Height &&
                    displayMode.RefreshRate > bestDisplayMode.RefreshRate)
                {
                    // refresh rate doesn't match, but width/height match, so keep this
                    // and keep looking
                    bestDisplayMode = displayMode;
                }
                else if (bestDisplayMode.Width == bestAdapterDesktopDisplayMode.Width)
                {
                    // width matches, so keep this and keep looking
                    bestDisplayMode = displayMode;
                }
                else if (bestDisplayMode.Width == 0)
                {
                    // we don't have anything better yet, so keep this and keep looking
                    bestDisplayMode = displayMode;
                }
            }
            graphicsSettings.FullscreenAdapterInfo = bestAdapterInfo;
            graphicsSettings.FullscreenDeviceInfo = bestDeviceInfo;
            graphicsSettings.FullscreenDeviceCombo = bestDeviceCombo;
            graphicsSettings.IsWindowed = false;
            graphicsSettings.FullscreenDisplayMode = bestDisplayMode;
            if (enumerationSettings.AppUsesDepthBuffer)
                graphicsSettings.FullscreenDepthStencilBufferFormat = (DepthFormat)bestDeviceCombo.DepthStencilFormatList[0];
            graphicsSettings.FullscreenMultisampleType = (MultiSampleType)bestDeviceCombo.MultiSampleTypeList[0];
            graphicsSettings.FullscreenMultisampleQuality = 0;
            graphicsSettings.FullscreenVertexProcessingType = (VertexProcessingType)bestDeviceCombo.VertexProcessingTypeList[0];
            graphicsSettings.FullscreenPresentInterval = (PresentInterval)bestDeviceCombo.PresentIntervalList[0];
            return true;
        }
        public bool FindBestWindowedMode(bool doesRequireHardware, bool doesRequireReference)
        {
            // Get display mode of primary adapter (which is assumed to be where the window will appear)
            DisplayMode primaryDesktopDisplayMode = Manager.Adapters[0].CurrentDisplayMode;

            GraphicsAdapterInfo bestAdapterInfo = null;
            GraphicsDeviceInfo bestDeviceInfo = null;
            DeviceCombo bestDeviceCombo = null;

            foreach (GraphicsAdapterInfo adapterInfo in enumerationSettings.AdapterInfoList)
            {
                foreach (GraphicsDeviceInfo deviceInfo in adapterInfo.DeviceInfoList)
                {
                    if (doesRequireHardware && deviceInfo.DevType != DeviceType.Hardware)
                        continue;
                    if (doesRequireReference && deviceInfo.DevType != DeviceType.Reference)
                        continue;
                    foreach (DeviceCombo deviceCombo in deviceInfo.DeviceComboList)
                    {
                        bool adapterMatchesBackBuffer = (deviceCombo.BackBufferFormat == deviceCombo.AdapterFormat);
                        if (!deviceCombo.IsWindowed)
                            continue;
                        if (deviceCombo.AdapterFormat != primaryDesktopDisplayMode.Format)
                            continue;
                        // If we haven't found a compatible DeviceCombo yet, or if this set
                        // is better (because it's a HAL, and/or because formats match better),
                        // save it
                        if (bestDeviceCombo == null ||
                            bestDeviceCombo.DevType != DeviceType.Hardware && deviceInfo.DevType == DeviceType.Hardware ||
                            deviceCombo.DevType == DeviceType.Hardware && adapterMatchesBackBuffer)
                        {
                            bestAdapterInfo = adapterInfo;
                            bestDeviceInfo = deviceInfo;
                            bestDeviceCombo = deviceCombo;
                            if (deviceInfo.DevType == DeviceType.Hardware && adapterMatchesBackBuffer)
                            {
                                // This windowed device combo looks great -- take it
                                goto EndWindowedDeviceComboSearch;
                            }
                            // Otherwise keep looking for a better windowed device combo
                        }
                    }
                }
            }
        EndWindowedDeviceComboSearch:
            if (bestDeviceCombo == null)
                return false;

            graphicsSettings.WindowedAdapterInfo = bestAdapterInfo;
            graphicsSettings.WindowedDeviceInfo = bestDeviceInfo;
            graphicsSettings.WindowedDeviceCombo = bestDeviceCombo;
            graphicsSettings.IsWindowed = true;
            graphicsSettings.WindowedDisplayMode = primaryDesktopDisplayMode;
            graphicsSettings.WindowedWidth = ourRenderTarget.ClientRectangle.Right - ourRenderTarget.ClientRectangle.Left;
            graphicsSettings.WindowedHeight = ourRenderTarget.ClientRectangle.Bottom - ourRenderTarget.ClientRectangle.Top;
            if (enumerationSettings.AppUsesDepthBuffer)
                graphicsSettings.WindowedDepthStencilBufferFormat = (DepthFormat)bestDeviceCombo.DepthStencilFormatList[0];
            graphicsSettings.WindowedMultisampleType = (MultiSampleType)bestDeviceCombo.MultiSampleTypeList[0];
            graphicsSettings.WindowedMultisampleQuality = 0;
            graphicsSettings.WindowedVertexProcessingType = (VertexProcessingType)bestDeviceCombo.VertexProcessingTypeList[0];
            graphicsSettings.WindowedPresentInterval = (PresentInterval)bestDeviceCombo.PresentIntervalList[0];
            return true;
        }

        public void InitializeEnvironment() { }
    }
}
