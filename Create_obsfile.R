library(tidyverse)
library(reshape2)

# Set the directory where your files are located
directory_path <- "LEV_BSP"

# Get a list of all files that start with 'LEV_BSP' and end with '.txt' (or any other specific extension)
file_list <- list.files(path = directory_path, pattern = "^LEV_BSP_chr[A-Z]+\\.winsfs\\.ddsfs$", full.names = TRUE)

# Read the first matrix to initialize the sum
sum_matrix <- read.table(file_list[1])

# Loop through the rest of the files and add each matrix to the sum_matrix
for (i in 2:length(file_list)) {
  temp_matrix <- read.table(file_list[i])
  sum_matrix <- sum_matrix + temp_matrix
}

ddsfs = unlist(sum_matrix)
num_columns <- floor(sqrt(length(ddsfs)))
ddsfs_matrix = matrix(round(ddsfs), ncol = num_columns, byrow = TRUE)

fddsfs = matrix(NA, nrow = num_columns, ncol = num_columns)
for(i in 1:num_columns){
  for(j in 1:((num_columns+1)-i)){
    fddsfs[i,j] = ddsfs_matrix[i,j] + ddsfs_matrix[(num_columns+1)-j, (num_columns+1)-i] 
  }
}

fddsfs[is.na(fddsfs)] = 0

colnames(fddsfs) = paste0("d0_", seq(0, nrow(fddsfs)-1))
rownames(fddsfs) = paste0("d1_", seq(0, nrow(fddsfs)-1))


ddm = melt(fddsfs)
ggplot(ddm[ddm$value < 2e8,], aes(x = Var1, y = Var2, fill = log10(value))) + geom_tile()


write.table(fddsfs, file = "LEV_BSP/LEV_BSP_jointMAFpop1_0.obs",
            quote = F, row.names = T, col.names = T, sep = "\t")
