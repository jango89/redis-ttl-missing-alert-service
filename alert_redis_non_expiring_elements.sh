#!/bin/sh

loop_through_db() {

  for db in $(split_database_indexes); do
    ttls_not_found=$(find_keys_without_ttl)

    print_ttls_not_found_keys=$(print_ttls_not_found_keys)

    if [ "$print_ttls_not_found_keys" ]; then

      create_temp_files
      notify
      remove_temp_files
    fi

  done
}

find_keys_without_ttl() {
  local ttls_not_found="$(
    redis-cli -h $host -p $port -a $password -n $db --no-auth-warning keys "*" |
      while read LINE; do
        if [[ $exclude_keys == *$LINE* ]]; then
          continue
        fi
        TTL=$(redis-cli -h $host -p $port -a $password -n $db --no-auth-warning ttl "$LINE")
        if [ $TTL -eq -1 ]; then echo "$LINE"; fi
      done
  )"
  echo "$ttls_not_found"
}

print_ttls_not_found_keys() {

  local result_string=""
  if [ "$ttls_not_found" ]; then
    result_string+="\n ******* Running in - $host:$port, DB - $db *******"

    for key in $ttls_not_found; do
      result_string+="\n $key"
    done
    result_string+="\n"
  fi

  echo "$result_string"
}


notify() {
  notify_via_g_chat
  notify_via_slack
}

create_temp_files() {
  printf "${print_ttls_not_found_keys}"
  local messageInJson="{\"text\":\"$print_ttls_not_found_keys\"}"
  echo "$messageInJson" >curl_data.txt
}

remove_temp_files() {
  #clean the files
  rm -r curl_data.txt
  rm -r null
}

split_database_indexes() {

  IFS=','
  read -ra DBNAME <<<"$database_indexes"
  echo "${DBNAME[@]}"
}

notify_via_g_chat() {
  if [ "$google_chat_webhook_uri" ]; then
    curl -s -o null --request POST "$google_chat_webhook_uri" --header 'Content-Type: application/json' --data-raw "$(cat curl_data.txt)"
  fi
}

notify_via_slack() {
  if [ "$slack_webhook_uri" ]; then
    curl -s -o null --request POST "$slack_webhook_uri" --header 'Content-Type: application/json' --data-raw "$(cat curl_data.txt)"
  fi
}

# Main function
echo "Currently executing for $host:$port"

loop_through_db

echo "Finished executing for $host:$port"
