#!/usr/bin/env bash
REPO_ROOT=$(dirname "${BASH_SOURCE[0]}")

####
# failed attempt at recursively merging files with jq
# actually it kinda works but I realized any standard tool
# json-patch, merge patch, kustomize, is probably better...
#####



# $temp=$(mktemp)
# trap 'rm $f' EXIT INT QUIT
base="packer/base.json"
layer="packer/sig-source-img.json"
# shift 2
merge_builders="$(jq -n '.
| input as $first         # read first input
| input as $second        # read second input
| $first.builders[0] + $second.builders[0] 
' $base $layer)"

merge_variables="$(jq -n '.
| input as $first         # read first input
| input as $second        # read second input
| $first.variables[0] + $second.variables[0] 
' $base $layer)"

jq --argjson builders "$merge_builders" --argjson variables "$merge_variables" '. | if ($builders == null or $builders == "null") then . else .builders = $builders end | if ($variables == null or $variables == "null") then . else .variables = $variables end' $base | sponge $temp


# for file in "$@"; do
   
# done
