using System;
using System.Drawing;
using Microsoft.DirectX;
using Microsoft.DirectX.Direct3D;

namespace DXEngine
{
    /// <summary>
    /// Face class for SkyBox
    /// </summary>
    public class SkyFace : IRenderable, IDisposable
    {
        #region Attributes
        private CustomVertex.PositionNormalTextured[] m_Corners;
        private VertexBuffer m_VB = null;  // Vertex buffer
        private Image m_Image; // image for face
        private bool m_bValid = false;
        private string m_sName;

        public bool Valid { get { return m_bValid; } }
        #endregion

        public SkyFace(string sName, SkyBox.Face face)
        {
            m_sName = sName;

            // create the vertices for the box
            m_Corners = new CustomVertex.PositionNormalTextured[4];

            switch (face)
            {
                case SkyBox.Face.Top:
                    m_Corners[0].X = -500.0f;
                    m_Corners[0].Y = 500.0f;
                    m_Corners[0].Z = -500.0f;
                    m_Corners[0].Tu = 0.0f;
                    m_Corners[0].Tv = 1.0f;
                    m_Corners[0].Nx = 0.0f;
                    m_Corners[0].Ny = -1.0f;
                    m_Corners[0].Nz = 0.0f;
                    m_Corners[1].X = 500.0f;
                    m_Corners[1].Y = 500.0f;
                    m_Corners[1].Z = -500.0f;
                    m_Corners[1].Tu = 0.0f;
                    m_Corners[1].Tv = 0.0f;
                    m_Corners[1].Nx = 0.0f;
                    m_Corners[1].Ny = -1.0f;
                    m_Corners[1].Nz = 0.0f;
                    m_Corners[2].X = -500.0f;
                    m_Corners[2].Y = 500.0f;
                    m_Corners[2].Z = 500.0f;
                    m_Corners[2].Tu = 1.0f;
                    m_Corners[2].Tv = 1.0f;
                    m_Corners[2].Nx = 0.0f;
                    m_Corners[2].Ny = -1.0f;
                    m_Corners[2].Nz = 0.0f;
                    m_Corners[3].X = 500.0f;
                    m_Corners[3].Y = 500.0f;
                    m_Corners[3].Z = 500.0f;
                    m_Corners[3].Tu = 1.0f;
                    m_Corners[3].Tv = 0.0f;
                    m_Corners[3].Nx = 0.0f;
                    m_Corners[3].Ny = -1.0f;
                    m_Corners[3].Nz = 0.0f;
                    break;
                case SkyBox.Face.Bottom:
                    m_Corners[0].X = -500.0f; // nw
                    m_Corners[0].Y = -500.0f;
                    m_Corners[0].Z = 500.0f;
                    m_Corners[0].Tu = 0.0f;
                    m_Corners[0].Tv = 0.0f;
                    m_Corners[0].Nx = 0.0f;
                    m_Corners[0].Ny = 1.0f;
                    m_Corners[0].Nz = 0.0f;
                    m_Corners[1].X = 500.0f; // ne
                    m_Corners[1].Y = -500.0f;
                    m_Corners[1].Z = 500.0f;
                    m_Corners[1].Tu = 1.0f;
                    m_Corners[1].Tv = 1.0f;
                    m_Corners[1].Nx = 0.0f;
                    m_Corners[1].Ny = 1.0f;
                    m_Corners[1].Nz = 0.0f;
                    m_Corners[2].X = -500.0f; // sw
                    m_Corners[2].Y = -500.0f;
                    m_Corners[2].Z = -500.0f;
                    m_Corners[2].Tu = 1.0f;
                    m_Corners[2].Tv = 0.0f;
                    m_Corners[2].Nx = 0.0f;
                    m_Corners[2].Ny = 1.0f;
                    m_Corners[2].Nz = 0.0f;
                    m_Corners[3].X = 500.0f; // se
                    m_Corners[3].Y = -500.0f;
                    m_Corners[3].Z = -500.0f;
                    m_Corners[3].Tu = 0.0f;
                    m_Corners[3].Tv = 1.0f;
                    m_Corners[3].Nx = 0.0f;
                    m_Corners[3].Ny = 1.0f;
                    m_Corners[3].Nz = 0.0f;
                    break;
                case SkyBox.Face.Front:
                    m_Corners[0].X = -500.0f; // upper nw
                    m_Corners[0].Y = 500.0f;
                    m_Corners[0].Z = 500.0f;
                    m_Corners[0].Tu = 0.0f;
                    m_Corners[0].Tv = 0.0f;
                    m_Corners[0].Nx = 0.0f;
                    m_Corners[0].Ny = 0.0f;
                    m_Corners[0].Nz = -1.0f;
                    m_Corners[1].X = 500.0f; // upper ne
                    m_Corners[1].Y = 500.0f;
                    m_Corners[1].Z = 500.0f;
                    m_Corners[1].Tu = 1.0f;
                    m_Corners[1].Tv = 0.0f;
                    m_Corners[1].Nx = 0.0f;
                    m_Corners[1].Ny = 0.0f;
                    m_Corners[1].Nz = -1.0f;
                    m_Corners[2].X = -500.0f; // lower nw
                    m_Corners[2].Y = -500.0f;
                    m_Corners[2].Z = 500.0f;
                    m_Corners[2].Tu = 0.0f;
                    m_Corners[2].Tv = 1.0f;
                    m_Corners[2].Nx = 0.0f;
                    m_Corners[2].Ny = 0.0f;
                    m_Corners[2].Nz = -1.0f;
                    m_Corners[3].X = 500.0f; // lower ne
                    m_Corners[3].Y = -500.0f;
                    m_Corners[3].Z = 500.0f;
                    m_Corners[3].Tu = 1.0f;
                    m_Corners[3].Tv = 1.0f;
                    m_Corners[3].Nx = 0.0f;
                    m_Corners[3].Ny = 0.0f;
                    m_Corners[3].Nz = -1.0f;
                    break;
                case SkyBox.Face.Right:
                    m_Corners[0].X = 500.0f; // upper ne
                    m_Corners[0].Y = 500.0f;
                    m_Corners[0].Z = 500.0f;
                    m_Corners[0].Tu = 0.0f;
                    m_Corners[0].Tv = 0.0f;
                    m_Corners[0].Nx = -1.0f;
                    m_Corners[0].Ny = 0.0f;
                    m_Corners[0].Nz = 0.0f;
                    m_Corners[1].X = 500.0f; // upper se
                    m_Corners[1].Y = 500.0f;
                    m_Corners[1].Z = -500.0f;
                    m_Corners[1].Tu = 1.0f;
                    m_Corners[1].Tv = 0.0f;
                    m_Corners[1].Nx = -1.0f;
                    m_Corners[1].Ny = 0.0f;
                    m_Corners[1].Nz = 0.0f;
                    m_Corners[2].X = 500.0f; // lower ne
                    m_Corners[2].Y = -500.0f;
                    m_Corners[2].Z = 500.0f;
                    m_Corners[2].Tu = 0.0f;
                    m_Corners[2].Tv = 1.0f;
                    m_Corners[2].Nx = -1.0f;
                    m_Corners[2].Ny = 0.0f;
                    m_Corners[2].Nz = 0.0f;
                    m_Corners[3].X = 500.0f; // lower se
                    m_Corners[3].Y = -500.0f;
                    m_Corners[3].Z = -500.0f;
                    m_Corners[3].Tu = 1.0f;
                    m_Corners[3].Tv = 1.0f;
                    m_Corners[3].Nx = -1.0f;
                    m_Corners[3].Ny = 0.0f;
                    m_Corners[3].Nz = 0.0f;
                    break;
                case SkyBox.Face.Back:
                    m_Corners[0].X = 500.0f; // upper se
                    m_Corners[0].Y = 500.0f;
                    m_Corners[0].Z = -500.0f;
                    m_Corners[0].Tu = 0.0f;
                    m_Corners[0].Tv = 0.0f;
                    m_Corners[0].Nx = 0.0f;
                    m_Corners[0].Ny = 0.0f;
                    m_Corners[0].Nz = -1.0f;
                    m_Corners[1].X = -500.0f; // upper sw
                    m_Corners[1].Y = 500.0f;
                    m_Corners[1].Z = -500.0f;
                    m_Corners[1].Tu = 1.0f;
                    m_Corners[1].Tv = 0.0f;
                    m_Corners[1].Nx = 0.0f;
                    m_Corners[1].Ny = 0.0f;
                    m_Corners[1].Nz = -1.0f;
                    m_Corners[2].X = 500.0f; // lower se
                    m_Corners[2].Y = -500.0f;
                    m_Corners[2].Z = -500.0f;
                    m_Corners[2].Tu = 0.0f;
                    m_Corners[2].Tv = 1.0f;
                    m_Corners[2].Nx = 0.0f;
                    m_Corners[2].Ny = 0.0f;
                    m_Corners[2].Nz = -1.0f;
                    m_Corners[3].X = -500.0f; // lower sw
                    m_Corners[3].Y = -500.0f;
                    m_Corners[3].Z = -500.0f;
                    m_Corners[3].Tu = 1.0f;
                    m_Corners[3].Tv = 1.0f;
                    m_Corners[3].Nx = 0.0f;
                    m_Corners[3].Ny = 0.0f;
                    m_Corners[3].Nz = -1.0f;
                    break;
                case SkyBox.Face.Left:
                    m_Corners[0].X = -500.0f; // upper south
                    m_Corners[0].Y = 500.0f;
                    m_Corners[0].Z = -500.0f;
                    m_Corners[0].Tu = 0.0f;
                    m_Corners[0].Tv = 0.0f;
                    m_Corners[0].Nx = 1.0f;
                    m_Corners[0].Ny = 0.0f;
                    m_Corners[0].Nz = 0.0f;
                    m_Corners[1].X = -500.0f; // upper north
                    m_Corners[1].Y = 500.0f;
                    m_Corners[1].Z = 500.0f;
                    m_Corners[1].Tu = 1.0f;
                    m_Corners[1].Tv = 0.0f;
                    m_Corners[1].Nx = 1.0f;
                    m_Corners[1].Ny = 0.0f;
                    m_Corners[1].Nz = 0.0f;
                    m_Corners[2].X = -500.0f; // lower south
                    m_Corners[2].Y = -500.0f;
                    m_Corners[2].Z = -500.0f;
                    m_Corners[2].Tu = 0.0f;
                    m_Corners[2].Tv = 1.0f;
                    m_Corners[2].Nx = 1.0f;
                    m_Corners[2].Ny = 0.0f;
                    m_Corners[2].Nz = 0.0f;
                    m_Corners[3].X = -500.0f; // lower north
                    m_Corners[3].Y = -500.0f;
                    m_Corners[3].Z = 500.0f;
                    m_Corners[3].Tu = 1.0f;
                    m_Corners[3].Tv = 1.0f;
                    m_Corners[3].Nx = 1.0f;
                    m_Corners[3].Ny = 0.0f;
                    m_Corners[3].Nz = 0.0f;
                    break;
            }

            // load the texture for the face
            try
            {
                m_Image = new Image(sName);
                m_bValid = true;
            }
            catch
            {
                Console.AddLine("Unable to create skybox texture for " + sName);
            }
        }

