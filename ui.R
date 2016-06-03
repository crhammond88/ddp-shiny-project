shinyUI(navbarPage("Linear Exploration",
      tabPanel("Explore",
        titlePanel(textOutput("chartTitle")),
        fluidRow(
          column(3,
                 wellPanel(
                   uiOutput("selectData"),
                   span(textOutput("numPoints"), textOutput("numVars"))
                   
                 ),
                 wellPanel(
                   uiOutput("selectX"),
                   uiOutput("selectY"),
                   uiOutput("numClusters")
                 )
          ),
          column(9,
                 tabsetPanel( 
                   tabPanel(p(icon("line-chart"),"Plot"), plotOutput("plot1")),
                   tabPanel(p(icon("book"),"Summary"), 
                            wellPanel(verbatimTextOutput("summary"), 
                                      verbatimTextOutput("summaryLM"),
                                      verbatimTextOutput("summaryKM"))
                   ),
                   tabPanel(p(icon("table"), "Data"), tableOutput("table"))
                 )
          )
        )
      ),
      tabPanel("About", 
               mainPanel(
                 includeMarkdown("about.md")
               )
      )
))
