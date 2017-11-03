using System;
using System.Collections.Generic;
using System.Text;
using Microsoft.DirectX.Direct3D;
using Direct3D = Microsoft.DirectX.Direct3D;
using Microsoft.DirectX;

namespace DXEngine
{
    public delegate bool PrepareEvent(System.Windows.Forms.Form target);
    public delegate bool ConfirmDeviceEvent(Caps caps, VertexProcessingType vertexProcessingType, Format format);
    public delegate void OneTimeSceneInitializationEvent();
    public delegate void InitializeDeviceObjectsEvent();
    public delegate void RestoreDeviceObjectsEvent(System.Object sender, System.EventArgs e);
    public delegate void FrameMoveEvent();
    public delegate void RenderEvent();
    public delegate void InvalidateDeviceObjectsEvent(System.Object sender, System.EventArgs e);
    public delegate void DeleteDeviceObjectsEvent(System.Object sender, System.EventArgs e);

    public class Engine
    {
        private static Engine localInstance;
        public static Engine Instance
        {
            get
            {
                if (localInstance == null) localInstance = new Engine();
                return localInstance;
            }
        }

        protected D3DEnumeration enumerationSettings = new D3DEnumeration();
        protected D3DSettings graphicsSettings = new D3DSettings();
        private System.Windows.Forms.Form ourRenderTarget;

        private float lastTime = 0.0f; // The last time
        private int frames = 0; // Number of rames since our last update
        private int appPausedCount = 0; // How many times has the app been paused (and when can it resume)?

        // Internal variables for the state of the app
        protected bool windowed;
        protected bool active;
        protected bool ready;
        protected bool hasFocus;

        // Internal variables used for timing
        protected bool frameMoving = true;               
        protected bool singleStep;

        private bool deviceLost = false;

        // Main objects used for creating and rendering the 3D scene
        protected PresentParameters presentParams = new PresentParameters();         // Parameters for CreateDevice/Reset
        private Device device; // The rendering device
        public Device Device { get { return device; } }
        public DeviceInfo DeviceInfo = new DeviceInfo(); // des infos qui ne peuvent être récupérées du Device en rendu PureDevice
        //protected RenderStateManager renderState;
        //protected SamplerStateManagerCollection sampleState;
        //protected TextureStateManagerCollection textureStates;
        private Caps graphicsCaps;           // Caps for the device
        protected Caps Caps { get { return graphicsCaps; } }
        private CreateFlags behavior;     // Indicate sw or hw vertex processing
        protected BehaviorFlags BehaviorFlags { get { return new BehaviorFlags(behavior); } }
        public System.Windows.Forms.Form RenderTarget { get { return ourRenderTarget; } set { ourRenderTarget = value; } }

        // Overridable functions for the 3D scene created by the app
        public event ConfirmDeviceEvent ConfirmDevice;
        private bool OnConfirmDevice(Caps caps, VertexProcessingType vertexProcessingType, Format backBufferFormat)
        {
            if (ConfirmDevice != null) 
                return ConfirmDevice(caps, vertexProcessingType, backBufferFormat);
            else
                return true;
        }
        public event OneTimeSceneInitializationEvent OneTimeSceneInitialization;
        public event InitializeDeviceObjectsEvent InitializeDeviceObjects;
        public event RestoreDeviceObjectsEvent RestoreDeviceObjects;
        private void OnRestoreDeviceObjects(System.Object sender, System.EventArgs e)
        {
            if (RestoreDeviceObjects != null) RestoreDeviceObjects(sender, e);
        }
        public event FrameMoveEvent FrameMove;
        public event RenderEvent Render;
        public event InvalidateDeviceObjectsEvent InvalidateDeviceObjects;
        private void OnInvalidateDeviceObjects(System.Object sender, System.EventArgs e)
        {
            if (InvalidateDeviceObjects != null) InvalidateDeviceObjects(sender, e);
        }
        public event DeleteDeviceObjectsEvent DeleteDeviceObjects;
        private void OnDeleteDeviceObjects(System.Object sender, System.EventArgs e)
        {
            if (DeleteDeviceObjects != null) DeleteDeviceObjects(sender, e);
        }

