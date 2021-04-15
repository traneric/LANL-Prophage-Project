#This script takes in a list of phispy output directory names. It extracts information from each directories'
#prophage.tbl and appends it into a prophage_data.tsv with each line containing STRAIN_NAME PROPHAGE_NUM BP_START BP_END

TEST_DATA_DIR="/projects/bgmp/shared/groups/2020/prophage/phispy_data/phispy_data_human_gut_genomes/test_data.tsv"
TEMP_DATA_DIR="/projects/bgmp/shared/groups/2020/prophage/phispy_data/phispy_data_human_gut_genomes/temp_data.tsv"
PROPHAGE_DATA_DIR="/projects/bgmp/shared/groups/2020/prophage/phispy_data/phispy_data_human_gut_genomes/gut_prophage_data.tsv"

cat directory_names.txt | while read file
do
        cd $file
	STRAIN_NAME="$(pwd | awk -F '/' '{print $NF}' | rev | cut -c 8- | rev)"
        cat prophage.tbl | tr "_" "\t" | cut -f 2,5,6 > $TEMP_DATA_DIR

	cat $TEMP_DATA_DIR | while read line
	do
		strain_prophage_line="${STRAIN_NAME}	${line}"
		echo $strain_prophage_line >> $PROPHAGE_DATA_DIR
	done

        cd ..
done

