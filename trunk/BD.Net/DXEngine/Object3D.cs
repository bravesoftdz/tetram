using System;
using System.Collections.Generic;
using System.Text;
using Microsoft.DirectX;

namespace DXEngine
{
    public enum Bounding
    {
        None, Sphere, Cube, Complex
    }

    public class Object3D
    {
        public Vector3 Position = Vector3.Empty;
        public Vector3 Rotation = Vector3.Empty;
        public Object3D Parent = null;
        private string name = String.Empty;
        private Engine engine;

        public Object3D(Engine Engine, string Name)
        {
            engine = Engine;
            name = Name;
        }
        
        public Matrix World
        {
            get { return Matrix.RotationYawPitchRoll(Rotation.Z, Rotation.X, Rotation.Y) * Matrix.Translation(Position) * (Parent != null ? Parent.World : Matrix.Identity); }
        }
        public string Name
        {
            get { return name; }
        }
        public Engine Engine
        { get { return engine; } }

        public Bounding boundingType = Bounding.None;
        // boundingType == Bounding.Sphere;
        public float Radius() { return 0.0f; }
        // boundingType == Bounding.Complex;
        public bool IsInFrustrum(Plane[] Frustrum) { return true; }
        public bool IsInFrustrum(POV pov) { return true; }
    }
}
