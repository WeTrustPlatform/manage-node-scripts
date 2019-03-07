#! /bin/bash

case `uname` in
  'Linux')
    prefix=geth-linux-amd64-$1
    ;;
  'Darwin')
    prefix=geth-darwin-amd64-$1
    ;;
  *)
    echo "Unknown OS!"
    exit 1
    ;;
esac

SEARCH_QUERY=https://gethstore.blob.core.windows.net/builds\?restype\=container\&comp\=list\&maxresults\=1\&prefix\=$prefix

echo $SEARCH_QUERY

read_dom () {
  local IFS=\>
  read -d \< ENTITY CONTENT
}

parse_dom () {
  if [[ $ENTITY = "Content-MD5" ]] ; then
    md5_value=$(echo -n $CONTENT | base64 --decode | xxd -p)
  fi

  if [[ $ENTITY = "Name" ]] ; then
    file_name=$CONTENT
  fi
}

parse_query_results () {
  md5_content=""
  file_name=""
  while read_dom ; do
    parse_dom
  done
  echo $file_name $md5_value
}

get_file_name_and_md5 () {
  curl $SEARCH_QUERY | parse_query_results
}

# assume file_name and md5_content content no spaces
read file_name md5_value < <(get_file_name_and_md5)

if [ -z "$file_name" ] ; then
  echo ">> Cannot find $prefix"
  exit 1
fi

echo $file_name $md5_value
