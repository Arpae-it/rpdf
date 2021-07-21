library(shiny)
library(DT)
library(shinydashboard)
library(shinyjs)
library(pdftools)
library(tabulizer)
httr::set_config(httr::config(ssl_verifypeer=0L))
setwd("www")
download.file("https://www.w3.org/WAI/WCAG20/Techniques/working-examples/PDF20/table.pdf","1.pdf",overwrite=TRUE)
# Define UI for data download app ----

ui=dashboardPage(
  dashboardHeader(title = 'Rpdf',
                  tags$li(a(href = 'http://www.arpae.it',
                            icon("power-off"),
                            title = "Torna ad Arpae"),
                          class = "dropdown")),
  dashboardSidebar(width=300,
                   useShinyjs(),
                   
               textInput("db","Copia e incolla l'indirizzo del pdf online"),
               fileInput('file1', 'Oppure carica un pdf',
                         accept=('pdf')),
               textInput("tabella","Scegli la tabella da estrarre",value="1")
            

    ),

    # Main panel for displaying outputs ----
  dashboardBody(
    fluidRow(


      htmlOutput("pdfo",height=800),
    tableOutput("pdfinfo")

     # textOutput("scelta")
      #leafletOutput("gvis",height=300))


    )

  ))


# Define server logic to display and download selected file ----


server <- function(input, output,session) {

  

  output$pdfo<-renderUI({
    print(input$db)
    if (!is.null(input$file1)){
     
      infile<-input$file1
      print (infile$datapath)
      file.copy(infile$datapath,"1.pdf",overwrite = TRUE)
     }
    if (input$db!=""){
      infile<-input$db
    try(  download.file(input$db,"1.pdf",overwrite = TRUE))}
    tags$iframe(src="1.pdf",style="height:600px;width:100%;scrolling=yes")})


  output$pdfinfo<-renderTable({
   
    pdf<-extract_tables("1.pdf",method="decide")

pdf[as.numeric(input$tabella)]

  })



}

# Create Shiny app ----
shinyApp(ui, server)
