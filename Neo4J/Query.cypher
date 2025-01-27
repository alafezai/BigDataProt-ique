// 1. Créer des nœuds et des relations
// Cette requête crée ou met à jour deux nœuds de protéines et une relation de similarité entre eux.
MERGE (p1:Protein {id: $protein1})
SET p1.reviewed = $reviewed1,
    p1.entry_name = $entry_name1,
    p1.protein_names = $protein_names1,
    p1.gene_names = $gene_names1,
    p1.organism = $organism1,
    p1.length = $length1,
    p1.sequence = $sequence1,
    p1.ec_number = $ec_number1,
    p1.domains = $domains1,
    p1.num_domains = $num_domains1
MERGE (p2:Protein {id: $protein2})
SET p2.reviewed = $reviewed2,
    p2.entry_name = $entry_name2,
    p2.protein_names = $protein_names2,
    p2.gene_names = $gene_names2,
    p2.organism = $organism2,
    p2.length = $length2,
    p2.sequence = $sequence2,
    p2.ec_number = $ec_number2,
    p2.domains = $domains2,
    p2.num_domains = $num_domains2
MERGE (p1)-[r:SIMILAR_TO {similarity: $similarity}]->(p2);

// 2. Récupérer toutes les protéines
// Cette requête retourne toutes les protéines dans la base de données.
MATCH (p:Protein)
RETURN p.id, p.entry_name, p.protein_names, p.gene_names, p.organism, p.length, p.sequence, p.ec_number, p.domains, p.num_domains;

// 3. Récupérer les relations de similarité entre deux protéines spécifiques
// Cette requête retourne le score de similarité entre deux protéines spécifiques.
MATCH (p1:Protein {id: $protein1})-[r:SIMILAR_TO]->(p2:Protein {id: $protein2})
RETURN r.similarity;

// 4. Récupérer toutes les protéines similaires à une protéine donnée
// Cette requête retourne toutes les protéines similaires à une protéine donnée, ainsi que leur score de similarité.
MATCH (p1:Protein {id: $protein1})-[r:SIMILAR_TO]->(p2:Protein)
RETURN p2.id, p2.entry_name, p2.protein_names, r.similarity;

// 5. Récupérer les protéines avec un score de similarité supérieur à un certain seuil
// Cette requête retourne les paires de protéines ayant un score de similarité supérieur à un seuil donné.
MATCH (p1:Protein)-[r:SIMILAR_TO]->(p2:Protein)
WHERE r.similarity > $threshold
RETURN p1.id, p2.id, r.similarity;

// 6. Récupérer les protéines d'un organisme spécifique
// Cette requête retourne toutes les protéines d'un organisme spécifique.
MATCH (p:Protein {organism: $organism})
RETURN p.id, p.entry_name, p.protein_names, p.gene_names, p.length, p.sequence, p.ec_number, p.domains, p.num_domains;

// 7. Récupérer les protéines avec un nombre de domaines supérieur à un certain seuil
// Cette requête retourne les protéines ayant un nombre de domaines supérieur à un seuil donné.
MATCH (p:Protein)
WHERE p.num_domains > $domain_threshold
RETURN p.id, p.entry_name, p.protein_names, p.num_domains;

// 8. Supprimer une protéine et ses relations
// Cette requête supprime une protéine et toutes ses relations.
MATCH (p:Protein {id: $protein_id})
DETACH DELETE p;

// 9. Mettre à jour les propriétés d'une protéine
// Cette requête met à jour les propriétés d'une protéine spécifique.
MATCH (p:Protein {id: $protein_id})
SET p.protein_names = $new_protein_names,
    p.gene_names = $new_gene_names,
    p.length = $new_length,
    p.sequence = $new_sequence,
    p.ec_number = $new_ec_number,
    p.domains = $new_domains,
    p.num_domains = $new_num_domains;

// 10. Récupérer les protéines avec un nom de gène spécifique
// Cette requête retourne les protéines ayant un nom de gène spécifique.
MATCH (p:Protein)
WHERE $gene_name IN p.gene_names
RETURN p.id, p.entry_name, p.protein_names, p.gene_names, p.organism, p.length, p.sequence, p.ec_number, p.domains, p.num_domains;

// 11. Récupérer les protéines avec un numéro EC spécifique
// Cette requête retourne les protéines ayant un numéro EC spécifique.
MATCH (p:Protein)
WHERE $ec_number IN p.ec_number
RETURN p.id, p.entry_name, p.protein_names, p.gene_names, p.organism, p.length, p.sequence, p.ec_number, p.domains, p.num_domains;

// 12. Récupérer les protéines avec une séquence spécifique
// Cette requête retourne les protéines ayant une séquence spécifique.
MATCH (p:Protein)
WHERE p.sequence CONTAINS $sequence
RETURN p.id, p.entry_name, p.protein_names, p.gene_names, p.organism, p.length, p.sequence, p.ec_number, p.domains, p.num_domains;

// 13. Récupérer les protéines avec un nom d'entrée spécifique
// Cette requête retourne les protéines ayant un nom d'entrée spécifique.
MATCH (p:Protein {entry_name: $entry_name})
RETURN p.id, p.entry_name, p.protein_names, p.gene_names, p.organism, p.length, p.sequence, p.ec_number, p.domains, p.num_domains;

