#!/bin/sh
wakeonlan -p 9 0A:1B:2C:3D:4E:5F > /dev/null 2>&1
echo "Paquet magique envoyé, le PC devrait s'allumer ..."
