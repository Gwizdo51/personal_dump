"""
Generates the "PalWorldSettingsp.ini" file in the required format from the YAML file

to get the original "DefaultPalWorldSettings.ini" file:
docker cp palworld_server-palworld_server_container-1:/pal/Package/DefaultPalWorldSettings.ini ./

to change the configuration of the server:
- if you dont have saved data, run the server once, let it set itself up and shut it down
- copy "./PalWorldSettings.ini" to "./data/Config/LinuxServer/PalWorldSettings.ini"
- restart the server
"""

import yaml
from pathlib import Path

def gen_palworld_settings():
    # create the list of lines to write to the file
    with open("./PalWorldSettings.yml") as f:
        palworld_settings_dict = yaml.safe_load(f)
    palworld_settings_file_lines = []
    palworld_settings_file_lines.append("[/Script/Pal.PalGameWorldSettings]")
    options_settings_line = "OptionSettings=("
    first_key = True
    for key in palworld_settings_dict:
        if first_key:
            first_key = False
        else:
            options_settings_line += ","
        options_settings_line += key + "=" + str(palworld_settings_dict[key])
    options_settings_line += ")"
    palworld_settings_file_lines.append(options_settings_line)
    # write the lines to "./PalWorldSettings.ini", with Unix EOL
    file_path = Path(__file__).parent / "data" / "Config" / "LinuxServer" / "PalWorldSettings.ini"
    # print(file_path)
    with open(file_path, "w", newline="\n") as f:
        f.writelines("\n".join(palworld_settings_file_lines) + "\n")


if __name__ == "__main__":
    gen_palworld_settings()
