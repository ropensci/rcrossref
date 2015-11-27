#' Get filter details and names.
#'
#' @export
#' @name filters
#' @param x (character) Optional filter name. If not given, all filters
#' returned.
#' @details Note that all filter names in this package have dashes replaced
#' with underscores as dashes cause problems in an R console.
#' @examples
#' filter_names()
#' filter_details()
#' filter_details()$assertion
#' filter_details()$assertion$possible_values
#' filter_details()$assertion$description
#' filter_details("issn")
#' filter_details("iss")
#' filter_details(c("issn", "alternative_id"))
filter_names <- function() filter_list

#' @export
#' @rdname filters
filter_details <- function(x = NULL) {
  if (is.null(x)) {
    filter_deets
  } else {
    filter_deets[match.arg(x, names(filter_deets), several.ok = TRUE)]
  }
}


# helpers ----------------------------
filter_handler <- function(x){
  if (is.null(x)) {
    NULL
  } else {
    nn <- names(x)
    if (any(nn %in% other_filters)) {
      nn <- sapply(nn, function(x) {
        if (x %in% other_filters) {
          switch(x,
                 license_url = 'license.url',
                 license_version = 'license.version',
                 license_delay = 'license.delay',
                 full_text_version = 'full-text.version',
                 full_text_type = 'full-text.type',
                 award_number = 'award.number',
                 award_funder = 'award.funder')
        } else {
          x
        }
      }, USE.NAMES = FALSE)
    }
    newnn <- gsub("_", "-", nn)
    names(x) <- newnn
    x <- sapply(x, asl)
    args <- list()
    for (i in seq_along(x)) {
      args[[i]] <- paste(names(x[i]), unname(x[i]), sep = ":")
    }
    paste0(args, collapse = ",")
  }
}

asl <- function(z) {
  # z <- tolower(z)
  if (is.logical(z) || tolower(z) == "true" || tolower(z) == "false") {
    if (z) {
      return('true')
    } else {
      return('false')
    }
  } else {
    return(z)
  }
}

other_filters <- c('license_url','license_version','license_delay','full_text_version','full_text_type',
                   'award_number','award_funder')

filter_list <- c(
  'has_funder','funder','prefix','member','from_index_date','until_index_date',
  'from_deposit_date','until_deposit_date','from_update_date','until_update_date',
  'from_first_deposit_date','until_first_deposit_date','from_pub_date','until_pub_date',
  'has_license','license_url','license_version','license_delay','has_full_text',
  'full_text_version','full_text_type','public_references','has_references','has_archive',
  'archive','has_orcid','orcid','issn','type','directory','doi','updates','is_update',
  'has_update_policy','container_title','publisher_name','category_name','type_name',
  'from_created_date', 'until_created_date', 'affiliation', 'has_affiliation',
  'assertion_group', 'assertion', 'article_number', 'alternative_id'
)

