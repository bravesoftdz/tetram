using System;
using System.Collections.Generic;
using System.Text;
using Microsoft.DirectX.Direct3D;
using D3DFont = Microsoft.DirectX.Direct3D.Font;
using WinFont = System.Drawing.Font;
using System.Drawing;
using Microsoft.DirectX;
using DXEngine;

namespace BDX
{
    public class FrameRate : Object3D, IRenderable
    {
        private D3DFont frameRateD3DFont;

        public FrameRate()
            : base("FPS")
        {
        }

        public void InitDevice(Device device, bool isReset)
        {
            frameRateD3DFont = new D3DFont(device, new WinFont(FontFamily.GenericSerif, 20));
        }

        public void LostDevice(Device device) { }

        public void Render(Device device, DeviceInfo deviceInfo)
        {
            frameRateD3DFont.DrawText(
              null,                  // Paramètre avancé
              "FPS: " + ((int)Engine.framePerSecond).ToString(),          // Texte à afficher
              new Rectangle(device.Viewport.X, device.Viewport.Y, device.Viewport.Width, device.Viewport.Height),       // Découpe ce texte dans ce rectangle
              DrawTextFormat.Left |  // Aligne le texte à la gauche de la fenêtre
              DrawTextFormat.Top |   // et à son dessus
              DrawTextFormat.WordBreak,   // Et saute des lignes si necessaire
              Color.Maroon);         // En quelle couleur dessiner le texte
        }
    }
}
