crAddins <- function() {
  ui <- miniPage(
    gadgetTitleBar("Add Crossref Citations"),
    miniContentPanel(
      h4("Add a new bibliography entry through Crossref DOI", 
         class="text-center", style="padding-bottom: 15px;"),
      fillRow(flex = c(7, 3), height = "45px",
              uiOutput("cr_input"), uiOutput("add_to_my_citations")),
      htmlOutput("preview")
    )
  )
  
  server <- function(input, output, session) {
    output$cr_input <- renderUI({
      textInput("entered_dois", label = NULL, 
                placeholder = "Enter a DOI to get started", width = "98%")
    })
    
    output$add_to_my_citations <- renderUI({
      actionButton("add_citations", label = "Add to My Citations",
                   width = "100%", class="btn-primary")
    })
    
    output$preview <- function(){
      req(input$entered_dois)
      if(substr(input$entered_dois, 1, 3) != "10.")return(NULL)
      contents <- suppressWarnings(try(cr_cn(dois = input$entered_dois, 
                         format = "citeproc-json"), silent = TRUE))
      if(class(contents) == "try-error"){
        HTML("<strong>Article Not Found.</strong>")
      }else{
        HTML(paste0(
          `if`(is.null(contents$type), NULL, paste0(
            "<strong>Type:</strong> ", contents$type, "<br>")),
          `if`(is.null(contents$title), NULL, paste0(
            "<strong>Title:</strong> ", contents$title, "<br>")),
          `if`(is.null(contents$author), NULL, 
              paste0("<strong>Author:</strong> ", 
                      paste0(paste(contents$author$given, 
                                   contents$author$family), 
                             collapse = "; "), "<br>")),
          `if`(is.null(contents$created), NULL, 
              paste0("<strong>Time:</strong> ",
                     contents$created$`date-parts`[1,1], "<br>")),
          `if`(is.null(contents$publisher), NULL, 
               paste0("<strong>Publisher:</strong> ",
                      contents$publisher))
        ))
      }
    }
    
    observeEvent(input$add_citations, {
      bib_to_write <- suppressWarnings(try(cr_cn(dois = input$entered_dois),
                                           silent = TRUE))
      if(class(bib_to_write) != "try-error"){
        if(!"crossref.bib" %in% list.files()){file.create("crossref.bib")}
        write(paste0(bib_to_write, "\n"), "crossref.bib", append = T)
        output$preview <- function(){
          HTML("<strong style='color:green;'>This citation has been saved ", 
               "to crossref.bib</strong>")
        }
        updateTextInput(session, "entered_dois", value = "")
      }else{
        output$preview <- function(){
          HTML("<strong style='color:red;'>Please make sure you have a valid ", 
               "Crossref DOI before you save it.</strong>")
        }
      }
    })
    
    observeEvent(input$done, {
      invisible(stopApp())
    })
  }
  
  viewer <- dialogViewer("Add Crossref Citations", width = 600, height = 800)
  runGadget(ui, server, viewer = viewer)
}
