hust_sync_frontend_original_id=`docker images -q --filter reference=hust-sync-frontend:latest`

git clone git@core.azw.net.cn:HUSTMirror/HUSTOpenSourceMirrorFrontEnd.git
cd HUSTOpenSourceMirrorFrontEnd
git switch main

docker build --force-rm -t hust-sync-frontend:latest -f ./Dockerfile .

cd ..
rm -rf HUSTOpenSourceMirrorFrontEnd

cd /home/azw/hust-sync/drone-cd
docker-compose up -d

hust_sync_frontend_current_id=`docker images -q --filter reference=hust-sync-frontend:latest`

if [ "$hust_sync_frontend_original_id" = "$hust_sync_frontend_current_id" ]; then 
	echo "No code changes, exiting..."; 
else 
	echo "New code deploy complete, deleting old image..." && docker rmi $hust_sync_frontend_original_id; 
fi;

docker rmi $(docker images -f "dangling=true" -q)