        public void InitDevice(Device device, bool isReset)
        {
            // Create a quad for rendering the face
            m_VB = new VertexBuffer(typeof(CustomVertex.PositionNormalTextured), 4,
                device, Usage.WriteOnly, CustomVertex.PositionNormalTextured.Format,
                Pool.Default);
            m_VB.Created += new System.EventHandler(this.CreateQuad);
            CreateQuad(m_VB, null);

            m_Image.InitDevice(device, isReset);
        }

        public void LostDevice(Device device)
        {
            m_Image.LostDevice(device);
        }

        public void CreateQuad(object sender, EventArgs e)
        {
            VertexBuffer vb = (VertexBuffer)sender;

            // Copy tree mesh data into vertexbuffer
            vb.SetData(m_Corners, 0, 0);
        }

        public void Render(Device Device3D, DeviceInfo deviceInfo)
        {
            if (m_bValid)
            {
                Material mtrl = new Material();
                mtrl.Ambient = Color.White;
                mtrl.Diffuse = Color.White;
                Device3D.Material = mtrl;
                Device3D.SetStreamSource(0, m_VB, 0);
                Device3D.VertexFormat = CustomVertex.PositionNormalTextured.Format;

                // Set the texture
                Device3D.SetTexture(0, m_Image.GetTexture());

                // Render the face
                Device3D.DrawPrimitives(PrimitiveType.TriangleStrip, 0, 2);
            }
        }

