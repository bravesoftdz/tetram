using System;
using System.Drawing;
using Microsoft.DirectX;
using Microsoft.DirectX.Direct3D;
using System.Collections.Generic;

namespace DXEngine
{
    /// <summary>
    /// delegate used for specifying the update method for each 
    /// particle from a given generator
    /// </summary>
    public delegate void ParticleUpdate(ref Particle Obj, float DeltaT);

    /// <summary>
    /// data structure for a given particle
    /// </summary>
    public struct Particle
    {
        public Vector3 Position, Accel, Speed;
        public Vector3 InitialPosition, InitialAccel, InitialSpeed;
        public System.Drawing.Color Color;
        public float fTimeRemaining, fCreationTime;
        public bool bActive;
    }


    /// <summary>
    /// Summary description for ParticleGenerator.
    /// </summary>
    public class ParticleGenerator : Object3D, IDisposable, IRenderable
    {
        #region Attributes
        private bool m_bValid = false;
        private string m_sTexture;
        private Image m_Texture;
        private int m_BaseParticle = 0;
        private int m_Flush = 0;
        private int m_Discard = 0;
        public int m_ParticlesLimit = 2000;
        private int m_Particles = 0;
        private Color m_Color;
        private float m_fTime = 0.0f;

        private VertexBuffer m_VB;
        private bool m_bActive = false;

        private List<Particle> m_ActiveParticles = new List<Particle>();
        private List<Particle> m_FreeParticles = new List<Particle>();
        private ParticleUpdate m_Method = null;
        private System.Random rand = new System.Random();

        public float m_fRate = 22.0f;  // particles to create per second
        public float m_fPartialParticles = 0.0f;
        public Vector3 m_EmitAccel = new Vector3(0.0f, 0.0f, 0.0f);
        public Vector3 m_EmitSpeed = new Vector3(0.0f, 0.0f, 0.7f);
        public Vector3 m_EmitAccelModulate = new Vector3(0.0f, 0.0f, 0.0f);
        public Vector3 m_EmitSpeedModulate = new Vector3(0.0f, 0.0f, 0.0f);
        public Vector3 m_EmitPositionModulate = new Vector3(1.0f, 0.0f, 1.0f);
        public float m_PointSize = 0.02f;
        public float m_PointSizeMin = 0.00f;
        public float m_PointScaleA = 0.00f;
        public float m_PointScaleB = 0.00f;
        public float m_PointScaleC = 1.00f;

        public bool Valid { get { return m_bValid; } }
        public bool Active { set { m_bActive = value; } }
        #endregion

        /// <Summary>copy constructor</Summary>
        public ParticleGenerator(Engine Engine, string Name, ParticleGenerator other)
            : base(Engine, Name)
        {
            Copy(other);
        }

        /// <Summary>normal constructor</Summary>
        public ParticleGenerator(Engine Engine, string Name, int numFlush, int numDiscard, Color color, string sTextureName, ParticleUpdate method)
            : base(Engine, Name)
        {
            m_Color = color;
            m_Flush = numFlush;
            m_Discard = numDiscard;
            m_sTexture = sTextureName;
            m_Texture = new Image(m_sTexture);
            m_Method = method;
        }

        private void Copy(ParticleGenerator other)
        {
            m_Flush = other.m_Flush;
            m_Discard = other.m_Discard;
            m_sTexture = other.m_sTexture;
            m_Method = other.m_Method;
            m_fRate = other.m_fRate;
            m_EmitAccel = other.m_EmitAccel;
            m_EmitSpeed = other.m_EmitSpeed;
            m_EmitAccelModulate = other.m_EmitAccelModulate;
            m_EmitSpeedModulate = other.m_EmitSpeedModulate;
            m_EmitPositionModulate = other.m_EmitPositionModulate;
            Rotation = other.Rotation;
            Position = other.Position;
            m_PointSize = other.m_PointSize;
            m_PointSizeMin = other.m_PointSizeMin;
            m_PointScaleA = other.m_PointScaleA;
            m_PointScaleB = other.m_PointScaleB;
            m_PointScaleC = other.m_PointScaleC;
            m_bValid = other.m_bValid;
        }

