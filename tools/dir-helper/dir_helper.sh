#!/bin/bash

function check_general_images() {
    if [ ! -f "$1/$2/general/$2" ]; then
      copy_country_image "$1" "$2" "$3" "$4" "$5" "$6" "$7"
    fi

    if [ ! -f "$1/$2/cities/$3/general/$3" ]; then
      copy_city_image "$1" "$2" "$3" "$4" "$5" "$6" "$7"
    fi

    if [ ! -f "$1/$2/cities/$3/activities/$4/$4" ]; then
      copy_activity_image "$1" "$2" "$3" "$4" "$5" "$6" "$7"
    fi
}


#######################################
# description
# Arguments:
#   1 - Directory to create the folder structure in
#   2 - Country to create
#   3 - City to create
#   4 - Activity to create
#   5 - Country Image
#   6 - City Image
#   7 - Activity Image
#######################################
#function copy_images() {
#  local file
#
#  cp "$5" "$1/$2/general/"
#  file=$(ls "$1/$2/general/")
#  mv "$1/$2/general/$file" "$1/$2/general/$2"
#
#  cp "$6" "$1/$2/cities/$3/general/"
#  file=$(ls "$1/$2/cities/$3/general/")
#  mv "$1/$2/cities/$3/general/$file" "$1/$2/cities/$3/general/$3"
#
#  cp "$7" "$1/$2/cities/$3/activities/$4/"
#  file=$(ls "$1/$2/cities/$3/activities/$4/")
#  mv "$1/$2/cities/$3/activities/$4/$file" "$1/$2/cities/$3/activities/$4/$4"
#}

function copy_activity_image() {
  local file

  cp "$7" "$1/$2/cities/$3/activities/$4/"
  file=$(ls "$1/$2/cities/$3/activities/$4/")
  mv "$1/$2/cities/$3/activities/$4/$file" "$1/$2/cities/$3/activities/$4/$4"
}

function copy_country_image() {
  local file

  cp "$5" "$1/$2/general/"
  file=$(ls "$1/$2/general/")
  mv "$1/$2/general/$file" "$1/$2/general/$2"
}

function copy_city_image() {
  local file

  cp "$6" "$1/$2/cities/$3/general/"
  file=$(ls "$1/$2/cities/$3/general/")
  mv "$1/$2/cities/$3/general/$file" "$1/$2/cities/$3/general/$3"
}

#######################################
# description
# Arguments:
#   1 - Country Image
#   2 - City Image
#   3 - Activity Image
#######################################
function verify_images_exist() {
    if [ ! -f "$1" ]
    then
        echo "Image $1 does not exist"
        exit 1
    fi
    if [ ! -f "$2" ]
    then
        echo "Image $2 does not exist"
        exit 1
    fi
    if [ ! -f "$3" ]
    then
        echo "Image $3 does not exist"
        exit 1
    fi
}
#######################################
# Creates folder structure for s3
# Arguments:
#   1 - Directory to create the folder structure in
#   2 - Country to create
#   3 - City to create
#   4 - Activity to create
#######################################
function create_dirs() {
    mkdir -p "$1/$2/cities/$3/activities/$4"
    mkdir -p "$1/$2/general"
    mkdir -p "$1/$2/cities/$3/general"
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
# description
# Arguments:
#   terraform_dir - Location of terraform code to create DIRs in
#######################################
#function check_flags() {
#  if [ -z "$1" ]; then
#    echo "Please ensure that the -t flag is provided"
#    usage 1
#  fi
#  shift
#    if [ -z "$1" ]; then
#    echo "Please ensure that the -c flag is provided"
#    usage 1
#  fi
#  shift
#    if [ -z "$1" ]; then
#    echo "Please ensure that the -v flag is provided"
#    usage 1
#  fi
#  shift
#    if [ -z "$1" ]; then
#    echo "Please ensure that the -b flag is provided"
#    usage 1
#  fi
#    shift
#    if [ -z "$1" ]; then
#    echo "Please ensure that the -i flag is provided"
#    usage 1
#  fi
#    shift
#    if [ -z "$1" ]; then
#    echo "Please ensure that the -o flag is provided"
#    usage 1
#  fi
#    shift
#    if [ -z "$1" ]; then
#    echo "Please ensure that the -p flag is provided"
#    usage 1
#  fi
#}

#######################################
# Main
# Arguments:
#  None
#######################################
function main() {
  local country_image=0
  local city_image=0
  local activity_image=0
  local flag
  # Get flags
  while getopts ":ht:c:v:b:i:o:p:" flag; do
    case "${flag}" in
      h)
        usage 0
        ;;
      t) local terraform_dir=${OPTARG} ;;
      c) local country=${OPTARG} ;;
      v) local city=${OPTARG} ;;
      b) local activity=${OPTARG} ;;
      i) country_image=${OPTARG} ;;
      o) city_image=${OPTARG} ;;
      p) activity_image=${OPTARG} ;;
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

  #check_flags "$terraform_dir" "$country" "$city" "$activity" "$country_image" "$city_image" "$activity_image"
#  check_country_general
#  check_city_general

  #verify_images_exist "$country_image" "$city_image" "$activity_image"
  create_dirs "$terraform_dir" "$country" "$city" "$activity"
  check_general_images "$terraform_dir" "$country" "$city" "$activity" "$country_image" "$city_image" "$activity_image"
}

main "$@"
