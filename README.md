# mask3d_ws
Das Ziel ist ein Docker-Setup für Mask3D.

# Installation Guide
Bauen des Docker-Images
```
docker build -t mask3d-easysetup .
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

Vorbereitung der Daten 
```
cd /workspace/Mask3d/mask3d
python -m datasets.preprocessing.s3dis_preprocessing preprocess --data_dir="/root/workspace/datasets/Stanford3dDataset_v1.2_Aligned_Version" --save_dir="/root/workspace/data/processed/s3dis"
```

Im **workspace** Folder, das in den Docker gemounted wird, folgendes Verzeichnis erstellen:
```
mkdir checkpoints
```
In diesem werden die checkpoints, die im Originalrepo verlinkt sind, abgelegt.
Bei Bedarf Symlink setzen, z.B. 
```
ln -s /root/workspace/data/ /workspace/Mask3D/mask3d
ln -s /root/workspace/checkpoints/ /workspace/Mask3D/mask3d/   
``` 

# Testen
Herunterladen des entsprechenden Checkpoints für S3DIS-Datensatz und Ablegen in Ordner
**~/workspace/Mask3D/mask3d/checkpoints/s3dis/scannet_pretrained/area6_scannet_pretrained.ckpt**

Ausführen eines Tests:
``` 
cd ~/workspace/Mask3D/
python main_instance_segmentation.py general.checkpoint="/root/workspace/Mask3D/checkpoints/s3dis/scratch/area6_from_scratch.ckpt" general.train_mode=false

## TODOs
symlink setzen, checkpoints herunterladen, Tests ausführen