        public virtual void InitParticle(ref Particle particle)
        {
            particle.fCreationTime = m_fTime;
            particle.bActive = true;
        }
             
        public void Update()
        {
            m_fTime += Engine.elapsedTime;              

            // Emit new particles
            float TotalNewParticles = (Engine.elapsedTime * m_fRate) + m_fPartialParticles;
            int NumParticlesToEmit = (int)TotalNewParticles;
            m_fPartialParticles = TotalNewParticles - NumParticlesToEmit;
            int particlesEmit = m_Particles + NumParticlesToEmit;
            while (m_Particles < m_ParticlesLimit && m_Particles < particlesEmit)
            {
                Particle particle;

                if (m_FreeParticles.Count > 0)
                {
                    particle = (Particle)m_FreeParticles[0];
                    m_FreeParticles.RemoveAt(0);
                }
                else
                {
                    particle = new Particle();
                }

                InitParticle(ref particle);

                m_ActiveParticles.Add(particle);
                m_Particles++;
            }
            for (int i = 0; i < m_ActiveParticles.Count; i++)
            {
                Particle p = (Particle)m_ActiveParticles[i];
                m_Method(ref p, Engine.elapsedTime);
                if (p.bActive)
                {
                    m_ActiveParticles[i] = p;
                }
                else
                {
                    m_ActiveParticles.RemoveAt(i);
                    m_FreeParticles.Add(p);
                    m_Particles--;
                }
            }
        }

