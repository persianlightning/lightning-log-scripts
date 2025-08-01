tail -f ~/.lightning/lightning.log | while read line; do
    timestamp=$(echo "$line" | grep -oE '[0-9]{4}-[0-9]{2}-[0-9]{2}T[0-9]{2}:[0-9]{2}:[0-9]{2}.[0-9]{3}Z')
    local_time=$(date -d "$timestamp" +"%Y-%m-%d %H:%M:%S")
    echo "${line/$timestamp/$local_time}"
done
