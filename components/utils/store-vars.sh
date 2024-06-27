#!/bin/bash
#identify all variables without default values in Terraform files
#and prompt for their values


TF_DIR="./tf"  # Adjust if your Terraform files are in a different directory
TFVARS_FILE="${TF_DIR}/terraform.tfvars"
touch $TFVARS_FILE

# Find all variables without default values
UNDEFINED_VARS=$(awk '/^variable/ {in_block=1; var_name=$2} 
                      in_block && /default/ {has_default=1} 
                      /^}/ && in_block {if (!has_default) print var_name; in_block=0; has_default=0}' "${TF_DIR}"/*.tf)

# Create a temporary tfvars file
TMP_TFVARS=$(mktemp "${TF_DIR}/terraform_tmp.tfvars.XXXXXX")

# Prompt for values and write to the temporary file
for var in $UNDEFINED_VARS; do
    # Remove quotes from the variable name for comparison
    var_without_quotes="${var%\"}"   # Remove closing quote
    var_without_quotes="${var_without_quotes#\"}"  # Remove opening quote

    if ! grep -q "^$var_without_quotes\s*=" "$TFVARS_FILE"; then  # Check if var is defined in tfvars
        read -p "Enter value for '$var': " value
        echo "$var_without_quotes = \"$value\"" >> "$TMP_TFVARS"
    fi
done

cat "$TMP_TFVARS" >> "$TFVARS_FILE"

# Remove the temporary file
rm "$TMP_TFVARS"