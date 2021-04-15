#This script takes in a list of DBSCAN output directory names. It extracts information from each directories'
#prophage.tbl and appends it into a dbscan_prophage_data.tsv with each line containing STRAIN_NAME,
#genome_size, prophage_start, prophage_end

TEMP_DATA_PATH="/projects/bgmp/shared/groups/2020/prophage/dbscan_data/dbscan_data_human_microbiome_genomes/temp_data.tsv"
PROPHAGE_DATA_PATH="/projects/bgmp/shared/groups/2020/prophage/dbscan_data/dbscan_data_human_microbiome_genomes/dbscan_human_microbiome_data.tsv"
DIRECTORY_NAMES_PATH="/projects/bgmp/shared/groups/2020/prophage/dbscan_data/dbscan_data_human_microbiome_genomes/dbscan_human_microbiome_directory_names.tsv"

cat $DIRECTORY_NAMES_PATH | while read file
do
        cd $file
        STRAIN_NAME="$(pwd | awk -F '/' '{print $NF}' | rev | cut -c 8- | rev)"

	if ls | grep -q ".fna";	then
    		echo "found"
	else
		cd ..
    		continue
	fi

	SUMMARY_FILE="$(ls | grep ".fna")"
        cat $SUMMARY_FILE | grep ">" | wc -l > $TEMP_DATA_PATH

        cat $TEMP_DATA_PATH | while read line
        do
                strain_prophage_line="${STRAIN_NAME}    ${line}"
                echo $strain_prophage_line >> $PROPHAGE_DATA_PATH
        done

        cd ..
done
