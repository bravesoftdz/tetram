using System;
using System.Drawing;
using System.Collections.Generic;
using Microsoft.DirectX;
using Microsoft.DirectX.Direct3D;

namespace DXEngine
{
    /// <summary>
    /// Summary description for the Image class.
    /// This class encapsulates a bitmap image as a Direct3D Surface.
    /// </summary>
    public class Image : IRenderable, IDisposable
    {
        private Texture m_image = null;
        private ImageInformation m_info = new ImageInformation();
        private string m_sFilename;

        public Image(string filename)
        {
            m_sFilename = filename;

            //Load();

        }

        public Size GetSize()
        {
            return new Size(m_info.Width, m_info.Height);
        }

        /// <summary>
        /// Dispose of the surface when we are done with it to free up video card memory
        /// </summary>
        public void Dispose()
        {
            if (m_image != null) m_image.Dispose();
        }

        public void InitDevice(Device device, bool isReset)
        {
            try
            {
                m_info = new ImageInformation();
                m_info = TextureLoader.ImageInformationFromFile(m_sFilename);
                //m_image = TextureLoader.FromFile(device, m_sFilename);
                m_image = TextureLoader.FromFile(device, m_sFilename, 0, 0, 0, Usage.None, Format.Unknown, Pool.Managed, Filter.Linear, Filter.Box, Color.FromArgb(255, 0, 0, 0).ToArgb());
            }
            catch (DirectXException d3de)
            {
                Console.AddLine("Unable to load image " + m_sFilename);
                Console.AddLine(d3de.ErrorString);
            }
            catch (Exception e)
            {
                Console.AddLine("Unable to load image " + m_sFilename);
                Console.AddLine(e.Message);
            }
        }

        public void LostDevice(Device device) { }

        public void Render(Device device, DeviceInfo deviceInfo) { }

        /// <summary>
        /// Get the texture for rendering
        /// </summary>
        /// <returns></returns>
        public Texture GetTexture()
        {
            return m_image;
        }

        public Rectangle GetRect()
        {
            return new Rectangle(0, 0, m_info.Width, m_info.Height);
        }

    }

    /// <summary>
    /// Summary description for ImageButton.
    /// </summary>
    public delegate void ButtonFunction();

    public class ImageButton : IRenderable, IDisposable
    {

        private int m_X = 0;     // X position of buton on screen
        private int m_Y = 0;     // Y position of the button on the screen
        private Image m_OffImage = null;  // what the button looks like when off
        private Image m_OnImage = null;  // what the button looks like when on
        private Image m_HoverImage = null;  // what the button looks like when on
        private bool m_bOn = false;
        private bool m_bHoverOn = false;
        private ButtonFunction m_Function = null;
        private Rectangle m_Rect;
        private VertexBuffer m_vb = null;
        private CustomVertex.TransformedTextured[] data;

        public Size GetSize() { return m_Rect.Size; }


        public ImageButton(int nX, int nY, string sOffFilename, string sOnFilename,
            string sHoverFilename, ButtonFunction pFunc)
        {
            m_X = nX;
            m_Y = nY;
            m_OffImage = new Image(sOffFilename);
            m_OnImage = new Image(sOnFilename);
            m_HoverImage = new Image(sHoverFilename);
            m_Rect = m_OffImage.GetRect();
            m_Rect.X += m_X;
            m_Rect.Y += m_Y;
            m_Function = pFunc;

        }

        public void InitDevice(Device device, bool isReset)
        {
            m_vb = new VertexBuffer(typeof(CustomVertex.TransformedTextured), 4,
                device, Usage.WriteOnly, CustomVertex.TransformedTextured.Format,
                Pool.Default);
            m_OffImage.InitDevice(device, isReset);
            m_OnImage.InitDevice(device, isReset);
            m_HoverImage.InitDevice(device, isReset);
        }
        public void LostDevice(Device device)
        {
            m_OffImage.LostDevice(device);
            m_OnImage.LostDevice(device);
            m_HoverImage.LostDevice(device);
        }

