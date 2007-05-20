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
            return true;
        }

        private void Form1_Paint(object sender, PaintEventArgs e)
        {
            engine.FullRender();
            this.Invalidate();
        }

        private void Form1_KeyPress(object sender, KeyPressEventArgs e)
        {
            if (!DXEngine.Console.IsVisible)
            {
                if ((int)(byte)e.KeyChar == (int)System.Windows.Forms.Keys.Escape)
                    this.Dispose(); // Esc was pressed

                if (e.KeyChar == 'w')
                    engine.d3ddevice.RenderState.FillMode = FillMode.WireFrame;

                if (e.KeyChar == 's')
                    engine.d3ddevice.RenderState.FillMode = FillMode.Solid;

                if (e.KeyChar == ' ')
                    engine.UserSelectNewDevice(null, null);
            }
        }
    }
}