#!/bin/bash

source ./read_input_options.sh

build_args() {
  result=""

  param_tokenizer="$(read_input_options_multiple tokenizer false)"
  if [[ "$param_tokenizer" != "" ]]; then
    result+="--tokenize"
    if [[ "${param_tokenizer: -1}" != "=" ]]; then
      result+="$param_tokenizer"
    fi
  fi

  param_tagger="$(read_input_options_multiple tagger false)"
  if [[ "$param_tagger" != "" ]]; then
    result+=" --tag"
    if [[ "${param_tagger: -1}" != "=" ]]; then
      result+="$param_tagger"
    fi
  fi

  param_parser="$(read_input_options_multiple parser false)"
  if [[ "$param_parser" != "" ]]; then
    result+=" --parse"
    if [[ "${param_parser: -1}" != "=" ]]; then
      result+="$param_parser"
    fi
  fi

  echo "$result"
}

# function to call udpipe. If the parameters are files, udpipe is called directly on them. If 
# the parameters are folders, then this function goes through the content of the folder recursively
# and creating equivalent output folder / file structure for each matching txt file input.
do_udpipe_recursively() {

  # debug echo: on current recursive level / parameters
  echo "apply udpipe recursively on" "$1" "$2"

  # if file
  if [ -f "$1" ]; then

    # if txt
    if [[ "$1" == *.txt ]]; then

      # prepare output conllu folder and file
      out_conllu_file=${1/\/veld\/input\/txt\//\/veld\/output\/}
      out_conllu_file=${out_conllu_file%txt}conllu
      out_conllu_path_folder=${out_conllu_file%/*}
      if ! [ -e "$out_conllu_path_folder" ]; then
        mkdir -p "$out_conllu_path_folder"
      fi

      # call udpipe
      command="udpipe $udpipe_args /veld/input/model/${in_model_file} --outfile="$out_conllu_file" ${1}"
      echo "is txt. executing:"
      echo "$command"
      eval "$command"

    fi

  # if folder
  elif [ -d "$1" ]; then

    # iterate over content of folder
    for file_or_folder in "$1"/*; do
      do_udpipe_recursively "$file_or_folder"
    done

  # if parameter is a non-existing path
  else

    echo "file or folder does not exist: ${1}"
    exit 1
  fi
}

udpipe_args=$(build_args)

if [[ $in_txt_file = "" ]]; then
  do_udpipe_recursively /veld/input/txt
else
  do_udpipe_recursively /veld/input/txt/"$in_txt_file"
fi

