#!/bin/bash
# Exercise 1
bedtools sort -i genes.bed > genes_chr1.bed 
bedtools sort -i exons.bed > exons_chr1.bed
bedtools sort -i cCREs.bed > cCREs_chr1.bed
bedtools merge -i genes_chr1.bed > merge_genes_chr1.bed
bedtools merge -i exons_chr1.bed > merge_exons_chr1.bed
bedtools merge -i cCREs_chr1.bed > merge_cCREs_chr1.bed
bedtools subtract -a merge_genes_chr1.bed -b merge_exons_chr1.bed > introns_chr1.bed 
bedtools subtract -a merge_genes_chr1.bed -b introns_chr1.bed merge_exons_chr1.bed merge_cCREs_chr1.bed > other_chr1.bed
