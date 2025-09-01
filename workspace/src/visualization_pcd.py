import numpy as np
import open3d as o3d

# Pfad zu deiner .txt-Datei
#file_path = "s3dis_pcd_results/area_6/office_12.txt"
file_path = "my/data/path/to/txt-file"

# Datei laden
data = np.loadtxt(file_path)

# XYZ und RGB
xyz = data[:, :3]
rgb = data[:, 3:6] / 255.0  # Open3D erwartet RGB Werte in [0,1]

# Optional: Instanzlabels für alternative Farben
inst_ids = data[:, 7].astype(int)
unique_ids = np.unique(inst_ids)

# Erzeuge zufällige Farben für Instanzen
np.random.seed(42)
inst_colors = np.random.rand(len(unique_ids), 3)
inst_color_map = {uid: inst_colors[i] for i, uid in enumerate(unique_ids)}
inst_rgb = np.array([inst_color_map[i] for i in inst_ids])

# Punktwolke erstellen
pcd = o3d.geometry.PointCloud()
pcd.points = o3d.utility.Vector3dVector(xyz)

# Wähle, ob RGB oder Instanzfarben angezeigt werden sollen
use_inst_colors = True
if use_inst_colors:
    pcd.colors = o3d.utility.Vector3dVector(inst_rgb)
else:
    pcd.colors = o3d.utility.Vector3dVector(rgb)

# Visualisierung
o3d.visualization.draw_geometries([pcd])
