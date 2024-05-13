#!/bin/bash

source ./read_input_options.sh

build_args() {
  result=""
  result+="$(read_input_options_multiple tokenizer)"
  result+="$(read_input_options_multiple tagger)"
  result+="$(read_input_options_multiple parser)"
  echo $result
}

udpipe_args=$(build_args)
echo "arguments constructed from environment input: ${udpipe_args}"

udpipe --train $udpipe_args $model_path $train_data_path

