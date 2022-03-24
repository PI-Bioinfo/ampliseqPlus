#!/usr/bin/env Rscript

args = commandArgs(trailingOnly=TRUE)

if(length(args) < 2){
  stop("Usage: lefse_prepare_input.r <relASVTable.tsv> <Metadata.tsv>")
}

rel.table <- args[1]
meta.table <- args[2]

OUT="lefse_ready_table.tsv"

#read in relative asv table

tab <-read.table(file = rel.table, sep = '\t', header = FALSE, comment.char = "", skip = 1)

#get column order of ASV table
col_order <- unlist(unname(tab[1,-1]))

#read in metadata file

meta <-read.table(file = meta.table, sep = '\t', header = FALSE)
meta.t <- as.data.frame(t(meta))[c(2,1),]
colnames(meta.t) <- meta.t[2,]
name <- colnames(meta.t)[1]

#re-order metadata columns as in ASV table order
meta.t <- meta.t[,c(name,col_order)]
colnames(meta.t) <- names(tab)

#combine metadata and ASV table 
tab.tsv <- rbind(meta.t[1,],tab)

#convert ";" into "|" and remove "|" at the end of taxonomy names

df <- unname(data.frame(sapply(tab.tsv, gsub, pattern = ";", replacement= "|")))
col1 <- strsplit(as.character(df[,1]),split='|',fixed=TRUE)
col1.na_rm <- lapply(col1, function(z){ z[!is.na(z) & z != ""]})
col1.new <- lapply(col1.na_rm, paste, collapse = "|") 
col1.df <- unname(data.frame(matrix(unlist(col1.new), nrow=length(col1.new), byrow=TRUE),stringsAsFactors=FALSE))

df[,1] <- col1.df

#write
print (paste("write",OUT))
write.table(df, file = OUT, row.names=FALSE, sep="\t", quote = FALSE)
