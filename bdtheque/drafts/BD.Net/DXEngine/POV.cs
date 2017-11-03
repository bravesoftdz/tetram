using System;
using System.Collections.Generic;
using System.Text;
using Microsoft.DirectX;
using Microsoft.DirectX.Direct3D;
using D3DFont = Microsoft.DirectX.Direct3D.Font;
using WinFont = System.Drawing.Font;
using System.Drawing;

namespace DXEngine
{
    public class POV : IRenderable
    {
        private Vector3 look, eye;
        private D3DFont infoD3DFont;
        internal bool frustrumChanged;
        private Vector3[] _frustumCorners = new Vector3[8];
        private Plane[] _frustumPlanes = new Plane[6];
        public bool DoRender = false;

        static internal POV instance;
        static public POV Instance
        {
            get
            {
                if (instance == null) instance = new POV();
                return instance;
            }
        }

        private POV()
        {
            Console.AddParameter("SHOWPOV", "Affiche ou masque les valeurs de la caméra.", new CommandFunction(ShowPov));
        }

        public void Position(Vector3 eye, Vector3 look)
        {
            Eye = eye;
            Look = look;
        }

        public Vector3 Eye
        {
            get { return eye; }
            set
            {
                eye = value;
                frustrumChanged = true;
            }
        }
        public Vector3 Look
        {
            get { return look; }
            set
            {
                look = Vector3.Normalize(value);
                if (look.Y > 0.8f) look.Y = 0.8f;
                if (look.Y < -0.8f) look.Y = -0.8f;
                frustrumChanged = true;
            }
        }
        public Vector3 StraightOn
        { get { return Vector3.Normalize(Vector3.Cross(Right, Up)); } }
        public Vector3 Right
        { get { return Vector3.Normalize(Vector3.Cross(Up, Look)); } }
        public Vector3 Up
        { get { return new Vector3(0.0f, 1.0f, 0.0f); } }
        public Vector3 LookAt
        { get { return Eye + Look; } }

        public void InitDevice(Device device, bool isReset)
        {
            infoD3DFont = new D3DFont(device, new System.Drawing.Font("Arial", 12));
        }
        public void LostDevice(Device device)
        {
            //infoD3DFont.Dispose();
        }

        private void ShowPov(string sData)
        {
            try
            {
                DoRender = bool.Parse(sData);
            }
            catch
            {                   
            }
        }

        public void Render(Device device, DeviceInfo deviceInfo)
        {
            if (DoRender)
            {
                string msg = "Eye: " + Eye.ToString() +
                             "\nLookAt: " + LookAt.ToString() +
                             "\nLook: " + Look.ToString() +
                             "\nlook: " + look.ToString() +
                             "\nStraightOn: " + StraightOn.ToString() +
                             "\nRight: " + Right.ToString() +
                             "\nUp: " + Up.ToString();

                infoD3DFont.DrawText(
                    null,                  // Paramètre avancé
                    msg,          // Texte à afficher
                    new Rectangle(device.Viewport.X, device.Viewport.Y + 30, device.Viewport.Width, device.Viewport.Height),       // Découpe ce texte dans ce rectangle
                    DrawTextFormat.Left |  // Aligne le texte à la gauche de la fenêtre
                    DrawTextFormat.Top |   // et à son dessus
                    DrawTextFormat.WordBreak,   // Et saute des lignes si necessaire
                    Color.Maroon);         // En quelle couleur dessiner le texte
            }
        }

        public Matrix View
        { get { return Matrix.LookAtLH(Eye, LookAt, new Vector3(0.0f, 1.0f, 0.0f)); } }

        public Matrix Perspective
        { get { return Matrix.PerspectiveFovLH((float)(Math.PI / 4), 1.0f, 1.0f, 1000.0f); } }

        private void CalculFrustum()
        {
            Matrix matrix = View * Perspective;
            matrix.Invert();
            _frustumCorners[0] = new Vector3(-1.0f, -1.0f, 0.0f); // xyz 
            _frustumCorners[1] = new Vector3(1.0f, -1.0f, 0.0f); // Xyz 
            _frustumCorners[2] = new Vector3(-1.0f, 1.0f, 0.0f); // xYz 
            _frustumCorners[3] = new Vector3(1.0f, 1.0f, 0.0f); // XYz 
            _frustumCorners[4] = new Vector3(-1.0f, -1.0f, 1.0f); // xyZ 
            _frustumCorners[5] = new Vector3(1.0f, -1.0f, 1.0f); // XyZ 
            _frustumCorners[6] = new Vector3(-1.0f, 1.0f, 1.0f); // xYZ 
            _frustumCorners[7] = new Vector3(1.0f, 1.0f, 1.0f); // XYZ 
            for (int i = 0; i < _frustumCorners.Length; i++)
                _frustumCorners[i] = Vector3.TransformCoordinate(_frustumCorners[i], matrix); // Now calculate the planes
            _frustumPlanes[0] = Plane.FromPoints(_frustumCorners[0], _frustumCorners[1], _frustumCorners[2]); // Near
            _frustumPlanes[1] = Plane.FromPoints(_frustumCorners[6], _frustumCorners[7], _frustumCorners[5]); // Far 
            _frustumPlanes[2] = Plane.FromPoints(_frustumCorners[2], _frustumCorners[6], _frustumCorners[4]); // Left 
            _frustumPlanes[3] = Plane.FromPoints(_frustumCorners[7], _frustumCorners[3], _frustumCorners[5]); // Right 
            _frustumPlanes[4] = Plane.FromPoints(_frustumCorners[2], _frustumCorners[3], _frustumCorners[6]); // Top 
            _frustumPlanes[5] = Plane.FromPoints(_frustumCorners[1], _frustumCorners[0], _frustumCorners[4]); // Bottom 
            frustrumChanged = false;
        }

        public bool IsInViewFrustum(Object3D unitToCheck)
        {
            if (frustrumChanged) CalculFrustum();

            switch (unitToCheck.boundingType)
            {
                case Bounding.Sphere:
                    {
                        foreach (Plane plane in _frustumPlanes)
                        {
                            if (plane.A * unitToCheck.Position.X
                                + plane.B * unitToCheck.Position.Y
                                + plane.C * unitToCheck.Position.Z
                                + plane.D <= (-unitToCheck.Radius()))
                                return false;
                        }
                        return true;
                    }
                case Bounding.Cube:
                    throw new NotImplementedException();
                case Bounding.Complex:
                    return unitToCheck.IsInFrustrum(_frustumPlanes) && unitToCheck.IsInFrustrum(this);
                default: return true;
            }
        }
    }
}