shinyServer(function(input, output, session) {  
  fullData <- reactive({ # The full selected dataset
    dataName <- input$selectedDataset
    # Prevent errors from occuring when no dataset is selected
    if(!is.character(dataName)) { dataName <- "Kepler Exoplanets"}
    datasets[[grep(dataName, datasets[,1]), doubles]]  
  })
  selectedData <- reactive({  # The selected variables of the full dataset
    selectedX <- input$xcol
    selectedY <- input$ycol
    # Prevent errors from occuring when changing datasets
    if(!(selectedX %in% names(fullData()))) { selectedX = 1 }
    if(!(selectedY %in% names(fullData()))) { selectedY = 2 }
    fullData()[, c(selectedX, selectedY)]  
  })
  clusters <- reactive({  kmeans(selectedData(), input$clusters)  })
  
  output$selectData <- renderUI({
    selectInput('selectedDataset', 'Dataset', datasets[,1], selected=datasets[startingDataset,1])
  })
  output$selectX <- renderUI({
    selectInput('xcol', 'X Variable', names(fullData()), selected=names(fullData())[[1]])
  })
  output$selectY <- renderUI({
    selectInput('ycol', 'Y Variable', names(fullData()), selected=names(fullData())[[2]])
  })
  output$numClusters <- renderUI({  numericInput('clusters', '# of Clusters', 5)  })
  
  output$chartTitle <- renderText({ paste(input$selectedDataset, " k-means Clustering") })
  output$numPoints <- renderText({ paste("Number of data points: ", nrow(fullData())) })
  output$numVars <- renderText({ paste("Number of variables: ", ncol(fullData())) })
  output$summary <- renderPrint({ summary(fullData()) })
  output$summaryLM <- renderPrint({ 
    x <- selectedData()[,1]
    y <- selectedData()[,2]
    summary(lm(y ~ x)) 
  })
  output$summaryKM <- renderPrint({ kmeans(selectedData(), input$clusters) })
  
  output$table <- renderTable({ fullData() })

  output$plot1 <- renderPlot({
    # Prevent errors from occuring when user input is empty
    if(is.null(input$ycol) | is.null(input$xcol) | is.null(input$selectedDataset) | !is.numeric(input$clusters))
      return()

    par(mar = c(5.1, 4.1, 0, 1))
    plot(selectedData(),
         col = clusters()$cluster,
         pch = 20, cex = 3)
    points(clusters()$centers, pch = 4, cex = 4, lwd = 4)
    fit <- lm(selectedData()[,2] ~ selectedData()[,1])
    abline(fit, lwd=2)
  })
  
})