filter_deets = list(
  "has_funder" = list("possible_values" = NA, "description" = "metadata which includes one or more funder entry" ),
  "funder" = list("possible_values" = "{funder_id}", "description" = "metadata which include the {funder_id} in FundRef data" ),
  "prefix" = list("possible_values" = "{owner_prefix}", "description" = "metadata belonging to a DOI owner prefix {owner_prefix} (e.g. '10.1016' )" ),
  "member" = list("possible_values" = "{member_id}", "description" = "metadata belonging to a CrossRef member" ),
  "from_index_date" = list("possible_values" = '{date}', "description" = "metadata indexed since (inclusive) {date}" ),
  "until_index_date" = list("possible_values" = '{date}', "description" = "metadata indexed before (inclusive) {date}" ),
  "from_deposit_date" = list("possible_values" = '{date}', "description" = "metadata last (re)deposited since (inclusive) {date}" ),
  "until_deposit_date" = list("possible_values" = '{date}', "description" = "metadata last (re)deposited before (inclusive) {date}" ),
  "from_update_date" = list("possible_values" = '{date}', "description" = "Metadata updated since (inclusive) {date} Currently the same as 'from_deposit_date'" ),
  "until_update_date" = list("possible_values" = '{date}', "description" = "Metadata updated before (inclusive) {date} Currently the same as 'until_deposit_date'" ),
  "from_created_date" = list("possible_values" = '{date}', "description" = "metadata first deposited since (inclusive) {date}" ),
  "until_created_date" = list("possible_values" = '{date}', "description" = "metadata first deposited before (inclusive) {date}" ),
  "from_pub_date" = list("possible_values" = '{date}', "description" = "metadata where published date is since (inclusive) {date}" ),
  "until_pub_date" = list("possible_values" = '{date}', "description" = "metadata where published date is before (inclusive)  {date}" ),
  "has_license" = list("possible_values" = NA, "description" = "metadata that includes any '<license_ref>' elements" ),
  "license_url" = list("possible_values" = '{url}', "description" = "metadata where '<license_ref>' value equals {url}" ),
  "license_version" = list("possible_values" = '{string}', "description" = "metadata where the '<license_ref>''s 'applies_to' attribute  is '{string}'"),
  "license_delay" = list("possible_values" = "{integer}", "description" = "metadata where difference between publication date and the '<license_ref>''s 'start_date' attribute is <= '{integer}' (in days"),
  "has_full_text" = list("possible_values" = NA, "description" = "metadata that includes any full text '<resource>' elements_" ),
  "full_text_version" = list("possible_values" = '{string}' , "description" = "metadata where '<resource>' element's 'content_version' attribute is '{string}'" ),
  "full_text_type" = list("possible_values" = '{mime_type}' , "description" = "metadata where '<resource>' element's 'content_type' attribute is '{mime_type}' (e.g. 'application/pdf')" ),
  "public_references" = list("possible_values" = NA, "description" = "metadata where publishers allow references to be distributed publically" ),
  "has_references" = list("possible_values" = NA , "description" = "metadata for works that have a list of references" ),
  "has_archive" = list("possible_values" = NA , "description" = "metadata which include name of archive partner" ),
  "archive" = list("possible_values" = '{string}', "description" = "metadata which where value of archive partner is '{string}'" ),
  "has_orcid" = list("possible_values" = NA, "description" = "metadata which includes one or more ORCIDs" ),
  "orcid" = list("possible_values" = '{orcid}', "description" = "metadata where '<orcid>' element's value = '{orcid}'" ),
  "issn" = list("possible_values" = '{issn}', "description" = "metadata where record has an ISSN = '{issn}' Format is 'xxxx_xxxx'." ),
  "type" = list("possible_values" = '{type}', "description" = "metadata records whose type = '{type}' Type must be an ID value from the list of types returned by the '/types' resource" ),
  "directory" = list("possible_values" = "{directory}", "description" = "metadata records whose article or serial are mentioned in the given '{directory}'. Currently the only supported value is 'doaj'" ),
  "doi" = list("possible_values" = '{doi}', "description" = "metadata describing the DOI '{doi}'" ),
  "updates" = list("possible_values" = '{doi}', "description" = "metadata for records that represent editorial updates to the DOI '{doi}'" ),
  "is_update" = list("possible_values" = NA, "description" = "metadata for records that represent editorial updates" ),
  "has_update_policy" = list("possible_values" = NA, "description" = "metadata for records that include a link to an editorial update policy" ),
  "container_title" = list("possible_values" = NA, "description" = "metadata for records with a publication title exactly with an exact match" ),
  "publisher_name" = list("possible_values" = NA, "description" = "metadata for records with an exact matching publisher name" ),
  "category_name" = list("possible_values" = NA, "description" = "metadata for records with an exact matching category label" ),
  "type_name" = list("possible_values" = NA, "description" = "metadata for records with an exacty matching type label" ),
  "award_number" = list("possible_values" = "{award_number}", "description" = "metadata for records with a matching award nunber_ Optionally combine with 'award_funder'" ),
  "award_funder" = list("possible_values" = '{funder doi or id}', "description" = "metadata for records with an award with matching funder. Optionally combine with 'award_number'"),
  "assertion_group" = list("possible_values" = NA, "description" = "metadata for records with an assertion in a particular group" ),
  "assertion" = list("possible_values" = NA, "description" = "metadata for records with a particular named assertion" ),
  "affiliation" = list("possible_values" = NA, "description" = "metadata for records with at least one contributor with the given affiliation" ),
  "has_affiliation" = list("possible_values" = NA, "description" = "metadata for records that have any affiliation information" ),
  "article_number" = list("possible_values" = NA, "description" = "metadata for records with a given article number"),
  "alternative_id" = list("possible_values" = NA, "description" = "metadata for records with the given alternative ID, which may be a publisher_specific ID, or any other identifier a publisher may have provided")
)
