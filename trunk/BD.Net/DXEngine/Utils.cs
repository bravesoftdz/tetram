using System;
using System.Collections.Generic;
using System.Text;
using Microsoft.DirectX.Direct3D;
using System.Runtime.InteropServices;

public enum TIMER
{
    RESET,
    START,
    STOP,
    ADVANCE,
    GETABSOLUTETIME,
    GETAPPTIME,
    GETELAPSEDTIME
};

class Utils
{
    #region Timer Internal Stuff
    [System.Security.SuppressUnmanagedCodeSecurity] // We won't use this maliciously
    [DllImport("kernel32")]
    private static extern bool QueryPerformanceFrequency(ref long PerformanceFrequency);
    [System.Security.SuppressUnmanagedCodeSecurity] // We won't use this maliciously
    [DllImport("kernel32")]
    private static extern bool QueryPerformanceCounter(ref long PerformanceCount);
    [System.Security.SuppressUnmanagedCodeSecurity] // We won't use this maliciously
    [DllImport("winmm.dll")]
    public static extern int timeGetTime();
    private static bool m_bTimerInitialized = false;
    private static bool m_bUsingQPF = false;
    private static bool m_bTimerStopped = true;
    private static long m_llQPFTicksPerSec = 0;
    private static long m_llStopTime = 0;
    private static long m_llLastElapsedTime = 0;
    private static long m_llBaseTime = 0;
    private static double m_fLastElapsedTime = 0.0;
    private static double m_fBaseTime = 0.0;
    private static double m_fStopTime = 0.0;
    #endregion

    private Utils() { }

    /// <summary>
    /// Gets the number of ColorChanelBits from a format
    /// </summary>
    static public int GetColorChannelBits(Format format)
    {
        switch (format)
        {
            case Format.R8G8B8:
                return 8;
            case Format.A8R8G8B8:
                return 8;
            case Format.X8R8G8B8:
                return 8;
            case Format.R5G6B5:
                return 5;
            case Format.X1R5G5B5:
                return 5;
            case Format.A1R5G5B5:
                return 5;
            case Format.A4R4G4B4:
                return 4;
            case Format.R3G3B2:
                return 2;
            case Format.A8R3G3B2:
                return 2;
            case Format.X4R4G4B4:
                return 4;
            case Format.A2B10G10R10:
                return 10;
            case Format.A2R10G10B10:
                return 10;
            default:
                return 0;
        }
    }

    /// <summary>
    /// Gets the number of alpha channel bits 
    /// </summary>
    static public int GetAlphaChannelBits(Format format)
    {
        switch (format)
        {
            case Format.R8G8B8:
                return 0;
            case Format.A8R8G8B8:
                return 8;
            case Format.X8R8G8B8:
                return 0;
            case Format.R5G6B5:
                return 0;
            case Format.X1R5G5B5:
                return 0;
            case Format.A1R5G5B5:
                return 1;
            case Format.A4R4G4B4:
                return 4;
            case Format.R3G3B2:
                return 0;
            case Format.A8R3G3B2:
                return 8;
            case Format.X4R4G4B4:
                return 0;
            case Format.A2B10G10R10:
                return 2;
            case Format.A2R10G10B10:
                return 2;
            default:
                return 0;
        }
    }

    /// <summary>
    /// Gets the number of depth bits
    /// </summary>
    static public int GetDepthBits(DepthFormat format)
    {
        switch (format)
        {
            case DepthFormat.D16:
                return 16;
            case DepthFormat.D15S1:
                return 15;
            case DepthFormat.D24X8:
                return 24;
            case DepthFormat.D24S8:
                return 24;
            case DepthFormat.D24X4S4:
                return 24;
            case DepthFormat.D32:
                return 32;
            default:
                return 0;
        }
    }

    static public int GetStencilBits(DepthFormat format)
    {
        switch (format)
        {
            case DepthFormat.D16:
                return 0;
            case DepthFormat.D15S1:
                return 1;
            case DepthFormat.D24X8:
                return 0;
            case DepthFormat.D24S8:
                return 8;
            case DepthFormat.D24X4S4:
                return 4;
            case DepthFormat.D32:
                return 0;
            default:
                return 0;
        }
    }

