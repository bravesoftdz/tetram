using System;
using System.Collections.Generic;
using System.Text;
using Microsoft.DirectX.Direct3D;
using System.Drawing;
using Microsoft.DirectX;
using DXEngine;
using D3DFont = Microsoft.DirectX.Direct3D.Font;
using WinFont = System.Drawing.Font;

namespace BDX.Objects
{
    class Axes : Object3D, IRenderable
    {
        private VertexBuffer vBuffer;

        public Axes(Engine Engine) : base(Engine, "Axes") { }

        private CustomVertex.PositionColored[] Sommets = 
        {
            new CustomVertex.PositionColored(0.0f, 0.0f, 0.0f, Color.Red.ToArgb()),
            new CustomVertex.PositionColored(10.0f, 0.0f, 0.0f, Color.Red.ToArgb()),
            new CustomVertex.PositionColored(0.0f, 0.0f, 0.0f, Color.Blue.ToArgb()),
            new CustomVertex.PositionColored(0.0f, 10.0f, 0.0f, Color.Blue.ToArgb()),
            new CustomVertex.PositionColored(0.0f, 0.0f, 0.0f, Color.Green.ToArgb()),
            new CustomVertex.PositionColored(0.0f, 0.0f, 10.0f, Color.Green.ToArgb())
        };

        #region iObject Membres

        public void InitDevice(Device device, bool isReset)
        {
            vBuffer = new VertexBuffer(typeof(CustomVertex.PositionColored), Sommets.Length,
                device, 0, CustomVertex.PositionColored.Format, Pool.Default);
            vBuffer.SetData(Sommets, 0, LockFlags.None);
        }

        public void Render(Device device, DeviceInfo deviceInfo)
        {
            device.Transform.World = this.World;    
            // il faut désactiver la lumière sinon les couleurs ne sont pas utilisées
            device.RenderState.Lighting = false;

            device.SetStreamSource(0, vBuffer, 0);
            device.VertexFormat = CustomVertex.PositionColored.Format;
            device.DrawPrimitives(PrimitiveType.LineList, 0, Sommets.Length / 2);
        }

        public void LostDevice(Device device) { }
        #endregion
    }
}
