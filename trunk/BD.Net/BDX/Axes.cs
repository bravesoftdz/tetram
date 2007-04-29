using System;
using System.Collections.Generic;
using System.Text;
using Microsoft.DirectX.Direct3D;
using System.Drawing;
using Microsoft.DirectX;

namespace BDX
{
    class Axes : D3DObject
    {
        private VertexBuffer vBuffer;
        public Vector3 Position = Vector3.Empty;
        public float Angle = 0;

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

        internal override void InitDevice(Device device, bool isReset)
        {
            vBuffer = new VertexBuffer(typeof(CustomVertex.PositionColored), Sommets.Length,
                device, 0, CustomVertex.PositionColored.Format, Pool.Default);
        }

        internal override void Render(Device device)
        {
            Matrix mxWorld, mx;
            mxWorld = Matrix.RotationY(Angle);
            mx = Matrix.Translation(Position);
            mxWorld *= mx;
            // D3DXMatrixMultiply(&mxWorld, &m_mxOrientation, &mxWorld); ??? 
            device.Transform.World = mxWorld;

            vBuffer.SetData(Sommets, 0, LockFlags.None);
            device.SetStreamSource(0, vBuffer, 0);
            device.VertexFormat = CustomVertex.PositionColored.Format;
            device.DrawPrimitives(PrimitiveType.LineList, 0, Sommets.Length / 2);
        }

        #endregion
    }
}
