check_bib <- function(bib_doi, bibfile) {
  str_detect(bibfile, paste0("\\{", bib_doi, "\\}"))
}

correct_bib <- function(bib, bib_key, bibfile) {
  if (!str_detect(bibfile, bib_key)) return(bib)
  new_key <- paste(bib_key, sample(9999, 1), sep = "_")
  return(str_replace(bib, bib_key, new_key))
}

crAddins <- function() {
  current_yr <- as.numeric(format(Sys.Date(), "%Y"))
  types <- cr_types()$data
  types <- sort(setNames(types$id, types$label))
  types <- c("Any Type" = "any", types)
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
              choices = c("\u25B2" = "asc", "\u25BC" = "desc"),
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
          textInput(
            "entered_dois",
            label = NULL,
            placeholder = "Enter a DOI to get started",
            width = "95%"
          ),
          uiOutput("selected_item2")
        )
      )
    )
  )
  
  server <- function(input, output, session) {
    rv <- reactiveValues(ref_loc = "")
    
    if (file.exists("~/.rc_addin")) {
      rv$ref_loc <- readLines("~/.rc_addin")
    } else {
      rv$ref_loc <- "references.bib"
      writeLines("references.bib", "~/.rc_addin")
    }
    
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
      if (input$search_type != "any") {
        search_filter <- c(search_filter, type = input$search_type)
      }
      if (input$search_date1 != "any") {
        if (input$search_date1 == "custom") {
          s_dates <- as.character(input$search_date2)
          if (s_dates[1] != s_dates[2] & input$search_date2[1] != Sys.Date()) {
            search_filter <- c(
              search_filter, 
              from_pub_date = s_dates[1],
              until_pub_date = s_dates[2]
            )
          }
        } else {
          search_filter <- c(search_filter,
                             from_pub_date = input$search_date1)
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
        if ("issued" %in% names(search_results())) {
          search_dt <- search_results()[, c("title", "issued")]
        } else {
          search_dt <- search_results()[, c("title")]
        }
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
            value = rv$ref_loc
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
      new_bib <- cr_cn(
        dois = search_results()$doi[input$search_table_rows_selected]
      )
      if (is.null(new_bib)) {
        updateActionButton(session, "add_citations_article", 
                           label = "Something Wrong", icon = icon("times"))
      } else {
        if (!input$save_to %in% list.files()) {
          file.create(input$save_to)
        }
        bib_file <- paste(readLines(input$save_to), collapse = " ")
        new_bibentry <- cr_cn(
          dois = search_results()$doi[input$search_table_rows_selected],
          format = "bibentry"
        )
        if (check_bib(new_bibentry$doi, bib_file)) {
          updateActionButton(session, "add_citations_article", 
                             label = "Item Exist!", icon = icon("times"))
        } else {
          new_bib <- correct_bib(new_bib, new_bibentry$key, bib_file)
          write(paste0(new_bib, "\n"), input$save_to, append = T)
          updateActionButton(session, "add_citations_article", 
                             label = "Added", icon = icon("check"))
        }
      } 
    })
    
    # DOI panel
    output$selected_item2 <- renderUI({
      req(input$entered_dois)
      if (substr(input$entered_dois, 1, 3) != "10.") return(NULL)
      selected_entry <- cr_cn(dois = input$entered_dois, 
                              format = "bibentry")
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
              selected_entry$author
            )
          ),
          tags$div(strong("Journal/Container: "), 
                   ifelse(is.null(selected_entry$journal), "-",
                          selected_entry$journal)),
          tags$div(strong("Year: "), 
                   ifelse(is.null(selected_entry$year), "-",
                          selected_entry$year)),
          tags$div(strong("Type: "), 
                   ifelse(is.null(selected_entry$entry), "-",
                          selected_entry$entry))
        ),
        tags$div(
          style = "margin-left: 5px;",
          textInput(
            "save_to2",
            label = "Save to",
            width = "95%",
            value = rv$ref_loc
          ),
          actionButton(
            "add_citations",
            label = "Add to My Citations",
            width = "95%",
            class = "btn-primary"
          )
        )
      )
    })
    
    observeEvent(input$add_citations, {
      new_bib <- cr_cn(
        dois = input$entered_dois
      )
      if (is.null(new_bib)) {
        updateActionButton(session, "add_citations", 
                           label = "Something Wrong", icon = icon("times"))
      } else {
        if (!input$save_to2 %in% list.files()) {
          file.create(input$save_to2)
        }
        bib_file <- paste(readLines(input$save_to2), collapse = " ")
        new_bibentry <- cr_cn(
          dois = input$entered_dois,
          format = "bibentry"
        )
        if (check_bib(new_bibentry$doi, bib_file)) {
          updateActionButton(session, "add_citations", 
                             label = "Item Exist!", icon = icon("times"))
        } else {
          new_bib <- correct_bib(new_bib, new_bibentry$key, bib_file)
          write(paste0(new_bib, "\n"), input$save_to2, append = T)
          updateActionButton(session, "add_citations", 
                             label = "Added", icon = icon("check"))
        }
      }
    })
    
    observeEvent(input$save_to, {
      writeLines(input$save_to, "~/.rc_addin")
      rv$ref_loc <- input$save_to
    })
    observeEvent(input$save_to2, {
      writeLines(input$save_to2, "~/.rc_addin")
      rv$ref_loc <- input$save_to2
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
