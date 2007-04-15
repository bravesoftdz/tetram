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

namespace BDX
{
    public partial class Form1 : Form
    {
        private Direct3D.Device device = null;
        private DirectInput.Device dinputDevice = null;
        Decor decor = new Decor();

        static private float elapsedTime;
        static private DateTime currentTime;
        static private DateTime lastTime;

        private Vector3 vEye = new Vector3(5.0f, 5.0f, -5.0f);  // Eye Position
        private Vector3 vLook = new Vector3(-0.5f, -0.5f, 0.5f); // Look Vector
        private Vector3 vUp = new Vector3(0.0f, 1.0f, 0.0f);   // Up Vector
        private Vector3 vRight = new Vector3(1.0f, 0.0f, 0.0f);   // Right Vector

        private Point ptLastMousePosit = new Point();
        private Point ptCurrentMousePosit = new Point();
        private bool mousing = false;
        private float moveSpeed = 25.0f;
        
        public bool Pause
        {
            get { return ((this.WindowState == FormWindowState.Minimized) || !this.Visible || !this.Focused || (this.Height <= 0)); }
        }

        public Form1()
        {
            InitializeComponent();
            this.SetStyle(ControlStyles.AllPaintingInWmPaint | ControlStyles.Opaque, true);
        }

        public bool InitializeGraphics()
        {
            try
            {
                Caps caps = Direct3D.Manager.GetDeviceCaps(Direct3D.Manager.Adapters.Default.Adapter, Direct3D.DeviceType.Hardware);
                CreateFlags flags;

                if (caps.DeviceCaps.SupportsHardwareTransformAndLight)
                    flags = CreateFlags.HardwareVertexProcessing;
                else
                    flags = CreateFlags.SoftwareVertexProcessing;

                PresentParameters d3dpp = new PresentParameters();

                d3dpp.BackBufferFormat = Format.Unknown;
                d3dpp.SwapEffect = SwapEffect.Discard;
                d3dpp.Windowed = true;
                d3dpp.EnableAutoDepthStencil = true;
                d3dpp.AutoDepthStencilFormat = DepthFormat.D16;
                d3dpp.PresentationInterval = PresentInterval.Immediate;

                device = new Direct3D.Device(0, Direct3D.DeviceType.Hardware, this, flags, d3dpp);
                device.DeviceReset += new System.EventHandler(this.OnResetDevice);
                OnCreateDevice(device, null);
                OnResetDevice(device, null);

                dinputDevice = new DirectInput.Device(SystemGuid.Keyboard);
                dinputDevice.SetCooperativeLevel(this, CooperativeLevelFlags.Background | CooperativeLevelFlags.NonExclusive);
                dinputDevice.Acquire();
            }
            catch (DirectXException)
            {
                return false;
            }
            return true;
        }

        public void OnCreateDevice(object sender, EventArgs e)
        {
            Direct3D.Device dev = (Direct3D.Device)sender;
            decor.CreateDevice(dev);
        }

        public void OnResetDevice(object sender, EventArgs e)
        {
            //ExtendedMaterial[] materials = null;

            //// Set the directory up two to load the right data (since the default build location is bin\debug or bin\release
            //Directory.SetCurrentDirectory(Application.StartupPath + @"\..\..\");

            Direct3D.Device dev = (Direct3D.Device)sender;

            dev.Transform.Projection =
                Matrix.PerspectiveFovLH(Geometry.DegreeToRadian(45.0f),
                (float)this.ClientSize.Width / this.ClientSize.Height,
                0.1f, 100.0f);

            dev.RenderState.Lighting = false;
            //dev.RenderState.FillMode = FillMode.WireFrame;
            dev.RenderState.CullMode = Cull.None;

            // Load the mesh from the specified file
            //mesh = Mesh.FromFile("tiger.x", MeshFlags.SystemMemory, device, out materials);

            //if (meshTextures == null)
            //{
            //    // We need to extract the material properties and texture names 
            //    meshTextures = new Texture[materials.Length];
            //    meshMaterials = new Direct3D.Material[materials.Length];
            //    for (int i = 0; i < materials.Length; i++)
            //    {
            //        meshMaterials[i] = materials[i].Material3D;
            //        // Set the ambient color for the material (D3DX does not do this)
            //        meshMaterials[i].Ambient = meshMaterials[i].Diffuse;

            //        // Create the texture
            //        meshTextures[i] = TextureLoader.FromFile(dev, materials[i].TextureFilename);
            //    }
            //}
        }

