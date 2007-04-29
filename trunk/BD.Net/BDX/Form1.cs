using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Data;
using System.Drawing;
using System.Text;
using System.Windows.Forms;
using Microsoft.DirectX.Direct3D;
using Microsoft.DirectX;
using Microsoft.DirectX.DirectInput;
using Direct3D = Microsoft.DirectX.Direct3D;
using DirectInput = Microsoft.DirectX.DirectInput;
using System.Diagnostics;

namespace BDX
{
    public partial class Form1 : Form
    {
        private PresentParameters d3dpp = new PresentParameters();
        private Direct3D.Device device = null;
        private DirectInput.Device dinputDevice = null;
        List<D3DObject> objects = new List<D3DObject>();

        static private float elapsedTime;
        static private DateTime currentTime;
        static private DateTime lastTime;

        public bool loading;

        //        internal POV pov = new POV(new Vector3(5.0f, 5.0f, -5.0f), new Vector3(-0.5f, -0.5f, 0.5f));
        internal POV pov = new POV(new Vector3(5.0f, 5.0f, -5.0f), new Vector3(-1.0f, 0.0f, 1.0f));

        private Point ptLastMousePosit = new Point();
        private Point ptCurrentMousePosit = new Point();
        private bool mousing = false;
        private float moveSpeed = 25.0f;

        Sol sol;

        private bool lostDevice;

        BDXEngine engine = new BDXEngine();

        public bool Pause
        {
            get { return ((this.WindowState == FormWindowState.Minimized) || !this.Visible || !this.Focused || (this.Height <= 0)); }
        }

        public Form1()
        {
            Debug.WriteLine("form1 constructor");
            InitializeComponent();

            this.ClientSize = new System.Drawing.Size(800, 600);
            this.SetStyle(ControlStyles.AllPaintingInWmPaint | ControlStyles.Opaque, true);

            engine.Prepare(this);

            // objects.Add(new Decor());
            sol = new Sol();
            objects.Add(sol);


            objects.Add(new Axes());
            objects.Add(new FrameRate());
        }

        public bool InitializeGraphics()
        {
            Debug.WriteLine("InitializeGraphics()");
            //try
            //{
            Caps caps = Direct3D.Manager.GetDeviceCaps(Direct3D.Manager.Adapters.Default.Adapter, Direct3D.DeviceType.Hardware);
            CreateFlags flags;

            if (caps.DeviceCaps.SupportsHardwareTransformAndLight)
                flags = CreateFlags.HardwareVertexProcessing;
            else
                flags = CreateFlags.SoftwareVertexProcessing;

            d3dpp.BackBufferFormat = Format.Unknown;
            d3dpp.SwapEffect = SwapEffect.Discard;
            d3dpp.Windowed = true;
            d3dpp.EnableAutoDepthStencil = true;
            d3dpp.AutoDepthStencilFormat = DepthFormat.D16;
            d3dpp.PresentationInterval = PresentInterval.Immediate;
            d3dpp.MultiSample = MultiSampleType.FourSamples;

            device = new Direct3D.Device(0, Direct3D.DeviceType.Hardware, this, flags, d3dpp);
            device.DeviceReset += new System.EventHandler(this.OnResetDevice);
            device.DeviceLost += new System.EventHandler(this.OnLostDevice);
            //device.DeviceResizing += new System.ComponentModel.CancelEventHandler(this.OnResizeDevice);
            OnCreateDevice(device, null);

            dinputDevice = new DirectInput.Device(SystemGuid.Keyboard);
            dinputDevice.SetCooperativeLevel(this, CooperativeLevelFlags.Background | CooperativeLevelFlags.NonExclusive);
            dinputDevice.Acquire();
            //}
            //catch (DirectXException e)
            //{
            //    MessageBox.Show(e.Message);
            //    return false;
            //}
            return true;
        }

        public void OnCreateDevice(object sender, EventArgs e)
        {
            Debug.WriteLine("OnCreateDevice(object sender, EventArgs e)");
            Direct3D.Device dev = (Direct3D.Device)sender;
            SetupDevice();
            foreach (D3DObject o in objects) o.InitDevice(dev, false);
        }

        public void OnLostDevice(object sender, EventArgs e)
        {
            Debug.WriteLine("OnLostDevice(object sender, EventArgs e)");
            lostDevice = true;
            Direct3D.Device dev = (Direct3D.Device)sender;
            foreach (D3DObject o in objects) o.LostDevice(dev);
        }

        public void OnResetDevice(object sender, EventArgs e)
        {
            Debug.WriteLine("OnResetDevice(object sender, EventArgs e)");
            Direct3D.Device dev = (Direct3D.Device)sender;
            SetupDevice();
            foreach (D3DObject o in objects) o.InitDevice(dev, true);
        }

        public void OnResizeDevice(object sender, CancelEventArgs e)
        {
            Debug.WriteLine("OnResizeDevice(object sender, CancelEventArgs e)");
            e.Cancel = true;
        }

        protected void AttemptRecovery()
        {
            Debug.WriteLine("AttemptRecovery()");
            try
            {
                device.TestCooperativeLevel();
                lostDevice = false;
            }
            catch (DeviceLostException)
            {
            }
            catch (DeviceNotResetException)
            {
                try
                {
                    device.Reset(d3dpp);
                    lostDevice = false;
                }
                catch (DeviceLostException)
                {
                    // Si c'est toujours perdu ou que ca a encore été perdu, ne fait rien
                }
            }
        }

