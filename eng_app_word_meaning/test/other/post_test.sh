
sentence_no=$1
en=$2

if [ $# -ne 2 ]; then
  echo "USAGE: sentence_no en"
  exit 1
fi

set -x

curl -X POST -H "Content-Type: application/json" -d "{\"en\": \"${en}\"}"  localhost:3000/words/${sentence_no}

