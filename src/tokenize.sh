#!/bin/bash

udpipe --tokenize --tag --parse $model_file_Path --outfile=$output_conllu_file_path $input_text_file_path

