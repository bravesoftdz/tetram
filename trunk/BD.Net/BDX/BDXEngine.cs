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
using BDX.Objects;

namespace BDX
{
    public class BDXEngine : Engine
    {
        Inputs inputs = null;

        internal POV pov = new POV(new Vector3(-78.0f, 63.0f, -18.0f), new Vector3(0.92f, -0.2f, 0.3f));
        private float moveSpeed = 25.0f;
        StateBlock initState;

        public List<IRenderable> objects = new List<IRenderable>();

        public DXEngine.Console console;

        internal Direct3D.Device d3ddevice { get { return device; } }
        internal PresentParameters d3dpp { get { return presentParams; } }

        public BDXEngine()
        {
            frameMoving = true;
            console = new DXEngine.Console(new GraphicsFont("Arial", System.Drawing.FontStyle.Regular, 12), @"Media\floor 2.jpg", this);
        }

        public override bool Prepare(Form target)
        {
            target.KeyDown += new KeyEventHandler(DXEngine.Console.ProcessKey);
            return base.Prepare(target);
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
            inputs.MapMouseAxisAction(Axis.X, new AxisAction(MouseX));
            inputs.MapMouseAxisAction(Axis.Y, new AxisAction(MouseY));

            // objects.Add(new Decor());
            //objects.Add(new SkyDome(@"Media\Dome\sky15.jpg", 60, 24, 0.5f, 1f));
            //            objects.Add(new SkyDome(@"Media\Dome\Sky_083004_layered_A.jpg", 60, 24, 0.92f, 1f));
            objects.Add(new SkyDome(@"Media\Dome\ALT022-01-sun.png", 60, 24, 1f, 1f));

            Sol sol = new Sol(this);
            objects.Add(sol);

            Feu feu = new Feu(this, null);
            feu.Position = new Vector3(105, 4, 1);
            objects.Add(feu);

            objects.Add(new Axes(this));
            objects.Add(new FrameRate(this));
            objects.Add(pov);

            //objects.Add(console);
        }

        protected override void InitializeDeviceObjects()
        {
            base.InitializeDeviceObjects();
            SetupDevice();
            SetupMatrices();
            SetupLights();
            initState = new StateBlock(device, StateBlockType.All);
            foreach (IRenderable o in objects) o.InitDevice(device, false);
        }

        protected override void InvalidateDeviceObjects(object sender, EventArgs e)
        {
            base.InvalidateDeviceObjects(sender, e);
            foreach (IRenderable o in objects) o.LostDevice(device);
        }

        protected override void RestoreDeviceObjects(object sender, EventArgs e)
        {
            base.RestoreDeviceObjects(sender, e);
            // Restore the device objects for the meshes and fonts

            // Set the transform matrices (view and world are updated per frame)
            Matrix matProj;
            float fAspect = device.PresentationParameters.BackBufferWidth / (float)device.PresentationParameters.BackBufferHeight;
            matProj = Matrix.PerspectiveFovLH((float)Math.PI / 4, fAspect, 1.0f, 100.0f);
            device.Transform.Projection = matProj;

            // Set up the default texture states
            device.TextureState[0].ColorOperation = TextureOperation.Modulate;
            device.TextureState[0].ColorArgument1 = TextureArgument.TextureColor;
            device.TextureState[0].ColorArgument2 = TextureArgument.Diffuse;
            device.TextureState[0].AlphaOperation = TextureOperation.SelectArg1;
            device.TextureState[0].AlphaArgument1 = TextureArgument.TextureColor;
            device.SamplerState[0].MinFilter = TextureFilter.Linear;
            device.SamplerState[0].MagFilter = TextureFilter.Linear;
            device.SamplerState[0].MipFilter = TextureFilter.Linear;
            device.SamplerState[0].AddressU = TextureAddress.Clamp;
            device.SamplerState[0].AddressV = TextureAddress.Clamp;

            device.RenderState.DitherEnable = true;

            SetupDevice();
            foreach (IRenderable o in objects) o.InitDevice(device, true);
        }

        protected void SetupDevice()
        {
            device.RenderState.ZBufferEnable = deviceInfo.ZEnabled = true;
            //device.RenderState.FillMode = FillMode.WireFrame;
            device.RenderState.CullMode = Cull.None;
            device.RenderState.NormalizeNormals = true;
        }

        protected void SetupLights()
        {
            device.RenderState.FogEnable = deviceInfo.FogEnabled = true;
            device.RenderState.FogColor = Color.WhiteSmoke;
            device.RenderState.FogStart = 80.0f;
            device.RenderState.FogEnd = 5000.0f;
            device.RenderState.FogTableMode = FogMode.Linear;

            if (device.DeviceCaps.MaxActiveLights == 0)
            {
                device.RenderState.Ambient = Color.WhiteSmoke;
            }
            else if (device.DeviceCaps.MaxActiveLights > 1)
            {
                int l = -1;

                // soleil
                if (++l <= device.DeviceCaps.MaxActiveLights)
                {
                    device.Lights[l].Diffuse = Color.LightYellow;
                    device.Lights[l].Type = LightType.Directional;
                    device.Lights[l].Direction = new Vector3(-0.4f, -1, 0);
                    device.Lights[l].Enabled = true;
                }

                if (++l <= device.DeviceCaps.MaxActiveLights)
                {
                    //device.Lights[l].Diffuse = Color.White;
                    //device.Lights[l].Specular = Color.White;
                    //device.Lights[l].Type = LightType.Point;
                    //device.Lights[l].Attenuation0 = 0.5f;
                    //device.Lights[l].Ambient = Color.WhiteSmoke;
                    //device.Lights[l].Range = 170;
                    //device.Lights[l].Position = pov.Eye;// new Vector3(-78.0f, 63.0f, -18.0f);
                    //device.Lights[l].Enabled = true;
                }
            }
            device.RenderState.Lighting = true;
        }

        void SetupMatrices()
        {
            device.Transform.World = deviceInfo.World = Matrix.Identity;
            device.Transform.View = deviceInfo.View = pov.View;
            device.Transform.Projection = deviceInfo.Projection = pov.Perspective;
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
            //Clear the backbuffer to a black color
            device.Clear(ClearFlags.Target | ClearFlags.ZBuffer, System.Drawing.Color.Black, 1.0f, 0);

            SetupMatrices();
            initState.Capture();

            //Begin the scene
            device.BeginScene();
            foreach (IRenderable o in objects)
                if (!(o is Object3D) || pov.IsInViewFrustum((Object3D)o))
                {
                    o.Render(device, deviceInfo);
                    initState.Apply();
                }

            //End the scene
            device.EndScene();
        }
    }
}