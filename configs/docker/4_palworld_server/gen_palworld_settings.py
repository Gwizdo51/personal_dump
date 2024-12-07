"""
Generates the "PalWorldSettingsp.ini" file in the required format from the YAML file

to get the original "DefaultPalWorldSettings.ini" file:
docker cp palworld_server-palworld_server_container-1:/pal/Package/DefaultPalWorldSettings.ini ./

to change the configuration of the server:
- freely modify "PalWorldSettings.yml" values
- restart the server: docker compose restart
"""

import yaml
from pathlib import Path


def gen_palworld_settings():
    # read the yaml file
    with open("./palworld_server_config.yml") as f:
        palworld_settings_dict: dict[str] = yaml.safe_load(f)
    # create the list of lines to write to the settings file
    palworld_settings_file_lines = []
    palworld_settings_file_lines.append("[/Script/Pal.PalGameWorldSettings]")
    options_settings_line = "OptionSettings=("
    first_key = True
    for key in palworld_settings_dict.keys():
        if first_key:
            first_key = False
        else:
            options_settings_line += ","
        options_settings_line += key + "=" + str(palworld_settings_dict[key])
    options_settings_line += ")"
    palworld_settings_file_lines.append(options_settings_line)
    # write the lines to "./PalWorldSettings.ini", with Unix EOL
    # add a line break at the end to make it a POSIX text file
    file_path = Path.cwd() / "data" / "Config" / "LinuxServer" / "PalWorldSettings.ini"
    with open(file_path, "w", newline="\n") as f:
        f.write("\n".join(palworld_settings_file_lines) + "\n")


if __name__ == "__main__":
    gen_palworld_settings()
    print("Successfully generated the server config file")
