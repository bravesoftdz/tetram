using System;
using System.Collections.Generic;
using System.Text;
using Microsoft.DirectX.Direct3D;
using System.Drawing;
using Microsoft.DirectX;

namespace BDX
{
    class Decor
    {

        private VertexBuffer vBuffer;

        private CustomVertex.PositionColored[] Sommets = 
        {
            new CustomVertex.PositionColored(-1.0f, -1.0f, 0.0f, Color.Red.ToArgb()),
            new CustomVertex.PositionColored(1.0f, -1.0f, 0.0f, Color.MediumOrchid.ToArgb()),
            new CustomVertex.PositionColored(0.0f, 1.0f, 0.0f, Color.Cornsilk.ToArgb()),
            new CustomVertex.PositionColored(1.0f, 1.0f, 0.0f, Color.Purple.ToArgb())
        };

        internal void Render(Device device)
        {
            device.Transform.World = Matrix.Scaling(1.0f, 1.0f, 1.0f);
            vBuffer.SetData(Sommets, 0, LockFlags.None);
            device.SetStreamSource(0, vBuffer, 0);
            device.VertexFormat = CustomVertex.PositionColored.Format;
            device.DrawPrimitives(PrimitiveType.TriangleStrip, 0, Sommets.Length - 2);
        }

        internal void CreateDevice(Device dev)
        {
            vBuffer = new VertexBuffer(typeof(CustomVertex.PositionColored), Sommets.Length,
                dev, 0, CustomVertex.PositionColored.Format, Pool.Default);
        }

    }
}
