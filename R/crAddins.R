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
    
    preview_message <- reactiveValues(added = 0, error = 0)
    
    output$preview <- function(){
      if(is.null(input$entered_dois))return(NULL)
      if(input$entered_dois == "" & preview_message$added == 1){return(
        HTML("<strong style='color:green;'>This citation has been saved ", 
             "to crossref.bib</strong>")
      )}
      if(input$entered_dois == "" & preview_message$error == 1){return(
        HTML("<strong style='color:red;'>Please make sure you have a valid ", 
             "Crossref DOI before you save it.</strong>")
      )}
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
    
    parsename <- function(name, isRegx = TRUE){
      if(isRegx){
        paste0("\\n\\t", name)
      }else{
        paste0("\n\t", name)
      }
    } 
    
    extract_bib <- function(bib, name, regex){
      regex_full <- paste0(
        parsename(name), "\\s=\\s", regex
      )
      out <- str_match(bib, regex_full)
      return(out[2])
    }
    
    correct_bib <- function(bib){
      out <- bib
      if(!str_detect(bib, parsename("author"))){
        title <- "Untitle"
        if(str_detect(bib, parsename("title"))){
          title <- extract_bib(bib, "title", "[^\\w]*(\\w*)")
        }
        original <- paste0("\\{.*,", parsename("doi"))
        if(str_detect(bib, parsename("year"))){
          year <- extract_bib(bib, "year", "(\\d*)")
          new <- paste0("\\{", title, "_", year, ",", parsename("doi", F))
        }else{
          new <- paste0("\\{", title, ",", parsename("doi", F))
        }
        out <- sub(original, new, bib)
      }
      return(out)
    }
    
    observeEvent(input$add_citations, {
      bib_to_write <- suppressWarnings(try(cr_cn(dois = input$entered_dois),
                                           silent = TRUE))
      if(class(bib_to_write) != "try-error"){
        if(!"crossref.bib" %in% list.files()){file.create("crossref.bib")}
        bib_to_write <- correct_bib(bib_to_write)
        write(paste0(bib_to_write, "\n"), "crossref.bib", append = T)
        updateTextInput(session, "entered_dois", value = "")
        preview_message$added <- 1
        preview_message$error <- 0
      }else{
        updateTextInput(session, "entered_dois", value = "")
        preview_message$added <- 0
        preview_message$error <- 1
      }
    })
    
    observeEvent(input$done, {
      invisible(stopApp())
    })
  }
  
  viewer <- dialogViewer("Add Crossref Citations", width = 600, height = 800)
  runGadget(ui, server, viewer = viewer)
}
