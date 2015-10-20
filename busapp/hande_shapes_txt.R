library(stringr)

shapes <- read.csv("shapes.txt")
out_bound <- str_detect(shapes$shape_id, "OB")
in_bound <- str_detect(shapes$shape_id, "IB")

shapes$route <- str_split_fixed(shapes$shape_id, pattern = "_", n = 3)[,1]

out_bound <- shapes[out_bound,]
in_bound <- shapes[in_bound,]

out_bound$route <- as.numeric(gsub("[^0-9]", "", out_bound$route))
in_bound$route <- as.numeric(gsub("[^0-9]", "", in_bound$route))

save(in_bound, out_bound, file = "route_lines.rda") 