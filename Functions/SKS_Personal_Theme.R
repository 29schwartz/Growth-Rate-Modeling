#Thematic Elements
Theme = theme_bw()+
  theme(panel.grid.major = element_line(),
        panel.grid.minor = element_line(),
        #legend.box.background = element_rect(color="black", linewidth =1.00),
        legend.margin = margin(6, 6, 6, 6),
        #legend.position = c(.9,.9),
        plot.title = element_text(size=22, face = "bold"),
        legend.direction = 'horizontal',
        legend.position = 'bottom',
        legend.title = element_text(size = 16),
        legend.text = element_text(size = 14),
        axis.text.x = element_text(size = 14),
        axis.text.y = element_text(size = 14),
        axis.title.x = element_text(size = 18),
        axis.title.y = element_text(size = 18),
        panel.spacing.x = unit(4, "mm"),
        strip.text.x = element_text(size = 14, color = "#18191A", face = "bold"))