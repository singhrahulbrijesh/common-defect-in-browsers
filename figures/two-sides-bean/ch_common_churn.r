{\rtf1\ansi\ansicpg1252\cocoartf2709
\cocoatextscaling0\cocoaplatform0{\fonttbl\f0\fmodern\fcharset0 Courier;}
{\colortbl;\red255\green255\blue255;\red0\green0\blue0;}
{\*\expandedcolortbl;;\cssrgb\c0\c0\c0;}
\margl1440\margr1440\vieww11520\viewh8400\viewkind0
\deftab720
\pard\pardeftab720\partightenfactor0

\f0\fs26 \cf0 \expnd0\expndtw0\kerning0
d <- read.csv("~/Documents/Research/CommonDefects/common-defect-in-browsers/figures/two-side-beans/ch_fx_component_churn2.csv", header = TRUE, sep = ",", quote = "\\"", dec = ".", fill = TRUE, comment.char = "")\
\
# Sort by churn desc\
d <- d[order(-d$Churn),]\
\
p <- ggplot(data=d, aes(x=Churn, y=Component, fill=Browser)) + geom_bar(stat="identity", color="black", position=position_dodge()) + theme_minimal()\
\
# Use custom colors\
p + scale_fill_manual(values=c('#999999','#E69F00'))\
# Use brewer color palettes\
p + scale_fill_brewer(palette="Blues")}