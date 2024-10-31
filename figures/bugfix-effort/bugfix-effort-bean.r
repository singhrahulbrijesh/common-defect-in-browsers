d <- read.csv("bugfix-effort-ch-fx.csv", header=TRUE, sep=",", quote = "\"", dec = ".", fill = TRUE)

#p <- ggplot(data = d, aes(x="", y=t_churn)) + geom_violin(scale="width", fill="lightblue") + geom_boxplot(width=0.1, fill="white", color="black", outlier.shape=NA) + theme_minimal() + labs(x="Budfix Churns", y="") + ggtitle("") + scale_y_log10()

p <- ggplot(d, aes(x=Browser, y=t_churn)) + geom_violin(scale="width", fill="lightblue") + geom_boxplot(width=0.1, fill="white", color="Black") + theme(text=element_text(size=20)) + labs(x="", y="Churns or Effort (log scale)") + ggtitle("") + scale_y_log10()