        public void Render(Device Device3D, DeviceInfo deviceInfo)
        {
            try
            {
                data = new CustomVertex.TransformedTextured[4];
                data[0].X = (float)m_Rect.X;
                data[0].Y = (float)m_Rect.Y;
                data[0].Z = 1.0f;
                data[0].Tu = 0.0f;
                data[0].Tv = 0.0f;
                data[1].X = (float)(m_Rect.X + m_Rect.Width);
                data[1].Y = (float)m_Rect.Y;
                data[1].Z = 1.0f;
                data[1].Tu = 1.0f;
                data[1].Tv = 0.0f;
                data[2].X = (float)m_Rect.X;
                data[2].Y = (float)(m_Rect.Y + m_Rect.Height);
                data[2].Z = 1.0f;
                data[2].Tu = 0.0f;
                data[2].Tv = 1.0f;
                data[3].X = (float)(m_Rect.X + m_Rect.Width);
                data[3].Y = (float)(m_Rect.Y + m_Rect.Height);
                data[3].Z = 1.0f;
                data[3].Tu = 1.0f;
                data[3].Tv = 1.0f;

                m_vb.SetData(data, 0, 0);

                Device3D.SetStreamSource(0, m_vb, 0);
                Device3D.VertexFormat = CustomVertex.TransformedTextured.Format;

                // Set the texture
                Device3D.SetTexture(0, GetTexture());

                // Render the face
                Device3D.DrawPrimitives(PrimitiveType.TriangleStrip, 0, 2);
            }
            catch (DirectXException d3de)
            {
                Console.AddLine("Unable to display imagebutton ");
                Console.AddLine(d3de.ErrorString);
            }
            catch (Exception e)
            {
                Console.AddLine("Unable to display imagebutton ");
                Console.AddLine(e.Message);
            }
        }

        /// <summary>
        /// dispose of the surfaces to free up video card memory
        /// </summary>
        public void Dispose()
        {
            m_OffImage.Dispose();
            m_OnImage.Dispose();
            m_HoverImage.Dispose();
        }

        /// <summary>
        /// Get the texture for rendering
        /// </summary>
        /// <returns></returns>
        public Texture GetTexture()
        {
            if (m_bHoverOn)
                return m_HoverImage.GetTexture();
            else if (m_bOn)
                return m_OnImage.GetTexture();
            else
                return m_OffImage.GetTexture();
        }

        public Rectangle GetDestRect()
        {
            return m_Rect;
        }

        public Rectangle GetSrcRect()
        {
            return m_OffImage.GetRect();
        }

        public Point GetPoint()
        {
            return new Point(m_X, m_Y); ;
        }

        private bool InRect(Point p)
        {
            return m_Rect.Contains(p);
        }

        public void HoverTest(Point p)
        {
            m_bHoverOn = InRect(p);
        }

        public void ClickTest(Point p)
        {
            if (InRect(p))
                m_bOn = !m_bOn;

            if (m_bOn && m_Function != null)
                m_Function();
        }
    }

    /// <summary>
    /// Summary description for the SplashScreen class.
    /// This class encapsulates a Splash Screen
    /// </summary>
    public class SplashScreen : IRenderable, IDisposable
    {
        private Image image = null;
        private float m_StartTime;
        private float m_EndTime = 0.0f;
        private VertexBuffer m_vb;
        public bool m_bInitialized = false;
        public float fTimeLeft;

        public SplashScreen(string filename, int nDuration)
        {
            image = new Image(filename);
            m_StartTime = Utils.Timer(TIMER.GETABSOLUTETIME);
            m_EndTime = m_StartTime + nDuration;
        }


        public void InitDevice(Device device, bool isReset)
        {
            m_vb = new VertexBuffer(typeof(CustomVertex.TransformedTextured), 4,
                device, Usage.WriteOnly, CustomVertex.TransformedTextured.Format,
                Pool.Default);
            image.InitDevice(device, isReset);
        }
        public void LostDevice(Device device)
        {
            image.LostDevice(device);
        }