    //-----------------------------------------------------------------------------
    // Name: DXUtil.Timer()
    // Desc: Performs timer opertations. Use the following commands:
    //          TIMER.RESET           - to reset the timer
    //          TIMER.START           - to start the timer
    //          TIMER.STOP            - to stop (or pause) the timer
    //          TIMER.ADVANCE         - to advance the timer by 0.001 seconds
    //          TIMER.GETABSOLUTETIME - to get the absolute system time
    //          TIMER.GETAPPTIME      - to get the current time
    //          TIMER.GETELAPSEDTIME  - to get the time that elapsed between 
    //                                  TIMER_GETELAPSEDTIME calls
    //-----------------------------------------------------------------------------
    public static float Timer(TIMER command)
    {
        if (!m_bTimerInitialized)
        {
            m_bTimerInitialized = true;

            // Use QueryPerformanceFrequency() to get frequency of timer.  If QPF is
            // not supported, we will timeGetTime() which returns milliseconds.
            long qwTicksPerSec = 0;
            m_bUsingQPF = QueryPerformanceFrequency(ref qwTicksPerSec);
            if (m_bUsingQPF)
                m_llQPFTicksPerSec = qwTicksPerSec;  // in msec
        }
        if (m_bUsingQPF)
        {
            double fTime;
            double fElapsedTime;
            long qwTime = 0;

            // Get either the current time or the stop time, depending
            // on whether we're stopped and what command was sent
            if (m_llStopTime != 0 && command != TIMER.START && command != TIMER.GETABSOLUTETIME)
                qwTime = m_llStopTime;
            else
                QueryPerformanceCounter(ref qwTime);

            switch (command)
            {
                case TIMER.GETELAPSEDTIME:
                    {
                        // Return the elapsed time
                        fElapsedTime = (double)(qwTime - m_llLastElapsedTime) / (double)m_llQPFTicksPerSec;
                        m_llLastElapsedTime = qwTime;
                        return (float)fElapsedTime;
                    }
                case TIMER.GETAPPTIME:
                    {
                        // Return the current time
                        double fAppTime = (double)(qwTime - m_llBaseTime) / (double)m_llQPFTicksPerSec;
                        return (float)fAppTime;
                    }
                case TIMER.RESET:
                    {
                        // Reset the timer
                        m_llBaseTime = qwTime;
                        m_llLastElapsedTime = qwTime;
                        m_llStopTime = 0;
                        m_bTimerStopped = false;
                        return 0.0f;
                    }
                case TIMER.START:
                    {
                        // Start the timer
                        if (m_bTimerStopped)
                            m_llBaseTime += qwTime - m_llStopTime;
                        m_llStopTime = 0;
                        m_llLastElapsedTime = qwTime;
                        m_bTimerStopped = false;
                        return 0.0f;
                    }
                case TIMER.STOP:
                    {
                        // Stop the timer
                        m_llStopTime = qwTime;
                        m_llLastElapsedTime = qwTime;
                        m_bTimerStopped = true;
                        return 0.0f;
                    }
                case TIMER.ADVANCE:
                    {
                        // Advance the timer by millisecond
                        m_llStopTime += m_llQPFTicksPerSec / 1000;
                        return 0.0f;
                    }
                case TIMER.GETABSOLUTETIME:
                    {
                        fTime = qwTime / (double)m_llQPFTicksPerSec;
                        return (float)fTime;
                    }
                default:
                    return -1.0f; // Invalid command specified
            }
        }
        else
        {
            // Get the time using timeGetTime()
            double fTime;
            double fElapsedTime;

            // Get either the current time or the stop time, depending
            // on whether we're stopped and what command was sent
            if (m_fStopTime != 0.0 && command != TIMER.START && command != TIMER.GETABSOLUTETIME)
                fTime = m_fStopTime;
            else
                fTime = timeGetTime();

            switch (command)
            {
                case TIMER.GETELAPSEDTIME:
                    {
                        // Return the elapsed time
                        fElapsedTime = (double)(fTime - m_fLastElapsedTime);
                        m_fLastElapsedTime = fTime;
                        return (float)fElapsedTime;
                    }
                case TIMER.GETAPPTIME:
                    {
                        // Return the current time
                        return (float)(fTime - m_fBaseTime);
                    }
                case TIMER.RESET:
                    {
                        // Reset the timer
                        m_fBaseTime = fTime;
                        m_fLastElapsedTime = fTime;
                        m_fStopTime = 0;
                        m_bTimerStopped = false;
                        return 0.0f;
                    }
                case TIMER.START:
                    {
                        // Start the timer
                        if (m_bTimerStopped)
                            m_fBaseTime += fTime - m_fStopTime;
                        m_fStopTime = 0.0f;
                        m_fLastElapsedTime = fTime;
                        m_bTimerStopped = false;
                        return 0.0f;
                    }
                case TIMER.STOP:
                    {
                        // Stop the timer
                        m_fStopTime = fTime;
                        m_fLastElapsedTime = fTime;
                        m_bTimerStopped = true;
                        return 0.0f;
                    }
                case TIMER.ADVANCE:
                    {
                        // Advance the timer by 1/10th second
                        m_fStopTime += 0.1f;
                        return 0.0f;
                    }
                case TIMER.GETABSOLUTETIME:
                    {
                        return (float)fTime;
                    }
                default:
                    return -1.0f; // Invalid command specified
            }
        }
    }
}

