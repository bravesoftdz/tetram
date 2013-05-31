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
    public class BDXEngine
    {
        Inputs inputs = null;

        internal POV pov = POV.Instance;
        private float moveSpeed = 25.0f;
        StateBlock initState;

        public List<IRenderable> objects = new List<IRenderable>();

        public DXEngine.Console console;
        private Engine engine = Engine.Instance;

        public BDXEngine()
        {
            engine.Prepare += new PrepareEvent(this.Prepare);
            engine.OneTimeSceneInitialization += new OneTimeSceneInitializationEvent(OneTimeSceneInitialization);
            engine.InitializeDeviceObjects += new InitializeDeviceObjectsEvent(InitializeDeviceObjects);
            engine.InvalidateDeviceObjects += new InvalidateDeviceObjectsEvent(InvalidateDeviceObjects);
            engine.RestoreDeviceObjects += new RestoreDeviceObjectsEvent(RestoreDeviceObjects);
            engine.FrameMove += new FrameMoveEvent(FrameMove);
            engine.Render += new RenderEvent(Render);
        }

        public bool Prepare(Form target)
        {
            console = new DXEngine.Console(new GraphicsFont("Arial", System.Drawing.FontStyle.Regular, 12), @"Media\floor 2.jpg");
            target.KeyDown += new KeyEventHandler(DXEngine.Console.ProcessKey);
            return true;
        }

        protected void OneTimeSceneInitialization()
        {
            inputs = new Inputs(engine.RenderTarget);

            inputs.ClearActionMaps();
            inputs.MapKeyboardAction(Key.Up, new ButtonAction(KeyUp), false);
            inputs.MapKeyboardAction(Key.Down, new ButtonAction(KeyDown), false);
            inputs.MapKeyboardAction(Key.Left, new ButtonAction(KeyLeft), false);
            inputs.MapKeyboardAction(Key.Right, new ButtonAction(KeyRight), false);
            inputs.MapKeyboardAction(Key.Home, new ButtonAction(KeyHome), false);
            inputs.MapKeyboardAction(Key.End, new ButtonAction(KeyEnd), false);
            inputs.MapMouseAxisAction(Axis.X, new AxisAction(MouseX));
            inputs.MapMouseAxisAction(Axis.Y, new AxisAction(MouseY));

            pov.Position(new Vector3(-78.0f, 17.7f, -18.0f), new Vector3(0.92f, -0.2f, 0.3f)); 
            
            objects.Add(TimeLine.Instance);

            // objects.Add(new Decor());
            //objects.Add(new SkyDome(@"Media\Dome\sky15.jpg", 60, 24, 0.5f, 1f));
            //            objects.Add(new SkyDome(@"Media\Dome\Sky_083004_layered_A.jpg", 60, 24, 0.92f, 1f));
            objects.Add(new SkyDome(@"Media\Dome\ALT022-01-sun.png", 60, 24, 1f, 1f));

            Sol sol = new Sol();
            objects.Add(sol);

            Cheminee cheminee = new Cheminee();
            cheminee.Parent = sol;
            objects.Add(cheminee);    

            Feu feu = new Feu(null);
            feu.Position = new Vector3(95, 4, 2);
            objects.Add(feu);         
            feu = new Feu(null);
            feu.Position = new Vector3(95, 4, -9);
            objects.Add(feu);         
            feu = new Feu(null);      
            feu.Position = new Vector3(94, 5, -4);
            objects.Add(feu);
            feu = new Feu(null);
            feu.Position = new Vector3(95, 4, 7);
            objects.Add(feu);

            //Bougie bougie = new Bougie(null);
            //bougie.Position = new Vector3(105, 4, 1);
            //objects.Add(bougie);

            objects.Add(new Axes());
            objects.Add(new FrameRate());
            objects.Add(pov);

            objects.Add(console);
        }

        protected void InitializeDeviceObjects()
        {
            SetupDevice();
            SetupMatrices();
            SetupLights();
            initState = new StateBlock(engine.Device, StateBlockType.All);
            foreach (IRenderable o in objects) o.InitDevice(engine.Device, false);
        }

        protected void InvalidateDeviceObjects(object sender, EventArgs e)
        {
            foreach (IRenderable o in objects) o.LostDevice(engine.Device);
        }

        protected void RestoreDeviceObjects(object sender, EventArgs e)
        {
            // Restore the device objects for the meshes and fonts

            // Set the transform matrices (view and world are updated per frame)
            Matrix matProj;
            float fAspect = engine.Device.PresentationParameters.BackBufferWidth / (float)engine.Device.PresentationParameters.BackBufferHeight;
            matProj = Matrix.PerspectiveFovLH((float)Math.PI / 4, fAspect, 1.0f, 100.0f);
            engine.Device.Transform.Projection = matProj;

            // Set up the default texture states
            engine.Device.TextureState[0].ColorOperation = TextureOperation.Modulate;
            engine.Device.TextureState[0].ColorArgument1 = TextureArgument.TextureColor;
            engine.Device.TextureState[0].ColorArgument2 = TextureArgument.Diffuse;
            engine.Device.TextureState[0].AlphaOperation = TextureOperation.SelectArg1;
            engine.Device.TextureState[0].AlphaArgument1 = TextureArgument.TextureColor;
            engine.Device.SamplerState[0].MinFilter = TextureFilter.Linear;
            engine.Device.SamplerState[0].MagFilter = TextureFilter.Linear;
            engine.Device.SamplerState[0].MipFilter = TextureFilter.Linear;
            engine.Device.SamplerState[0].AddressU = TextureAddress.Wrap;
            engine.Device.SamplerState[0].AddressV = TextureAddress.Wrap;

            engine.Device.RenderState.DitherEnable = true;

            SetupDevice();
            foreach (IRenderable o in objects) o.InitDevice(engine.Device, true);
        }

        protected void SetupDevice()
        {
            engine.Device.RenderState.ZBufferEnable = true;
            //engine.Device.RenderState.FillMode = FillMode.WireFrame;
            engine.Device.RenderState.CullMode = Cull.None;
            engine.Device.RenderState.NormalizeNormals = true;
        }

        protected void SetupLights()
        {
            engine.Device.RenderState.FogEnable = true;
            engine.Device.RenderState.FogColor = Color.WhiteSmoke;
            engine.Device.RenderState.FogStart = 80.0f;
            engine.Device.RenderState.FogEnd = 5000.0f;
            engine.Device.RenderState.FogTableMode = FogMode.Linear;

            //engine.Device.RenderState.Ambient = Color.WhiteSmoke;
            if (engine.Device.DeviceCaps.MaxActiveLights == 0)
            {
                engine.Device.RenderState.Ambient = Color.WhiteSmoke;
            }
            else if (engine.Device.DeviceCaps.MaxActiveLights > 1)
            {
                int l = -1;

                // soleil
                if (++l <= engine.Device.DeviceCaps.MaxActiveLights)
                {
                    engine.Device.Lights[l].Diffuse = Color.LightYellow;
                    engine.Device.Lights[l].Type = LightType.Directional;
                    engine.Device.Lights[l].Direction = new Vector3(-0.4f, -1, 0);
                    engine.Device.Lights[l].Enabled = true;
                }

                if (++l <= engine.Device.DeviceCaps.MaxActiveLights)
                {
                    //engine.Device.Lights[l].Diffuse = Color.White;
                    //engine.Device.Lights[l].Specular = Color.White;
                    //engine.Device.Lights[l].Type = LightType.Point;
                    //engine.Device.Lights[l].Attenuation0 = 0.5f;
                    //engine.Device.Lights[l].Ambient = Color.WhiteSmoke;
                    //engine.Device.Lights[l].Range = 170;
                    //engine.Device.Lights[l].Position = pov.Eye;// new Vector3(-78.0f, 63.0f, -18.0f);
                    //engine.Device.Lights[l].Enabled = true;
                }
            }
            engine.Device.RenderState.Lighting = true;
        }

        void SetupMatrices()
        {
            engine.Device.Transform.World = engine.DeviceInfo.World = Matrix.Identity;
            engine.Device.Transform.View = engine.DeviceInfo.View = pov.View;
            engine.Device.Transform.Projection = engine.DeviceInfo.Projection = pov.Perspective;
        }

        protected void FrameMove()
        {
            inputs.Poll();
        }

        // Up Arrow Key - View moves forward
        private void KeyUp() { pov.Eye += pov.StraightOn * moveSpeed * engine.ElapsedTime; }
        // Down Arrow Key - View moves backward
        private void KeyDown() { pov.Eye -= pov.StraightOn * moveSpeed * engine.ElapsedTime; }
        // Right Arrow Key - View side-steps or strafes to the right
        private void KeyRight() { pov.Eye += pov.Right * moveSpeed * engine.ElapsedTime; }
        // Left Arrow Key - View side-steps or strafes to the left
        private void KeyLeft() { pov.Eye -= pov.Right * moveSpeed * engine.ElapsedTime; }
        // Home Key - View elevates up
        private void KeyHome() { pov.Eye += pov.Up * moveSpeed * engine.ElapsedTime; }
        // End Key - View elevates down
        private void KeyEnd() { pov.Eye -= pov.Up * moveSpeed * engine.ElapsedTime; }

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


        protected void Render()
        {
            //Clear the backbuffer to a black color
            engine.Device.Clear(ClearFlags.Target | ClearFlags.ZBuffer, System.Drawing.Color.Black, 1.0f, 0);

            SetupMatrices();
            initState.Capture();

            //Begin the scene
            engine.Device.BeginScene();
            foreach (IRenderable o in objects)
                if (!(o is Object3D) || pov.IsInViewFrustum((Object3D)o))
                {
                    o.Render(engine.Device, engine.DeviceInfo);
                    initState.Apply();
                }

            //End the scene
            engine.Device.EndScene();
        }
    }
}