using System;
using System.Collections.Generic;
using System.Text;
using Microsoft.DirectX.Direct3D;
using D3DFont = Microsoft.DirectX.Direct3D.Font;
using WinFont = System.Drawing.Font;
using System.Drawing;
using Microsoft.DirectX;

namespace BDX
{
    public class FrameRate : D3DObject
    {
        private D3DFont frameRateD3DFont;
        private WinFont frameRateWinFont = new WinFont(FontFamily.GenericSerif, 20);

        private SizeF meshBounds = new SizeF();
        private Mesh fontMesh;
        private WinFont meshWinFont = new WinFont(FontFamily.GenericSansSerif, 36);

        private int frames;
        private string frameratemsg = "";
        private int lastTickCount;

        public FrameRate()
        {
        }

        public override void InitDevice(Device device, bool isReset)
        {
            frameRateD3DFont = new D3DFont(device, frameRateWinFont);

            string text = "Rotating Text";
            GlyphMetricsFloat[] glyphMetrics = new GlyphMetricsFloat[text.Length];
            fontMesh = Mesh.TextFromFont(
              device,            // Le device bien sur
              meshWinFont,       // La fonte avec laquelle on veut faire le rendu
              text,              // Le texte desiré
              0.01F,              // "Bosselé" comment?
              0.25F,             // Epais comment?
              out glyphMetrics   // Information sur les meshes
              );

            meshBounds = ComputeMeshBounds(glyphMetrics);
        }

        public override void Render(Device device)
        {
            float yaw = Environment.TickCount / 1200.0F;
            float pitch = Environment.TickCount / 800.0F;
            Matrix translate = Matrix.Translation(-meshBounds.Width / 2.0F, -meshBounds.Height / 2.0F, 0.125F);
            Matrix rotate = Matrix.RotationYawPitchRoll(yaw, pitch, 0);
            device.Transform.World = Matrix.Multiply(translate, rotate);

            CalculateFrameRate();

            //device.Viewport.
            frameRateD3DFont.DrawText(
              null,                  // Paramètre avancé
              frameratemsg,          // Texte à afficher
              new Rectangle(device.Viewport.X, device.Viewport.Y, device.Viewport.Width, device.Viewport.Height),       // Découpe ce texte dans ce rectangle
              DrawTextFormat.Left |  // Aligne le texte à la gauche de la fenêtre
              DrawTextFormat.Top |   // et à son dessus
              DrawTextFormat.WordBreak,   // Et saute des lignes si necessaire
              Color.Maroon);         // En quelle couleur dessiner le texte
        }

        protected void CalculateFrameRate()
        {
            ++frames;

            int ticks = Environment.TickCount;
            int elapsed = ticks - lastTickCount;
            if (elapsed > 1000)
            {
                int framerate = frames;
                frames = 0;
                frameratemsg = "FPS: " + framerate.ToString();
                lastTickCount = ticks;
            }
        }

        private SizeF ComputeMeshBounds(GlyphMetricsFloat[] gmfs)
        {
            float maxx = 0;
            float maxy = 0;

            float offsety = 0;
            foreach (GlyphMetricsFloat gmf in gmfs)
            {
                maxx += gmf.CellIncX;
                float y = offsety + gmf.BlackBoxY;
                if (y > maxy)
                {
                    maxy = y;
                }

                offsety += gmf.CellIncY;
            }

            return new SizeF(maxx, maxy);
        }
    }
}
