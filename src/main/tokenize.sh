#!/bin/bash

source ./read_input_options.sh

build_args() {
  result=""

  param_tokenizer="$(read_input_options_multiple tokenizer false)"
  if [[ "$param_tokenizer" != " " ]]; then
    result+="--tokenize"
    if [[ "${param_tokenizer: -1}" != "=" ]]; then
      result+="$param_tokenizer"
    fi
  fi

  param_tagger="$(read_input_options_multiple tagger false)"
  if [[ "$param_tagger" != " " ]]; then
    result+=" --tag"
    if [[ "${param_tagger: -1}" != "=" ]]; then
      result+="$param_tagger"
    fi
  fi

  param_parser="$(read_input_options_multiple parser false)"
  if [[ "$param_parser" != " " ]]; then
    result+=" --parse"
    if [[ "${param_parser: -1}" != "=" ]]; then
      result+="$param_parser"
    fi
  fi

  echo "$result"
}

udpipe_args=$(build_args)
command="udpipe $udpipe_args ${model_path} --outfile=${output_conllu_file_path} ${input_text_file_path}"
echo "constructed command: ${command}"
$command