        protected void SetupDevice()
        {
            // device.RenderState.ZBufferEnable = true;
        }

        protected void SetupLights()
        {
            //device.RenderState.Lighting = true;
            //device.RenderState.Ambient = Color.White;
        }

        protected void SetupMaterials(Color color)
        {
            //Material mat = new Material();
            //mat.Ambient = color;
            //device.Material = mat;
        }

        void SetupMatrices()
        {
            // For our world matrix, we will just leave it as the identity
            int iTime = Environment.TickCount % 1000;
            float fAngle = iTime * (2.0f * (float)Math.PI) / 1000.0f;
            device.Transform.World = Matrix.RotationY(fAngle);

            // Set up our view matrix. A view matrix can be defined given an eye point,
            // a point to lookat, and a direction for which way is up. Here, we set the
            // eye five units back along the z-axis and up three units, look at the 
            // origin, and define "up" to be in the y-direction.
            device.Transform.View = Matrix.LookAtLH(new Vector3(0.0f, 3.0f, -5.0f),
                new Vector3(0.0f, 0.0f, 0.0f),
                new Vector3(0.0f, 1.0f, 0.0f));

            // For the projection matrix, we set up a perspective transform (which
            // transforms geometry from 3D view space to 2D viewport space, with
            // a perspective divide making objects smaller in the distance). To build
            // a perpsective transform, we need the field of view (1/4 pi is common),
            // the aspect ratio, and the near and far clipping planes (which define at
            // what distances geometry should be no longer be rendered).
            device.Transform.Projection = Matrix.PerspectiveFovLH((float)(Math.PI / 4), 1.0f, 1.0f, 100.0f);
        }

        public void Render()
        {
            if (device == null) return;
            if (Pause) return;

            int i = int.Parse(this.Text) + 1;
            this.Text = i.ToString();

            SetupDevice();
            SetupLights();

            //Clear the backbuffer to a blue color 
            device.Clear(ClearFlags.Target/* | ClearFlags.ZBuffer*/, System.Drawing.Color.Blue, 1.0f, 0);

            GetRealTimeUserInput();
            UpdateViewMatrix();

            //SetupMaterials(Color.White);

            //Begin the scene
            device.BeginScene();
            //// Setup the world, view, and projection matrices
            //SetupMatrices();

            decor.Render(device);
            //// Meshes are divided into subsets, one for each material. Render them in
            //// a loop
            //for (int i = 0; i < meshMaterials.Length; i++)
            //{
            //    // Set the material and texture for this subset
            //    device.Material = meshMaterials[i];
            //    device.SetTexture(0, meshTextures[i]);

            //    // Draw the mesh subset
            //    mesh.DrawSubset(i);
            //}

            //End the scene
            device.EndScene();
            device.Present();
        }

        private void Form1_Paint(object sender, PaintEventArgs e)
        {
            currentTime = DateTime.Now;
            TimeSpan elapsedTimeSpan = currentTime.Subtract(lastTime);
            elapsedTime = (float)elapsedTimeSpan.Milliseconds * 0.001f;
            lastTime = currentTime;

            this.Render();
            this.Invalidate();
        }

        private void Form1_KeyPress(object sender, KeyPressEventArgs e)
        {
            if ((int)(byte)e.KeyChar == (int)System.Windows.Forms.Keys.Escape)
                this.Dispose(); // Esc was pressed
        }

