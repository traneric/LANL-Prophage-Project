library(ggplot2)
library(ggpubr)
library(tidyverse)

### PHISPY SOIL AND MARINE DATA ###

#Reading in the prophage data tables from my downloads
soil_pro <- read.delim("soil_prophage_data.tsv", header = FALSE, sep = " ")
colnames(soil_pro) <- c("bacterial_species", "prophage_num", 
                        "prophage_start", "prophage_end")


marine_pro <- read.delim("marine_prophage_data.tsv", header = FALSE, sep = " ")
colnames(marine_pro) <- c("bacterial_species", "prophage_num", 
                          "prophage_start", "prophage_end")

# Read in DBSCAN prophage data
dbscan_soil <- read.delim("dbscan_soil_data.tsv", header = FALSE, sep = " ")
dbscan_soil["Type"] = "Soil"
colnames(dbscan_soil) <- c("bacterial_species", "prophage_count", "Type")

dbscan_marine <- read.delim("dbscan_marine_data.tsv", header = FALSE, sep = " ")
dbscan_marine["Type"] = "Marine"
colnames(dbscan_marine) <- c("bacterial_species", "prophage_count", "Type")

dbscan_human <- read.delim("dbscan_human_microbiome_data.tsv", header = FALSE, sep = " ")
colnames(dbscan_human) <- c("bacterial_species", "prophage_count", "Type")

# Calculate DBSCAN averages
average_dbscan_soil <- mean(dbscan_soil$prophage_count)
average_dbscan_marine <- mean(dbscan_marine$prophage_count)
average_dbscan_human <- mean(dbscan_human$prophage_count)

### PLOTS FOR SOILL AND MARINE ONLY ###
par(mfrow=c(1,2))
boxplot(dbscan_soil$prophage_count,
        main = "Average Soil Prophage Abundance",
        ylab = "prophage", outline = FALSE)

boxplot(dbscan_marine$prophage_count,
        main = "Average Marine Prophage Abundance",
        ylab = "prophage", outline = FALSE)

#Creating counts files to use for graphs
soil_pro_count <- data.frame(table(soil_pro$bacterial_species))
soil_pro_count["Type"] = "Soil"
avg_soil <- mean(soil_pro_count$Freq)

marine_pro_count <- data.frame(table(marine_pro$bacterial_species))
marine_pro_count["Type"] = "Marine"
avg_marine <- mean(marine_pro_count$Freq)

dbscan_soil_pro_count <- data.frame(table(dbscan_soil$bacterial_species))
soil_pro_count["Type"] = "Soil"
dbscan_avg_soil <- mean(soil_pro_count$Freq)

dbscan_marine_pro_count <- data.frame(table(dbscan_marine$bacterial_species))
marine_pro_count["Type"] = "Marine"
dbscan_avg_marine <- mean(marine_pro_count$Freq)


### PLOTS FOR SOILL AND MARINE ONLY ###
par(mfrow=c(1,2))
boxplot(soil_pro_count$Freq, data = soil_pro_count,
        main = "Average Soil Prophage Abundance",
        ylab = "prophage")
boxplot(marine_pro_count$Freq, main = "Average Marine Prophage Abundance",
        ylab = "prophage")
mtext("Comparison of soil and marine prophages for Phispy",side=3,line=-1,outer=TRUE)

#Basic boxplot, good for starters
par(mfrow=c(1,2))
boxplot(soil_pro_count$Freq, data = soil_pro_count,
        main = "Average Soil Prophage Abundance",
        ylab = "prophage")
boxplot(marine_pro_count$Freq, main = "Average Marine Prophage Abundance",
        ylab = "prophage")
mtext("Comparison of soil and marine prophages for PhiSpy",side=3,line=-1,outer=TRUE)

#Fancy plot

#Had to combine both counts tables in order to  make a ggboxplot
soilnmarine_combined <- rbind(soil_pro_count, marine_pro_count)
ggboxplot(soilnmarine_combined, x = "Type", y = "Freq",
          main = "Average prophage abundance with PhiSpy",
          ylim = c(0,18),
          xlab = "Environment type",
          ylab = "Prophage",
          color = "Type", 
          palette = c("forestgreen", "deepskyblue3"))

