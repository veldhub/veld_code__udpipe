# ![veld chain](https://raw.githubusercontent.com/veldhub/.github/refs/heads/main/images/symbol_V_letter.png) veld_code__udpipe

This repo contains [code velds](https://zenodo.org/records/13322913) encapsulating
[updipe](https://lindat.mff.cuni.cz/services/udpipe/) .

## requirements

- git
- docker compose (note: older docker compose versions require running `docker-compose` instead of 
  `docker compose`)

## how to use

A code veld may be integrated into a chain veld, or used directly by adapting the configuration 
within its yaml file and using the template folders provided in this repo. Open the respective veld 
yaml file for more information.

Run a veld with:
```
docker compose -f <VELD_NAME>.yaml up
```

## contained code velds

**[./veld_train.yaml](./veld_train.yaml)** 

udpipe training

```
docker compsoe -f veld_train.yaml up
```

**[./veld_infer.yaml](./veld_infer.yaml)** 

udpipe inference

```
docker compsoe -f veld_infer.yaml up
```

