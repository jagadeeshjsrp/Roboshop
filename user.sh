script=$(realpath "$0")
scrpit_path=$(dirname "$script")
source ${script_path}/common.sh

component=user
schema_setup=mongo
func_nodejs

