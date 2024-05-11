#!/bin/bash

# Function to check if Azure CLI is installed
check_azure_cli() {
    if ! command -v az &> /dev/null; then
        return 1
    else
        return 0
    fi
}

# Function to install Azure CLI
install_azure_cli() {
    echo "Azure CLI is not installed."
    read -p "Would you like to install Azure CLI? (Y/N): " choice
    case "$choice" in
        y|Y )
            echo "Installing Azure CLI..."
            curl -sL https://aka.ms/InstallAzureCLIDeb | sudo bash
            ;;
        n|N )
            echo "Please install Azure CLI manually before using this script."
            exit 1
            ;;
        * )
            echo "Invalid choice. Please enter Y or N."
            install_azure_cli
            ;;
    esac
}

# Function to login to Azure CLI
login_azure_cli() {
    az login
    if [ $? -eq 0 ]; then
        echo "Successfully logged in to Azure CLI."
    else
        echo "Failed to log in to Azure CLI. Please try again."
        exit 1
    fi
}

# Function to create a new resource group
create_resource_group() {
    read -p "Enter the name of the new resource group: " rg_name
    echo "Please choose a region for the new resource group:"
    echo "1. East US"
    echo "2. West US"
    echo "3. Central US"
    echo "4. East Asia"
    echo "5. West Europe"
    read -p "Enter the number of your desired region: " region_choice
    case "$region_choice" in
        1 ) rg_location="eastus";;
        2 ) rg_location="westus";;
        3 ) rg_location="centralus";;
        4 ) rg_location="eastasia";;
        5 ) rg_location="westeurope";;
        * )
            echo "Invalid choice. Please try again."
            create_resource_group
            ;;
    esac
    az group create --name $rg_name --location $rg_location
    if [ $? -eq 0 ]; then
        echo "Resource group $rg_name created successfully in $rg_location."
    else
        echo "Failed to create resource group $rg_name. Please try again."
        exit 1
    fi
}

# Function to create a new storage account
create_storage_account() {
    read -p "Enter the name of the storage account: " storage_name
    echo "Please choose a region for the storage account:"
    echo "1. East US"
    echo "2. West US"
    echo "3. Central US"
    echo "4. East Asia"
    echo "5. West Europe"
    read -p "Enter the number of your desired region: " region_choice
    case "$region_choice" in
        1 ) location="eastus";;
        2 ) location="westus";;
        3 ) location="centralus";;
        4 ) location="eastasia";;
        5 ) location="westeurope";;
        * )
            echo "Invalid choice. Please try again."
            create_storage_account
            ;;
    esac
    az storage account create --name $storage_name --resource-group $rg_name --location $location --sku Standard_LRS
    if [ $? -eq 0 ]; then
        echo "Storage account $storage_name created successfully in $location."
    else
        echo "Failed to create storage account $storage_name. Please try again."
        exit 1
    fi
}

# Function to create a new container
create_container() {
    read -p "Enter the name of the container: " container_name
    az storage container create --account-name $storage_name --name $container_name --auth-mode login
    if [ $? -eq 0 ]; then
        echo "Container $container_name created successfully in storage account $storage_name."
    else
        echo "Failed to create container $container_name. Please try again."
        exit 1
    fi
}

# Function to upload a file to the cloud
upload_file() {
    read -p "Enter the path of the file you want to upload: " file_path
    read -p "Enter the name for the uploaded file: " file_name
    az storage blob upload --account-name $storage_name --container-name $container_name --file $file_path --name $file_name
    if [ $? -eq 0 ]; then
        echo "File $file_name uploaded successfully to container $container_name."
    else
        echo "Failed to upload file $file_name. Please try again."
        exit 1
    fi
}

# Main script
if check_azure_cli; then
    echo "Azure CLI is installed."
    login_azure_cli
else
    install_azure_cli
    login_azure_cli
fi

read -p "Do you want to create a new resource group? (Y/N): " create_rg
case "$create_rg" in
    y|Y )
        create_resource_group
        ;;
    n|N )
        read -p "Enter the name of the pre-made resource group: " pre_rg_name
        if az group show --name $pre_rg_name &> /dev/null; then
            rg_name=$pre_rg_name
            echo "Using pre-made resource group $rg_name."
        else
            echo "Resource group $pre_rg_name does not exist."
            exit 1
        fi
        ;;
    * )
        echo "Invalid choice. Please enter Y or N."
        exit 1
        ;;
esac

if [[ ! -z "$rg_name" ]]; then
    read -p "Do you want to create a new storage account? (Y/N): " create_storage
    case "$create_storage" in
        y|Y )
            create_storage_account
            ;;
        n|N )
            read -p "Enter the name of the pre-made storage account: " pre_storage_name
            if az storage account show --name $pre_storage_name &> /dev/null; then
                storage_name=$pre_storage_name
                echo "Using pre-made storage account $storage_name."
            else
                echo "Storage account $pre_storage_name does not exist."
                exit 1
            fi
            ;;
        * )
            echo "Invalid choice. Please enter Y or N."
            exit 1
            ;;
    esac
fi

if [[ ! -z "$storage_name" ]]; then
    read -p "Do you want to create a new container? (Y/N): " create_container
    case "$create_container" in
        y|Y )
            create_container
            ;;
        n|N )
            read -p "Enter the name of the pre-made container: " pre_container_name
            if az storage container exists --account-name $storage_name --name $pre_container_name &> /dev/null; then
                container_name=$pre_container_name
                echo "Using pre-made container $container_name."
            else
                echo "Container $pre_container_name does not exist."
                exit 1
            fi
            ;;
        * )
            echo "Invalid choice. Please enter Y or N."
            exit 1
            ;;
    esac
fi

if [[ ! -z "$container_name" ]]; then
    while true; do
        upload_file
        read -p "Do you want to upload another file? (Y/N): " choice
        case "$choice" in
            y|Y )
                continue
                ;;
            n|N )
                echo "Exiting..."
                break
                ;;
            * )
                echo "Invalid choice. Please enter Y or N."
                ;;
        esac
    done
fi
