# Project Architecture

## 1. **Introduction**
This project aims to construct a protein graph based on their domain compositions, using Big Data techniques to efficiently handle large-scale data. The primary goal is to automatically annotate unannotated proteins by propagating annotations from already annotated proteins through the graph. To achieve this, we used **Locality-Sensitive Hashing (LSH)** to accelerate similarity computations between proteins and implemented a label propagation algorithm for protein annotation.

---

## 2. **Global Architecture**

### 2.1 **Data Flow**
1. **Data Collection**:
   - Data is extracted from public sources : UniProt.
   - The files used include:
     - `protein2ipr.dat.gz`: Protein-domain associations.
     - `enzyme.dat`: EC (Enzyme Commission) number information.

2. **Data Preprocessing**:
   - Data is cleaned and transformed to extract relevant information (domains, EC annotations).
   - Proteins are represented by their domain compositions (sets of InterPro domains).

3. **Graph Construction**:
   - Proteins are connected based on the similarity of their domain compositions, calculated using the **Jaccard Index**.
   - **LSH** is used to accelerate similarity computations by reducing the number of required comparisons.

4. **Protein Annotation**:
   - A **label propagation algorithm** is applied to propagate annotations from annotated proteins to unannotated ones.
   - Propagated annotations include EC numbers.

5. **Storage and Querying**:
   - The protein graph is stored in a graph database (**Neo4j**).
   - A user interface allows visualization of proteins, their neighbors, and their annotations.

---

## 3. **Technological Choices**

### 3.1 **LSH (Locality-Sensitive Hashing)**
- **Objective**: Accelerate similarity computations between proteins by reducing the number of required comparisons.
- **Implementation**:
  - Protein domain compositions are hashed using multiple hash functions.
  - Proteins with similar hashes are considered potentially similar and are compared in detail.
- **Advantages**:
  - Significant reduction in computation time for large datasets.
  - Maintains high accuracy in similarity detection.

### 3.2 **Graph Database (Neo4j)**
- **Objective**: Efficiently store and query the protein graph.
- **Structure**:
  - **Nodes**: Represent proteins with attributes such as ID, domain composition, and annotations.
  - **Relationships**: Represent similarities between proteins, weighted by the Jaccard Index.
- **Advantages**:
  - Enables complex queries on protein relationships.
  - Facilitates graph visualization and annotation exploration.

### 3.3 **Label Propagation Algorithm**
- **Objective**: Propagate annotations from annotated proteins to unannotated ones.
- **Implementation**:
  - For each unannotated protein, annotations from neighboring proteins (based on Jaccard similarity) are aggregated.
  - The most frequent or relevant annotations are assigned to the unannotated protein.
- **Advantages**:
  - Enables automatic annotation of a large number of proteins.
  - Leverages similarity relationships to improve annotation accuracy.

---

## 4. **Implemented Features**

### 4.1 **Graph Construction**
- **Input**: Preprocessed data files (domains, EC annotations).
- **Output**: Protein graph stored in Neo4j.
- **Steps**:
  1. Extract domain compositions for each protein.
  2. Compute Jaccard similarities between proteins using LSH.
  3. Create nodes and relationships in Neo4j.
- **Protein Annotation**
  1. Select unannotated proteins.
  2. Propagate annotations from neighboring proteins.
  3. Assign the most relevant annotations.

### 4.2 **Neo4j**
- **Features**:
  - Search for proteins by ID, name, or description.
  - Visualize proteins and their neighbors.
  - Display annotations (EC) for each protein.

---

## 5. **Results and Evaluation**

### 5.1 **LSH Performance**
- **Computation Time**: Significant reduction in similarity computation time compared to an exhaustive approach.
- **Accuracy**: Maintains high accuracy in similarity detection with an acceptable recall rate.

### 5.2 **Protein Annotation**
- **Coverage**: A large number of unannotated proteins received annotations.
- **Accuracy**: Propagated annotations are consistent with available manual annotations.


---

## 6. **Conclusion**
This project demonstrates the effectiveness of using **LSH** to accelerate similarity computations in a Big Data context, as well as the power of graph databases for protein annotation and visualization. The results show that this approach is scalable and accurate, paving the way for broader applications in automatic protein annotation.