dbscan_soilnmarine_combined <- rbind(dbscan_soil, dbscan_marine)
ggboxplot(dbscan_soilnmarine_combined, x = "prophage_count", y = "Type",
          main = "Average prophage abundance with DBSCAN-SWA",
          ylim = c(0,18),
          xlab = "Environment type",
          ylab = "Prophage",
          color = "Type", 
          palette = c("forestgreen", "deepskyblue3"))

#Just-messing-around plot, didnt use this data for a graph
par(mfrow=c(1,2))
hist(soil_pro_count$Freq, main = "Soil Prophage Abundance",
     ylab = "prophage")
hist(marine_pro_count$Freq, main = "Marine Prophage Abundance",
     ylab = "prophage")
means <- table(soil_pro_count$Freq, marine_pro_count$Freq)
barplot(means)



### WILCOXON TEST FOR SOIL AND MARINE ###

v_soil_counts <- as.vector(soil_pro_count)
v_marine_counts <- as.vector(marine_pro_count)
results <- wilcoxon.test(v_soil_counts$Freq, v_marine_counts$Freq)
print(results)





### DBSCAN SOIL DATA ###
phaster_soil <- read.delim("phaster_soil_prophage_data.csv", header = FALSE, sep = ",")
colnames(phaster_soil) <- c("bacterial_species", "prophage_num", 
                            "prophage_start", "prophage_end")

#Creating counts files to use for graphs
phaster_soil_count <- data.frame(table(phaster_soil$bacterial_species))
avg_phaster_soil <- mean(phaster_soil_count$Freq)

### PLOT FOR SOIL  ###

boxplot(phaster_soil_count$Freq, data = phaster_soil_count,
        main = "Average Soil Prophage Abundance",
        ylab = "prophage")




### PHISPY GUT DATA ###

#Read in the gut prophage data from my downloads
gut_pro <- read.delim("gut_prophage_data.tsv", header = FALSE, sep = " ")
colnames(gut_pro) <- c("bacterial_species", "prophage_num", 
                       "prophage_start", "prophage_end")

#Creating counts files to use for graphs
gut_pro_count <- data.frame(table(gut_pro$bacterial_species))
gut_pro_count["Type"] = "Gut Microbiome"
avg_gut <- mean(gut_pro_count$Freq)

### PLOT FOR GUT ###

#Basic Boxplot
boxplot(gut_pro_count$Freq,
        main = "Prophage Abundance in Human Gut Microbiome",
        ylab = "Prophage")

### FANCY PLOT FOR ALL 3 ENVIRONMENTS ###

all_env_df <- rbind(soilnmarine_combined, gut_pro_count)
smg_plot <- ggboxplot(all_env_df, x = "Type", y = "Freq",
                      main = "Average Prophage Abundance with PhiSpy Across 3 Environments",
                      ylim = c(0,60),
                      xlab = "Environment type",
                      ylab = "Prophage",
                      color = "Type", 
                      palette = c("forestgreen", "deepskyblue3", "gold1"))
#Add the p-value to the graph by conducting a wilcoxon test
smg_plot + stat_compare_means(method = "wilcox.test")



### WILCOXON TEST ###
#this wasn't necessary since I got a p-val on the graph above...this is just helpful to know how you do the test and to see if all the p-vals are actually the same

#Soil & Marine
v_soil_counts <- as.vector(soil_pro_count)
v_marine_counts <- as.vector(marine_pro_count)
sm_results <- wilcox.test(v_soil_counts$Freq, v_marine_counts$Freq)
print(sm_results)

#Soil & Gut
v_gut_counts <- as.vector(gut_pro_count)
sg_results <- wilcox.test(v_soil_counts$Freq, v_gut_counts$Freq)
print(sg_results)

#Marine & Gut
mg_results <- wilcox.test(v_marine_counts$Freq, v_gut_counts$Freq)
print(mg_results)


### SUMMARY TABLE OF COUNTS FOR ALL ENVIRONMENTS ###
install.packages("formattable")
library(formattable)

all_counts <- data.frame(table(all_env_df$Type))
colnames(all_counts) <- c("Environment", "Genomes")
formattable(all_counts,
            align = c("l", "c"),
            #This was just to change up the style of the text, like color and if it's bolded or not
            list(`Environment` = formatter("span", style = ~ style(color = "grey", font.weight = "bold"))))


