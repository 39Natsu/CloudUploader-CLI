# Azure Cloud File Upload Script

This Bash script facilitates easy file uploads to Azure cloud storage using Azure CLI. It guides users through the process of creating resource groups, storage accounts, containers, and uploading files to Azure cloud.

## Prerequisites

- **Azure CLI:** Ensure Azure CLI is installed on your machine. If not, the script will guide you through the installation process.
  
## Installation

To use this script, follow these steps:

1. **Clone the Repository:**
   ```bash
   git clone https://github.com/39Natsu/CloudUploader-CLI
   
2. **Clone the Repository:**
   ```bash
   cd CloudUploader-CLI
3. **Make the script executable:**
   ```bash
   chmod +x CloudUploader.sh

 
## Usage

1. Run the script (`upload_script.sh`).
2. Follow the prompts to log in to Azure CLI and select or create resource groups, storage accounts, and containers.
3. Upload your files to the selected container.

## Features

- **Azure CLI Installation:** Checks if Azure CLI is installed, and if not, offers to install it.
- **Login to Azure CLI:** Allows users to log in to Azure CLI.
- **Resource Group Management:** Users can create a new resource group or select from pre-existing ones.
- **Storage Account Management:** Users can create a new storage account or select from pre-existing ones.
- **Container Management:** Users can create a new container or select from pre-existing ones.
- **File Upload:** Users can upload files to the selected container in Azure cloud.
- **Multiple File Uploads:** Allows users to upload multiple files in a single session.
  
## Notes

- This script simplifies the process of uploading files to Azure cloud storage, making it suitable for users who prefer command-line interfaces.
- Users need to have appropriate permissions and access to Azure resources for successful execution.

## License

This script is licensed under the [MIT License](LICENSE).
