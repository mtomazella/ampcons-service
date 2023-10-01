url='http://localhost:3001'
tension=110
current=2
tension_random=0
current_random=0
sensor_id=0
speed=5

while getopts u:t:c:r:R:i:S:s: flag
do
    case "${flag}" in
        u) url=${OPTARG};;
        t) tension=${OPTARG};;
        c) current=${OPTARG};;
        r) tension_random=${OPTARG};;
        R) current_random=${OPTARG};;
        S) sensor_id=${OPTARG};;
        s) speed=${OPTARG};;
    esac
done

while [[ 1 == 1 ]]
do
  t_rng=$(echo $tension + $(shuf -i 0-$tension_random -n 1) | bc)
  c_rng=$(echo $current + $(shuf -i 0-$current_random -n 1) | bc)
  body='{ "tension": '"$t_rng"', "current": '"$c_rng"', "sensor_id": "'"$sensor_id"'" }'
  echo $(curl -X POST -H 'Content-Type: application/json' -d "$body" $url/measurements)
  sleep $speed
done
