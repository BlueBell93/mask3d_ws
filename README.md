# mask3d_ws
Das Ziel ist ein Docker-Setup für Mask3D.

# Installation Guide
Klonen eines Forks mit Easy Setup für Mask3D
```
mkdir workspace
cd workspace
git clone https://github.com/cvg/Mask3D.git
```

Bauen des Docker-Images
```
docker build -t mask3d .
```

Ausführen des Docker-Containers
```
./run_mask3d_container.sh
```
Falls sich der Rechner aufgrund begrenzter Ressourcen aufhängt, setze MAX_JOBS Umgebungsvariable
```
export MAX_JOBS=4
```
Installation MinkowskiEngine
``` 
cd ~/workspace/Mask3D/third_party
git clone --recursive "https://github.com/NVIDIA/MinkowskiEngine"
cd MinkowskiEngine
git checkout 02fc608bea4c0549b0a7b00ca1bf15dee4a0b228
python setup.py install --force_cuda --blas=openblas
```

Setup für ScanNet Segmentator
```
cd ..
git clone https://github.com/ScanNet/ScanNet.git
cd ScanNet/Segmentator
git checkout 3e5726500896748521a6ceb81271b0f5b2c0e7d2
make
```

Installation pointnet2
``` 
cd ../../pointnet2
python setup.py install
``` 
Installation pytorch-lightning und Gesamt-Installation
``` 
cd ../../
pip3 install pytorch-lightning
pip install .
``` 

# Setup beim Starten der Dockerfile
Teile der Installation gehen verloren und müssen bei 
jedem Start des Docker-Containers ausgeführt werden

```
cd ~/workspace/Mask3D/third_party/MinkowskiEngine
python setup.py install --force_cuda --blas=openblas
cd ~/workspace/Mask3D/third_party/pointnet2
python setup.py install
cd ../../
pip3 install pytorch-lightning
pip install .
```

# Date Preprocessing für S3DIS
1. Download des S3DIS Datensatzes über dieses [Google Formular](https://docs.google.com/forms/d/e/1FAIpQLScDimvNMCGhy_rmBA2gHfDu3naktRm6A8BPwAWWDv-Uhm6Shw/viewform?c=0&w=1).
Download des **Stanford3dDataset_v1.2_Aligned_Version.zip** und unzippen
im Verzeichnis von **~/workspace/Mask3D/mask3d/data/**

Korrektur einiger Fehler im Datensatz via (siehe hierzu [ISBNet Issue 60](https://github.com/VinAIResearch/ISBNet/issues/60))
- Line 180389 of Stanford3dDataset_v1.2_Aligned_Version\Area_5\hallway_6\Annotations\ceiling_1.txt
- Line 741101 of Stanford3dDataset_v1.2_Aligned_Version\Area_2\auditorium_1\auditorium_1.txt
- Line 926337 of Stanford3dDataset_v1.2_Aligned_Version\Area_3\hallway_2\hallway_2.txt

Vorbereitung der Daten 
```
python -m datasets.preprocessing.s3dis_preprocessing preprocess \
--data_dir="/root/workspace/Mask3D/data/Stanford3dDataset_v1.2_Aligned_Version" \
--save_dir="/root/workspace/Mask3D/data/processed/s3dis"
```

# Testen
Herunterladen des entsprechenden Checkpoints für S3DIS-Datensatz und Ablegen in Ordner
**~/workspace/Mask3D/mask3d/checkpoints/s3dis/scannet_pretrained/area6_scannet_pretrained.ckpt**

Ausführen eines Tests:
``` 
cd ~/workspace/Mask3D/
python main_instance_segmentation.py general.checkpoint="/root/workspace/Mask3D/checkpoints/s3dis/scratch/area6_from_scratch.ckpt" general.train_mode=false
