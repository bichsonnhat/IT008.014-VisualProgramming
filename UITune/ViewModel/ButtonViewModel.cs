using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Windows;
using System.Windows.Controls;

namespace UITune.ViewModel
{
    public class ButtonViewModel : RadioButton
    {
        static ButtonViewModel()
        {
            DefaultStyleKeyProperty.OverrideMetadata(typeof(ButtonViewModel), new FrameworkPropertyMetadata(typeof(ButtonViewModel)));
        }
    }
}
