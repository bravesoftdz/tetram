using System;
using System.Collections.Generic;
using System.Text;
using Microsoft.DirectX.Direct3D;

namespace DXEngine
{
    public class Engine
    {
        protected D3DEnumeration enumerationSettings = new D3DEnumeration();
        protected D3DSettings graphicsSettings = new D3DSettings();
        private System.Windows.Forms.Control ourRenderTarget;

        // Internal variables for the state of the app
        protected bool windowed;
        protected bool active;

        // Main objects used for creating and rendering the 3D scene
        protected PresentParameters presentParams = new PresentParameters();         // Parameters for CreateDevice/Reset
        protected Device device; // The rendering device
        protected RenderStateManager renderState;
        protected SamplerStateManagerCollection sampleState;
        protected TextureStateManagerCollection textureStates;
        private Caps graphicsCaps;           // Caps for the device
        protected Caps Caps { get { return graphicsCaps; } }
        private CreateFlags behavior;     // Indicate sw or hw vertex processing
        protected BehaviorFlags BehaviorFlags { get { return new BehaviorFlags(behavior); } }
        protected System.Windows.Forms.Control RenderTarget { get { return ourRenderTarget; } set { ourRenderTarget = value; } }

        // Overridable functions for the 3D scene created by the app
        protected virtual bool ConfirmDevice(Caps caps, VertexProcessingType vertexProcessingType, Format format) { return true; }
        protected virtual void OneTimeSceneInitialization() { /* Do Nothing */ }
        protected virtual void InitializeDeviceObjects() { /* Do Nothing */ }
        protected virtual void RestoreDeviceObjects(System.Object sender, System.EventArgs e) { /* Do Nothing */ }
        protected virtual void FrameMove() { /* Do Nothing */ }
        protected virtual void Render() { /* Do Nothing */ }
        protected virtual void InvalidateDeviceObjects(System.Object sender, System.EventArgs e) { /* Do Nothing */ }
        protected virtual void DeleteDeviceObjects(System.Object sender, System.EventArgs e) { /* Do Nothing */ }

        protected string deviceStats;// String to hold D3D device stats

        protected bool showCursorWhenFullscreen; // Whether to show cursor when fullscreen
        protected bool clipCursorWhenFullscreen; // Whether to limit cursor pos when fullscreen
        protected bool startFullscreen; // Whether to start up the app in fullscreen mode

        public Engine()
        {
        }

        public bool Prepare(System.Windows.Forms.Control target)
        {
            enumerationSettings.ConfirmDeviceCallback = new D3DEnumeration.ConfirmDeviceCallbackType(this.ConfirmDevice);
            enumerationSettings.Enumerate();

            RenderTarget = target;

            if (!ChooseInitialSettings()) return false;
            InitializeEnvironment();
            OneTimeSceneInitialization();
            return true;
        }

