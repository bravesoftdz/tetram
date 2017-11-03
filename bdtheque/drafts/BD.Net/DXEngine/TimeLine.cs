using System;
using System.Collections.Generic;
using System.Text;
using Microsoft.DirectX;
using D3DFont = Microsoft.DirectX.Direct3D.Font;
using System.Drawing;
using Microsoft.DirectX.Direct3D;

namespace DXEngine
{
    public struct Position
    {
        public Vector3 look, eye;
        public TimeSpan start;
    }

    public class TimeLine : IRenderable, IComparer<Position>
    {
        public int Compare(Position x, Position y)
        {
            return TimeSpan.Compare(x.start, y.start);
        }

        public enum TimeLineStatus
        {
            Stopped,
            Playing,
            Recording,
            PausePlaying,
            PauseRecording
        }

        List<Position> Positions = new List<Position>();
        internal TimeSpan Interval = new TimeSpan(0, 0, 0, 0, 100);
        internal TimeLineStatus timelineStatus = TimeLineStatus.Stopped;
        internal int currentPosition;
        internal DateTime debut;
        internal Position startPOV, currentPOV, previousPOV;
        internal POV pov;
        public bool DoRender = false;

        internal D3DFont infoD3DFont;

        static internal TimeLine instance;
        static public TimeLine Instance
        {
            get
            {
                if (instance == null) instance = new TimeLine();
                return instance;
            }
        }

        private TimeLine() 
        {
            Console.AddCommand("TIMELINE", "Commande la timeline.", new CommandFunction(Command));
        }

        private void Command(string sData)
        {
            switch (sData)
            {
                case "PLAY":
                case "START":
                    {
                        Console.ToggleState();
                        Play(POV.Instance);
                        break;
                    }
                case "STOP":
                    {
                        Stop();
                        break;
                    }
                case "PAUSE":
                    {
                        Pause();
                        break;
                    }
                case "RECORD":
                    {
                        Console.ToggleState();
                        Record();
                        break;
                    }
                case "SHOW":
                    {
                        DoRender = true;
                        break;
                    }
                case "HIDE":
                    {
                        DoRender = false;
                        break;
                    }
            }
        }
        
        public void Record()
        {
            Positions.Clear();
            debut = DateTime.Now;
            timelineStatus = TimeLineStatus.Recording;
        }

        public void Play(POV pov)
        {
            startPOV.eye = pov.Eye;
            startPOV.look = pov.Look;
            startPOV.start = new TimeSpan(0);
            Positions.Sort(this);
            Restart(pov);
            timelineStatus = TimeLineStatus.Playing;
        }

        public void Stop()
        {
            timelineStatus = TimeLineStatus.Stopped;
            Restart(null);
        }

        public void Pause()
        {
            switch (timelineStatus)
            {
                case TimeLineStatus.PausePlaying:
                    {
                        timelineStatus = TimeLineStatus.Playing;
                        break;
                    }
                case TimeLineStatus.Playing:
                    {
                        timelineStatus = TimeLineStatus.PausePlaying;
                        break;
                    }
                case TimeLineStatus.PauseRecording:
                    {
                        timelineStatus = TimeLineStatus.Recording;
                        break;
                    }
                case TimeLineStatus.Recording:
                    {
                        timelineStatus = TimeLineStatus.PauseRecording;
                        break;
                    }
            }
        }
         
        public void Restart(POV pov)
        {
            this.pov = pov;
            currentPosition = 0;
            debut = DateTime.Now;
        }

        #region IRenderable Membres

        public void InitDevice(Microsoft.DirectX.Direct3D.Device device, bool isReset)
        {
            infoD3DFont = new D3DFont(device, new System.Drawing.Font("Arial", 12));
        }

        public void LostDevice(Microsoft.DirectX.Direct3D.Device device)
        {
            //infoD3DFont.Dispose();
        }

        public void Render(Microsoft.DirectX.Direct3D.Device device, DeviceInfo deviceInfo)
        {
            Vector3 newEye = currentPOV.eye;
            Vector3 newLook = currentPOV.look;
            float factor = -1;

            switch (timelineStatus)
            {
                case TimeLineStatus.Recording:
                    {
                        Position newPos;
                        newPos.start = new TimeSpan(-1);

                        if (currentPosition == 0)
                        {
                            newPos.start = new TimeSpan(0);
                        }
                        else
                        {
                            TimeSpan delta = DateTime.Now - debut;
                            if (delta > Interval)
                            {
                                newPos.start = Positions[currentPosition - 1].start + delta;
                                debut = DateTime.Now;
                            }
                        }

                        if (newPos.start >= new TimeSpan(0))
                        {
                            newPos.eye = POV.Instance.Eye;
                            newPos.look = POV.Instance.Look;
                            Positions.Add(newPos);
                            currentPosition++;
                        }
                        break;
                    }
                case TimeLineStatus.Playing:
                    {
                        if (pov == null || Positions.Count == 0) return;

                        TimeSpan delta = DateTime.Now - debut;

                        while (Positions[currentPosition].start <= delta && currentPosition < Positions.Count)
                            currentPosition++;

                        if (currentPosition == Positions.Count - 1) timelineStatus = TimeLineStatus.Stopped; 

                        currentPOV = Positions[currentPosition];
                        if (currentPosition == 0)
                            previousPOV = startPOV;
                        else
                            previousPOV = Positions[currentPosition - 1];

                        factor = (float)(delta.Ticks - previousPOV.start.Ticks) / (float)(currentPOV.start.Ticks - previousPOV.start.Ticks);

                        newEye = previousPOV.eye + (currentPOV.eye - previousPOV.eye) * factor;
                        newLook = previousPOV.look + (currentPOV.look - previousPOV.look) * factor;

                        POV.Instance.Position(newEye, newLook);
                        break;
                    }
            }

            if (DoRender)
            {
                string msg = "Status: " + timelineStatus.ToString() +
                             "\ncurrentPosition: " + currentPosition.ToString() +
                             "\nPositions.Count: " + Positions.Count.ToString() +
                             "\ncurrentPOV: " + currentPOV.eye.ToString() +
                             "\npreviousPOV: " + previousPOV.eye.ToString() +
                             "\nfactor: " + factor.ToString() +
                             "\nnewEye: " + newEye.ToString() +
                             "\nnewLook: " + newLook.ToString();

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

        #endregion
    }
}
