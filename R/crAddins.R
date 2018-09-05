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

crAddins <- function() {
  current_yr <- as.numeric(format(Sys.Date(), "%Y"))
  types <- cr_types()$data
  types <- sort(setNames(types$id, types$label))
  types <- c("Any Type" = "*", types)
  ui <- miniPage(
    gadgetTitleBar("Add Crossref Citations"),
    miniTabstripPanel(
      miniTabPanel(
        "Search Metadata", icon = icon("search"),
        miniContentPanel(
          fillRow(
            flex = c(8, 1, 2, 1), height = "50px",
            textInput(
              "search_query", label = NULL, width = "100%",
              placeholder = "Search, Select & Add"
            ),
            h5("Sort:", class = "text-center"),
            selectInput(
              "search_sort",
              label = NULL, width = "95%",
              choices = c(
                "Relevance" = "relevance",
                "Published" = "published",
                "Recent Changed" = "updated",
                "Referenced" = "is-referenced-by-count"
              )
            ),
            selectInput(
              "search_order",
              label = NULL, width = "95%",
              choices = c("▲" = "asc", "▼" = "desc"),
              selected = "desc"
            )
          ),
          tags$div(
            style = "margin-top: -10px;",
            fillRow(
              flex = c(1, 1, 1, 1, 2), height = "60px", 
              textInput("search_author", label = "Author", width = "95%"),
              textInput("search_container", label = "Journal/Container", 
                        width = "95%"),
              selectInput("search_type", label = "Type", width = "95%",
                          choices = types, selected = "journal-article"),
              selectInput("search_date1", label = "Since", width = "95%",
                          choices = c(
                            "Any time" = "any", 
                            seq(current_yr, current_yr - 4), 
                            "Custom" = "custom"
                          )),
              conditionalPanel(
                condition = "input.search_date1 == 'custom'",
                dateRangeInput("search_date2", label = "Select Range",
                               width = "95%", startview = "decade")
              )
            )
          ),
          conditionalPanel(
            condition = "input.search_query == ''",
            hr(),
            h4("Tips:"),
            p("1. The crossref API doesn't support exact match right now. ", 
              "In fact, it returns all results based on each word being ",
              'searched against. For example, "John Smith" in the author ',
              'field will list out all results matches "John" OR "Smith", ',
              'instead of searching for "John Smith" as a whole name.'),
            p("2. If you want to find all publications by a person, try to ",
              "put in his/her name in Author and put a space in the search box.")
          ),
          
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
    search_results <- reactive({
      req(input$search_query)
      search_flq <- NULL
      if (input$search_container != "") {
        search_flq <- c(search_flq, 
                        `query.container-title` = input$search_container)
      }
      if (input$search_author != "") {
        search_flq <- c(search_flq, `query.author` = input$search_author)
      }
      
      search_filter <- NULL
      if (input$search_date1 != "any") {
        if (input$search_date1 == "custom") {
          s_dates <- as.character(input$search_date2)
          if (s_dates[1] != s_dates[2] & input$search_date2[1] != Sys.Date()) {
            search_filter <- c(
              from_pub_date = s_dates[1],
              until_pub_date = s_dates[2]
            )
          }
        } else {
          search_filter <- c(from_pub_date = input$search_date1)
        }
      }
      
      out <- cr_works(query = input$search_query, limit = 100,
                      select = c("DOI","type", "title", "URL",
                                 "author","issued", "publisher", 
                                 "container-title"),
                      sort = input$search_sort,
                      order = input$search_order,
                      flq = search_flq,
                      filter = search_filter)
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
        flex = c(8, 2), height = "120px",
        tags$div(
          style = "border: 1px solid #ddd; border-radius: 5px; padding: 5px; overflow-y: scroll; height: 120px; ",
          h5(selected_entry$title),
          tags$div(strong("Link: "), 
                   tags$a(selected_entry$doi, 
                          href = selected_entry$url,
                          target = "_blank")),
          tags$div(
            strong("Author(s): "), 
            ifelse(
              is.null(selected_entry$author), "-", 
              paste0(paste0(selected_entry$author[[1]]$given, " ", 
                            selected_entry$author[[1]]$family), collapse = ", ")
            )
          ),
          tags$div(strong("Journal/Container: "), selected_entry$container.title),
          tags$div(strong("Issued: "), selected_entry$issued),
          tags$div(strong("Type: "), selected_entry$type)
        ),
        tags$div(
          style = "margin-left: 5px;",
          textInput(
            "save_to",
            label = "Save to",
            width = "95%",
            value = "references.bib"
          ),
          actionButton(
            "add_citations_article",
            label = "Add to My Citations",
            width = "95%",
            class = "btn-primary"
          )
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
        if (!input$save_to %in% list.files()) {
          file.create(input$save_to)
        }
        bib_to_write <- correct_bib(bib_to_write)
        write(paste0(bib_to_write, "\n"), input$save_to, append = T)
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
    
    observeEvent(input$add_citations, {
      bib_to_write <-
        suppressWarnings(try(cr_cn(dois = input$entered_dois),
                             silent = TRUE)
        )
      if (class(bib_to_write) != "try-error") {
        if (!input$save_to %in% list.files()) {
          file.create(
            input$save_to)
        }
        bib_to_write <- correct_bib(bib_to_write)
        write(paste0(bib_to_write, "\n"), input$save_to, append = T)
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
