library(dplyr)
library(tidyr)
library(mclust)
library(ggplot2)
load("voting_results.rda")


a <- voting_results %>%
    filter( Race %in% c("UNITED STATES SENATOR", "GOVERNOR/LT GOVERNOR", "US REPRESENTATIVE")) %>%
    filter(! Value %in% "Registered Voters") %>%
    group_by(DISTRICT, Race) %>%
    mutate(Result = n/sum(n)) %>%
    filter(Value == "Sullivan, Dan" | Value == "Walker/Mallott" | Value == "Young, Don") %>%
    select(DISTRICT, Race, Result) %>%
    unique() %>%
    as.data.frame() %>%
    spread(Race, Result)

b <- voting_results %>%
    filter( Race %in% c("MOA Proposition #1", "Ballot Measure 2 - 13PSUM", "Ballot Measure 3 - 13MINW", "Ballot Measure 4 - 12BBAY")) %>%
    filter(! Value %in% "Registered Voters") %>%
    group_by(DISTRICT, Race) %>%
    mutate(Result = n/sum(n)) %>%
    filter(Value == "YES") %>%
    select(DISTRICT, Race, Result) %>%
    unique() %>%
    as.data.frame() %>%
    spread(Race, Result)

Prop_Results <- cbind(a,b[,2:5])
rownames(Prop_Results) <- Prop_Results$DISTRICT 
Prop_Results<- select(Prop_Results, -DISTRICT)  %>%
    as.matrix() 


input <- list(clusters = 3, races = "MOA Proposition #1", bindwidth = 0.4, model = "EEV", checkGroup = c(1,2,3,4))
shinyServer(function(input, output, session) {

ggobjFUNCTION <- reactive({

#Prop_Results <- Prop_Results[,input$checkGroup]


princomp_obj <- princomp(Prop_Results)
pca <- princomp_obj$scores

fit <- Mclust(pca, G= input$clusters, modelNames = input$model)
#plot3d(pca[,1:3], col = fit$classification, size = 10)

ggobj <- data.frame(District = rownames(pca), pca, classification = fit$classification) %>%
    as.data.frame()
rownames(ggobj) <- NULL    
ggobj$District <- substr(ggobj$District, 8, 50)



p1 <- ggplot(data = ggobj, aes(x = Comp.1, y = Comp.2, color = factor(classification))) + 
     geom_text(aes(label = District, vjust = -.30, size = 1.5)) + geom_point() + theme(legend.position="none")


p2 <- ggplot(data = ggobj, aes(x = Comp.1, fill = factor(classification))) + geom_histogram(stat = "bin", binwidth = input$bin_width) +
    theme(legend.position="none")

list(p1 = p1, p2 = p2, princomp1 = princomp_obj)
})

output$textscatter <- renderPlot({
    print(ggobjFUNCTION()$p1)
    })

output$histogram <- renderPlot({
  print(ggobjFUNCTION()$p2)
})
#biplot(princomp_obj)
# p <- ggpairs(data = ggobj[,2:5])

#mega_ggobj <- makePairs(ggobj[,2:5])
#mega_ggobj <- data.frame(mega_ggobj$all, 
#                         District = rep(ggobj$District, length = nrow(mega_ggobj$all)), 
#                         classification = rep(fit$classification, length = nrow(mega_ggobj$all)))

#ggplot(data = mega_ggobj, aes_string(x = "x", y = "y")) +
#    facet_grid(xvar ~ yvar, scales = "free") + #geom_point(aes(color = factor(classification))) +
#    geom_text(data = mega_ggobj, aes(label = mega_ggobj$District, color = factor(classification), size = 2))
})





    