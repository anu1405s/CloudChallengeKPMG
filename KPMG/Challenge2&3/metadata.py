import requests
import json

metadata_endpoint = "http://{public_ip}/metadata/instance?api-version=2021-02-01"

metadata_instances = ["network","compute"]

def azureMetadata():
    metadata = {}
    for instance in metadata_instances:
        instance_endpoint = f"{metadata_endpoint}&category={instance}"
        try:
            response = requests.get(instance_endpoint, headers={"Metadata": "true"})
            if response.status_code == 200:
                metadata[instance] = json.loads(response.text)
            else:
                metadata[instance] = f"Error: {response.status_code}"
        except Exception as e:
            metadata[instance] = f"Error: {str(e)}"   
    return metadata

if __name__ == "__main__":
    azure_metadata = azureMetadata()
    formatted_json = json.dumps(azure_metadata, indent=4)
    print(formatted_json)