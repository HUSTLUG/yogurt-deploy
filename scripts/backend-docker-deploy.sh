# shellcheck disable=SC2006
hust_sync_original_id=`docker images -q --filter reference=hust-sync:latest`

#git clone git@core.azw.net.cn:HUSTMirror/HUSTOpenSourceMirror.git
#cd HUSTOpenSourceMirror
#git switch dev

docker build --force-rm -t hust-sync:latest -f ./Dockerfile .

cd ..
rm -rf HUSTOpenSourceMirror

# shellcheck disable=SC2164
cd /home/azw/hust-sync/drone-cd
docker-compose up -d

# shellcheck disable=SC2006
hust_sync_current_id=`docker images -q --filter reference=hust-sync:latest`

if [ "$hust_sync_original_id" = "$hust_sync_current_id" ]; then 
	echo "No code changes, exiting..."; 
else 
	echo "New code deploy complete, deleting old image..." && docker rmi $hust_sync_original_id; 
fi;

# shellcheck disable=SC2046
docker rmi $(docker images -f "dangling=true" -q)