        public void Render(Device Device3D, DeviceInfo deviceInfo)
        {
            Update();
            try
            {
                if (m_ActiveParticles.Count > 0)
                {
                    Device3D.Transform.World = this.World;
                    // il faut désactiver la lumière sinon les couleurs ne sont pas utilisées
                    Device3D.RenderState.Lighting = false;

                    // Set the render states for using point sprites
                    Device3D.RenderState.ZBufferWriteEnable = false;
                    Device3D.RenderState.AlphaBlendEnable = true;
                    Device3D.RenderState.SourceBlend = Blend.SourceAlpha;
                    Device3D.RenderState.DestinationBlend = Blend.One;

                    Device3D.SetTexture(0, m_Texture.GetTexture());
                    Device3D.RenderState.PointSpriteEnable = true;
                    Device3D.RenderState.PointScaleEnable = true;
                    Device3D.RenderState.PointSize = m_PointSize;
                    Device3D.RenderState.PointSizeMin = m_PointSizeMin;
                    Device3D.RenderState.PointScaleA = m_PointScaleA;
                    Device3D.RenderState.PointScaleB = m_PointScaleB;
                    Device3D.RenderState.PointScaleC = m_PointScaleC;

                    Device3D.VertexFormat = CustomVertex.PositionColoredTextured.Format;

                    // Set up the vertex buffer to be rendered
                    Device3D.SetStreamSource(0, m_VB, 0);

                    CustomVertex.PositionColoredTextured[] vertices = null;
                    int numParticlesToRender = 0;

                    // Lock the vertex buffer.  We fill the vertex buffer in small
                    // chunks, using LockFlags.NoOverWrite.  When we are done filling
                    // each chunk, we call DrawPrim, and lock the next chunk.  When
                    // we run out of space in the vertex buffer, we start over at
                    // the beginning, using LockFlags.Discard.

                    m_BaseParticle += m_Flush;

                    if (m_BaseParticle >= m_Discard)
                        m_BaseParticle = 0;

                    int count = 0;
                    vertices = (CustomVertex.PositionColoredTextured[])m_VB.Lock(m_BaseParticle * DXHelp.GetTypeSize(typeof(CustomVertex.PositionColoredTextured)), typeof(CustomVertex.PositionColoredTextured), (m_BaseParticle != 0) ? LockFlags.NoOverwrite : LockFlags.Discard, m_Flush);
                    foreach (Particle p in m_ActiveParticles)
                    {
                        vertices[count].X = p.Position.X;
                        vertices[count].Y = p.Position.Y;
                        vertices[count].Z = p.Position.Z;
                        vertices[count].Color = unchecked((int)p.Color.ToArgb());
                        count++;

                        if (++numParticlesToRender == m_Flush)
                        {
                            // Done filling this chunk of the vertex buffer.  Lets unlock and
                            // draw this portion so we can begin filling the next chunk.

                            m_VB.Unlock();

                            Device3D.DrawPrimitives(PrimitiveType.PointList, m_BaseParticle, numParticlesToRender);

                            // Lock the next chunk of the vertex buffer.  If we are at the 
                            // end of the vertex buffer, LockFlags.Discard the vertex buffer and start
                            // at the beginning.  Otherwise, specify LockFlags.NoOverWrite, so we can
                            // continue filling the VB while the previous chunk is drawing.
                            m_BaseParticle += m_Flush;

                            if (m_BaseParticle >= m_Discard)
                                m_BaseParticle = 0;

                            vertices = (CustomVertex.PositionColoredTextured[])m_VB.Lock(m_BaseParticle * DXHelp.GetTypeSize(typeof(CustomVertex.PositionColoredTextured)), typeof(CustomVertex.PositionColoredTextured), (m_BaseParticle != 0) ? LockFlags.NoOverwrite : LockFlags.Discard, m_Flush);
                            count = 0;

                            numParticlesToRender = 0;
                        }

                    }

                    // Unlock the vertex buffer
                    m_VB.Unlock();
                    // Render any remaining particles
                    if (numParticlesToRender > 0)
                        Device3D.DrawPrimitives(PrimitiveType.PointList, m_BaseParticle, numParticlesToRender);

                    // Reset render states
                    Device3D.RenderState.PointSpriteEnable = false;
                    Device3D.RenderState.PointScaleEnable = false;

                    Device3D.RenderState.ZBufferWriteEnable = true;
                    Device3D.RenderState.AlphaBlendEnable = false;

                }
            }
            catch (DirectXException d3de)
            {
                Console.AddLine("Unable to Render Particles");
                Console.AddLine(d3de.ErrorString);
            }
            catch (Exception e)
            {
                Console.AddLine("Unable to Render Particles");
                Console.AddLine(e.Message);
            }
        }

        public void Dispose()
        {
            if (m_Texture != null) m_Texture.Dispose();
            if (m_VB != null) m_VB.Dispose();
        }

        #region IRenderable Membres

        public void InitDevice(Device Device3D, bool isReset)
        {
            try
            {
                m_Texture.InitDevice(Device3D, isReset); 
                try
                {
                    m_VB = new VertexBuffer(typeof(CustomVertex.PositionColoredTextured), m_Discard,
                        Device3D, Usage.Dynamic | Usage.WriteOnly | Usage.Points,
                        CustomVertex.PositionColoredTextured.Format, Pool.Default);
                    m_bValid = true;

                }
                catch (DirectXException d3de)
                {
                    Console.AddLine("Unable to create vertex buffer for " + Name);
                    Console.AddLine(d3de.ErrorString);
                }
                catch (Exception e)
                {
                    Console.AddLine("Unable to create vertex buffer for " + Name);
                    Console.AddLine(e.Message);
                }
            }
            catch (DirectXException d3de)
            {
                Console.AddLine("Unable to create texture " + m_sTexture);
                Console.AddLine(d3de.ErrorString);
            }
            catch (Exception e)
            {
                Console.AddLine("Unable to create texture " + m_sTexture);
                Console.AddLine(e.Message);
            }

        }

        public void LostDevice(Device device)
        {
            m_Texture.LostDevice(device);
            Dispose();
        }

        #endregion
    }
}
