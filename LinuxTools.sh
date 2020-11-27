#!/bin/bash

###################
# Scripting Linux #
###################

## CONSIGNES DE L'EXERCICE ##

# Créer un script LinuxTools.sh qui présente en boucle un menu à l’utilisateur avec un choix d’actions possibles. Rem : envisagez l’utilisation de l’outil « whiptail ».
# Ce menu doit comporter les fonctionnalités suivantes : 

# 1. Archivage d’un répertoire. 
# L’utilisateur est invité à entrer le nom du répertoire qu’il désire sauver ainsi que le nom et le chemin de l’archive à créer. 
# Une archive de ce répertoire est alors créée (fichier .tar). Il est évident que le répertoire doit exister et que l’archive doit avoir été créée. 
# Dans le cas contraire, l’utilisateur doit en être averti. 

# 2. Compression d’une archive. 
# L’utilisateur est invité à entrer le nom de l’archive (fichier .tar) qu’il désire compresser (fichier .tar.gz). 

# 3. Désarchivage d’une archive.
# L’utilisateur est invité à introduire le nom de l’archive (fichier .tar) qu’il désire désarchiver et le répertoire de destination. 
# Si le fichier n’existe pas, l’utilisateur doit en être informé. 

# 4. Décompression d’une archive compressée. 
# L’utilisateur est invité à introduire le nom de l’archive compressée (fichier .tar.gz) qu’il désire décompresser (fichier .tar comme résultat). 
# Si le fichier n’existe pas, l’utilisateur doit en être informé.

# 5. Comparaison de 2 fichiers. 
# L’utilisateur est invité à introduire les deux noms des fichiers à comparer. Les fichiers doivent bien entendu exister. Une comparaison est alors effectuée (somme MD5). 
# L’utilisateur doit être informé du résultat de la comparaison. 

# 6. Mise en forme d'un fichier .csv.
# L’utilisateur est invité à introduire le nom d'un fichier .csv à mettre en forme. Si le fichier n'existe pas, l'utilisateur doit en être informé. 
# Le fichier sélectionné est affiché, avec mise-en-forme en colonnes. Les outils awk ou column trouvent ici leur utilité. 

# 7. Affiche votre configuration IP.

# 8. Redémarre votre carte réseau.

# 9. Quitter Quitter le script.

## NOTES SUR LE SCRIPT ##

# Pour exécuter le script :
# - modifier d'abord les permissions de ce dernier : "sudo chmod 777 LinuxTools.sh" ;
# - le mettre dans un répertoire du PATH ou se rendre dans le dossier qui le contient et le lancer : "./LinuxTools.sh" ;
# - exécution de débogage possible : "bash -x LinuxTools.sh".

########################
# Script LinuxTools.sh #
########################

# DECLARATION DE FONCTIONS
# Cancel : relance le script à chaque fois que l'utilisateur appuie sur "Cancel" dans les menus Whiptail.
function Cancel
{
        exitStatus=$1

        if [[ $exitStatus -ne 0 ]]
        then
                exec $0
        fi
}


# PROGRAMME

OPTION=$(whiptail --title "Script LinuxTools' menu" --menu "Choose the option of your choice :" 0 0 10 \
"1" "Archive a folder" \
"2" "Compress an archive" \
"3" "Unarchive an archive" \
"4" "Decompress a compressed archive" \
"5" "Compare two files" \
"6" "Format a .csv file" \
"7" "View your IP configuration" \
"8" "Restart your network card" \
"9" "Exit"  3>&1 1>&2 2>&3)