        public void Dispose()
        {
            m_Image.Dispose();

            if (m_VB != null)
                m_VB.Dispose();
        }
    }

    /// <summary>
    /// Summary description for SkyBox.
    /// </summary>
    public class SkyBox : IRenderable, IDisposable
    {
        #region Attributes
        private SkyFace[] m_faces = new SkyFace[6];

        public enum Face { Top, Bottom, Front, Right, Back, Left }
        #endregion

        public SkyBox(string sFront, string sRight, string sBack, string sLeft, string sTop, string sBottom)
            : base()
        {
            // create the faces for the box
            m_faces[0] = new SkyFace(sFront, Face.Front);
            m_faces[1] = new SkyFace(sLeft, Face.Left);
            m_faces[2] = new SkyFace(sBack, Face.Back);
            m_faces[3] = new SkyFace(sRight, Face.Right);
            m_faces[4] = new SkyFace(sTop, Face.Top);
            m_faces[5] = new SkyFace(sBottom, Face.Bottom);

        }

        public void Dispose()
        {
            foreach (SkyFace face in m_faces) face.Dispose();
        }

        public void InitDevice(Device device, bool isReset)
        {
            foreach (SkyFace face in m_faces) face.InitDevice(device, isReset);
        }
        public void LostDevice(Device device)
        {
            foreach (SkyFace face in m_faces) face.LostDevice(device);
        }