        protected void SetupDevice()
        {
            device.RenderState.ZBufferEnable = true;
            //device.RenderState.FillMode = FillMode.WireFrame;
            device.RenderState.CullMode = Cull.None;
        }

        protected void SetupLights()
        {
            device.RenderState.FogEnable = true;
            device.RenderState.FogColor = Color.Gray;
            device.RenderState.FogStart = 80.0f;
            device.RenderState.FogEnd = 500.0f;
            device.RenderState.FogTableMode = FogMode.Linear;

            device.RenderState.Lighting = true;

            device.Lights[0].Diffuse = Color.White;
            device.Lights[0].Specular = Color.White;
            device.Lights[0].Type = LightType.Directional;
            device.Lights[0].Direction = new Vector3(-1, -1, 3);
            //            device.Lights[0].Commit();
            device.Lights[0].Enabled = true;

            device.RenderState.Ambient = Color.White;
        }

        protected void SetupMaterials(Color color)
        {
            //Material mat = new Material();
            //mat.Ambient = color;
            //device.Material = mat;
        }

        void SetupMatrices()
        {
            device.Transform.View = Matrix.LookAtLH(pov.Eye, pov.LookAt, new Vector3(0.0f, 1.0f, 0.0f));
            device.Transform.Projection = Matrix.PerspectiveFovLH((float)(Math.PI / 4), 1.0f, 1.0f, 1000.0f);
        }

        public void Render()
        {
            if (loading) return;

            if (lostDevice) AttemptRecovery();
            if (lostDevice) return;

            currentTime = DateTime.Now;
            TimeSpan elapsedTimeSpan = currentTime.Subtract(lastTime);
            elapsedTime = (float)elapsedTimeSpan.Milliseconds * 0.001f;
            lastTime = currentTime;

            if (device == null) return;
            if (Pause) return;

            int i = int.Parse(this.Text) + 1;
            this.Text = i.ToString();

            SetupLights();

            //Clear the backbuffer to a black color 
            ClearFlags flags = ClearFlags.Target;
            if (device.RenderState.ZBufferEnable) flags |= ClearFlags.ZBuffer;
            device.Clear(flags, System.Drawing.Color.Black, 1.0f, 0);

            UpdatePOV();
            SetupMatrices();

            SetupMaterials(Color.White);

            //Begin the scene
            device.BeginScene();
            Matrix oldWorld = device.Transform.World;
            foreach (D3DObject o in objects)
                try
                {
                    o.Render(device);
                }
                finally
                {
                    device.Transform.World = oldWorld;
                }


            //End the scene
            device.EndScene();
            device.Present();
        }

        private void UpdatePOV()
        {
            ptCurrentMousePosit.X = Cursor.Position.X;
            ptCurrentMousePosit.Y = Cursor.Position.Y;

            Vector3 currentLookAt = pov.LookAt;

            if (mousing)
            {
                Matrix matRotation =
                    Matrix.RotationAxis(pov.Right, Geometry.DegreeToRadian((float)(ptCurrentMousePosit.Y - ptLastMousePosit.Y) / 3.0f)) +
                    Matrix.RotationAxis(pov.Up, Geometry.DegreeToRadian((float)(ptCurrentMousePosit.X - ptLastMousePosit.X) / 3.0f));
                pov.Look = Vector3.TransformCoordinate(pov.Look, matRotation);
            }

            ptLastMousePosit.X = ptCurrentMousePosit.X;
            ptLastMousePosit.Y = ptCurrentMousePosit.Y;

            if (dinputDevice != null)
            {
                KeyboardState keys = dinputDevice.GetCurrentKeyboardState();

                // Up Arrow Key - View moves forward
                if (keys[Key.Up])
                    pov.Eye += pov.StraightOn * moveSpeed * elapsedTime;

                // Down Arrow Key - View moves backward
                if (keys[Key.Down])
                    pov.Eye -= pov.StraightOn * moveSpeed * elapsedTime;

                // Left Arrow Key - View side-steps or strafes to the left
                if (keys[Key.Left])
                    pov.Eye -= pov.Right * moveSpeed * elapsedTime;

                // Right Arrow Key - View side-steps or strafes to the right
                if (keys[Key.Right])
                    pov.Eye += pov.Right * moveSpeed * elapsedTime;

                // Home Key - View elevates up
                if (keys[Key.Home])
                    pov.Eye += pov.Up * moveSpeed * elapsedTime;

                // End Key - View elevates down
                if (keys[Key.End])
                    pov.Eye -= pov.Up * moveSpeed * elapsedTime;
            }
        }

        private void Form1_Paint(object sender, PaintEventArgs e)
        {
            this.Render();
            this.Invalidate();
        }

        private void Form1_KeyPress(object sender, KeyPressEventArgs e)
        {
            if ((int)(byte)e.KeyChar == (int)System.Windows.Forms.Keys.Escape)
                this.Dispose(); // Esc was pressed

            if (e.KeyChar == '+')
                sol.lod++;

            if (e.KeyChar == '-')
                sol.lod--;

            if (e.KeyChar == 'w')
                device.RenderState.FillMode = FillMode.WireFrame;

            if (e.KeyChar == 's')
                device.RenderState.FillMode = FillMode.Solid;

            if (e.KeyChar == ' ')
                engine.DoSelectNewDevice();
        }

        private void Form1_MouseDown(object sender, MouseEventArgs e)
        {
            mousing = true;
        }

        private void Form1_MouseUp(object sender, MouseEventArgs e)
        {
            mousing = false;
        }
    }
}