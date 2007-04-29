using System;
using System.Collections.Generic;
using System.Text;
using Microsoft.DirectX.Direct3D;
using System.Drawing;
using Microsoft.DirectX;

namespace BDX
{
    class Decor : D3DObject
    {

        private VertexBuffer vBuffer;

        private CustomVertex.PositionColored[] Sommets = 
        {
            new CustomVertex.PositionColored(0.0f, 0.0f, 0.0f, Color.Red.ToArgb()),
            new CustomVertex.PositionColored(1.0f, 0.0f, 0.0f, Color.MediumOrchid.ToArgb()),
            new CustomVertex.PositionColored(0.0f, 1.0f, 0.0f, Color.Cornsilk.ToArgb()),
            new CustomVertex.PositionColored(1.0f, 1.0f, 0.0f, Color.Purple.ToArgb()),
            new CustomVertex.PositionColored(0.0f, 1.0f, 1.0f, Color.Chartreuse.ToArgb()),
            new CustomVertex.PositionColored(1.0f, 1.0f, 1.0f, Color.BlueViolet.ToArgb()),
            new CustomVertex.PositionColored(0.0f, 0.0f, 1.0f, Color.DarkCyan.ToArgb()),
            new CustomVertex.PositionColored(1.0f, 0.0f, 1.0f, Color.Firebrick.ToArgb()),
            new CustomVertex.PositionColored(0.0f, 0.0f, 0.0f, Color.Red.ToArgb()),
            new CustomVertex.PositionColored(1.0f, 0.0f, 0.0f, Color.MediumOrchid.ToArgb())
        };

        #region iObject Membres

        public override void Render(Device device)
        {
            vBuffer.SetData(Sommets, 0, LockFlags.None);
            device.SetStreamSource(0, vBuffer, 0);
            device.VertexFormat = CustomVertex.PositionColored.Format;
            device.DrawPrimitives(PrimitiveType.TriangleStrip, 0, Sommets.Length - 2);
        }

        public override void InitDevice(Device device, bool isReset)
        {
            vBuffer = new VertexBuffer(typeof(CustomVertex.PositionColored), Sommets.Length,
                device, 0, CustomVertex.PositionColored.Format, Pool.Default);
        }

        #endregion
    }
}
