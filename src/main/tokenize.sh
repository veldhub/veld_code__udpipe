#!/bin/bash

source ./read_input_options.sh

build_args() {
  result=""
  result+="$(read_input_options_simple tokenize)"
  result+="$(read_input_options_simple tag)"
  result+="$(read_input_options_simple parse)"
  echo $result
}

udpipe_args=$(build_args)
echo "arguments constructed from environment input: ${udpipe_args}"

udpipe $udpipe_args $model_path --outfile=$output_conllu_file_path $input_text_file_path

