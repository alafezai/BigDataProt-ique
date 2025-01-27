# PRO Project - Protein Annotation with Spark and Neo4j

This project aims to build a protein graph based on their domain compositions, using **Apache Spark** for distributed data processing and **Neo4j** for graph storage and querying. The goal is to automatically annotate unannotated proteins by propagating annotations from already annotated proteins through the graph.

# Project Structure

```bash
root/
PRO_PROJECT/
├── config/
│   └── spark_config.json       
├── docs/                        
├── hadoop/
├── Neo4j/
│   ├── query.cypher                     
├── spark/                       
│   ├── notebook_1.ipynb        
│   └── version_final.ipynb      
├── README.md                   
└── requirements.txt             
```

## Prérequis

- Docker
- Python 3.x
- Spark
- Hadoop
- Neo4j


# set up a Hadoop cluster with one master and two slave nodes, follow these steps:

## Clone the Hadoop Lab Repository:
Use the following command to clone the repository that contains the necessary scripts and configurations for setting up the Hadoop cluster:

```bash
git clone https://github.com/inoubliwissem/BigDataLab4TalTech.git
cd BigDataLab4TalTech
```

## Follow the Instructions:
The repository contains detailed instructions on how to set up the Hadoop cluster. Typically, this involves:

   1. Configuring the master node.
   2. Configuring the slave nodes.
   3. Setting up SSH access between the nodes.
   4. Starting the Hadoop services.

. **Clonez ce dépôt :**
```bash
   git clone https://github.com/votre-utilisateur/PROJET_PRO.git
   cd PROJET_PRO
```

2. **Install Python dependencies:**
```bash
pip install -r requirements.txt
```
3. **To use Docker, build the image:**
```bash
docker build -t projet_pro .
```

3. **Usage**
To run the calculations and annotations:
```bash
spark-submit --master local[*] calculs_et_annotations.py
```
**To execute Neo4j queries, use the Query.cypher file in the Neo4j interface.**
