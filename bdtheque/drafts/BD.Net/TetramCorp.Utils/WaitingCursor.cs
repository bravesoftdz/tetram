using System;
using System.Windows.Forms;

namespace TetramCorp.Utilities
{
    /// <summary>
    /// Description résumée de WaitCursor.
    /// </summary>
    public class WaitingCursor : IDisposable
    {
        private Cursor oldCursor;
        public WaitingCursor()
        {
            oldCursor = Cursor.Current;
            Cursor.Current = Cursors.WaitCursor;
        }

        #region Membres de IDisposable

        public void Dispose()
        {
            Dispose(true);
            GC.SuppressFinalize(this);
        }

        private bool disposed; // = false;
        private void Dispose(bool disposing)
        {
            if (!this.disposed)
            {
                if (disposing)
                {
                    Cursor.Current = oldCursor;
                }
            }
            disposed = true;
        }

        #endregion
    }
}