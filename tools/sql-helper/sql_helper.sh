#!/bin/bash

#######################################
# description
# Arguments:
#   1 - sql_host
#   2 - country
#   3 - city
#   4 - activity
#   5 - country_image
#   6 - city_image
#   7 - activity_image
#######################################
function prepare_query() {
  echo "Preparing SQL Queries"

local sql=(
    "DROP TABLE returned_activity_id; DROP TABLE returned_city_id;DROP TABLE returned_country_id;"
  "
WITH e AS(
    INSERT INTO countries (country_name, image_location)
          VALUES ('$2', 'Countries/$2/General/')
    ON CONFLICT(country_name) DO NOTHING
  RETURNING country_id
  )
  SELECT * into returned_country_id FROM e
    UNION
      SELECT country_id FROM countries WHERE country_name='$2';
  "
  "
    WITH e AS(
      INSERT INTO cities (city_name, image_location)
          VALUES ('$3', 'Countries/$2/$3/')
      ON CONFLICT(city_name) DO NOTHING
        RETURNING city_id
    )
    SELECT * into returned_city_id FROM e
    UNION
      SELECT city_id FROM cities WHERE city_name='$3';
  "

    "
    WITH e AS(
      INSERT INTO activities (activity_name, image_location, activity_type, sponsored, points, lat_x, lat_y, lon_x, lon_y)
          VALUES ('$4', 'Countries/$2/$3/Activities/$4/', 'Place', false, 10, '43.672162', '43.629845', '-79.435850', '-79.314585')
      ON CONFLICT(activity_name) DO NOTHING
        RETURNING activity_id
    )
    SELECT * into returned_activity_id FROM e
    UNION
      SELECT activity_id FROM activities WHERE activity_name='$4';
  "

  "
    INSERT INTO country_city_activity_maps (activity_id, city_id, country_id)
    WITH
      t1 AS (
        SELECT activity_id
        FROM returned_activity_id
      ),
      t2 AS (
        SELECT city_id
        FROM returned_city_id
      ), t3 AS (
        SELECT country_id
        FROM returned_country_id
      )
      select t1.activity_id, t2.city_id, t3.country_id
      from t1,t2,t3;
  "
  "DROP TABLE returned_activity_id; DROP TABLE returned_city_id;DROP TABLE returned_country_id;"
  )

for t in "${sql[@]}"; do
  docker exec iScore-api-DB /bin/sh -c "psql -U postgres -t -d api -c \"$t\""
done
}

#######################################
# Prints help options
# Arguments:
#  None
#######################################
function usage() {
  echo -e "Options:\n\t-h Displays this message\n\t-t Terraform DIR to create structure\n\t-c Name of Country DIR to create\n\t-o Name of City DIR to create/n/t-a Name of Activity DIR to create\nExample: ./dir_helper.sh -t ~/iScore/iScore-Infrastructure/s3/media/countries/ -c wales -v cardiff -b "cardiff castle" -i ~/Desktop/iscoreimages/cardiff.jpeg -o  ~/Desktop/iscoreimages/cardiff.jpeg -p  ~/Desktop/iscoreimages/cardiffcastle.webp"
  exit "$1"
}


#######################################
# Main
# Arguments:
#  None
#######################################
function main() {
  local flag
  # Get flags
  while getopts ":ht:c:v:b:i:o:p:" flag; do
    case "${flag}" in
      h)
        usage 0
        ;;
      t) local sql_host=${OPTARG} ;;
      c) local country=${OPTARG} ;;
      v) local city=${OPTARG} ;;
      b) local activity=${OPTARG} ;;
      i) local country_image=${OPTARG} ;;
      o) local city_image=${OPTARG} ;;
      p) local activity_image=${OPTARG} ;;
      \?)
        echo "Unknown option"
        usage 1
        ;;
    esac
  done

  # Verify that any flags have been provided
  if [ $OPTIND -eq 1 ]; then
    echo "No options were passed"
    usage 1
  fi

  prepare_query "$sql_host" "$country" "$city" "$activity" "$country_image" "$city_image" "$activity_image"
}

main "$@"
