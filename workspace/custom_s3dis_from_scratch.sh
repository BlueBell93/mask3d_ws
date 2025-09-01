#!/bin/bash
export OMP_NUM_THREADS=3  # speeds up MinkowskiEngine

CURR_AREA=2  # set the area number accordingly [1,6]
CURR_DBSCAN=0.6
CURR_TOPK=-1
CURR_QUERY=100

python main_instance_segmentation.py \
  general.project_name="s3dis_eval" \
  general.experiment_name="area${CURR_AREA}_from_scratch_eps_${CURR_DBSCAN}_topk_${CURR_TOPK}_q_${CURR_QUERY}" \
  general.checkpoint="checkpoints/s3dis/scratch/area${CURR_AREA}_from_scratch.ckpt" \
  general.train_mode=false \
  general.export=true \
  data.batch_size=1 \
  data/datasets=s3dis \
  general.num_targets=14 \
  data.num_labels=13 \
  general.area=${CURR_AREA} \
  model.num_queries=${CURR_QUERY} \
  general.topk_per_image=${CURR_TOPK} \
  general.use_dbscan=true \
  general.dbscan_eps=${CURR_DBSCAN}
