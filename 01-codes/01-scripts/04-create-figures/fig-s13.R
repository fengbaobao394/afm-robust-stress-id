#===============================================================================
# Name: fig-s13
# By: Brandon Sloan
# Last Updated: 3/18/23
#
# Description: This script creates Figure S13 from Sloan and Feng (2023)
#===============================================================================

# Load libraries and add datasets
gc(reset = TRUE)
rm(list = ls())
source("./01-codes/02-functions/04-robustness/robustness-helper-fxns.R")
loadPacks("miceadds","egg")
svpath <- "./03-outputs/03-figures/"

# Load the original and new robustness categories
RC.7 <-
  load.Rdata2(filename = "./03-outputs/02-robust-framework/02-robust-summary/AFM_RC_0_7.RData")
RC.6 <-
  load.Rdata2(filename = "./03-outputs/02-robust-framework/02-robust-summary/AFM_RC_0_6.RData")
RC.8 <-
  load.Rdata2(filename = "./03-outputs/02-robust-framework/02-robust-summary/AFM_RC_0_8.RData")
RC.7$runID <- as.factor("70%")
RC.6$runID <- as.factor("60%")
RC.8$runID <- as.factor("80%")
RC <- rbind(RC.6,RC.7,RC.8)

comp <- RC %>% group_by(runID,RbStrID) %>% summarize(n = n())

# Update factors
RC.plt <-
  RC %>% mutate(
    StrID = fct_relevel(
      fct_recode(
        StrID,
        Dry = "Dry Stress",
        Wet = "Wet Stress",
        Negligible = "No Stress",
        Unsure = "Unsure"
      ),
      "Dry",
      "Wet",
      "Negligible",
      "Unsure"
    ),
    RbrunID = interaction(StrID, runID,lex.order = TRUE),
    RbID = fct_relevel(
      fct_recode(
        RbID,
        'Slope + Performance' = "Both",
        Slope = "Slp",
        Performance = "Prf",
        "Not Robust" = ""
      ),
      "Not Robust",
      after = Inf
    ))

# Axis properties
fs <- 8
#ft <- c("CMU Classical Serif")
lw.ax <- 0.25

# Jitter point properties
stk = 0.05
mrk = 20
sz = 0.5

# Boxplot properties
lw = 0.1
ft = 1

# Colors for slope categories
bc2 <- scale_fill_manual(
  name = "Stress Class",
  labels = c('Dry', 'Wet', "Both", "Negligible", "Unsure"),
  values = c("#e41a1c", "#377eb8", "#984ea3", "#deebf7", "white"),
  drop = FALSE
)

# Figure 2a: Show count of stress response by plant variable
g2a <-
  ggplot(RC.plt, aes(x = RbrunID,
                 linestyle = runID, fill = StrID, alpha = RbID)) + 
  geom_bar(color = "black", position = position_stack(), lwd = lw) + 
  scale_alpha_manual(name = "Robust Class",values = c(1,0.7,0.4,0.1)) +
  scale_fill_manual(
    name = "Stress Class",
    values = c("#d7191c", "#2c7bb6", "#ffffbf", "white"),
    drop = FALSE
  ) +
  scale_y_continuous(breaks = c(0,40,80))+
  labs(x = "Matching Stress Response", y = "No. of Sites") +
  theme_cowplot(fs, line_size = lw.ax) +
  theme(legend.position = c(0.8,0.7),axis.title.x = element_blank(),
        axis.text.x = element_text(angle = 30, vjust = 1, hjust=1))
plot(g2a)

ggsave2(
  paste0(svpath,"fig-s13.pdf"),
  plot = g2a,
  width = 6,
  height = 4,
  units = "in"
)


# Extra figure showing the stress class counts not included in the supplement
g2b <- RC.plt %>%
  ggplot(aes(
    x = RbID,
    linestyle = runID,
    fill = runID
  )) +
  geom_bar(
    color = "black",
    position = position_dodge2(preserve = "single"),
    lwd = lw
  ) +
  geom_text(stat='count', aes(label=..count..), vjust=-1,
            position = position_dodge2(width=0.9),
            size = (fs-1)*5/14) +
  scale_x_discrete(labels = c("Slope + Performance" = "Slope +\n Performance")) +
  scale_y_continuous(limits = c(0, 45), breaks = c(0, 20, 40)) +
  labs(x = "Matching Stress Response", y = "No. of Sites") +
  facet_wrap( ~ StrID, dir = "v") +
  theme_cowplot(fs, line_size = lw.ax) 
plot(g2b)
g2b <- tag_facet(g2b, open = "", size = fs/2.75) +
  theme_cowplot(font_size = fs, line_size = lw) +
  theme(
    legend.position = "top",
    legend.justification = "center",
    axis.title.x = element_blank()
  )
# Combine Figure 2
# ggsave2(
#   paste0(svpath,"extra-fig.pdf"),
#   plot = g2b,
#   width = 3,
#   height = 4,
#   units = "in"
# )
