# Map Plot Function

make_map <- function(data,
                     fill) {
  geom_polygon_interactive(data = data,
  aes_string(group = "group", fill = fill), # need to figure out data + fill
  color = "black", size = 0.3
) +
  coord_map(
    projection = "mercator",
    xlim = c(-180, 180)
  ) +
  scale_fill_viridis_c(
    option = "inferno",
    name = "Death rate",
    labels = label_number(big.mark = ","),
    na.value = "lightgray"
  ) +
  theme_void() +
  theme(
    text = element_text(color = "black"),
    legend.direction = "vertical",
    legend.position = "left",
    legend.key.height = unit(2, "cm"),
    plot.background = element_rect(fill = "white", color = "white"),
    plot.title = element_blank(),
    plot.subtitle = element_blank()
  )
}

