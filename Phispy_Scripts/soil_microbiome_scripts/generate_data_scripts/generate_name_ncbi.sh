# This script takes in a list of Phispy folder directories and generates a list of species names and NCBI numbers.

cat soil_directory_names.txt | while read directory_name
do
        STRAIN_NAME="$(echo $directory_name | rev | cut -c 9- | rev)"
	echo $STRAIN_NAME | tr -d '\n' >> soil_strain_ncbi.txt
	echo "  " | tr -d '\n' >> soil_strain_ncbi.txt
	
	cd $directory_name
	cat prophage.gff3 | cut -f 1 | sed -n '2p' >> /projects/bgmp/shared/groups/2020/prophage/phispy_data/phispy_data_refsoil_genomes/soil_strain_ncbi.txt
	cd ..
done