case $OPTION in
        1)
                # Archiver un répertoire

                whiptail --msgbox "You chose to archive a folder." 0 0

                FOLDER_PATH=$(whiptail --title "Path to the folder to archive" --inputbox "Please enter a valid path to the folder you wish to archive. \
                Use absolute or relative path names. Don't forget the "/" at the end of the path. Leave blank for current folder." 0 0 /home/%USER%/Documents/ 3>&1 1>&2 2>&3)
                Cancel $?

                if [[ ! -z $FOLDER_PATH ]]
                then
                        while [[ ! -d $FOLDER_PATH || ${FOLDER_PATH: -1} != "/" ]]
                        do 
                        whiptail --msgbox "Error. The folder's path $FOLDER_PATH does not exist, is not a folder or you forgot the '/' character at the end. Please try again." 0 0
                        FOLDER_PATH=$(whiptail --title "Path to the folder to archive" --inputbox "Please enter a valid path to the folder you wish to archive. \
                        Use absolute or relative path names. Don't forget the "/" at the end of the path." 0 0 /home/%USER%/Documents/ 3>&1 1>&2 2>&3)
                        Cancel $?
                        done
                fi

                if [[ -z $FOLDER_PATH ]]
                then
                         FOLDER_PATH="$PWD/"
                fi

                FOLDER=$(whiptail --title "Folder to archive" --inputbox "Please enter the name of the folder you wish to archive. \
                Don't forget the '/' character at the end of the folder's name." 0 0 myfolder/ 3>&1 1>&2 2>&3)
                Cancel $?

                while [[ -z $FOLDER || ! -d $FOLDER_PATH$FOLDER || ${FOLDER: -1} != "/" ]]
                do 
                        whiptail --msgbox "Error. You left the field blank, the folder $FOLDER does not exist, is not a folder or you forgot the '/' character at the end. Please try again." 0 0
                        FOLDER=$(whiptail --title "Folder to archive" --inputbox "Please enter the name of the folder you wish to archive. \
                        Don't forget the '/' character at the end of the folder's name." 0 0 myfolder/ 3>&1 1>&2 2>&3)
                        Cancel $?
                done
                
                ARCHIVE_NAME=$(whiptail --title "Name of the new archive" --inputbox "Please enter a valid name for the new archive file. No extension name needed." 0 0 myarchive 3>&1 1>&2 2>&3)
                Cancel $?

                while [[ -z $ARCHIVE_NAME ]]
                do 
                        whiptail --msgbox "Error. You need to name the new archive. Please enter one." 0 0
                        ARCHIVE_NAME=$(whiptail --title "Name of the new archive" --inputbox "Please enter a valid name for the new archive file. No extension name needed." 0 0 myarchive 3>&1 1>&2 2>&3)
                        Cancel $?
                done

                ARCHIVE_PATH=$(whiptail --title "New archive's path" --inputbox "Please enter a valid path to put in the newly created archive. \
                Use absolute or relative path names. Don't forget the "/" at the end of the path. Leave blank for current folder." 0 0 /home/%USER%/Documents/ 3>&1 1>&2 2>&3)
                Cancel $?

                if [[ ! -z $ARCHIVE_PATH ]]
                then
                        while [[ ! -d $ARCHIVE_PATH || ${ARCHIVE_PATH: -1} != "/" ]]
                        do 
                        whiptail --msgbox "Error. The archive's path $ARCHIVE_PATH does not exist, is not a folder or you forgot the '/' character at the end. Please try again." 0 0
                        ARCHIVE_PATH=$(whiptail --title "New archive's path" --inputbox "Please enter a valid path to put in the newly created archive. \
                        Use absolute or relative path names. Don't forget the "/" at the end of the path." 0 0 /home/%USER%/Documents/ 3>&1 1>&2 2>&3)
                        Cancel $?
                        done
                fi

                if [[ -z $ARCHIVE_PATH ]]
                then
                         ARCHIVE_PATH="$PWD/"
                fi

                SCRIPT_PATH=$PWD
                cd $FOLDER_PATH

                tar -cvf $ARCHIVE_PATH$ARCHIVE_NAME.tar $FOLDER

                cd $SCRIPT_PATH

                ARCHIVE_FULL_PATH="$ARCHIVE_PATH$ARCHIVE_NAME.tar"

                if [[ -f $ARCHIVE_FULL_PATH ]]
                then
                        whiptail --msgbox "$FOLDER from this folder $FOLDER_PATH has been archived in $ARCHIVE_PATH by the name of $ARCHIVE_NAME.tar." 0 0
                else
                        whiptail --msgbox "There has been an error. $FOLDER has NOT been archived in $ARCHIVE_PATH by the name of $ARCHIVE_NAME.tar. Please restart the whole procedure." 0 0
                fi

                exec $0
                ;;
        2)
                # Compresser une archive

                whiptail --msgbox "You chose to compress an archive." 0 0

                TYPE_OF_COMPRESSION=$(whiptail --title "Compress an archive" --radiolist "Choose a method of compression using the space bar:" 0 0 0 \
                "gzip" "Most common, faster method" ON \
                "bzip2" "More powerful, slower method" OFF \
                3>&1 1>&2 2>&3 )

                ARCHIVE_PATH=$(whiptail --title "Archive's path" --inputbox "Please enter a valid path to the archive you want to compress. \
                Use absolute or relative path names. Don't forget the '/' character at the end of the path's name. Leave blank for current folder." 0 0 /home/%USER%/Documents/ 3>&1 1>&2 2>&3)
                Cancel $? 

                if [[ ! -z $ARCHIVE_PATH ]]
                then
                        while [[ ! -d $ARCHIVE_PATH || ${ARCHIVE_PATH: -1} != "/" ]]
                        do
                                whiptail --msgbox "Error. $ARCHIVE_PATH does not exist, is not a folder or you forgot the '/' character at the end. Please try again." 0 0
                                ARCHIVE_PATH=$(whiptail --title "Archive's path" --inputbox "Please enter a valid path to the archive you want to compress. \
                                Use absolute or relative path names. Don't forget the '/' character at the end of the path's name." 0 0 /home/%USER%/Documents/ 3>&1 1>&2 2>&3)
                                Cancel $? 
                        done
                fi

                if [[ -z $ARCHIVE_PATH ]]
                then
                         ARCHIVE_PATH="$PWD/"
                fi

                ARCHIVE=$(whiptail --title "Archive to compress" --inputbox "Please enter the name of the archive you want to compress (.tar extension mandatory)." 0 0 myarchive.tar 3>&1 1>&2 2>&3)
                Cancel $?

                while [[ ! -f $ARCHIVE_PATH$ARCHIVE ]]
                do 
                        whiptail --msgbox "Error. $ARCHIVE does not exist, is not a file or does not end with the .tar extension." 0 0
                        ARCHIVE=$(whiptail --title "Archive to compress" --inputbox "Please enter the name of the archive you want to compress (.tar extension mandatory)." 0 0 myarchive.tar 3>&1 1>&2 2>&3)
                        Cancel $?
                done

                COMPRESSED_ARCHIVE_PATH=$(whiptail --title "Compressed archive's path" --inputbox "Please enter the path to the folder where you want to put the newly compressed archive. \
                Use absolute or relative path names. Don't forget the '/' character at the end of the path's name. Leave blank for current folder." 0 0 /home/%USER%/Documents/ 3>&1 1>&2 2>&3)
                Cancel $?

                if [[ ! -z $COMPRESSED_ARCHIVE_PATH ]]
                then    
                        while [[ ! -d $COMPRESSED_ARCHIVE_PATH || ${COMPRESSED_ARCHIVE_PATH: -1} != "/" ]]
                        do 
                                whiptail --msgbox "Error. $COMPRESSED_ARCHIVE_PATH does not exist, is not a folder or you forgot the '/' character at the end. Please try again." 0 0
                                COMPRESSED_ARCHIVE_PATH=$(whiptail --title "Compressed archive's path" --inputbox "Please enter the path to the folder where you want to put the newly compressed archive. \
                                Use absolute or relative path names. Don't forget the '/' character at the end of the path's name." 0 0 /home/%USER%/Documents/ 3>&1 1>&2 2>&3)
                                Cancel $?
                        done
                fi

                if [[ -z $COMPRESSED_ARCHIVE_PATH ]]
                then
                         COMPRESSED_ARCHIVE_PATH="$PWD/"
                fi

                if [[ $TYPE_OF_COMPRESSION == *"gzip"* ]]
                then
                        gzip -c $ARCHIVE_PATH$ARCHIVE > $COMPRESSED_ARCHIVE_PATH$ARCHIVE.gz
                        COMPRESSED_ARCHIVE_FULL_PATH="$COMPRESSED_ARCHIVE_PATH$ARCHIVE.gz"   
                else
                        bzip2 -c $ARCHIVE_PATH$ARCHIVE > $COMPRESSED_ARCHIVE_PATH$ARCHIVE.bz2
                        COMPRESSED_ARCHIVE_FULL_PATH="$COMPRESSED_ARCHIVE_PATH$ARCHIVE.bz2" 
                fi

                if [[ -f $COMPRESSED_ARCHIVE_FULL_PATH ]]
                then
                        whiptail --msgbox "$ARCHIVE from this folder $ARCHIVE_PATH has been compressed in $COMPRESSED_ARCHIVE_PATH." 0 0
                else
                        whiptail --msgbox "There has been an error. $ARCHIVE has NOT been compressed in $COMPRESSED_ARCHIVE_PATH. Please restart the whole procedure." 0 0
                fi

                exec $0
                ;;
        3)
                # Désarchiver une archive

                whiptail --msgbox "You chose to unarchive an archive." 0 0

                ARCHIVE_TO_UNARCHIVE=$(whiptail --title "Archive's path" --inputbox "Please enter both the path to and the name of the archive that you want to unarchive. \
                Use absolute or relative path names. Don't forget the .tar extension." 0 0 /home/%USER%/Documents/myarchive.tar 3>&1 1>&2 2>&3)
                Cancel $? 

                while [[ ! -f $ARCHIVE_TO_UNARCHIVE ]]
                do
                        whiptail --msgbox "Error. $ARCHIVE_TO_UNARCHIVE does not exist, is not a file or does not end with the .tar extension." 0 0
                        ARCHIVE_TO_UNARCHIVE=$(whiptail --title "Archive's path" --inputbox "Please enter both the path and the name of the archive that you want to unarchive. \
                        Use absolute or relative path names. Don't forget the .tar extension." 0 0 /home/%USER%/Documents/myarchive.tar 3>&1 1>&2 2>&3)
                        Cancel $? 
                done

                UNARCHIVED_ARCHIVE_PATH=$(whiptail --title "Unarchived archive's path" --inputbox "Please enter the path to the folder where you want to put the unarchived archive. \
                Use absolute or relative path names. Don't forget the "/" at the end of the path. Leave blank for current folder." 0 0 /home/%USER%/Documents/ 3>&1 1>&2 2>&3)
                Cancel $?

                if [[ ! -z $UNARCHIVED_ARCHIVE_PATH ]]
                then    
                        while [[ ! -d $UNARCHIVED_ARCHIVE_PATH || ${UNARCHIVED_ARCHIVE_PATH: -1} != "/" ]]
                        do 
                                whiptail --msgbox "Error. $UNARCHIVED_ARCHIVE_PATH does not exist, is not a folder or you forgot the '/' character at the end. Please try again." 0 0
                                UNARCHIVED_ARCHIVE_PATH=$(whiptail --title "Unarchived archive's path" --inputbox "Please enter the path to the folder where you want to put the unarchived archive. \
                                Use absolute or relative path names. Don't forget the "/" at the end of the path." 0 0 /home/%USER%/Documents/ 3>&1 1>&2 2>&3)
                                Cancel $?
                        done
                fi

                if [[ -z $UNARCHIVED_ARCHIVE_PATH ]]
                then
                         UNARCHIVED_ARCHIVE_PATH="$PWD/"
                fi

                tar -xvf $ARCHIVE_TO_UNARCHIVE -C $UNARCHIVED_ARCHIVE_PATH && \

                whiptail --msgbox "$ARCHIVE_TO_UNARCHIVE has been unarchived in $UNARCHIVED_ARCHIVE_PATH." 0 0

                whiptail --textbox --title "Content of folder containing unarchived archive" /dev/stdin 12 80 <<< "$(ls -l $UNARCHIVED_ARCHIVE_PATH)"

                exec $0
                ;;
        4)
                # Décompresser une archive compressée

                whiptail --msgbox "You chose to decompress an archive." 0 0

                TYPE_OF_DECOMPRESSION=$(whiptail --title "Decompress an archive" --radiolist "Choose a method of decompression using the space bar: " 0 0 0 \
                "gzip" "Most common, faster method" ON \
                "bzip2" "More powerful, slower method" OFF \
                3>&1 1>&2 2>&3 )

                ARCHIVE_TO_DECOMPRESS_PATH=$(whiptail --title "Archive's path" --inputbox "Please enter a valid path to the archive you want to decompress. \
                Use absolute or relative path names. Don't forget the '/' character at the end of the path's name. Leave blank for current folder." 0 0 /home/%USER%/Documents/ 3>&1 1>&2 2>&3)
                Cancel $? 

                if [[ ! -z $ARCHIVE_TO_DECOMPRESS_PATH ]]
                then
                        while [[ ! -d $ARCHIVE_TO_DECOMPRESS_PATH || ${ARCHIVE_TO_DECOMPRESS_PATH: -1} != "/" ]]
                        do
                                whiptail --msgbox "Error. $ARCHIVE_TO_DECOMPRESS_PATH does not exist, is not a folder or you forgot the '/' character at the end. Please try again." 0 0
                                ARCHIVE_TO_DECOMPRESS_PATH=$(whiptail --title "Archive's path" --inputbox "Please enter a valid path to the archive you want to decompress. \
                                Use absolute or relative path names. Don't forget the '/' character at the end of the path's name." 0 0 /home/%USER%/Documents/ 3>&1 1>&2 2>&3)
                                Cancel $? 
                        done
                fi

                if [[ -z $ARCHIVE_TO_DECOMPRESS_PATH ]]
                then
                         ARCHIVE_TO_DECOMPRESS_PATH="$PWD/"
                fi

                ARCHIVE_TO_DECOMPRESS=$(whiptail --title "Archive to decompress" --inputbox "Please enter the name of the archive you want to decompress. \
                Don't forget the .tar.gz or the .tar.bz2 extension." 0 0 /home/%USER%/Documents/myarchive.tar.gz/bz2 3>&1 1>&2 2>&3)
                Cancel $? 

                if [[ $TYPE_OF_DECOMPRESSION == *"gzip"* ]]
                then
                        while [[ ! -f $ARCHIVE_TO_DECOMPRESS_PATH$ARCHIVE_TO_DECOMPRESS || ${ARCHIVE_TO_DECOMPRESS: -6} != "tar.gz" ]]
                        do
                                whiptail --msgbox "Error. $ARCHIVE_TO_DECOMPRESS does not exist or is not a compressed archive (.tar.gz)." 0 0
                                ARCHIVE_TO_DECOMPRESS=$(whiptail --title "Archive to decompress" --inputbox "Please enter the name of the archive you want to decompress. \
                                Don't forget the .tar.gz extension." 0 0 /home/%USER%/Documents/myarchive.tar.gz 3>&1 1>&2 2>&3)
                                Cancel $? 
                        done
                else
                        while [[ ! -f $ARCHIVE_TO_DECOMPRESS_PATH$ARCHIVE_TO_DECOMPRESS || ${ARCHIVE_TO_DECOMPRESS: -7} != "tar.bz2" ]]
                        do
                                whiptail --msgbox "Error. $ARCHIVE_TO_DECOMPRESS does not exist or is not a compressed archive (.tar.bz2)." 0 0
                                ARCHIVE_TO_DECOMPRESS=$(whiptail --title "Archive to decompress" --inputbox "Please enter the name of the archive you want to decompress. \
                                Don't forget the .tar.bz2 extension." 0 0 /home/%USER%/Documents/myarchive.tar.bz2 3>&1 1>&2 2>&3)
                                Cancel $? 
                        done
                fi

                DECOMPRESSED_ARCHIVE_PATH=$(whiptail --title "Decompressed archive's path" --inputbox "Please enter the path to the folder where you want to put the newly decompressed archive. \
                Use absolute or relative path names. Don't forget the "/" at the end of the path. Leave blank for current folder." 0 0 /home/%USER%/Documents/ 3>&1 1>&2 2>&3)
                Cancel $?

                if [[ ! -z $DECOMPRESSED_ARCHIVE_PATH ]]
                then    
                        while [[ ! -d $DECOMPRESSED_ARCHIVE_PATH || ${DECOMPRESSED_ARCHIVE_PATH: -1} != "/" ]]
                        do 
                                whiptail --msgbox "Error. $DECOMPRESSED_ARCHIVE_PATH does not exist, is not a folder or you forgot the '/' character at the end. Please try again." 0 0
                                DECOMPRESSED_ARCHIVE_PATH=$(whiptail --title "Decompressed archive's path" --inputbox "Please enter the path to the folder where you want to put the newly decompressed archive. \
                                Use absolute or relative path names. Don't forget the "/" at the end of the path." 0 0 /home/%USER%/Documents/ 3>&1 1>&2 2>&3)
                                Cancel $?
                        done
                fi

                if [[ -z $DECOMPRESSED_ARCHIVE_PATH ]]
                then
                         DECOMPRESSED_ARCHIVE_PATH="$PWD/"
                fi

                if [[ $TYPE_OF_DECOMPRESSION == *"gzip"* ]]
                then
                        if [[ $DECOMPRESSED_ARCHIVE_PATH == $PWD ]]
                        then
                                gunzip $ARCHIVE_TO_DECOMPRESS_PATH$ARCHIVE_TO_DECOMPRESS
                        else
                                ARCHIVE_DECOMPRESSED=${ARCHIVE_TO_DECOMPRESS%.gz}
                                gunzip -cf $ARCHIVE_TO_DECOMPRESS_PATH$ARCHIVE_TO_DECOMPRESS > $DECOMPRESSED_ARCHIVE_PATH$ARCHIVE_DECOMPRESSED
                        fi
                else
                        if [[ $DECOMPRESSED_ARCHIVE_PATH == $PWD ]]
                        then
                                bunzip2 $ARCHIVE_TO_DECOMPRESS_PATH$ARCHIVE_TO_DECOMPRESS
                        else
                                ARCHIVE_DECOMPRESSED=${ARCHIVE_TO_DECOMPRESS%.bz2}
                                bunzip2 -cf $ARCHIVE_TO_DECOMPRESS > $DECOMPRESSED_ARCHIVE_PATH$ARCHIVE_DECOMPRESSED
                        fi
                fi

                if [[ -f $DECOMPRESSED_ARCHIVE_PATH$ARCHIVE_DECOMPRESSED ]]
                then
                        whiptail --msgbox "$ARCHIVE_TO_DECOMPRESS has been decompressed in $DECOMPRESSED_ARCHIVE_PATH as $ARCHIVE_DECOMPRESSED." 0 0
                        whiptail --textbox --title "Content of folder containing decompressed archive" /dev/stdin 12 80 <<< "$(ls -l $DECOMPRESSED_ARCHIVE_PATH)"
                else
                        whiptail --msgbox "There has been an error. $ARCHIVE_TO_DECOMPRESS has NOT been decompressed in $DECOMPRESSED_ARCHIVE_PATH as $ARCHIVE_DECOMPRESSED. Please restart the whole procedure." 0 0
                fi

                exec $0
                ;;
        5)
                # Comparer 2 fichiers
                whiptail --msgbox "You chose to compare two files." 0 0
                
                FILE1=$(whiptail --title "Files comparison - File 1" --inputbox "Please enter a valid filename for the first file." 0 0 myfile.txt 3>&1 1>&2 2>&3)
                Cancel $?

                while [[ ! -f $FILE1 ]] 
                do 
                        whiptail --msgbox "$FILE1 does not exist or is not a file." 0 0
                        FILE1=$(whiptail --title "Files comparison - File 1" --inputbox "Please enter a valid filename." 0 0 myfile.txt 3>&1 1>&2 2>&3)
                        Cancel $?
                done

                FILE2=$(whiptail --title "Files comparison - File 2" --inputbox "Please enter a valid filename for the second file." 0 0 myfile.txt 3>&1 1>&2 2>&3)
                Cancel $?
                
                while [[ ! -f $FILE2 ]]
                do 
                        whiptail --msgbox "$FILE2 does not exist or is not a file." 0 0
                        FILE2=$(whiptail --title "Files comparison - File 2" --inputbox "Please enter a valid filename." 0 0 myfile.txt 3>&1 1>&2 2>&3)
                        Cancel $?
                done

                MD5SUM_HASHES=$(md5sum $FILE1 $FILE2)
                
                whiptail --textbox --title "MD5SUM hashes" /dev/stdin 12 80 <<< $MD5SUM_HASHES
                whiptail --textbox --title "Files content" /dev/stdin 12 80 <<< $(cat $FILE1 $FILE2)

                MD5SUM_FILE1=$(md5sum $FILE1 | awk '{print $1}')
                MD5SUM_FILE2=$(md5sum $FILE2 | awk '{print $1}')

                if [[ $MD5SUM_FILE1 == $MD5SUM_FILE2 ]]
                then
                        whiptail --title "MD5SUM results" --msgbox "$FILE1 is the same as $FILE2." 0 0
                else
                        whiptail --title "MD5SUM results" --msgbox "$FILE1 is NOT the same as $FILE2." 0 0 
                fi

                exec $0
                ;;
        6)
                # Mettre en forme un fichier .csv
                FILE_CSV=$(whiptail --title ".csv File Formatting" --inputbox "Please enter a valid .csv filename." 0 0 myfile.csv 3>&1 1>&2 2>&3)
                Cancel $?

                while [[ ! -f $FILE_CSV ]] || [[ ${FILE_CSV: -4} != ".csv" ]]
                do 
                        whiptail --msgbox "$FILE_CSV does not exist, is not a file or doesn't have the correct extension (.csv)." 0 0
                        FILE_CSV=$(whiptail --title ".csv File Formatting" --inputbox "Please enter a valid .csv filename." 0 0 myfile.csv 3>&1 1>&2 2>&3)
                        Cancel $?
                done
                
                whiptail --textbox --title ".csv File" /dev/stdin 12 80 <<< "$(cat $FILE_CSV | column -t -s ';,:')"

                exec $0
                ;;
        7)
                # Afficher votre configuration IP
                whiptail --msgbox "Here is your network configuration:" 0 0
                whiptail --textbox --title "Network Configuration" /dev/stdin 0 0 <<< "$(ifconfig)"

                exec $0
                ;;
        8)
                # Redémarrer votre carte réseau
                if (whiptail --yesno "Are you sure you want to restart your network interface controller?" --yes-button "Restart" --no-button "Don't restart" 0 0)
                then
                        whiptail --msgbox "Your network interface controller is going to be shut down and restarted." 0 0
                        nmcli networking off && \
                        {
                        for ((i=0 ; i<=100 ; i+=20))
                        do
                                sleep 1
                                echo $i
                                if [[ $i -eq 40 ]]
                                then
                                        nmcli networking on
                                fi
                        done
                        } | whiptail --gauge "Your network interface controller is restarting. Please, wait." 0 0 0

                        exec $0
                else
                        exec $0
                fi
                ;;

        9)      # Quitter
                if (whiptail --yesno "Do you really want to exit this script?" --yes-button "Exit" --no-button "Stay" 0 0)
                then
                        whiptail --msgbox "You exit the script. Thank you for using it." 0 0
                        exit
                else
                        whiptail --msgbox "You continue using the script." 0 0
                        exec $0
                fi
                ;;

        *)      # Autres choix (Ok et Cancel)
                if (whiptail --yesno "Do you really want to exit this script?" --yes-button "Exit" --no-button "Stay" 0 0)
                then
                        whiptail --msgbox "You exit the script. Thank you for using it." 0 0
                        exit
                else
                        whiptail --msgbox "You continue using the script." 0 0
                        exec $0
                fi
                ;;
esac