// 14. Récupérer les protéines avec un nom de protéine spécifique
// Cette requête retourne les protéines ayant un nom de protéine spécifique.
MATCH (p:Protein)
WHERE $protein_name IN p.protein_names
RETURN p.id, p.entry_name, p.protein_names, p.gene_names, p.organism, p.length, p.sequence, p.ec_number, p.domains, p.num_domains;

// 15. Récupérer les protéines avec un domaine spécifique
// Cette requête retourne les protéines ayant un domaine spécifique.
MATCH (p:Protein)
WHERE $domain IN p.domains
RETURN p.id, p.entry_name, p.protein_names, p.gene_names, p.organism, p.length, p.sequence, p.ec_number, p.domains, p.num_domains;

// 16. Trouver les clusters de protéines fortement connectées
// Cette requête identifie les clusters de protéines où chaque protéine est connectée à au moins `k` autres protéines avec un score de similarité supérieur à un seuil donné.
MATCH (p1:Protein)-[r:SIMILAR_TO]->(p2:Protein)
WHERE r.similarity > $threshold
WITH p1, COUNT(p2) AS connections
WHERE connections >= $k
RETURN p1.id, p1.entry_name, connections
ORDER BY connections DESC;

// 17. Trouver les protéines centrales dans le réseau (high betweenness centrality)
// Cette requête calcule la centralité d'intermédiarité (betweenness centrality) pour chaque protéine, ce qui permet d'identifier les protéines les plus centrales dans le réseau.
CALL gds.betweenness.stream('protein-network')
YIELD nodeId, score
RETURN gds.util.asNode(nodeId).id AS protein_id, gds.util.asNode(nodeId).entry_name AS entry_name, score
ORDER BY score DESC
LIMIT 10;

// 18. Trouver les protéines avec le plus grand nombre de domaines communs
// Cette requête identifie les paires de protéines qui partagent le plus grand nombre de domaines communs.
MATCH (p1:Protein), (p2:Protein)
WHERE p1 <> p2 AND size([domain IN p1.domains WHERE domain IN p2.domains]) > 0
RETURN p1.id, p2.id, size([domain IN p1.domains WHERE domain IN p2.domains]) AS shared_domains
ORDER BY shared_domains DESC
LIMIT 10;

// 19. Trouver les protéines avec des motifs de domaines spécifiques
// Cette requête recherche des protéines ayant un motif spécifique de domaines (par exemple, une séquence de domaines donnée).
MATCH (p:Protein)
WHERE p.domains = $domain_pattern
RETURN p.id, p.entry_name, p.domains;

// 20. Trouver les protéines avec des relations de similarité réciproques
// Cette requête identifie les paires de protéines qui ont des relations de similarité dans les deux directions (par exemple, `A -> B` et `B -> A`).
MATCH (p1:Protein)-[r1:SIMILAR_TO]->(p2:Protein)-[r2:SIMILAR_TO]->(p1)
RETURN p1.id, p2.id, r1.similarity, r2.similarity;

// 21. Trouver les protéines avec des chemins de similarité indirects
// Cette requête recherche des protéines connectées indirectement via une chaîne de similarité (par exemple, `A -> B -> C`).
MATCH path = (p1:Protein)-[:SIMILAR_TO*2..5]->(p2:Protein)
WHERE p1.id = $protein_id
RETURN [node IN nodes(path) | node.id] AS path_proteins, length(path) AS path_length;

// 22. Trouver les protéines avec des propriétés similaires (sans relation explicite)
// Cette requête identifie des protéines ayant des propriétés similaires (par exemple, même organisme, longueur similaire, etc.) sans qu'il y ait nécessairement une relation de similarité explicite.
MATCH (p1:Protein), (p2:Protein)
WHERE p1 <> p2
  AND p1.organism = p2.organism
  AND abs(p1.length - p2.length) <= $length_tolerance
RETURN p1.id, p2.id, p1.organism, p1.length, p2.length;

// 23. Trouver les protéines avec des relations de similarité transitives
// Cette requête identifie des groupes de protéines où chaque protéine est similaire à la suivante, formant une chaîne transitive.
MATCH path = (p1:Protein)-[:SIMILAR_TO*]->(p2:Protein)
WHERE p1.id = $protein_id
RETURN [node IN nodes(path) | node.id] AS transitive_path;

// 24. Trouver les protéines avec des relations de similarité en boucle
// Cette requête identifie des protéines qui forment une boucle de similarité (par exemple, `A -> B -> C -> A`).
MATCH path = (p1:Protein)-[:SIMILAR_TO*]->(p1)
WHERE length(path) > 1
RETURN [node IN nodes(path) | node.id] AS loop_proteins;

// 25. Trouver les protéines avec des relations de similarité asymétriques
// Cette requête identifie les paires de protéines où la similarité dans un sens est beaucoup plus forte que dans l'autre.
MATCH (p1:Protein)-[r1:SIMILAR_TO]->(p2:Protein), (p2)-[r2:SIMILAR_TO]->(p1)
WHERE abs(r1.similarity - r2.similarity) > $asymmetry_threshold
RETURN p1.id, p2.id, r1.similarity, r2.similarity;