        public void Render(Device Device3D, DeviceInfo deviceInfo)
        {
            try
            {
                // Set the matrix for normal viewing
                Matrix matWorld = new Matrix();
                matWorld = Matrix.Identity;

                // Center view matrix for skybox and disable zbuffer
                Matrix matView;
                matView = deviceInfo.View;
                matView.M41 = 0.0f; matView.M42 = -0.3f; matView.M43 = 0.0f;
                Device3D.Transform.View = matView;

                Device3D.Transform.World = matWorld;
                Device3D.RenderState.ZBufferWriteEnable = false;
                Device3D.RenderState.CullMode = Microsoft.DirectX.Direct3D.Cull.None;

                Device3D.RenderState.FogEnable = false;
                Device3D.RenderState.FogColor = Color.WhiteSmoke;
                Device3D.RenderState.FogStart = 80.0f;
                Device3D.RenderState.FogEnd = 1000.0f;
                Device3D.RenderState.FogTableMode = FogMode.Linear;

                // pick faces based on camera attitude

                //if (cam.Pitch > 0.0f)
                //{
                m_faces[4].Render(Device3D, deviceInfo);
                //}
                //else if (cam.Pitch < 0.0f)
                //{
                //m_faces[5].Render(Device3D, deviceInfo);
                //}

                //if (cam.Heading > 0.0f && cam.Heading < 180.0)
                //{
                m_faces[1].Render(Device3D, deviceInfo);
                //}

                //if (cam.Heading > 270.0f || cam.Heading < 90.0)
                //{
                m_faces[0].Render(Device3D, deviceInfo);
                //}

                //if (cam.Heading > 180.0f && cam.Heading < 360.0)
                //{
                m_faces[3].Render(Device3D, deviceInfo);
                //}

                //if (cam.Heading > 90.0f && cam.Heading < 270.0)
                //{
                m_faces[2].Render(Device3D, deviceInfo);
                //}

                // Restore the render states
                //Device3D.Transform.View = cam.View;
                Device3D.RenderState.ZBufferWriteEnable = true;
            }
            catch (DirectXException d3de)
            {
                Console.AddLine("Unable to render skybox ");
                Console.AddLine(d3de.ErrorString);
            }
            catch (Exception e)
            {
                Console.AddLine("Unable to render skybox ");
                Console.AddLine(e.Message);
            }
        }
    }
}