        public bool ChooseInitialSettings()
        {
            bool foundFullscreenMode = FindBestFullscreenMode(false, false);
            bool foundWindowedMode = FindBestWindowedMode(false, false);
            if (startFullscreen && foundFullscreenMode)
                graphicsSettings.IsWindowed = false;

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

        public void BuildPresentParamsFromSettings()
        {
            presentParams.Windowed = graphicsSettings.IsWindowed;
            presentParams.BackBufferCount = 1;
            presentParams.MultiSample = graphicsSettings.MultisampleType;
            presentParams.MultiSampleQuality = graphicsSettings.MultisampleQuality;
            presentParams.SwapEffect = SwapEffect.Discard;
            presentParams.EnableAutoDepthStencil = enumerationSettings.AppUsesDepthBuffer;
            presentParams.AutoDepthStencilFormat = graphicsSettings.DepthStencilBufferFormat;
            presentParams.PresentFlag = PresentFlag.None;
            if (windowed)
            {
                presentParams.BackBufferWidth = ourRenderTarget.ClientRectangle.Right - ourRenderTarget.ClientRectangle.Left;
                presentParams.BackBufferHeight = ourRenderTarget.ClientRectangle.Bottom - ourRenderTarget.ClientRectangle.Top;
                presentParams.BackBufferFormat = graphicsSettings.DeviceCombo.BackBufferFormat;
                presentParams.FullScreenRefreshRateInHz = 0;
                presentParams.PresentationInterval = PresentInterval.Immediate;
                presentParams.DeviceWindow = ourRenderTarget;
            }
            else
            {
                presentParams.BackBufferWidth = graphicsSettings.DisplayMode.Width;
                presentParams.BackBufferHeight = graphicsSettings.DisplayMode.Height;
                presentParams.BackBufferFormat = graphicsSettings.DeviceCombo.BackBufferFormat;
                presentParams.FullScreenRefreshRateInHz = graphicsSettings.DisplayMode.RefreshRate;
                presentParams.PresentationInterval = graphicsSettings.PresentInterval;
                presentParams.DeviceWindow = ourRenderTarget;
            }
        }
        public void InitializeEnvironment()
        {
            GraphicsAdapterInfo adapterInfo = graphicsSettings.AdapterInfo;
            GraphicsDeviceInfo deviceInfo = graphicsSettings.DeviceInfo;

            windowed = graphicsSettings.IsWindowed;

            // Set up the presentation parameters
            BuildPresentParamsFromSettings();

            //if (deviceInfo.Caps.PrimitiveMiscCaps.IsNullReference)
            //{
            //    // Warn user about null ref device that can't render anything
            //    HandleSampleException(new NullReferenceDeviceException(), ApplicationMessage.None);
            //}

            CreateFlags createFlags = new CreateFlags();
            if (graphicsSettings.VertexProcessingType == VertexProcessingType.Software)
                createFlags = CreateFlags.SoftwareVertexProcessing;
            else if (graphicsSettings.VertexProcessingType == VertexProcessingType.Mixed)
                createFlags = CreateFlags.MixedVertexProcessing;
            else if (graphicsSettings.VertexProcessingType == VertexProcessingType.Hardware)
                createFlags = CreateFlags.HardwareVertexProcessing;
            else if (graphicsSettings.VertexProcessingType == VertexProcessingType.PureHardware)
            {
                createFlags = CreateFlags.HardwareVertexProcessing | CreateFlags.PureDevice;
            }
            else
                throw new ApplicationException();

            createFlags |= CreateFlags.MultiThreaded;

            try
            {
                // Create the device
                device = new Device(graphicsSettings.AdapterOrdinal, graphicsSettings.DevType,
                    presentParams.DeviceWindow, createFlags, presentParams);

                // Cache our local objects
                renderState = device.RenderState;
                sampleState = device.SamplerState;
                textureStates = device.TextureState;
                // When moving from fullscreen to windowed mode, it is important to
                // adjust the window size after recreating the device rather than
                // beforehand to ensure that you get the window size you want.  For
                // example, when switching from 640x480 fullscreen to windowed with
                // a 1000x600 window on a 1024x768 desktop, it is impossible to set
                // the window size to 1000x600 until after the display mode has
                // changed to 1024x768, because windows cannot be larger than the
                // desktop.
                if (windowed)
                {
                    // Make sure main window isn't topmost, so error message is visible
                    System.Drawing.Size currentClientSize = presentParams.DeviceWindow.ClientSize;
                    presentParams.DeviceWindow.Size = presentParams.DeviceWindow.ClientSize;
                    presentParams.DeviceWindow.ClientSize = currentClientSize;
                    presentParams.DeviceWindow.SendToBack();
                    presentParams.DeviceWindow.BringToFront();
                }

                // Store device Caps
                graphicsCaps = device.DeviceCaps;
                behavior = createFlags;

                // Store device description
                if (deviceInfo.DevType == DeviceType.Reference)
                    deviceStats = "REF";
                else if (deviceInfo.DevType == DeviceType.Hardware)
                    deviceStats = "HAL";
                else if (deviceInfo.DevType == DeviceType.Software)
                    deviceStats = "SW";

                BehaviorFlags behaviorFlags = new BehaviorFlags(createFlags);
                if ((behaviorFlags.HardwareVertexProcessing) &&
                    (behaviorFlags.PureDevice))
                {
                    if (deviceInfo.DevType == DeviceType.Hardware)
                        deviceStats += " (pure hw vp)";
                    else
                        deviceStats += " (simulated pure hw vp)";
                }
                else if ((behaviorFlags.HardwareVertexProcessing))
                {
                    if (deviceInfo.DevType == DeviceType.Hardware)
                        deviceStats += " (hw vp)";
                    else
                        deviceStats += " (simulated hw vp)";
                }
                else if (behaviorFlags.MixedVertexProcessing)
                {
                    if (deviceInfo.DevType == DeviceType.Hardware)
                        deviceStats += " (mixed vp)";
                    else
                        deviceStats += " (simulated mixed vp)";
                }
                else if (behaviorFlags.SoftwareVertexProcessing)
                {
                    deviceStats += " (sw vp)";
                }

                if (deviceInfo.DevType == DeviceType.Hardware)
                {
                    deviceStats += ": ";
                    deviceStats += adapterInfo.AdapterDetails.Description;
                }

                // Set up the fullscreen cursor
                if (showCursorWhenFullscreen && !windowed)
                {
                    System.Windows.Forms.Cursor ourCursor = presentParams.DeviceWindow.Cursor;
                    device.SetCursor(ourCursor, true);
                    device.ShowCursor(true);
                }

                // Confine cursor to fullscreen window
                if (clipCursorWhenFullscreen)
                {
                    if (!windowed)
                    {
                        System.Drawing.Rectangle rcWindow = presentParams.DeviceWindow.ClientRectangle;
                    }
                }

                // Setup the event handlers for our device
                device.DeviceLost += new System.EventHandler(this.InvalidateDeviceObjects);
                device.DeviceReset += new System.EventHandler(this.RestoreDeviceObjects);
                device.Disposing += new System.EventHandler(this.DeleteDeviceObjects);
                device.DeviceResizing += new System.ComponentModel.CancelEventHandler(this.EnvironmentResized);


                // Initialize the app's device-dependent objects
                try
                {
                    InitializeDeviceObjects();
                    RestoreDeviceObjects(null, null);
                    active = true;
                    return;
                }
                catch
                {
                    // Cleanup before we try again
                    InvalidateDeviceObjects(null, null);
                    DeleteDeviceObjects(null, null);
                    device.Dispose();
                    device = null;
                    if (presentParams.DeviceWindow.Disposing)
                        return;
                }
            }
            catch
            {
                // If that failed, fall back to the reference rasterizer
                if (deviceInfo.DevType == DeviceType.Hardware)
                {
                    if (FindBestWindowedMode(false, true))
                    {
                        windowed = true;
                        // Make sure main window isn't topmost, so error message is visible
                        System.Drawing.Size currentClientSize = presentParams.DeviceWindow.ClientSize;
                        presentParams.DeviceWindow.Size = presentParams.DeviceWindow.ClientSize;
                        presentParams.DeviceWindow.ClientSize = currentClientSize;
                        presentParams.DeviceWindow.SendToBack();
                        presentParams.DeviceWindow.BringToFront();

                        //// Let the user know we are switching from HAL to the reference rasterizer
                        //HandleSampleException(null, ApplicationMessage.WarnSwitchToRef);

                        InitializeEnvironment();
                    }
                }
            }
        }

        public void EnvironmentResized(object sender, System.ComponentModel.CancelEventArgs e)
        {
            // Check to see if we're minimizing and our rendering object
            // is not the form, if so, cancel the resize
            //if ((ourRenderTarget != this) && (this.WindowState == System.Windows.Forms.FormWindowState.Minimized))
            //    e.Cancel = true;

            // Set up the fullscreen cursor
            if (showCursorWhenFullscreen && !windowed)
            {
                System.Windows.Forms.Cursor ourCursor = presentParams.DeviceWindow.Cursor;
                device.SetCursor(ourCursor, true);
                device.ShowCursor(true);
            }

            //// If the app is paused, trigger the rendering of the current frame
            //if (false == frameMoving)
            //{
            //    singleStep = true;
            //    DXUtil.Timer(TIMER.START);
            //    DXUtil.Timer(TIMER.STOP);
            //}
        }

        /// <summary>
        /// Displays a dialog so the user can select a new adapter, device, or
        /// display mode, and then recreates the 3D environment if needed
        /// </summary>
        public void DoSelectNewDevice()
        {
            // Can't display dialogs in fullscreen mode
            //if (windowed == false)
            //{
            //    try
            //    {
            //        ToggleFullscreen();
            //    }
            //    catch
            //    {
            //        HandleSampleException(new ResetFailedException(), ApplicationMessage.ApplicationMustExit);
            //        return;
            //    }
            //}

            // Make sure the main form is in the background
            RenderTarget.SendToBack();
            D3DSettingsForm settingsForm = new D3DSettingsForm(enumerationSettings, graphicsSettings);
            System.Windows.Forms.DialogResult result = settingsForm.ShowDialog(null);
            if (result != System.Windows.Forms.DialogResult.OK)
            {
                return;
            }
            graphicsSettings = settingsForm.settings;

            //windowed = graphicsSettings.IsWindowed;

            // Release display objects, so a new device can be created
            device.Dispose();
            device = null;

            // Inform the display class of the change. It will internally
            // re-create valid surfaces, a d3ddevice, etc.
            InitializeEnvironment();
        }
    }
}