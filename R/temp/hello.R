#'
#' #' Recode select_one to binary TRUE/FALSE
#' #'
#' #'@param x vector of select_one
#' #'@param becomes.TRUE values to recode to TRUE
#' #'@param becomes.FALSE values to change to FALSE
#' #'@details NA's stay NA. All values not specified in becomes.TRUE or becomes.FALSE become NA.
#' #'@return logical vector of the same length as the input vector, all values in becomes.TRUE changed to TRUE, and in becomes.FALSE to FALSE
#' recode_select_one_to_logical <- function(x, becomes.TRUE, becomes.FALSE){
#'   make_true <- x %in% becomes.TRUE # check which value matches the critical value
#'   make_false<- x %in% becomes.FALSE
#'   x_recoded<-rep(NA,length(x))
#'   x_recoded[make_false] <- FALSE  # recode to "to" value where condition met
#'   x_recoded[make_true] <- TRUE  # recode to "to" value where condition not met
#'   return(x_recoded)
#' }
#'
#' #' #' Recode select_multiple to binaryw TRUE/FALSE
#' #' #'
#' #' #'@param x vector of select_multiple
#' #' #'@param selected.any.in  vector of possible respones; returns TRUE only if ANY of these were selected (and all other paramteters conditions are fulfilled)
#' #' #'@param selected.all.in  vector of possible respones; returns TRUE only if ALL of these were selected (and all other paramteters conditions are fulfilled)
#' #' #'@param selected.none.in vector of possible respones; returns TRUE only if NONE of these were selected (and all other paramteters conditions are fulfilled)
#' #' #'@details NA's stay NA. All values not specified in becomes.TRUE or becomes.FALSE become NA.
#' #' #'@return logical vector of the same length as th einput vector, all values in becomes.TRUE changed to TRUE, and in becomes.FALSE to FALSE
#' #' recode_select_multiple_to_logical <- function(x, selected.any.in = NULL, selected.all.in = NULL, selected.none.in = NULL){
#' #'   if(is.null(c(selected.any.in, selected.all.in, selected.none.in))){stop("At least one parameter must be provided")}
#' #'   x_recoded <- rep(FALSE, length(x))
#' #'   ####match any
#' #'   if(!is.null(selected.any.in)){
#' #'   match_any <- x %>% strsplit(" ") %>% lapply(function(x){
#' #'     match(selected.any.in, x)})
#' #'   make_false_any <- lapply(match_any, function(x){all(is.na(x))}) %>% unlist
#' #'   x_recoded[!make_false_any] <- TRUE}
#' #'   ####match all
#' #'   if(!is.null(selected.all.in)){
#' #'   make_false_all <- x %>% strsplit(" ") %>% sapply(function(x){
#' #'     match(selected.all.in,x) %>% is.na %>% any})
#' #'   x_recoded[!make_false_all] <- TRUE}
#' #'   ####match none
#' #'   if(!is.null(selected.none.in)){
#' #'   match_none <- x %>% strsplit(" ") %>% lapply(function(x){
#' #'     match(selected.none.in, x)})
#' #'   make_true_none <- lapply(match_none, function(x){all(is.na(x))}) %>% unlist
#' #'   x_recoded[make_true_none] <- TRUE}
#' #'   return(x_recoded)
#' #' }
#'
#'
#' recode_generic <- function(data, x, value, condition, to, variable.name){
#'   if(condition=="else"){
#'     recoded <- recode_else(data = data, x = x, to = to)
#'     return(recoded)
#'   }
#'
#'   if(question_is_select_multiple(variable.name)){
#'     recoded <- recode_select_multiple(data = data, x = x, value = value, condition = condition, to = to, variable.name = variable.name)
#'     return(recoded)
#'   }
#'
#'   recoded <- recode_generic_one(data = data, x = x, value = value, condition = condition, to = to, variable.name = variable.name)
#'   return(recoded)
#' }
#'
#'
#' #' Recode select_multiple to value in "to"
#' #'
#' #'@param x vector of select_multiple
#' #'@param value  vector of possible respones; returns "to" only if ANY, ALL, or NONE of these were selected (depending on condition)
#' #'@param condition  specifies the relationship to the vector in value
#' #'@details NA's stay NA
#' #'@return vector of the same length ast h einput vector, all values are either a numeric value specified in "to" or NA's
#' recode_select_multiple <- function(data, x, value, condition, to, variable.name = variable.name){
#'   x<-as.character(x)
#'   if(is.null(value)){stop("At least one parameter must be provided")}
#'   x_recoded <- rep(NA, length(x))
#'   value <- value %>% strsplit(" ") %>% as.vector %>% unlist
#'   ####match any
#'   if(condition == "any"){
#'     match_any <- x %>% as.character %>% strsplit(" ") %>% lapply(function(x){
#'       match(value, x)})
#'     make_false_any <- lapply(match_any, function(x){all(is.na(x))}) %>% unlist
#'     x_recoded[!make_false_any] <- to}
#'   ####match all
#'   if(condition == "all"){
#'     isfulfilled <- x %>% strsplit(" ") %>% lapply(function(x){
#'       (value %in% x) %>% all}) %>% unlist
#'     x_recoded[isfulfilled] <- to}
#'   ####match none
#'   if(condition == "none"){
#'     match_none <- x %>% strsplit(" ") %>% lapply(function(x){
#'       match(value, x)})
#'     make_true_none <- lapply(match_none, function(x){all(is.na(x))}) %>% unlist
#'     x_recoded[make_true_none] <- to}
#'
#'   ####match skipped
#'   if(condition == "skipped"){
#'     skipped <- question_is_skipped(data, variable.name)
#'     x_recoded[skipped] <- to}
#'   # ####match else
#'
#'   # if(condition == "else"){
#'   #   x_recoded <- recode_else(data = data, x = x, to = to)
#'   # }
#'   return(x_recoded)
#' }
#'
#'
#' ### input x should be the line in the data with variable name,
#' recode_generic_one <- function(data, x, value, condition, to, variable.name = variable.name){
#'   recoded <- rep(NA,length(x))
#'   if(condition == "smaller.equal"){
#'     recoded <- recode_smaller_equal(x = x, from = value, to = to)
#'   }
#'   if(condition == "equal")
#'   {
#'     recoded <- recode_equal(x = x, from = value, to = to)
#'   }
#'   if(condition == "larger"){
#'     recoded <- recode_larger(x = x, from = value, to = to)
#'   }
#'   if(condition == "skipped"){
#'     recoded <- recode_skipped(data = data, x = x, to = to, variable.name = variable.name)
#'   }
#'   if(condition == "any"){
#'     recoded <- recode_any(x = x, from = value, to = to)}
#'   return(recoded)
#' }
#'
#'
#' recode_any<-function(x, from, to){
#'   from <- from %>% strsplit(" ") %>% as.vector %>% unlist
#'   x %<>% as.character
#'   to %<>% as.numeric
#'   match_any <- match(x, from)
#'   make_true <- !is.na(match_any)
#'   recoded_empty <- rep(NA,length(x))
#'   recoded_empty[make_true] <- to
#'   return(recoded_empty)
#' }
#'
#' recode_equal<-function(x,from,to){
#'   x %<>% as.character
#'   to %<>% as.numeric
#'   recoded <- to[match(x,from)]
#'   return(recoded)
#' }
#'
#' recode_smaller_equal<-function(x,from,to){
#'   x %<>% as.character %>% as.numeric
#'   from %<>% as.numeric
#'   to %<>% as.numeric
#'   condition_met <- x <= from
#'   recoded_empty <- rep(NA,length(x))
#'   recoded_empty[condition_met] <- to
#'   return(recoded_empty)
#' }
#'
#' recode_larger<-function(x,from,to){
#'   x %<>% as.character %>% as.numeric
#'   from %<>% as.numeric
#'   to %<>% as.numeric
#'   condition_met <- x > from
#'   recoded_empty <- rep(NA,length(x))
#'   recoded_empty[condition_met] <- to
#'   return(recoded_empty)
#' }
#'
#' recode_skipped <- function(data, x, to, variable.name){
#'   skipped <- question_is_skipped(data, variable.name)
#'   recoded_empty <- rep(NA,length(x))
#'   recoded_empty[skipped] <- to
#'   return(recoded_empty)
#' }
#'
#'
#' recode_else <- function(data, x, to){
#'   to %<>% as.numeric
#'   recoded_empty <- rep(NA,length(x))
#'   skipped <- question_is_skipped(data, x)
#'   recoded_empty[skipped] <- to
#'   recoded_empty[!is.na(x)] <- to
#'   return(recoded_empty)
#' }
#'
#' ass.numeric<-function(x){
#'   # as.numeric, but without factor mayham
#'   if(is.factor(x)){return(as.numeric(levels(x))[x])}else{
#'     return(as.numeric(x))
#'   }
#' }
#'
#'
#'
#'
#'
#'
#'
