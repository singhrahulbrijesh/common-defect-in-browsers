library(ggplot2)
p <- ggplot(data = NULL, aes(x = "", y = dCompCh$churn)) +
     geom_violin(scale = "width", fill = "lightblue") +
     geom_boxplot(width = 0.1, fill = "white", color = "black", outlier.shape = NA) +
     theme_minimal() +
     labs(x = "Churn", y = "") +
     ggtitle("")
p <- p + geom_text(aes(label = ifelse(dCompCh$churn == max(dCompCh$churn), as.character("app"), "")), vjust = 0.5, nudge_x = 0.10)
p <- p + geom_text(aes(label = ifelse(dCompCh$churn == 14217829, as.character("net"), "")), vjust = 0.5, nudge_x = 0.10)
p <- p + geom_text(aes(label = ifelse(dCompCh$churn == 10883927, as.character("tools"), "")), vjust = 0.5, nudge_x = 0.10)
#p <- p + geom_text(aes(label = ifelse(dCompCh$churn == 10342872, as.character("library"), "")), vjust = 0.5, nudge_x = 0.10)
#p <- p + geom_text(aes(label = ifelse(dCompCh$churn == 9634995, as.character("data"), "")), vjust = 0.5, nudge_x = 0.10)
#p <- p + geom_text(aes(label = ifelse(dCompCh$churn == 8567968, as.character("base"), "")), vjust = 0.5, nudge_x = 0.10)
#p <- p + geom_text(aes(label = ifelse(dCompCh$churn == 6754208, as.character("layout"), "")), vjust = 0.5, nudge_x = 0.10)