        public void Render(Device Device3D, DeviceInfo deviceInfo)
        {
            try
            {
                Device3D.RenderState.FogEnable = false;

                CustomVertex.TransformedTextured[] data = new CustomVertex.TransformedTextured[4];
                data[0].X = 0.0f;
                data[0].Y = 0.0f;
                data[0].Z = 0.0f;
                data[0].Tu = 0.0f;
                data[0].Tv = 0.0f;
                data[1].X = Device3D.Viewport.Width;
                data[1].Y = 0.0f;
                data[1].Z = 0.0f;
                data[1].Tu = 1.0f;
                data[1].Tv = 0.0f;
                data[2].X = 0.0f;
                data[2].Y = Device3D.Viewport.Height;
                data[2].Z = 0.0f;
                data[2].Tu = 0.0f;
                data[2].Tv = 1.0f;
                data[3].X = Device3D.Viewport.Width;
                data[3].Y = Device3D.Viewport.Height;
                data[3].Z = 0.0f;
                data[3].Tu = 1.0f;
                data[3].Tv = 1.0f;

                m_vb.SetData(data, 0, 0);

                Device3D.SetStreamSource(0, m_vb, 0);
                Device3D.VertexFormat = CustomVertex.TransformedTextured.Format;

                // Set the texture
                Device3D.SetTexture(0, image.GetTexture());

                // Render the face
                Device3D.DrawPrimitives(PrimitiveType.TriangleStrip, 0, 2);

                Device3D.RenderState.FogEnable = deviceInfo.FogEnabled;
            }
            catch (DirectXException d3de)
            {
                Console.AddLine("Unable to display SplashScreen ");
                Console.AddLine(d3de.ErrorString);
            }
            catch (Exception e)
            {
                Console.AddLine("Unable to display SplashScreen ");
                Console.AddLine(e.Message);
            }

            // check for timeout
            float fCurrentTime = Utils.Timer(TIMER.GETABSOLUTETIME);
            fTimeLeft = m_EndTime - fCurrentTime;

            //return (fCurrentTime > m_EndTime);
        }

        /// <summary>
        /// dispose of the image
        /// </summary>
        public void Dispose()
        {
            image.Dispose();
        }
    }
    /// <summary>
    /// Summary description for the OptionScreen class.
    /// This class encapsulates a Option Screen
    /// </summary>
    public class OptionScreen : IRenderable, IDisposable
    {
        #region Attributes
        private Image m_Background = null;
        private Image m_Cursor = null;
        public bool m_bInitialized = false;
        private List<ImageButton> m_buttons = new List<ImageButton>();
        private Point m_MousePoint = new Point(0, 0);
        private bool m_bMouseIsDown = false;
        private bool m_bMouseWasDown = false;
        private VertexBuffer m_vb;
        #endregion

        public OptionScreen(string filename)
        {
            try
            {
                m_Background = new Image(filename);

                m_Cursor = new Image(@"Media\Cursor.dds");
            }
            catch (DirectXException d3de)
            {
                Console.AddLine("Error creating Option Screen " + filename);
                Console.AddLine(d3de.ErrorString);
            }
            catch (Exception e)
            {
                Console.AddLine("Error creating Option Screen " + filename);
                Console.AddLine(e.Message);
            }
        }

        public void InitDevice(Device device, bool isReset)
        {
            m_vb = new VertexBuffer(typeof(CustomVertex.TransformedTextured), 4,
                device, Usage.WriteOnly, CustomVertex.TransformedTextured.Format,
                Pool.Default);

            m_Background.InitDevice(device, isReset);
            m_Cursor.InitDevice(device, isReset);
            foreach (ImageButton button in m_buttons)
                button.InitDevice(device, isReset);
        }

        public void LostDevice(Device device) { }

        public void AddButton(int nX, int nY, string sOffFilename, string sOnFilename, string sHoverFilename, ButtonFunction pFunc)
        {
            ImageButton button = new ImageButton(nX, nY, sOffFilename, sOnFilename, sHoverFilename, pFunc);

            m_buttons.Add(button);
        }

