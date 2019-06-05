#!/usr/bin/env bash
. credentials.sh

function change_seed() {
  ssh -o StrictHostKeyChecking=no -i $sk_path $username@$1 'bash -s' < ./action/change_seed.sh
}

function start_cass() {
	ssh -f -o StrictHostKeyChecking=no -i $sk_path $username@$1 "~/cassandra/bin/cassandra"
}

function stop_cass() {
  nodetool="~/cassandra/bin/nodetool"
  do_action="$nodetool drain &> /dev/null; $nodetool stopdaemon &> /dev/null"
  ssh -f -o StrictHostKeyChecking=no -i $sk_path $username@$1 $do_action
}

function clear_cass() {
  do_action="rm ~/cassandra/data -rf; rm ~/cassandra/logs -rf"
  ssh -f -o StrictHostKeyChecking=no -i $sk_path $username@$1 $do_action
}

function download_data() {
  ssh -n -o StrictHostKeyChecking=no -i $sk_path $username@$1 \
  "cd $ycsb_path; zip data_${2}_${1}.zip data_t*"
  scp -i $sk_path -o StrictHostKeyChecking=no $username@$1:$ycsb_path/data_${2}_${1}.zip  ./data
}

function rm_data() {
  ssh -n -o StrictHostKeyChecking=no -i $sk_path $username@$1 \
  "cd $ycsb_path; rm data*"
}