        // Variables for timing
        internal float appTime;
        public float AppTime { get { return appTime; } }             // Current time in seconds
        internal float elapsedTime;
        public float ElapsedTime { get { return elapsedTime; } }      // Time elapsed since last frame
        internal float framePerSecond;
        public float FramePerSecond { get { return framePerSecond; } }              // Instanteous frame rate
        internal string deviceStats;
        public string DeviceStats { get { return deviceStats; } }// String to hold D3D device stats
        internal string frameStats;
        public string FrameStats { get { return frameStats; } } // String to hold frame stats

        public bool showCursorWhenFullscreen; // Whether to show cursor when fullscreen
        public bool clipCursorWhenFullscreen; // Whether to limit cursor pos when fullscreen
        public bool startFullscreen; // Whether to start up the app in fullscreen mode

        private Engine()
        {
        }

        public event PrepareEvent Prepare;
        public bool DoPrepare(System.Windows.Forms.Form target)
        {
            if (Prepare != null) Prepare(target);

            enumerationSettings.ConfirmDeviceCallback = new D3DEnumeration.ConfirmDeviceCallbackType(this.OnConfirmDevice);
            enumerationSettings.Enumerate();

            RenderTarget = target;

            if (!ChooseInitialSettings()) return false;
            if (OneTimeSceneInitialization != null) OneTimeSceneInitialization();
            InitializeEnvironment(); // devrait être avant OneTimeSceneInitialization();

            ready = true;
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
            presentParams.Windowed = graphicsSettings.IsWindowed; // default false
            presentParams.BackBufferCount = 1; // default 0
            presentParams.MultiSample = graphicsSettings.MultisampleType; // default None
            presentParams.MultiSampleQuality = graphicsSettings.MultisampleQuality; // default 0
            presentParams.SwapEffect = SwapEffect.Discard; // default 0
            presentParams.EnableAutoDepthStencil = enumerationSettings.AppUsesDepthBuffer; // default false
            presentParams.AutoDepthStencilFormat = graphicsSettings.DepthStencilBufferFormat; // default Unknown
            presentParams.PresentFlag = PresentFlag.None; // default None
            if (windowed)
            {
                presentParams.BackBufferWidth = ourRenderTarget.ClientRectangle.Right - ourRenderTarget.ClientRectangle.Left; // default 0
                presentParams.BackBufferHeight = ourRenderTarget.ClientRectangle.Bottom - ourRenderTarget.ClientRectangle.Top; // default 0
                presentParams.BackBufferFormat = graphicsSettings.DeviceCombo.BackBufferFormat; // default Unknown
                presentParams.BackBufferFormat = Format.Unknown; // default Unknown
                presentParams.FullScreenRefreshRateInHz = 0; // default 0
                presentParams.PresentationInterval = PresentInterval.Immediate; // default Default
                presentParams.DeviceWindow = ourRenderTarget; // default Null
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
            switch (graphicsSettings.VertexProcessingType)
            {
                case VertexProcessingType.Software:
                    {
                        createFlags = CreateFlags.SoftwareVertexProcessing; break;
                    }
                case VertexProcessingType.Mixed:
                    {
                        createFlags = CreateFlags.MixedVertexProcessing; break;
                    }
                case VertexProcessingType.Hardware:
                    {
                        createFlags = CreateFlags.HardwareVertexProcessing; break;
                    }
                case VertexProcessingType.PureHardware:
                    {
                        createFlags = CreateFlags.HardwareVertexProcessing | CreateFlags.PureDevice; break;
                    }
                default:
                    throw new ApplicationException();
            }

            createFlags |= CreateFlags.MultiThreaded;

            try
            {
                // Create the device
                device = new Device(graphicsSettings.AdapterOrdinal, graphicsSettings.DevType,
                    presentParams.DeviceWindow, createFlags, presentParams);

                // Cache our local objects
                //renderState = device.RenderState;
                //sampleState = device.SamplerState;
                //textureStates = device.TextureState;
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

                device.Transform.World = Matrix.Identity;
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
                device.DeviceLost += new System.EventHandler(this.OnInvalidateDeviceObjects);
                device.DeviceReset += new System.EventHandler(this.OnRestoreDeviceObjects);
                device.Disposing += new System.EventHandler(this.OnDeleteDeviceObjects);
                device.DeviceResizing += new System.ComponentModel.CancelEventHandler(this.EnvironmentResized);


                // Initialize the app's device-dependent objects
                try
                {
                    if (InitializeDeviceObjects != null) InitializeDeviceObjects();
                    OnRestoreDeviceObjects(null, null);
                    active = true;
                    return;
                }
                catch
                {
                    // Cleanup before we try again
                    OnInvalidateDeviceObjects(null, null);
                    OnDeleteDeviceObjects(null, null);
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

            // If the app is paused, trigger the rendering of the current frame
            if (!frameMoving)
            {
                singleStep = true;
                Utils.Timer(TIMER.START);
                Utils.Timer(TIMER.STOP);
            }
        }

        /// <summary>
        /// Prepares the simulation for a new device being selected
        /// </summary>
        public void UserSelectNewDevice(object sender, EventArgs e)
        {
            // Prompt the user to select a new device or mode
            if (active && ready)
            {
//                Pause(true);
                DoSelectNewDevice();
//                Pause(false);
            }
        }

        /// <summary>
        /// Displays a dialog so the user can select a new adapter, device, or
        /// display mode, and then recreates the 3D environment if needed
        /// </summary>
        private void DoSelectNewDevice()
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

        public void Pause(bool pause)
        {

            appPausedCount += (int)(pause ? +1 : -1);
            ready = ((appPausedCount > 0) ? false : true);

            // Handle the first pause request (of many, nestable pause requests)
            if (pause && (1 == appPausedCount))
            {
                // Stop the scene from animating
                if (frameMoving)
                    Utils.Timer(TIMER.STOP);
            }

            if (0 == appPausedCount)
            {
                // Restart the timers
                if (frameMoving)
                    Utils.Timer(TIMER.START);
            }
        }

        /// <summary>
        /// Called when our sample has nothing else to do, and it's time to render
        /// </summary>
        public void FullRender()
        {
            //if (m_bTerminate)
            //    this.Close();

            // Render a frame during idle time (no messages are waiting)
            if (active && ready)
            {
                try
                {
                    if (deviceLost)
                    {
                        // Yield some CPU time to other processes
                        System.Threading.Thread.Sleep(100); // 100 milliseconds
                    }
                    // Render a frame during idle time
                    if (active)
                    {
                        Render3DEnvironment();
                    }
                }
                catch (Exception ee)
                {
                    System.Windows.Forms.MessageBox.Show("An exception has occurred.  This sample must exit.\r\n\r\n" + ee.ToString(), "Exception", System.Windows.Forms.MessageBoxButtons.OK, System.Windows.Forms.MessageBoxIcon.Information);               
                    //this.Close();
                }
            }
        }

        /// <summary>
        /// Draws the scene 
        /// </summary>
        public void Render3DEnvironment()
        {
            if (deviceLost)
            {
                try
                {
                    // Test the cooperative level to see if it's okay to render
                    device.TestCooperativeLevel();
                }
                catch (DeviceLostException)
                {
                    // If the device was lost, do not render until we get it back
                    return;
                }
                catch (DeviceNotResetException)
                {
                    // Check if the device needs to be resized.

                    // If we are windowed, read the desktop mode and use the same format for
                    // the back buffer
                    if (windowed)
                    {
                        GraphicsAdapterInfo adapterInfo = graphicsSettings.AdapterInfo;
                        graphicsSettings.WindowedDisplayMode = Manager.Adapters[adapterInfo.AdapterOrdinal].CurrentDisplayMode;
                        presentParams.BackBufferFormat = graphicsSettings.WindowedDisplayMode.Format;
                    }

                    // Reset the device and resize it
                    device.Reset(device.PresentationParameters);
                    EnvironmentResized(device, null);
                }
                deviceLost = false;
            }

            //// Get the app's time, in seconds. Skip rendering if no time elapsed
            float fAppTime = Utils.Timer(TIMER.GETAPPTIME);
            float fElapsedAppTime = Utils.Timer(TIMER.GETELAPSEDTIME);
            if ((0.0f == fElapsedAppTime) && frameMoving)
                return;

            // FrameMove (animate) the scene
            if (frameMoving || singleStep)
            {
                // Store the time for the app
                appTime = fAppTime;
                elapsedTime = fElapsedAppTime;

                // Frame move the scene
                if (FrameMove != null) FrameMove();

                singleStep = false;
            }

            // Render the scene as normal
            if (Render != null) Render();

            UpdateStats();

            try
            {
                // Show the frame on the primary surface.
                device.Present();
            }
            catch (DeviceLostException)
            {
                deviceLost = true;
            }
        }

        /// <summary>
        /// Update the various statistics the simulation keeps track of
        /// </summary>
        public void UpdateStats()
        {
            // Keep track of the frame count
            float time = Utils.Timer(TIMER.GETABSOLUTETIME);
            ++frames;

            // Update the scene stats once per second
            if (time - lastTime > 1.0f)
            {
                framePerSecond = frames / (time - lastTime);
                lastTime = time;
                frames = 0;

                string strFmt;
                DisplayMode mode = Manager.Adapters[graphicsSettings.AdapterOrdinal].CurrentDisplayMode;
                if (mode.Format == device.PresentationParameters.BackBufferFormat)
                {
                    strFmt = mode.Format.ToString();
                }
                else
                {
                    strFmt = String.Format("backbuf {0}, adapter {1}",
                        device.PresentationParameters.BackBufferFormat.ToString(), mode.Format.ToString());
                }

                string strDepthFmt;
                if (enumerationSettings.AppUsesDepthBuffer)
                {
                    strDepthFmt = String.Format(" ({0})",
                        graphicsSettings.DepthStencilBufferFormat.ToString());
                }
                else
                {
                    // No depth buffer
                    strDepthFmt = "";
                }

                string strMultiSample;
                switch (graphicsSettings.MultisampleType)
                {
                    case Direct3D.MultiSampleType.NonMaskable: strMultiSample = " (NonMaskable Multisample)"; break;
                    case Direct3D.MultiSampleType.TwoSamples: strMultiSample = " (2x Multisample)"; break;
                    case Direct3D.MultiSampleType.ThreeSamples: strMultiSample = " (3x Multisample)"; break;
                    case Direct3D.MultiSampleType.FourSamples: strMultiSample = " (4x Multisample)"; break;
                    case Direct3D.MultiSampleType.FiveSamples: strMultiSample = " (5x Multisample)"; break;
                    case Direct3D.MultiSampleType.SixSamples: strMultiSample = " (6x Multisample)"; break;
                    case Direct3D.MultiSampleType.SevenSamples: strMultiSample = " (7x Multisample)"; break;
                    case Direct3D.MultiSampleType.EightSamples: strMultiSample = " (8x Multisample)"; break;
                    case Direct3D.MultiSampleType.NineSamples: strMultiSample = " (9x Multisample)"; break;
                    case Direct3D.MultiSampleType.TenSamples: strMultiSample = " (10x Multisample)"; break;
                    case Direct3D.MultiSampleType.ElevenSamples: strMultiSample = " (11x Multisample)"; break;
                    case Direct3D.MultiSampleType.TwelveSamples: strMultiSample = " (12x Multisample)"; break;
                    case Direct3D.MultiSampleType.ThirteenSamples: strMultiSample = " (13x Multisample)"; break;
                    case Direct3D.MultiSampleType.FourteenSamples: strMultiSample = " (14x Multisample)"; break;
                    case Direct3D.MultiSampleType.FifteenSamples: strMultiSample = " (15x Multisample)"; break;
                    case Direct3D.MultiSampleType.SixteenSamples: strMultiSample = " (16x Multisample)"; break;
                    default: strMultiSample = string.Empty; break;
                }
                frameStats = String.Format("{0} fps ({1}x{2}), {3}{4}{5}", framePerSecond.ToString("f2"),
                    device.PresentationParameters.BackBufferWidth, device.PresentationParameters.BackBufferHeight, strFmt, strDepthFmt, strMultiSample);
            }
        }
    }
}