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

    class Cheminee : D3DMesh
    {
        public Cheminee()
            : base("Cheminee")
        {
            fichier = @"media\Cheminee2.x";
            scale = 0.1f;
            //Rotation.X = -(float)(Math.PI / 2);
            //useProgessive = 5;
        }
    }
}
