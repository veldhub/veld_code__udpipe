#!/bin/bash

source ./read_input_options.sh

build_args() {
  result=""
  result+="$(read_input_options_multiple tokenizer true) "
  result+="$(read_input_options_multiple tagger true) "
  result+="$(read_input_options_multiple parser true)"
  echo "$result"
}

udpipe_args=$(build_args)
command="udpipe --train ${udpipe_args} /veld/output/${model_path} /veld/input/${train_data_path}"
echo "constructed command: ${command}"
$command
