using System;
using System.Collections.Generic;
using System.Text;
using DXEngine;
using System.Drawing;
using Microsoft.DirectX.Direct3D;
using Microsoft.DirectX;
using Microsoft.DirectX.DirectInput;
using Direct3D = Microsoft.DirectX.Direct3D;
using DirectInput = Microsoft.DirectX.DirectInput;
using System.Windows.Forms;

namespace BDX
{
    public class BDXEngine : Engine
    {
        Inputs inputs = null;

        internal POV pov = new POV(new Vector3(5.0f, 5.0f, -5.0f), new Vector3(-1.0f, 0.0f, 1.0f));
        private float moveSpeed = 25.0f;

        public List<D3DObject> objects = new List<D3DObject>();

        internal Sol sol;

        internal Direct3D.Device d3ddevice { get { return device; } }
        internal PresentParameters d3dpp { get { return presentParams; } }

        public BDXEngine()
        {
            frameMoving = true;
            //startFullscreen = true;
        }

        protected override void OneTimeSceneInitialization()
        {
            base.OneTimeSceneInitialization();

            inputs = new Inputs(RenderTarget);

            inputs.ClearActionMaps();
            inputs.MapKeyboardAction(Key.Up, new ButtonAction(KeyUp), false);
            inputs.MapKeyboardAction(Key.Down, new ButtonAction(KeyDown), false);
            inputs.MapKeyboardAction(Key.Left, new ButtonAction(KeyLeft), false);
            inputs.MapKeyboardAction(Key.Right, new ButtonAction(KeyRight), false);
            inputs.MapKeyboardAction(Key.Home, new ButtonAction(KeyHome), false);
            inputs.MapKeyboardAction(Key.End, new ButtonAction(KeyEnd), false);
            inputs.MapMouseAxisAction(0, new AxisAction(MouseX));
            inputs.MapMouseAxisAction(1, new AxisAction(MouseY));  

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

        void SetupMatrices()
        {
            device.Transform.View = Matrix.LookAtLH(pov.Eye, pov.LookAt, new Vector3(0.0f, 1.0f, 0.0f));
            device.Transform.Projection = Matrix.PerspectiveFovLH((float)(Math.PI / 4), 1.0f, 1.0f, 1000.0f);
        }

        protected override void FrameMove()
        {
            inputs.Poll();
        }

        // Up Arrow Key - View moves forward
        private void KeyUp() { pov.Eye += pov.StraightOn * moveSpeed * elapsedTime; }
        // Down Arrow Key - View moves backward
        private void KeyDown() { pov.Eye -= pov.StraightOn * moveSpeed * elapsedTime; }
        // Right Arrow Key - View side-steps or strafes to the right
        private void KeyRight() { pov.Eye += pov.Right * moveSpeed * elapsedTime; }
        // Left Arrow Key - View side-steps or strafes to the left
        private void KeyLeft() { pov.Eye -= pov.Right * moveSpeed * elapsedTime; }
        // Home Key - View elevates up
        private void KeyHome() { pov.Eye += pov.Up * moveSpeed * elapsedTime; }
        // End Key - View elevates down
        private void KeyEnd() { pov.Eye -= pov.Up * moveSpeed * elapsedTime; }

        private void MouseX(int Count)
        {
            if (!inputs.IsMouseButtonDown(0)) return;
            Matrix matRotation = Matrix.RotationAxis(pov.Up, Geometry.DegreeToRadian(Count / 3.0f));
            pov.Look = Vector3.TransformCoordinate(pov.Look, matRotation);
        }
        private void MouseY(int Count)
        {
            if (!inputs.IsMouseButtonDown(0)) return;
            Matrix matRotation = Matrix.RotationAxis(pov.Right, Geometry.DegreeToRadian(Count / 3.0f));
            pov.Look = Vector3.TransformCoordinate(pov.Look, matRotation);
        }


        protected override void Render()
        {
            SetupLights();

            //Clear the backbuffer to a black color 
            ClearFlags flags = ClearFlags.Target | ClearFlags.ZBuffer;
            device.Clear(flags, System.Drawing.Color.Black, 1.0f, 0);

            SetupMatrices();

            //Begin the scene
            device.BeginScene();
            foreach (D3DObject o in objects)
                try
                {
                    o.Render(device);
                }
                finally
                {
                    device.Transform.World = Matrix.Identity;
                }           

            //End the scene
            device.EndScene();
        }
    }
}
