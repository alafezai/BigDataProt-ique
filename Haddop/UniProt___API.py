import requests
import csv
import subprocess
import os

base_url = "https://rest.uniprot.org/uniprotkb/search"

params = {
    "query": "model_organism:9606", #human
    "format": "json",
    "size": 200
}

response = requests.get(base_url, params=params)

if response.status_code == 200:
    data = response.json()
    results = data.get("results", [])

    output_file = "uniprot_data_with_ec.csv"

    with open(output_file, mode="w", newline="", encoding="utf-8") as file:
        writer = csv.writer(file)

        header = [
            "Entry",
            "Entry Name",
            "Protein Names",
            "Gene Names",
            "Organism",
            "Length",
            "Sequence",
            "EC Number",
            "InterPro Cross-reference"
        ]
        writer.writerow(header)

        for entry in results:
            entry_id = entry.get("primaryAccession", "")
            entry_name = entry.get("uniProtkbId", "")
            protein_names = entry.get("proteinDescription", {}).get("recommendedName", {}).get("fullName", {}).get("value", "")
            gene_names = " ".join([gene["geneName"]["value"] for gene in entry.get("genes", [])]) if entry.get("genes") else ""
            organism = entry.get("organism", {}).get("scientificName", "")
            length = entry.get("sequence", {}).get("length", "")
            sequence = entry.get("sequence", {}).get("value", "")

            ec_numbers = "; ".join(
                ec_number.get("value", "") 
                for ec_number in entry.get("proteinDescription", {}).get("recommendedName", {}).get("ecNumbers", [])
                if "value" in ec_number
            )

            interpro = "; ".join(
                xref["id"] for xref in entry.get("uniProtKBCrossReferences", []) if xref.get("database") == "InterPro"
            )

            writer.writerow([
                entry_id,
                entry_name,
                protein_names,
                gene_names,
                organism,
                length,
                sequence,
                ec_numbers,
                interpro
            ])

    print(f"Les données ont été enregistrées localement dans le fichier '{output_file}'.")

    hdfs_path = "/user/ala"

    try:
        subprocess.run(
            ["hdfs", "dfs", "-put", "-f", output_file, hdfs_path],
            check=True
        )
        print(f"Les données ont été téléchargées dans HDFS à l'emplacement '{hdfs_path}'.")
    except subprocess.CalledProcessError as e:
        print(f"Erreur lors du téléchargement vers HDFS : {e}")
else:
    print(f"Erreur lors de la requête : {response.status_code} - {response.text}")




#All prot human  

import requests
import gzip

# Define the URL for the API endpoint
url = "https://rest.uniprot.org/uniprotkb/stream"

# Define the parameters for the query
params = {
    "compressed": "true",
    "fields": "accession,reviewed,id,protein_name,gene_names,organism_name,length,sequence,ec,xref_interpro",
    "format": "tsv",
    "query": "(* ) AND (model_organism:9606)"
}

try:
    # Make the GET request to the API
    response = requests.get(url, params=params, stream=True)
    response.raise_for_status()  # Raise an HTTPError if the response code is not 200

    # Decompress the gzip content and decode it to a string
    with gzip.GzipFile(fileobj=response.raw) as gz:
        data = gz.read().decode("utf-8")

    # The data is now stored in the data variable
    print("Data successfully retrieved.")

except requests.exceptions.RequestException as e:
    print(f"An error occurred while fetching data: {e}")
print(data)