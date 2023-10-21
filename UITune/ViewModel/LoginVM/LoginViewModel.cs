using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Windows;
using UITune.Views.LoginWindow;

namespace UITune.ViewModel.LoginVM
{
    public class LoginViewModel : BaseViewModel
    {
        public bool isLoaded = false;
        public LoginViewModel() 
        {
            if (!isLoaded)
            {
                isLoaded = true;
                LoginWindow loginWindow = new LoginWindow();
                loginWindow.ShowDialog();
            }
        }
    }
}
