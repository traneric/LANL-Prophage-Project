# This script accepts a file of NCBI IDs as an input, and web scrapes NCBI for the genome assembly files associated
# with the input NCBI IDs. This script can download FASTA and/or GBFF files.

cat NCBI_ID_LIST.txt | while read ncbi_id
do
	wget "https://www.ncbi.nlm.nih.gov/search/all/?term=${ncbi_id}&database=assembly" -O 1.html

	ASSEMBLY_LINK="$(grep "https://www.ncbi.nlm.nih.gov/assembly" 1.html | head -1 | sed 's/<a href="//' | sed 's/.$//')"

	wget $ASSEMBLY_LINK -O 2.html

	FTP_LINK="$(grep assembly_report 2.html | sed -E -e 's#.*href="(https://ftp.ncbi.nlm.nih.gov/genomes/all[^"]*).*#\1#' | sed -e 's#/[^/]*$##'
)"

	GENE_ID_NAME="$(echo $FTP_LINK | sed 's/.*\///')"

	# Choose between FASTA or GBFF format files, or both.
	FASTA_LINK="${FTP_LINK}/${GENE_ID_NAME}_genomic.fna.gz"
	GBFF_LINK="${FTP_LINK}/${GENE_ID_NAME}_genomic.gbff.gz"
	
	# Input file choice here. FASTA format chosen by default.
	wget $FASTA_LINK
done
