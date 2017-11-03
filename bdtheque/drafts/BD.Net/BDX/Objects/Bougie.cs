﻿using System;
using System.Collections.Generic;
using System.Text;
using DXEngine;
using System.Drawing;
using Microsoft.DirectX;

namespace BDX.Objects
{
    class Bougie : ParticleGenerator
    {
        public Bougie(Object3D parent)
            : base("Feu", 10, 20, Color.Red, @"Media\Flame02.bmp", null)
        {
            m_Method = new ParticleUpdate(BougieUpdate);

            Parent = parent;
            m_ParticlesLimit = 10;

            m_EmitPositionModulate = new Vector3(0.2f, 0.0f, 0.2f);
            m_EmitAccel = new Vector3(0, 0, 0);
            m_EmitAccelModulate = new Vector3(0.0f, 0.15f, 0.0f);
            m_EmitSpeed = new Vector3(0.0f, 0.5f, 0.0f);
            m_EmitSpeedModulate = new Vector3(0.2f, 0.3f, 0.2f);

            m_PointSize = 3;
            m_PointScaleA = 0;
            m_PointScaleB = 0;
            m_PointScaleC = 1;
        }

        static private System.Random rnd = new System.Random();
        public void BougieUpdate(ref Particle Obj, float DeltaT)
        {
 
            //Call .ResetIt(X, Y, -0.4 + (Rnd * 0.8), -0.5 - (Rnd * 0.4), 0, -(Rnd * 0.3), 2)
            //ResetIt(X As Single, Y As Single, XSpeed As Single, YSpeed As Single, XAcc As Single, YAcc As Single, sngResetSize As Single)
            //sngX = sngX + sngXSpeed * sngTime;
            //sngY = sngY + sngYSpeed * sngTime;
            Obj.Position += new Vector3((float)(Obj.Speed.X * DeltaT), (float)(Obj.Speed.Y * DeltaT), (float)(Obj.Speed.Z * DeltaT));

            //sngXSpeed = sngXSpeed + sngXAccel * sngTime;
            //sngYSpeed = sngYSpeed + sngYAccel * sngTime;
            Obj.Speed += new Vector3((float)(Obj.Accel.X * DeltaT), (float)(Obj.Accel.Y * DeltaT), (float)(Obj.Accel.Z * DeltaT));

            //Call .ResetColor(1, 0.5, 0.2, 0.6 + (0.2 * Rnd), 0.01 + Rnd * 0.05)
            //ResetColor(sngRed As Single, sngGreen As Single, sngBlue As Single, sngAlpha As Single, sngDecay As Single)
            //sngA = sngA - sngAlphaDecay * sngTime;
            //Obj.m_Color = Color.FromArgb(0.6 + rnd.Next(0.2) - (0.01 + rnd.Next(0.05)) * DeltaT, 1, 0.5, 0.2);
            //Obj.Color = Color.FromArgb((int)(153 + rnd.Next(51) - (3 + rnd.Next(13)) * DeltaT), 255, 128, 51);
            int alpha = (int)(Obj.Color.A - /*(3 + rnd.Next(13)) * */ DeltaT);
            if (alpha < 0) alpha = 0;
            Obj.Color = Color.FromArgb(alpha, Obj.Color);

            Obj.fTimeRemaining -= DeltaT;
            Obj.bActive = /* Obj.fTimeRemaining > 0; && */Obj.Color.A > 0;
        }

        private void CalculPosition(ref Particle particle)
        {
            particle.Position = new Vector3(m_EmitPositionModulate.X * (float)(rnd.NextDouble() - 0.5),
                                            m_EmitPositionModulate.Y * (float)(rnd.NextDouble() - 0.5),
                                            m_EmitPositionModulate.Z * (float)(rnd.NextDouble() - 0.5));
            particle.Accel = m_EmitAccel + new Vector3(m_EmitAccelModulate.X * (float)(rnd.NextDouble() - 0.5),
                                                       m_EmitAccelModulate.Y * (float)(rnd.NextDouble() - 0.5),
                                                       m_EmitAccelModulate.Z * (float)(rnd.NextDouble() - 0.5));
            particle.Speed = m_EmitSpeed + new Vector3(m_EmitSpeedModulate.X * (float)(rnd.NextDouble() - 0.5),
                                                       m_EmitSpeedModulate.Y * (float)(rnd.NextDouble() - 0.5),
                                                       m_EmitSpeedModulate.Z * (float)(rnd.NextDouble() - 0.5));
        }

        public override void InitParticle(ref Particle particle)
        {
            base.InitParticle(ref particle);

            CalculPosition(ref particle);

            particle.InitialPosition = particle.Position;
            particle.InitialAccel = particle.Accel;
            particle.InitialSpeed = particle.Speed;

//            particle.Color = Color.FromArgb(200 + rnd.Next(55), 255, 128, 51);
            particle.Color = Color.FromArgb(153 + rnd.Next(51), 255, 128, 51);

            particle.fTimeRemaining = 0.5f;
        }
    }
}
