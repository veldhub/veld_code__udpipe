#!/bin/bash

read_input_options_simple() {
  if [[ "${!1}" == "true" ]]; then
    echo " --${1}"
  elif [[ "${!1}" == "false" ]]; then
    echo " "
  fi
}

read_input_options_multiple() {
  base_option=$(read_input_options_simple "$1")
  if [[ "$base_option" != " " ]]; then
    result=""
    var_sub="${1}_"
    for var in $(env | cut -d= -f1); do
      if [[ $var == $var_sub* ]]; then
        var_short=${var//$var_sub}
        var_value=${!var}
        if [[ "$var_value" == "true" ]]; then
          var_value=1
        elif [[ "$var_value" == "false" ]]; then
          var_value=0
        fi
        result+="${var_short}=${var_value};"
      fi
    done
    echo "${base_option}=${result}"
  else
    echo " "
  fi
  #if [[ -z $result ]]; then
  #  echo ""
  #else
  #  echo " --${1%_*}=${result}"
  #fi
}

