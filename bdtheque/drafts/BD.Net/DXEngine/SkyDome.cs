using System;
using System.Collections.Generic;
using System.Text;
using Microsoft.DirectX.Direct3D;
using System.Drawing;
using Microsoft.DirectX;

namespace DXEngine
{
    public class SkyDome : IRenderable
    {
        private VertexBuffer vertices;
        private IndexBuffer indices;

        private Image Image;
        private int NumOfVertices, NumOfFaces, hres, vres;
        private float img_pct, half_sphere;

        ///<summary>
        ///</summary>
        ///<param name="fileName">Nom du fichier image contenant la texture</param>
        ///<param name="hori_res">Controls the number of faces along the horizontal axis (30 is a good value)</param>
        ///<param name="vert_res">Controls the number of faces along the vertical axis (8 is a good value)</param>
        ///<param name="image_percentage">Only the top image_percentage of the image is used, e.g. 0.8 uses the top 80% of the image,
        ///1.0 uses the entire image. This is useful as some landscape images have a small banner
        ///at the bottom that you don't want.</param>
        ///<param name="half_sphere_fraction">This controls how far around the sphere the sky dome goes. For value 1.0 you get exactly the upper
        ///hemisphere, for 1.1 you get slightly more, and for 2.0 you get a full sphere. It is sometimes useful
        ///to use a value slightly bigger than 1 to avoid a gap between some ground place and the sky. This
        ///parameters stretches the image to fit the chosen "sphere-size".</param>

        public SkyDome(string fileName, int hori_res, int vert_res, float image_percentage, float half_sphere_fraction)
        {
            Image = new Image(fileName);

            hres = hori_res;
            vres = vert_res;
            img_pct = image_percentage;
            half_sphere = half_sphere_fraction;
        }

        public void InitDevice(Device device, bool isReset)
        {
            float radius = 1000;               /* Adjust this to get more or less perspective distorsion. */
            float azimuth, azimuth_step;
            float elevation, elevation_step;
            int k, j, c;

            NumOfVertices = (hres + 1) * (vres + 1);
            NumOfFaces = (2 * vres - 1) * hres;

            azimuth_step = 2.0f * (float)Math.PI / hres;
            elevation_step = half_sphere * (float)Math.PI / 2.0f / vres;

            CustomVertex.PositionNormalTextured[] vtx = new CustomVertex.PositionNormalTextured[NumOfVertices];
            c = 0;
            for (k = 0, azimuth = 0; k <= hres; k++, azimuth += azimuth_step)
            {
                for (j = 0, elevation = (float)Math.PI / 2.0f; j <= vres; j++, elevation -= elevation_step)
                {
                    vtx[c].Position = new Microsoft.DirectX.Vector3(radius * (float)Math.Cos(elevation) * (float)Math.Sin(azimuth), radius * (float)Math.Sin(elevation) + 50, radius * (float)Math.Cos(elevation) * (float)Math.Cos(azimuth));
                    vtx[c].Tu = (float)k / (float)hres;
                    vtx[c].Tv = (float)j / (float)vres * img_pct;
                    c++;
                }
            }

            vertices = new VertexBuffer(
              typeof(CustomVertex.PositionNormalTextured),  // Quel type de sommets
              NumOfVertices,                                    // Combien
              device,                                       // Le device
              0,                                    // Utilisation par défaut
              CustomVertex.PositionNormalTextured.Format,   // Format de sommets
              Pool.Default);                        // Pooling par défaut
            vertices.SetData(vtx, 0, 0);

            int[] Indices = new int[3 * NumOfFaces];
            c = 0;
            for (k = 0; k < hres; k++)
            {
                Indices[c++] = vres + 2 + (vres + 1) * k;
                Indices[c++] = 1 + (vres + 1) * k;
                Indices[c++] = 0 + (vres + 1) * k;

                for (j = 1; j < vres; j++)
                {
                    Indices[c++] = vres + 2 + (vres + 1) * k + j;
                    Indices[c++] = 1 + (vres + 1) * k + j;
                    Indices[c++] = 0 + (vres + 1) * k + j;

                    Indices[c++] = vres + 1 + (vres + 1) * k + j;
                    Indices[c++] = vres + 2 + (vres + 1) * k + j;
                    Indices[c++] = 0 + (vres + 1) * k + j;
                }
            }

            indices = new IndexBuffer(Indices[0].GetType(), 3 * NumOfFaces, device, 0, Pool.Default);
            indices.SetData(Indices, 0, 0);

            Image.InitDevice(device, isReset);
        }

        public void LostDevice(Device device)
        {
            Image.LostDevice(device);
            if (vertices != null) vertices.Dispose();
            if (indices != null) indices.Dispose();
        }

        public void Render(Device Device3D, DeviceInfo deviceInfo)
        {
            try
            {
                // Center view matrix for skybox and disable zbuffer
                Matrix matView;
                matView = deviceInfo.View;
                matView.M41 = 0.0f; matView.M42 = -0.3f; matView.M43 = 0.0f;
                Device3D.Transform.View = matView;
                // on change la profondeur de champ pour être sûr d'afficher le dome
                Device3D.Transform.Projection = Matrix.PerspectiveFovLH((float)(Math.PI / 4), 1.0f, 1.0f, 2000.0f);
                // Set the matrix for normal viewing
                Device3D.Transform.World = Matrix.Identity;
                Device3D.RenderState.ZBufferWriteEnable = false;
                Device3D.RenderState.CullMode = Microsoft.DirectX.Direct3D.Cull.None;

                Material mtrl = new Material();
                mtrl.Ambient = Color.White;
                mtrl.Diffuse = Color.White;
                Device3D.Material = mtrl;
                Device3D.SetTexture(0, Image.GetTexture());
                Device3D.RenderState.Ambient = Color.WhiteSmoke;

                Device3D.SetStreamSource(0, vertices, 0);
                Device3D.VertexFormat = CustomVertex.PositionNormalTextured.Format;
                Device3D.Indices = indices;

                // Render the face
                Device3D.DrawIndexedPrimitives(
                  PrimitiveType.TriangleList,   // Le type de primtives qu'on dessine
                  0,                            // Sommet de base
                  0,                            // Indice de sommet mini
                  NumOfVertices,                // Nombre de sommets utilisés
                  0,                            // Indice de début
                  NumOfFaces);                  // Nombre de primitives

                Device3D.RenderState.ZBufferWriteEnable = true;
            }
            catch
            {

            }

        }
    }
}