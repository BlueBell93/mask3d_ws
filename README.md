# mask3d_ws
Das Ziel ist ein Docker-Setup für Mask3D.
Erstelle folgende Verzeichnisse in **mask3d_ws**
```
cd checkpoints
cd data
``` 

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

Umbenennen der Datei **Stanford3dDataset_v1.2_Aligned_Version/Area_6/copyRoom_1/copy_Room_1.txt** im S3DIS-Datensatz zu 
**Stanford3dDataset_v1.2_Aligned_Version/Area_6/copyRoom_1/copyRoom_1.txt**.

Vorbereitung der Daten 
```
cd /workspace/Mask3d/
python -m datasets.preprocessing.s3dis_preprocessing preprocess --data_dir="/root/workspace/data/Stanford3dDataset_v1.2_Aligned_Version" --save_dir="/root/workspace/data/processed/s3dis"
```

# Testen
Herunterladen des entsprechenden Checkpoints für S3DIS-Datensatz und Ablegen in Ordner
**~/workspace/Mask3D/mask3d/checkpoints/s3dis/scannet_pretrained/area6_scannet_pretrained.ckpt**

Ausführen eines Tests:
Warning, dass die Shapes des Checkpoints nicht stimmt:
``` 
cd ~/workspace/Mask3D/
python main_instance_segmentation.py general.checkpoint="/root/workspace/checkpoints/s3dis/scratch/area6_from_scratch.ckpt" general.train_mode=false
```  
Schon mal besser, löst aber noch nicht alles (| WARNING  | utils.utils:load_checkpoint_with_missing_or_exsessive_keys:100 - criterion.empty_weight not in loaded checkpoint): 
```
python main_instance_segmentation.py general.project_name="s3dis_eval" general.experiment_name="area${CURR_AREA}_pretrained_eps_${CURR_DBSCAN}_topk_${CURR_TOPK}_q_${CURR_QUERY}" general.checkpoint="/root/workspace/checkpoints/s3dis/scratch/area6_from_scratch.ckpt" general.train_mode=false data.batch_size=4 data/datasets=s3dis general.num_targets=14 data.num_labels=13 general.area=${CURR_AREA} model.num_queries=${CURR_QUERY} general.topk_per_image=${CURR_TOPK} general.use_dbscan=true general.dbscan_eps=${CURR_DBSCAN}
```

Weitere Versuche:
```
python main_instance_segmentation.py general.project_name="s3dis_eval" general.experiment_name="area${CURR_AREA}_pretrained_eps_${CURR_DBSCAN}_topk_${CURR_TOPK}_q_${CURR_QUERY}" general.checkpoint="/root/workspace/checkpoints/s3dis/scratch/area6_from_scratch.ckpt" general.train_mode=false data.batch_size=4 data/datasets=s3dis general.num_targets=14 data.num_labels=13 general.area=${CURR_AREA} model.num_queries=${CURR_QUERY} general.topk_per_image=${CURR_TOPK} general.use_dbscan=true general.dbscan_eps=${CURR_DBSCAN}
```
#!/bin/bash
export OMP_NUM_THREADS=3  # speeds up MinkowskiEngine

CURR_AREA=6  # set the area number accordingly [1,6]
CURR_DBSCAN=0.6
CURR_TOPK=-1
CURR_QUERY=100

python main_instance_segmentation.py \
    general.project_name="s3dis_eval" \
    general.experiment_name="area${CURR_AREA}_pretrained_eps_${CURR_DBSCAN}_topk_${CURR_TOPK}_q_${CURR_QUERY}" \
    general.checkpoint="/root/workspace/checkpoints/s3dis/pretrained/area6_scannet_pretrained.ckpt" \
    general.train_mode=false \
    data.batch_size=4 \
    data/datasets=s3dis \ ??????
    general.num_targets=14 \
    data.num_labels=13 \
    general.area=${CURR_AREA} \
    model.num_queries=${CURR_QUERY} \
    general.topk_per_image=${CURR_TOPK} \
    general.use_dbscan=true \
    general.dbscan_eps=${CURR_DBSCAN}
```  

## TODOs
symlink setzen, checkpoints herunterladen, Tests ausführen
