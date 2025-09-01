# mask3d_ws
Das Ziel ist ein Docker-Setup für Mask3D.
Erstelle folgende Verzeichnisse in **mask3d_ws/workspace**
```
cd checkpoints
cd data
``` 

# Installation Guide
Bauen des Docker-Images
```
docker build -t mask3d-originalsetup .
```

Ausführen des Docker-Containers
```
./run_mask3d_container.sh
```

# Data Preprocessing für S3DIS
1. Download des S3DIS Datensatzes über dieses [Google Formular](https://docs.google.com/forms/d/e/1FAIpQLScDimvNMCGhy_rmBA2gHfDu3naktRm6A8BPwAWWDv-Uhm6Shw/viewform?c=0&w=1).
Download des **Stanford3dDataset_v1.2_Aligned_Version.zip** und unzippen
im Verzeichnis von **~/workspace/Mask3D/mask3d/data/**

Korrektur einiger Fehler im Datensatz via (siehe hierzu [ISBNet Issue 60](https://github.com/VinAIResearch/ISBNet/issues/60))
- Line 180389 of Stanford3dDataset_v1.2_Aligned_Version\Area_5\hallway_6\Annotations\ceiling_1.txt
- Line 741101 of Stanford3dDataset_v1.2_Aligned_Version\Area_2\auditorium_1\auditorium_1.txt
- Line 926337 of Stanford3dDataset_v1.2_Aligned_Version\Area_3\hallway_2\hallway_2.txt

Umbenennen der Datei **Stanford3dDataset_v1.2_Aligned_Version/Area_6/copyRoom_1/copy_Room_1.txt** im S3DIS-Datensatz zu 
**Stanford3dDataset_v1.2_Aligned_Version/Area_6/copyRoom_1/copyRoom_1.txt**.

Folgender Code im Container ausführen. Vorbereitung der Daten 
```
cd /workspace/Mask3d/
python -m datasets.preprocessing.s3dis_preprocessing preprocess --data_dir="/root/workspace/data/Stanford3dDataset_v1.2_Aligned_Version" --save_dir="/root/workspace/data/processed/s3dis"
```

# Testing Inference Results
Herunterladen des entsprechenden Checkpoints für S3DIS-Datensatz und Ablegen im Ordner **mask3d_ws/workspace/checkpoints** z.B. in
**mask3d_ws/workspace/checkpoints/s3dis/scratch/area6_from_scratch.ckpt**. Die Datei **custom_s3dis_from_scratch.sh** in den **workspace** Ordner (gemounteter Ordner) kopieren.

**custom_s3dis_from_scatch.sh** im laufenden Container in den Ordner **/workspace/mask3D** kopieren. Folgender Code wird im Container ausgeführt (in **/workspace/Mask3D/**):
```
sh /root/workspace/custom_s3dis_from_scratch.sh  
```
In **/workspace/mask3D/eval_output** werden die Inferenz-Ergebnisse gespeichert. Kopiere diesen Ordner in den gemounteten **/root/workspace** Ordner, damit beim Schließen des Mask3D Docker Images die Ergebnisse nicht gelöscht sind. 
In **/root/workspace/src** befindet sich ein Skript **create_mask3d_pcd.py**, welches aus den Inferenzergebnissen und den preprocessed Point Clouds pro Szene eine Punktwolke mit Instanzsegmentierung erstellt. Hierfür wird eine txt-Datei pro Szene dargestellt, pro Zeile wird ein Punkt beschrieben mit seinen Labels (x y z r g b semantischesLabel Instanzlabel).
Folgende semantische Kategorien gelten: 
0: ceiling, 1: floor, 2: wall, 3: beam, 4: column, 5: window, 6: door, 7: table, 8: chair, 9: sofa, 10: bookcase, 11: board, 12: clutter.

Das Skript **visualization_pcd.py** im src-Ordner visualisiert die Punktwolke mit Instanzsegmentierung. 