        public void Render(Device Device3D, DeviceInfo deviceInfo)
        {
            try
            {
                Device3D.RenderState.FogEnable = false;

                CustomVertex.TransformedTextured[] data = new CustomVertex.TransformedTextured[4];
                data[0].X = 0.0f;
                data[0].Y = 0.0f;
                data[0].Z = 1.0f;
                data[0].Tu = 0.0f;
                data[0].Tv = 0.0f;
                data[1].X = Device3D.Viewport.Width;
                data[1].Y = 0.0f;
                data[1].Z = 1.0f;
                data[1].Tu = 1.0f;
                data[1].Tv = 0.0f;
                data[2].X = 0.0f;
                data[2].Y = Device3D.Viewport.Height;
                data[2].Z = 1.0f;
                data[2].Tu = 0.0f;
                data[2].Tv = 1.0f;
                data[3].X = Device3D.Viewport.Width;
                data[3].Y = Device3D.Viewport.Height;
                data[3].Z = 1.0f;
                data[3].Tu = 1.0f;
                data[3].Tv = 1.0f;

                m_vb.SetData(data, 0, 0);

                Device3D.SetStreamSource(0, m_vb, 0);
                Device3D.VertexFormat = CustomVertex.TransformedTextured.Format;

                // Set the texture
                Device3D.SetTexture(0, m_Background.GetTexture());

                // Render the screen background
                Device3D.DrawPrimitives(PrimitiveType.TriangleStrip, 0, 2);

                // Set diffuse blending for alpha set in vertices.
                Device3D.RenderState.AlphaBlendEnable = true;
                Device3D.RenderState.SourceBlend = Blend.SourceAlpha;
                Device3D.RenderState.DestinationBlend = Blend.InvSourceAlpha;

                // Enable alpha testing (skips pixels with less than a certain alpha.)
                if (Device3D.DeviceCaps.AlphaCompareCaps.SupportsGreaterEqual)
                {
                    Device3D.RenderState.AlphaTestEnable = true;
                    Device3D.RenderState.ReferenceAlpha = 0x08;
                    Device3D.RenderState.AlphaFunction = Compare.GreaterEqual;
                }
                // copy on the buttons
                foreach (ImageButton button in m_buttons)
                {
                    button.HoverTest(m_MousePoint);
                    if (m_bMouseIsDown && !m_bMouseWasDown)
                    {
                        button.ClickTest(m_MousePoint);
                    }

                    button.Render(Device3D, deviceInfo);
                }
                m_bMouseWasDown = m_bMouseIsDown;

                // draw cursor
                Rectangle mouserect = new Rectangle(m_MousePoint, m_Cursor.GetSize());
                try
                {
                    data[0].X = (float)mouserect.X;
                    data[0].Y = (float)mouserect.Y;
                    data[0].Z = 0.0f;
                    data[0].Tu = 0.0f;
                    data[0].Tv = 0.0f;
                    data[1].X = (float)(mouserect.X + mouserect.Width);
                    data[1].Y = (float)mouserect.Y;
                    data[1].Z = 0.0f;
                    data[1].Tu = 1.0f;
                    data[1].Tv = 0.0f;
                    data[2].X = (float)mouserect.X;
                    data[2].Y = (float)(mouserect.Y + mouserect.Height);
                    data[2].Z = 0.0f;
                    data[2].Tu = 0.0f;
                    data[2].Tv = 1.0f;
                    data[3].X = (float)(mouserect.X + mouserect.Width);
                    data[3].Y = (float)(mouserect.Y + mouserect.Height);
                    data[3].Z = 0.0f;
                    data[3].Tu = 1.0f;
                    data[3].Tv = 1.0f;

                    m_vb.SetData(data, 0, 0);

                    Device3D.SetStreamSource(0, m_vb, 0);
                    Device3D.VertexFormat = CustomVertex.TransformedTextured.Format;

                    // Set the texture
                    Device3D.SetTexture(0, m_Cursor.GetTexture());

                    // Set diffuse blending for alpha set in vertices.
                    Device3D.RenderState.AlphaBlendEnable = true;
                    Device3D.RenderState.SourceBlend = Blend.SourceAlpha;
                    Device3D.RenderState.DestinationBlend = Blend.InvSourceAlpha;

                    // Enable alpha testing (skips pixels with less than a certain alpha.)
                    if (Device3D.DeviceCaps.AlphaCompareCaps.SupportsGreaterEqual)
                    {
                        Device3D.RenderState.AlphaTestEnable = true;
                        Device3D.RenderState.ReferenceAlpha = 0x08;
                        Device3D.RenderState.AlphaFunction = Compare.GreaterEqual;
                    }
                    // Render the face
                    Device3D.DrawPrimitives(PrimitiveType.TriangleStrip, 0, 2);
                }
                catch (DirectXException d3de)
                {
                    Console.AddLine("Unable to display cursor ");
                    Console.AddLine(d3de.ErrorString);
                }
                catch (Exception e)
                {
                    Console.AddLine("Unable to display cursor ");
                    Console.AddLine(e.Message);
                }

                Device3D.RenderState.FogEnable = deviceInfo.FogEnabled;
            }
            catch (DirectXException d3de)
            {
                Console.AddLine("Error rendering Option Screen ");
                Console.AddLine(d3de.ErrorString);
            }
            catch (Exception e)
            {
                Console.AddLine("Error rendering Option Screen ");
                Console.AddLine(e.Message);
            }
        }

        public void SetMousePosition(int x, int y, bool bDown)
        {
            m_MousePoint.X = x;
            m_MousePoint.Y = y;
            m_bMouseIsDown = bDown;
        }

        public void Dispose()
        {
            m_Background.Dispose();
            m_Cursor.Dispose();
            m_vb.Dispose();
            foreach (ImageButton button in m_buttons)
                button.Dispose();
        }
    }
}