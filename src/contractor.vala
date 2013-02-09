/*
 * Copyright (C) 2013 Elementary Developers
 *
 * This program is free software: you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation, either version 3 of the License, or
 * (at your option) any later version.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with this program.  If not, see <http://www.gnu.org/licenses/>.
 *
 * Author: lampe2 mgoldhand@googlemail.com
 */

using GLib;
using Contractor;
namespace Contractor{
    /* starts the contractor goodnes
       creates a new Bus and enters the main loops
    */
    private MainLoop loop;
    void main(){
        Bus.own_name (BusType.SESSION, "org.elementary.Contractor", BusNameOwnerFlags.NONE,
                      on_bus_aquired,
                      () => {},
                      () => on_bus_not_aquired);
        loop = new MainLoop ();
        loop.run();
        }
    // trys to aquire the bus 
    private void on_bus_aquired(DBusConnection conn){
        try {
            conn.register_object("/org/elementary/contractor", new Contractor());
        } catch (IOError e) {
            stderr.printf("Could not register service because: %s \n",e.message);
        }
    }
    private void on_bus_not_aquired(){
        stderr.printf("Could not aquire Session bus for contractor\n");
        loop.quit();
    }

    // the main constractor class where everything comes together
    [DBus (name = "org.elementary.Contractor")]
    public class Contractor : Object {
        private ContractFileService cfs;
        construct{
            message("starting Contractor...");
            GLib.Intl.setlocale (GLib.LocaleCategory.ALL, "");
            GLib.Intl.textdomain (Build.GETTEXT_PACKAGE);
            cfs = new ContractFileService ();
        }

        public string GetServicesByLocation (string strlocation){
            message(strlocation);
            return strlocation;
        }
        
        public signal void pong (int count, string msg);
    }
}

namespace Translations {
    const string archive_name = N_("Archives");
    const string archive_desc = N_("Extract here");
    const string archive_compress = N_("Compress");
    const string wallpaper_name = N_("Wallpaper");
    const string wallpaper_desc = N_("Set as Wallpaper");
}