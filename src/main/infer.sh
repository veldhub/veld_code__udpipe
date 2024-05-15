#!/bin/bash

source ./read_input_options.sh

if [[ "$in_txt_url" != "" ]]; then
  if [[ "$in_txt_path" != "" ]]; then
    echo "both in_txt_url and in_txt_path are provided. Exiting. Define only one." 
    exit 1
  fi
  echo "downloading txt from ${in_txt_url}"
  curl -o /tmp/tmp.txt "$in_txt_url"
  in_txt_path=/tmp/tmp.txt
fi

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

  # quick info on current recursive level / parameters
  # echo "do_udpipe_recursively" "$1" "$2"

  # if file
  if [ -f "$1" ]; then

    # if txt
    if [[ "$1" == *.txt ]]; then

      # since the current parameter is a txt file, call udpipe on it
      # echo "is txt. processing"

      # create parent folder of output (if it doesn't exist)
      out_conllu_path_folder=${2%/*}
      if ! [ -e "$out_conllu_path_folder" ]; then
        mkdir -p "$out_conllu_path_folder"
      fi

      # call udpipe
      command="udpipe $udpipe_args ${in_model_path} --outfile=${2} ${1}"
      echo "executing: ${command}"
      $command

    else

      # if the input parameter is a non-txt file, this must have been a mistake. Abort then.
      # echo "not a txt file" "$1"
      exit 1
    fi

  # if folder
  elif [ -d "$1" ]; then
    # echo "check content of folder" "$1"

    # iterate over content of folder
    for file_or_folder in "$1"/*; do
      # echo "check if file or folder" "$file_or_folder"

      # if file
      if [ -f "$file_or_folder" ]; then

        # if txt
        if [[ "$file_or_folder" == *.txt ]]; then
          # echo "is txt. creating equivalent target conllu"

          # since this txt file was detected by iterating over a folder (potentially recursively), 
          # an equivalent output folder / file structure must be created dynamically. 
          in_txt_path_single=$file_or_folder

          # remove /veld/input/* so that only relevant subfolder stays
          out_conllu_path_single=${in_txt_path_single#$in_txt_path}

          # replace .txt with .conllu
          out_conllu_path_single=${out_conllu_path_single/.txt/.conllu}

          # concatenate main output folder passed via environment with dynamically created subpath
          out_conllu_path_single="${out_conllu_path}${out_conllu_path_single}"

          # step further down, to reuse the udpipe creation logic at the beginning of this
          # function
          do_udpipe_recursively "$in_txt_path_single" "$out_conllu_path_single"
        # else

          # is file, but not txt. Ignore then.
          # echo "is neither folder, nor txt"
        fi 

      # if folder
      elif [ -d "$file_or_folder" ]; then
        # echo "is folder"

        # recurse downwards into this subfolder
        do_udpipe_recursively "$file_or_folder"
      fi
    done
  else

    # if parameter is a non-existing path
    echo "parameter is neither file, nor path. Exiting."
    exit 1
  fi
}

udpipe_args=$(build_args)

do_udpipe_recursively "$in_txt_path" "$out_conllu_path"

