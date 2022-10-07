library(ggseqlogo)
library(ggplot2)
library(grid)
library(viridis)

alphabetletters <- list(
  "seq-4" = c("A", "C", "G", "U"),
  "struct-2" = c("U", "P"),
  "struct-4" = c("P", "L", "U", "M"),
  "struct-7" = c("B", "E", "H", "L", "M", "R", "T"),
  "seq-struct-8" = LETTERS[1:8],
  "seq-struct-16" = LETTERS[1:16],
  "seq-struct-28" = c(LETTERS, letters[1:2])
)

seq_struct_2_struct <- list(
  "seq-struct-8" = "struct-2",
  "seq-struct-16" = "struct-4",
  "seq-struct-28" = "struct-7"
)

colorschemes <- list(
  "seq-4" = make_col_scheme(chars = c("A", "C", "G", "U"), 
                            cols=c("#00CC00", "#0000CC", "#FFB302", "#CC0001"), 
                            name="RNAseq"),
  "struct-2" = make_col_scheme(chars = c("U", "P"), 
                               cols=c("#000000", "#ff006b"), 
                               name="RNAstruct-2"),
  "struct-4" = make_col_scheme(chars = c("P", "L", "U", "M"), 
                               cols=c("#ff006b", "#008060", "#000000", "#01C8CA"), 
                               name="RNAstruct-4"),
  "struct-7" = make_col_scheme(chars = c("B", "E", "H", "L", "M", "R", "T"), 
                               #cols=c("#000000", "#CC0001", "#00CC00", "#CC00CC", "#01C8CA", "#FFB302", "#0000CC"), 
                               cols=c("#e67300", "#000000", "#008060", "#bb00cc", "#01C8CA", "#ff006b", "#6b00ff"), 
                               name="RNAstruct-7")
)

split_seq_struct_pfm <- function(pfm, alphabet) {
  struct.alphabet <- seq_struct_2_struct[[alphabet]]
  struct.alph <- alphabetletters[[struct.alphabet]]
  struct.alph.len <- length(struct.alph)
  seqpfm <- matrix(0, nrow=4, ncol=ncol(pfm))
  for (i in 1:4) {
    for (j in 1:ncol(pfm)) {
      seqpfm[i, j] <- sum(pfm[(((i-1)*struct.alph.len)+1):(i*struct.alph.len), j])
    }
  }
  row.names(seqpfm) <- c("A", "C", "G", "U")
  
  structpfm <- matrix(0, nrow=struct.alph.len, ncol=ncol(pfm)) 
  for (i in 1:struct.alph.len) {
    modulo <- i %% struct.alph.len
    for (j in 1:ncol(pfm)) {
      structpfm[i, j] <- sum(pfm[which((1:nrow(pfm) %% struct.alph.len) == modulo), j])
    }
  }
  row.names(structpfm) <- struct.alph
  return(list(seqpfm, structpfm))
}

pfm_2_logo <- function(pfm, alphabet, meth) {
  if (meth == "probability") {maxy = 1} else {maxy = -log2(1/nrow(pfm))}
  colscheme <- colorschemes[[alphabet]]
  plot <- ggplot() + 
    geom_logo(pfm, 
              namespace = colscheme$letter, 
              col_scheme = colscheme, 
              font="roboto_bold",
              method=meth) + 
    theme_logo() +
    ylim(c(0, maxy)) + 
    theme(axis.text.y = element_blank(),
          axis.text.x = element_blank(),
          axis.title = element_blank(), panel.border = element_blank(),
          plot.background = element_blank(),
          plot.margin = margin(-0.01,0,-0.01,0, unit = "in"))
  return(plot)
}

# Read in path to PRIESSTESS output directory and a name for the output figure
args = commandArgs(TRUE)
directory = args[1]
outfile = args[2]

# Add final slash to directory path if not present
if (substr(directory, nchar(directory), nchar(directory)) != '/') {
  directory <- paste0(directory, "/")
}

# Read in model weights
weights <- read.table(paste0(directory, "PRIESSTESS_model_weights.tab"), sep="\t",
                      stringsAsFactors = FALSE, header=FALSE)
colnames(weights) <- c("feature", "weight")

# Split alphabet and PFM numbers
weights$alphabet <- unlist(lapply(weights$feature, function(X) strsplit(X, "_")[[1]][1]))
weights$PFM <- unlist(lapply(weights$feature, function(X) strsplit(X, "_")[[1]][2]))

# Generate file names for PFMs
weights$filename <- paste0(directory, paste(weights$alphabet, weights$PFM, sep="/"), ".txt")

