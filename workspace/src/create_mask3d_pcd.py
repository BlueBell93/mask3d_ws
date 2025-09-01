import numpy as np
from pathlib import Path 
import argparse 
from multiprocessing import Pool

def parse_cli():
    parser = argparse.ArgumentParser()
    parser.add_argument('--s3dis_data_path', type=str, default='/root/workspace/data/processed/s3dis/Area_2')
    parser.add_argument('--pred_path', type=str, default="/root/workspace/results_area2/instance_evaluation_area2_from_scratch_eps_0.6_topk_-1_q_100_0/decoder_-1")
    parser.add_argument("--area_name", type=str, default="Area_2_")
    parser.add_argument("--save_dir", type=str, default="/root/workspace/sedis_pcd_results/area_2")
    args = parser.parse_args()
    return args

def extract_labels(pred_path, scene_name, area_name, num_mask):
    instance_file = pred_path / f'{area_name+scene_name}.txt'
    with open(instance_file, "r") as file:
        masks = file.readlines()
    masks = [mask.rstrip().split() for mask in masks] # pro Eintrag: (Dateinamen, Sem_label, Score)
    instance_number = len(masks) # Anzahl der Instanzen
    instance_pointnumber = np.zeros(instance_number) # Array mit 0en (Anzahl Inst)
    instance_label = -100 * np.ones(num_mask).astype(int)
    semantic_label = -100 * np.ones(num_mask).astype(int)
    #print(f"num_mask: {num_mask}")

    scores = np.array([float(x[-1]) for x in masks])
    sort_inds = np.argsort(scores)[::-1] # aufsteigend sortierte Liste
    num_scores_under_threshold = 0
    for i_ in range(len(masks) - 1, -1, -1):
        i = sort_inds[i_] # instance label
        #print(f"i: {i}")
        mask_path = pred_path / f"{masks[i][0]}"
        if float(masks[i][2]) < 0.5:
            num_scores_under_threshold += 1
            continue
        mask = np.loadtxt(mask_path).astype(int)
        cls_id = int(masks[i][1]) # semantic label-id
        instance_pointnumber[i] = mask.sum() # Anzahl der Punkte
        instance_label[mask == 1] = i # setzen instance label
        semantic_label[mask == 1] = cls_id # setzen semantic label
    #print(f"number of instances with score under 0.5: {num_scores_under_threshold}")
    #print(f"semantic_label: {semantic_label}")
    return semantic_label, instance_label
def build_labeled_pointcloud(scene, pred_path, area_name, save_dir): 
    scene_name = scene.stem
    print(f"Start processing scene {scene_name}")
    # open file and read xyz, rgb
    pcd = np.load(scene)
    num_mask = pcd.shape[0]
    xyz = pcd[:, :3]
    rgb = pcd[:, 3:6]
    sem_labels, inst_labels = extract_labels(pred_path, scene_name, area_name, num_mask)
    sem_labels = np.array(sem_labels).reshape((len(sem_labels), 1))
    inst_labels = np.array(inst_labels).reshape((len(inst_labels), 1))
    combined = np.hstack((xyz, rgb, sem_labels, inst_labels))
    #save_path = Path(__file__).joinpath(args.save_dir)
    save_path = save_dir / f"{scene_name}.txt"
    np.savetxt(save_path, combined, fmt=['%.3f']*6 + ['%d', '%d'])
    print(f"Saved scene {scene_name}")
    

if __name__ == "__main__":
    args = parse_cli()
    s3dis_data_path = Path(args.s3dis_data_path)
    pred_path = Path(args.pred_path)
    save_dir = Path(args.save_dir)
    area_name = args.area_name
    save_dir.mkdir(parents = True, exist_ok=True)
    data = []
    for scene in s3dis_data_path.glob("*.npy"):
        data.append((scene, pred_path, area_name, save_dir))
    with Pool(processes=10) as pool:
        pool.starmap(build_labeled_pointcloud, data)
