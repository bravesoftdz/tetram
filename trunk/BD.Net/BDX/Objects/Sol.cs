using System;
using System.Collections.Generic;
using System.Text;
using Microsoft.DirectX.Direct3D;
using Microsoft.DirectX;
using DXEngine;

namespace BDX.Objects
{
    class Sol : D3DMesh
    {
        public Sol()
            : base("Sol")
        {
            fichier = @"media\salon.x";
            Rotation.X = -(float)(Math.PI / 2);
            //useProgessive = 5;
        }
    }
}
