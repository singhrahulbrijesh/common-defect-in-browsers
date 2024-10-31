d <- read.csv("/home/taj/Documents/CommonDefects/component-bugs-ch-fx-common.csv", header=TRUE, sep=",", quote = "\"", dec = ".", fill = TRUE)


p <- ggplot(d, aes(x=Browser, y=Bugs)) + geom_violin(scale="width", fill="lightblue") + geom_boxplot(width=0.1, fill="white", color="Black") + theme(text=element_text(size = 20)) + labs(x="", y="Bugs (log scale)") + ggtitle("") + scale_y_log10()
