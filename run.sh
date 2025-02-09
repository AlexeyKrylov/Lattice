#!/bin/bash
#SBATCH --job-name=Lattice # Название задачи
#SBATCH --error=/home/etutubalina/somov_students/krylov_as/Lattice/cluster_logs/train-%j.err # Файл для вывода ошибок
#SBATCH --output=/home/etutubalina/somov_students/krylov_as/Lattice/cluster_logs/train-%j.log # Файл для вывода результатов
#SBATCH --time=200:00:00 # Максимальное время выполнения
#SBATCH --cpus-per-task=6 # Количество CPU на одну задачу
#SBATCH --gpus=1 # Требуемое кол-во GPU

export TOKENIZERS_PARALLELISM=false
export CUDA_VISIBLE_DEVICES='0'
export PL_TORCH_DISTRIBUTED_BACKEND='gloo'

python /home/etutubalina/somov_students/krylov_as/Lattice/train.py \
--model_name_or_path t5-small \
--do_train \
--do_eval \
--do_predict \
--train_file totto_data/train.csv \
--validation_file totto_data/dev.csv \
--test_file totto_data/dev.csv \
--output_dir outputs/ \
--per_device_train_batch_size 8 \
--gradient_accumulation_steps 1 \
--per_device_eval_batch_size 32 \
--group_by_length \
--max_source_length 512 \
--max_target_length 128 \
--val_max_target_length 128 \
--num_beams 4 \
--max_steps 150000 \
--learning_rate 2e-4 \
--lr_scheduler_type constant \
--evaluation_strategy steps \
--eval_steps 5000 \
--logging_steps  5000 \
--save_steps 5000 \
--metric_for_best_model bleu \
--load_best_model_at_end \
--dataloader_num_workers 8 \
--overwrite_cache \
--overwrite_output_dir \
--predict_with_generate
