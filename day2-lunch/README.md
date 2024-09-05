## BIOMART Answer 1

- `less hg38-gene-metadata-feature.tsv`
- `cut -f 7 hg38-gene-metadata-feature.tsv | sort | uniq -c`
- `cut -f 7 hg38-gene-metadata-feature.tsv | sort | uniq -c | grep "protein_coding"`
- There are 19618 protein coding genes. 
- I want to know more about the rRNA, since I want to know the relationship between ribosome availability, protein translation - - speed and rRNA expression level. 


## BIOMART Answer 2

-`cut -f 1 hg38-gene-metadata-go.tsv |  sort | uniq -c | sort -n`
- ENSG00000168036 has the most go_ids with amount of 273. 
- `grep -w "ENSG00000168036" hg38-gene-metadata-go.tsv | sort -f -k 3`
- `grep -w "ENSG00000168036" hg38-gene-metadata-go.tsv | sort -f -k 3 > sorted_gene_file.tsv`
- I think this gene is mainly responsible for cellular structure establishment including cellular membrane, signaling receptors - and interaction with other cells. More globally, This gene should also be responsible for tissue or organ structure, and epithelial cell. 


## GENCODE Answer 1
- `grep -w -e "IG...gene" -e "IG....gene" genes.gtf | cut -f 1 | sort | uniq -c | sort`
- The distribution of IG genes is as following: 1 on chr 21, 6 on chr16, 16 on chr15, 48 on chr22, 52 on chr2, and 91 on chr14. 

-`grep -w -e "IG.pseudogene" -e "IG...pseudogene" genes.gtf | cut -f 1 | sort | uniq -c | sort`
- The distribution of IG pseudogenes is as following: 1 on chr1, 1 on chr10, 1 on chr18, 1 on chr8, 5 on chr9, 6 on chr15, 8 on - chr16, 45 on chr2, 48 on chr22, 84 on chr14. 
- IG genes are expressed on less chromosomes than IG pseudogenes, there are also more IG pseudogenes than IG genes. 

## GENCODE Answer 2
- Because the grep pseudogene gene.gtf is looking for all lines with "pseudogene" words existing, without ruling out it being part of another word, such as "overlap_pseudogene". In this case, some other unwanted lines are included in the final result. We need to grep for lines with exact words matching "pseudogene". 
- `grep -w "gene_type 'pseudogene'" genes.gts`


## GENCODE Answer 3
- `sed "s/ /\t/g" gene.gtf > gene-tabs.gtf`
- `cut -f 1,4,5,14 gene-tabs.gtf > gene-tabs.bed`

