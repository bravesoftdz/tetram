using System;
using System.Collections.Generic;
using System.Text;
using DXEngine;
using Microsoft.DirectX.Direct3D;

namespace BDX
{
    public class BDXEngine : Engine
    {
        public List<D3DObject> objects = new List<D3DObject>();

        internal Sol sol;

        internal Device d3ddevice { get { return device; } }
        internal PresentParameters d3dpp { get { return presentParams; } }

        protected override void OneTimeSceneInitialization()
        {
            base.OneTimeSceneInitialization();

            // objects.Add(new Decor());
            sol = new Sol();
            objects.Add(sol);


            objects.Add(new Axes());
            objects.Add(new FrameRate());
        }

        protected override void InitializeDeviceObjects()
        {
            base.InitializeDeviceObjects();
            SetupDevice();
            foreach (D3DObject o in objects) o.InitDevice(device, false);
        }

        protected override void InvalidateDeviceObjects(object sender, EventArgs e)
        {
            base.InvalidateDeviceObjects(sender, e);
            foreach (D3DObject o in objects) o.LostDevice(device);
        }

        protected override void RestoreDeviceObjects(object sender, EventArgs e)
        {
            base.RestoreDeviceObjects(sender, e);
            SetupDevice();
            foreach (D3DObject o in objects) o.InitDevice(device, true);
        }

        protected void SetupDevice()
        {
            device.RenderState.ZBufferEnable = true;
            //device.RenderState.FillMode = FillMode.WireFrame;
            device.RenderState.CullMode = Cull.None;
        }
    }
}