# Calculate proportion of total weight for all motifs/features
weights$prop <- abs(weights$weight)/sum(abs(weights$weight))

# Order features by weight and remove features with zero weights
weights_ordered <- weights[order(weights$prop, decreasing = TRUE), ]
weights_ordered <- weights_ordered[which(weights_ordered$prop > 0), ]
  
# Prepare information for plot
meth = "bits"
nummotifs <- min(nrow(weights_ordered), 10)
colours = mako(100)[100:20]

# Generate plots (sequence and/or structure motif logos + proportion)
allplots <- list()
  
for (i in 1:nummotifs) {
  alphabet <- weights_ordered$alphabet[i]
  prop <- weights_ordered$prop[i]
  pfmfile <- read.table(weights_ordered$filename[i], sep = "\t", stringsAsFactors = FALSE)
  pfmfile <- as.data.frame(pfmfile[, 2:ncol(pfmfile)], row.names=pfmfile[, 1])
  defaultW <- getOption("warn") 
  options(warn = -1) 
  if (grepl("seq-struct", alphabet)) {
    pfms <- split_seq_struct_pfm(as.matrix(pfmfile), alphabet)
    logo1 <- pfm_2_logo(pfms[[1]], "seq-4", meth)
    logo2 <- pfm_2_logo(pfms[[2]], seq_struct_2_struct[[alphabet]], meth)
  } else if ("seq-4" == alphabet) {
    logo1 <- pfm_2_logo(as.matrix(pfmfile), alphabet, meth)
    logo2 <- ggplot() + theme_bw() + theme(rect = element_blank())
  } else if (grepl("^struct-", alphabet)) {
    logo2 <- pfm_2_logo(as.matrix(pfmfile), alphabet, meth)
    logo1 <- ggplot() + theme_bw() + theme(rect = element_blank())
  }
  options(warn = defaultW)
  colourbar <- ggplot() + theme(panel.background = element_rect(fill = colours[round(prop*80) + 1],
                                                                colour = colours[round(prop*80) + 1]),
                                plot.background = element_blank(),
                                plot.margin = margin(0,2,0,2))
  allplots[[(length(allplots)+ 1)]] <- logo1
  allplots[[(length(allplots)+ 1)]] <- logo2
  allplots[[(length(allplots)+ 1)]] <- colourbar
}
  
while (length(allplots) < 30) {
  allplots[[(length(allplots) + 1)]] <- ggplot() + theme_bw() + theme(rect = element_blank())
}

pdf(paste0(outfile, ".pdf"), width=8, height = 1.5)
grid.newpage()
pushViewport(viewport(layout = grid.layout(3, 10, heights=c(0.42, 0.42, 0.16))))
vplayout <- function(x, y) viewport(layout.pos.row = x, layout.pos.col = y)
print(allplots[[1]], vp = vplayout(1, 1))
print(allplots[[2]], vp = vplayout(2, 1))
print(allplots[[3]], vp = vplayout(3, 1))
print(allplots[[4]], vp = vplayout(1, 2))
print(allplots[[5]], vp = vplayout(2, 2))
print(allplots[[6]], vp = vplayout(3, 2))
print(allplots[[7]], vp = vplayout(1, 3))
print(allplots[[8]], vp = vplayout(2, 3))
print(allplots[[9]], vp = vplayout(3, 3))
print(allplots[[10]], vp = vplayout(1, 4))
print(allplots[[11]], vp = vplayout(2, 4))
print(allplots[[12]], vp = vplayout(3, 4))
print(allplots[[13]], vp = vplayout(1, 5))
print(allplots[[14]], vp = vplayout(2, 5))
print(allplots[[15]], vp = vplayout(3, 5))
print(allplots[[16]], vp = vplayout(1, 6))
print(allplots[[17]], vp = vplayout(2, 6))
print(allplots[[18]], vp = vplayout(3, 6))
print(allplots[[19]], vp = vplayout(1, 7))
print(allplots[[20]], vp = vplayout(2, 7))
print(allplots[[21]], vp = vplayout(3, 7))
print(allplots[[22]], vp = vplayout(1, 8))
print(allplots[[23]], vp = vplayout(2, 8))
print(allplots[[24]], vp = vplayout(3, 8))
print(allplots[[25]], vp = vplayout(1, 9))
print(allplots[[26]], vp = vplayout(2, 9))
print(allplots[[27]], vp = vplayout(3, 9))
print(allplots[[28]], vp = vplayout(1, 10))
print(allplots[[29]], vp = vplayout(2, 10))
print(allplots[[30]], vp = vplayout(3, 10))
dev.off()
