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
        public bool loading;

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

        }

        public bool InitializeGraphics()
        {
            Debug.WriteLine("InitializeGraphics()");
            
            engine.Prepare(this);

            //try
            //{
            //Caps caps = Direct3D.Manager.GetDeviceCaps(Direct3D.Manager.Adapters.Default.Adapter, Direct3D.DeviceType.Hardware);
            //CreateFlags flags;

            //if (caps.DeviceCaps.SupportsHardwareTransformAndLight)
            //    flags = CreateFlags.HardwareVertexProcessing;
            //else
            //    flags = CreateFlags.SoftwareVertexProcessing;

            //d3dpp.BackBufferFormat = Format.Unknown;
            //d3dpp.SwapEffect = SwapEffect.Discard;
            //d3dpp.Windowed = true;
            //d3dpp.EnableAutoDepthStencil = true;
            //d3dpp.AutoDepthStencilFormat = DepthFormat.D16;
            //d3dpp.PresentationInterval = PresentInterval.Immediate;
            //d3dpp.MultiSample = MultiSampleType.FourSamples;

            //device = new Direct3D.Device(0, Direct3D.DeviceType.Hardware, this, flags, d3dpp);

            //}
            //catch (DirectXException e)
            //{
            //    MessageBox.Show(e.Message);
            //    return false;
            //}
            return true;
        }

        private void Form1_Paint(object sender, PaintEventArgs e)
        {
            engine.FullRender();
            this.Invalidate();
        }

        private void Form1_KeyPress(object sender, KeyPressEventArgs e)
        {
            if ((int)(byte)e.KeyChar == (int)System.Windows.Forms.Keys.Escape)
                this.Dispose(); // Esc was pressed

            if (e.KeyChar == '+')
                engine.sol.lod++;

            if (e.KeyChar == '-')
                engine.sol.lod--;

            if (e.KeyChar == 'w')
                engine.d3ddevice.RenderState.FillMode = FillMode.WireFrame;

            if (e.KeyChar == 's')
                engine.d3ddevice.RenderState.FillMode = FillMode.Solid;

            if (e.KeyChar == ' ')
                engine.UserSelectNewDevice(null, null);
        }
    }
}