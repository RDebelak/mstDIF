#' A general function to detect differential item functioning (DIF) in multistage tests (MSTs)
#'
#' This function allows the application of various methods for the detection of differential item functioning
#' in multistage tests. Currently five methods are implemented: 1. Logistic Regression, 2. mstSIB, 3. score-based
#' parameter invariance tests, 4. a score-based Bootstrap test, 5. a score-based permutation test. The required input
#' differs with regard to the selected DIF test.
#'
#' Author: Rudolf Debelak
#'
#' @param \code{resp} A data frame containing the response matrix. Rows correspond to respondents, columns to items
#' @param \code{order_by} A vector of ability estimates for each respondent.
#' @param \code{method} A character value indicating the DIF test that should be used. Possible values are "logreg"
#'  (Logistic regression), "mstsib" (mstSIB), "bootstrap" (score-based Bootstrap test), "permutation" (score-based)
#'  permutation test) and "analytical" (analytical score-based test)
#'
#' @return A list with the following elements:
#' \describe{
#'   \item{\code{p_values}}{A data frame where each row corresponds to an item. The first column corresponds to the
#'    item numbers, the second column to the p-value of an overall DIF test for ths corresponding item.}
#'   \item{\code{resp}}{The response matrix.}
#'   \item{\code{order_by}}{The person covariate tested for DIF.}
#'   \item{\code{method}}{The selected DIF test.}
#'   \item{\code{complete_output}}{The complete output of the selected DIF test.
#'   Differs depending on the selection.}
#' }
#'
#' @export
#'
mstDIF <- function(object, order_by, method, ...) UseMethod(mstDIF)

mstDIF.AllModelClass <- function(object, order_by, method, ...){
  if(method == "scDIFtest") {
    complete_output <- scDIFtest(object, order_by, ...)
  } else {
    resp <- object@Data$data
    complete_output <- mstDIF(resp, order_by, method, ...)
  }

  ### Todo: Create p_values
  result <- list(p_values = p_values, resp = resp, order_by = order_by, method = method, complete_output = output)
  return(result)
}


mstDIF.default <- function(resp=NULL, mirt_object = NULL, order_by, method, ...) {
  if (method == "logreg") {
    ### Check whether order_by is correct variable type (factor) and has two categories.
    if (class(order_by) != factor){
      stop("Error: order_by must be a factor.")
    }
    if (length(levels(order_by)) != 2){
      stop("Error: order_by must have exactly two categories.")
    }
    ### Check: Error when method is logreg and no theta available
    if (is.null(theta)){
      stop("Error: method logreg requires a theta variable")
    }
    ### Check: Recode levels of order_by if not 0 and 1
    if (levels(order_by) != c(0,1)) {
      warning("Warning: Levels of order_by recoded to 0 and 1")
      levels(order_by) <- c(0,1)
    }
    output <- log_reg(resp = resp, group = order_by, ...)
    p_values <- data.frame(item_numbers = seq(1, ncol(resp)), p = output$overall_p_value)
  }

  if (method == "mstsib") {
    ### Check whether order_by is a factor and has the correct number of levels (2)
    if (class(order_by) != factor){
      stop("Error: order_by must be a factor.")
    }
    if (length(levels(order_by)) != 2){
      stop("Error: order_by must have exactly two categories.")
    }
    ### Check: Error when method is logreg and no theta available
    if (is.null(theta)){
      stop("Error: method mstsib requires a theta variable")
    }
    ### Check: Error when method is logreg and no see available
    if (is.null(see)){
      stop("Error: method mstsib requires a see variable")
    }

    output <- mstSIB(resp = resp, group = order_by, ...)
    p_values <- data.frame(item_numbers = seq(1, ncol(resp)), p = output[,6])
  }

  if (method == "bootstrap") {
    output <- bootstrap_sctest(resp = resp, order_by = order_by, ...)
    p_values <- data.frame(item_numbers = seq(1, ncol(resp)), p = output$p)
  }

  if (method == "permutation") {
    output <- permutation_sctest(resp = resp, order_by = order_by, ...)
    p_values <- data.frame(item_numbers = seq(1, ncol(resp)), p = output$p)
  }

  if (method == "analytical") {
    ### Todo: Check whether group is correct variable type (factor) and has two categories.
    ### Todo: Error when method is analytical and no model input is available.
    output <- scDIFtest(object = mirt_object, order_by = order_by, ...)
  }

  result <- list(p_values = p_values, resp = resp, order_by = order_by, method = method, complete_output = output)
  return(result)
}


