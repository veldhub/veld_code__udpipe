#!/bin/bash

# this script is shared among training and inference scripts. It translates the veld-specific 
# configuration via environment variables into udpipe conforming parameters

# function reading the basic boolean paramater, returning "--param" if true, empty if not
read_input_options_simple() {
  if [[ "${!1}" == "true" ]]; then
    echo " --${1}"
  else
    echo " "
  fi
}

# function reading the sub parameters of udpipe main parameters, such as "tokenizer options"
# $1 the main parameter
# $2 boolean, if the output should be parameter + values (main_param=sub_param=1, 
# or main_param=sub_param=0), or just the param (main_param=param)
read_input_options_multiple() {

  # first, read in simple main parameter
  base_option=$(read_input_options_simple "$1")
  if [[ "$base_option" != " " ]]; then
    result=""

    # iterate over all environment variables, check if they match the main parameter, but with a
    # "-" at the end, indicating sub parameter
    var_sub="${1}_"
    for var in $(env | cut -d= -f1); do
      if [[ $var == $var_sub* ]]; then

        # extract the sub parameter which is conforming to udpipe
        var_short=${var//$var_sub}

        # process value
        var_value=${!var}
        # if true, conver into "param=1" or "param"
        if [[ "$var_value" == "true" ]]; then
          if [[ $2 == "true" ]]; then
            result+="${var_short}=1;"
          else
            result+="${var_short};"
          fi
        # if true, conver into "param=0"
        elif [[ "$var_value" == "false" ]]; then
          if [[ $2 == "true" ]]; then
            result+="${var_short}=0;"
          fi
        fi
      fi
    done

    # return full parameter with sub parameters as one string
    echo "${base_option}=${result}"
  else
    echo " "
  fi
}

