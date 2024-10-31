d <- read.csv("/home/taj/Documents/CommonDefects/common-defect-in-browsers/figures/component-bugs/component-bugs-ch-fx-common-barchart.csv", header=TRUE, sep=",", quote = "\"", dec = ".", fill = TRUE)

p <- ggplot(data=d, aes(x=Component, y=Bugs, fill=Browser)) + geom_bar(stat="identity", color="black", position=position_dodge()) + scale_fill_manual(values=c('#999999','#E69F00')) + theme(axis.text.x=element_text(angle=90, hjust=1, vjust=0.5))
