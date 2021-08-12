#!/bin/bash 
#SBATCH --job-name=test
#SBATCH --nodes=1             
#SBATCH --partition=debug
#SBATCH --time=24:00:00 
#SBATCH --error=%x-%j.err 
#SBATCH --out=%x-%j.out
#SBATCH --signal=B:USR1@300
#SBATCH --requeue
#SBATCH --open-mode=append


function requeue_job() {
  dmtcp_command --checkpoint     #checkpoint the job if ckpt_command=ckpt_dmtcp  
  scontrol requeue $SLURM_JOB_ID #requeue the job 
}


spack load dmtcp

#checkpointing once every hour
#start_coordinator -i 3600
dmtcp_coordinator -i 3600 --daemon --exit-on-last -p 0 --port-file $fname $@ 1>/dev/null 2>&1

echo "Restart Count = $restart_count"
#c/r jobs
if [[ $(restart_count) == 0 ]]; then

    # Initial launch of your program
    dmtcp_launch -j <your program here> &

elif [[ $(restart_count) > 0 ]] && [[ -e dmtcp_restart_script.sh ]]; then

    # Hot-Restart of your program
    ./dmtcp_restart_script.sh &
else

    echo "Failed to restart the job, exit"; exit
fi

# When the USR1 signal is sent from Slurm, (300 seconds before wall-time is reached), we requeue the job
# In this event, we've reached the 24 hour limit of a preemptible instance being live.
trap requeue_job USR1

wait