        private void Form1_MouseDown(object sender, MouseEventArgs e)
        {
            mousing = true;
        }

        private void Form1_MouseUp(object sender, MouseEventArgs e)
        {
            mousing = false;
        }

        private void GetRealTimeUserInput()
        {
            ptCurrentMousePosit.X = Cursor.Position.X;
            ptCurrentMousePosit.Y = Cursor.Position.Y;

            Matrix matRotation;

            if (mousing)
            {
                int nXDiff = (ptCurrentMousePosit.X - ptLastMousePosit.X);
                int nYDiff = (ptCurrentMousePosit.Y - ptLastMousePosit.Y);

                if (nYDiff != 0)
                {
                    matRotation = Matrix.RotationAxis(vRight, Geometry.DegreeToRadian((float)nYDiff / 3.0f));
                    vLook = Vector3.TransformCoordinate(vLook, matRotation);
                    vUp = Vector3.TransformCoordinate(vUp, matRotation);

                }

                if (nXDiff != 0)
                {
                    Vector3 vTemp = new Vector3(0.0f, 1.0f, 0.0f);
                    matRotation = Matrix.RotationAxis(vTemp, Geometry.DegreeToRadian((float)nXDiff / 3.0f));
                    vLook = Vector3.TransformCoordinate(vLook, matRotation);
                    vUp = Vector3.TransformCoordinate(vUp, matRotation);
                }
            }

            ptLastMousePosit.X = ptCurrentMousePosit.X;
            ptLastMousePosit.Y = ptCurrentMousePosit.Y;

            //
            // Get keyboard input...
            //

            Vector3 tmpLook = new Vector3();
            Vector3 tmpRight = new Vector3();
            tmpLook = vLook;
            tmpRight = vRight;

            KeyboardState keys = dinputDevice.GetCurrentKeyboardState();

            // Up Arrow Key - View moves forward
            if (keys[Key.Up])
                vEye -= tmpLook * -moveSpeed * elapsedTime;

            // Down Arrow Key - View moves backward
            if (keys[Key.Down])
                vEye += (tmpLook * -moveSpeed) * elapsedTime;

            // Left Arrow Key - View side-steps or strafes to the left
            if (keys[Key.Left])
                vEye -= (tmpRight * moveSpeed) * elapsedTime;

            // Right Arrow Key - View side-steps or strafes to the right
            if (keys[Key.Right])
                vEye += (tmpRight * moveSpeed) * elapsedTime;

            // Home Key - View elevates up
            if (keys[Key.Home])
                vEye.Y += moveSpeed * elapsedTime;

            // End Key - View elevates down
            if (keys[Key.End])
                vEye.Y -= moveSpeed * elapsedTime;
        }
    
        private void UpdateViewMatrix()
        {
            Matrix view = Matrix.Identity;

            vLook = Vector3.Normalize(vLook);
            vRight = Vector3.Cross(vUp, vLook);
            vRight = Vector3.Normalize(vRight);
            vUp = Vector3.Cross(vLook, vRight);
            Vector3.Normalize(vUp);

            view.M11 = vRight.X;
            view.M12 = vUp.X;
            view.M13 = vLook.X;
            view.M14 = 0.0f;

            view.M21 = vRight.Y;
            view.M22 = vUp.Y;
            view.M23 = vLook.Y;
            view.M24 = 0.0f;

            view.M31 = vRight.Z;
            view.M32 = vUp.Z;
            view.M33 = vLook.Z;
            view.M34 = 0.0f;

            view.M41 = -Vector3.Dot(vEye, vRight);
            view.M42 = -Vector3.Dot(vEye, vUp);
            view.M43 = -Vector3.Dot(vEye, vLook);
            view.M44 = 1.0f;

            device.Transform.View = view;
        }
    }
}