crAddins <- function() {
  ui <- miniPage(
    gadgetTitleBar("Add Crossref Citations"),
    miniTabstripPanel(
      miniTabPanel(
        "Search Metadata", icon = icon("search"),
        miniContentPanel(
          uiOutput("search_input"),
          uiOutput("selected_item"),
          DT::dataTableOutput("search_table")
        )
      ),
      miniTabPanel(
        "Search by DOI",
        icon = icon("barcode"),
        miniContentPanel(
          h4(
            "Add a new bibliography entry through Crossref DOI",
            class = "text-center",
            style = "padding-bottom: 15px;"
          ),
          fillRow(
            flex = c(7, 3),
            height = "45px",
            uiOutput("cr_input"),
            uiOutput("add_to_my_citations")
          ),
          htmlOutput("preview")
        )
      )
    )
  )
  
  server <- function(input, output, session) {
    # Search panel
    output$search_input <- renderUI({
      textInput(
        "search_query",
        label = NULL,
        placeholder = "1. Search 2. Select 3. Insert citation",
        width = "100%"
      )
    })
    
    search_results <- reactive({
      req(input$search_query)
      if (nchar(input$search_query) < 2) return(NULL)
      out <- cr_works(query = input$search_query, limit = 100,
                      select = c("DOI","type", "title", 
                                 "author","issued", "publisher"))
      return(out$data)
    })
    
    output$search_table <- DT::renderDataTable({
      req(input$search_query, search_results())
      if ("title" %in% names(search_results())) {
        search_dt <- search_results()[, c("title", "issued")]
      } else {
        search_dt <- data.frame(title = character(), issued = character())
      }
      DT::datatable(search_dt, selection = 'single', rownames = FALSE,
                    options = list(pageLength = 5, dom = 'tip'))
    })
    
    output$selected_item <- renderUI({
      req(input$search_table_rows_selected)
      selected_entry <- search_results()[input$search_table_rows_selected, ]
      fillRow(
        flex = c(8, 2), height = "85px",
        tags$div(
          style = "border: 1px solid #ddd; border-radius: 5px; padding: 5px; overflow-y: scroll; height: 85px; ",
          h5(selected_entry$title),
          tags$div(strong("DOI: "), selected_entry$doi),
          tags$div(
            strong("Author(s): "), 
            ifelse(
              is.null(selected_entry$author), "-", 
              paste0(paste0(selected_entry$author[[1]]$given, " ", 
                            selected_entry$author[[1]]$family), collapse = ", ")
            )
          ),
          tags$div(strong("Publisher: "), selected_entry$publisher),
          tags$div(strong("Issued: "), selected_entry$issued),
          tags$div(strong("Type: "), selected_entry$type)
        ),
        actionButton(
          "add_citations_article",
          label = "Add to My Citations",
          width = "100%",
          class = "btn-primary",
          style = "margin-top: 25px; margin-left: 5px; "
        )
      )
    })
    
    observeEvent(input$add_citations_article, {
      bib_to_write <- suppressWarnings(
        try(cr_cn(
          dois = search_results()$doi[input$search_table_rows_selected]),
          silent = TRUE)
      )
      if (class(bib_to_write) != "try-error") {
        if (!"crossref.bib" %in% list.files()) {
          file.create(
            "crossref.bib")
        }
        bib_to_write <- correct_bib(bib_to_write)
        write(paste0(bib_to_write, "\n"), "crossref.bib", append = T)
        updateActionButton(session, "add_citations_article", 
                           label = "Added", icon = icon("check"))
      } 
    })
    
    
    
    
    # DOI panel
    preview_message <- reactiveValues(added = 0, error = 0)
    output$cr_input <- renderUI({
      textInput(
        "entered_dois",
        label = NULL,
        placeholder = "Enter a DOI to get started",
        width = "98%"
      )
    })
    
    output$add_to_my_citations <- renderUI({
      actionButton(
        "add_citations",
        label = "Add to My Citations",
        width = "100%",
        class = "btn-primary"
      )
    })
    
    
    output$preview <- function() {
      req(input$entered_dois)
      if (input$entered_dois == "" &
          preview_message$added == 1) {
        return(
          HTML(
            "<strong style='color:green;'>This citation has been saved ",
            "to crossref.bib</strong>"
          )
        )
      }
      if (input$entered_dois == "" &
          preview_message$error == 1) {
        return(
          HTML(
            "<strong style='color:red;'>Please make sure you have a valid ",
            "Crossref DOI before you save it.</strong>"
          )
        )
      }
      if (substr(input$entered_dois, 1, 3) != "10.")
        return(NULL)
      contents <-
        suppressWarnings(try(cr_cn(dois = input$entered_dois,
                                   format = "citeproc-json"),
                             silent = TRUE)
        )
      if (class(contents) == "try-error") {
        HTML("<strong>Article Not Found.</strong>")
      } else{
        HTML(paste0(
          `if`(
            is.null(contents$type),
            NULL,
            paste0("<strong>Type:</strong> ", contents$type, "<br>")
          ),
          `if`(
            is.null(contents$title),
            NULL,
            paste0("<strong>Title:</strong> ", contents$title, "<br>")
          ),
          `if`(
            is.null(contents$author),
            NULL,
            paste0(
              "<strong>Author:</strong> ",
              paste0(
                paste(contents$author$given,
                      contents$author$family),
                collapse = "; "
              ),
              "<br>"
            )
          ),
          `if`(
            is.null(contents$created),
            NULL,
            paste0(
              "<strong>Time:</strong> ",
              contents$created$`date-parts`[1, 1],
              "<br>"
            )
          ),
          `if`(
            is.null(contents$publisher),
            NULL,
            paste0("<strong>Publisher:</strong> ",
                   contents$publisher)
          )
        ))
      }
    }
    
    parsename <- function(name, isRegx = TRUE) {
      if (isRegx) {
        paste0("\\n\\t", name)
      } else{
        paste0("\n\t", name)
      }
    }
    
    extract_bib <- function(bib, name, regex) {
      regex_full <- paste0(parsename(name), "\\s=\\s", regex)
      out <- str_match(bib, regex_full)
      return(out[2])
    }
    
    correct_bib <- function(bib) {
      out <- bib
      if (!str_detect(bib, parsename("author"))) {
        title <- "Untitle"
        if (str_detect(bib, parsename("title"))) {
          title <- extract_bib(bib, "title", "[^\\w]*(\\w*)")
        }
        original <- paste0("\\{.*,", parsename("doi"))
        if (str_detect(bib, parsename("year"))) {
          year <- extract_bib(bib, "year", "(\\d*)")
          new <-
            paste0("\\{", title, "_", year, ",", parsename("doi", F))
        } else{
          new <- paste0("\\{", title, ",", parsename("doi", F))
        }
        out <- sub(original, new, bib)
      }
      return(out)
    }
    
    observeEvent(input$add_citations, {
      bib_to_write <-
        suppressWarnings(try(cr_cn(dois = input$entered_dois),
                             silent = TRUE)
        )
      if (class(bib_to_write) != "try-error") {
        if (!"crossref.bib" %in% list.files()) {
          file.create(
            "crossref.bib")
        }
        bib_to_write <- correct_bib(bib_to_write)
        write(paste0(bib_to_write, "\n"), "crossref.bib", append = T)
        updateTextInput(session, "entered_dois", value = "")
        updateActionButton(session, "add_citations", 
                           label = "Added", icon = icon("check"))
        preview_message$added <- 1
        preview_message$error <- 0
      } else{
        updateTextInput(session, "entered_dois", value = "")
        preview_message$added <- 0
        preview_message$error <- 1
      }
    })
    
    observeEvent(input$done, {
      invisible(stopApp())
    })
  }
  
  viewer <-
    dialogViewer("Add Crossref Citations",
                 width = 800,
                 height = 600)
  runGadget(ui, server, viewer = viewer)
}
