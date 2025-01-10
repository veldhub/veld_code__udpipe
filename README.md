# veld_code__udpipe

Code VELD repo to encapsulate [updipe](https://lindat.mff.cuni.cz/services/udpipe/). 

Offers currently two code velds:

- [./veld_infer.yaml](./veld_infer.yaml): inference on txt data with a given udpipe model
- [./veld_train.yaml](./veld_train.yaml): train a udpipe model from scratch on conllu data

See the respective VELD yaml files for more details.

## requirements

- git
- docker compose

## how to run

Either integrate a code veld into a chain veld, or use the code veld directly by adapting its 
configuration with its veld yaml file. 

Run a veld with:
```
docker compsoe -f <veld>.yaml up
```

e.g. 

```
docker compsoe -f veld_train.yaml up
```

