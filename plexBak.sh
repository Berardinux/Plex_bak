#!/bin/bash

# Ensure that you have replaced {
# /PATH/TO/YOUR/BACKUP/DIRECTORY,
# /PATH/TO/YOUR/PLEX,
# }

# Print ASCII art
cat << "EOF"
        .:okOXNWWMMWWNXOko:.
      ONMMMMMMMMMMMMMMMMMMMMWO
      0MMMMMMMMMMMMMMMMMMMMMM0
      ;MMMMMMMMMMMMMMMMMMMMMM;
       MMMMMMMMMMMMMMMMMMMMMM
       NMMMMMMMMMMMMMMMMMMMMM
       lMMMMMMMMMMMMMMMMMMMMx
       .MMMMMMMMMMMMMMMMMMMM.
        MMMMMMMMMMMMMMMMMMMM
        xMMMMMMMMMMMMMMMMMMO
        'MMMMMMMMMMMMMMMMMM;
  .;ldO0NMMMMMMMMMMMMMMMMMMN0Odl;.
cWMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMWo
    dMMMMMMMMMMMMMMMMMMMMMMMMMMx

       d                    o
       ;                    ,
       0                    k
      lM                    Xl
     .MM                    XM.
     ;MM,                  ,MM:
      ;MMKo,            ,o0MM:
        xMMMMKd;.  .;dKMMMMO
          cMMMMMMMMMMMMMMl
             .MMMMMMMM,
                 ..
EOF

# Check if the script is running as root
if [ "$EUID" -ne 0 ]; then
    echo "Please run this script as root or with sudo."
    exit 1
fi

PlexSource="/movie/files"
PlexDestination="/mnt/destination"
DriveAnswer="1"
DriveUUID="UUID=blablabla"
Date=$(date +"%Y%m%d")
BackupDir="$PlexDestination/$Date"
Log="$BackupDir/plexScript.log"

if [ "$DriveAnswer" -eq 1 ]; then
  mount "$DriveUUID" "$PlexDestination"
fi

mv $(ls $PlexDestination | grep 20*) $BackupDir
mv $BackupDir/Plex-backup_* $BackupDir/Plex-backup_$Date

# Create the backup directory
if [ -d "$BackupDir" ] || [ -d "$Log" ]; then
    echo "Backup directory $BackupDir or log file $Log already exists." >> "$Log"
else
    mkdir -p "$BackupDir"
    touch "$Log"
fi

if rsync -av --ignore-existing "$PlexSource/" "$BackupDir/Plex-backup_$Date/"; then
    echo "Plex files backup completed successfully." >> "$Log"
else
    echo "Plex files backup failed." >> "$Log"
fi

if [ "$DriveAnswer" -eq 1 ]; then
  umount "$PlexDestination"
fi
