#' A general function to detect differential item functioning (DIF) in multistage tests (MSTs)
#'
#' This function allows the application of various methods for the detection of differential item functioning
#' in multistage tests. Currently five methods are implemented: 1. Logistic Regression, 2. mstSIB, 3. analytical
#' score-base tests, 4. a score-based Bootstrap test, 5. a score-based permutation test. The required input
#' differs with regard to the selected DIF test.
#'
#' Author: Rudolf Debelak
#'
#' @param resp A data frame or matrix containing the response matrix. Rows correspond to respondents, columns to items.
#' @param DIF_covariate A vector of ability estimates for each respondent.
#' @param method A character value indicating the DIF test that should be used. Possible values are "logreg"
#'  (Logistic regression), "mstsib" (mstSIB), "bootstrap" (score-based Bootstrap test), "permutation" (score-based)
#'  permutation test) and "analytical" (analytical score-based test)
#' @param object A SingleGroup-class or MultiGroup-class object as returned by mirt, or a dRm objcect as returned by the RM function in eRm.
#' @param theta documentation missing
#' @param see documentation missing
#' @param theta_method documentation missing
#' @param ... additional, test-specific arguments
#'
#' @return A list with the following elements:
#' \describe{
#'   \item{\code{resp}}{The response matrix as a data frame.}
#'   \item{\code{method}}{The used DIF detection method.}
#'   \item{\code{test}}{The used test or statistic.}
#'   \item{\code{DIF_covariate}}{The person covariate tested for DIF.}
#'   \item{\code{DIF_test}}{A list with the DIF-test results.}
#'   \item{\code{call}}{The function call.}
#'   \item{\code{method_results}}{The complete output of the selected DIF test.
#'   Differs depending on the selection.}
#' }
#'
#' @importFrom Rsctest bootstrap_sctest permutation_sctest
#' @importFrom scDIFtest scDIFtest
#' @importFrom stats coef
#'
#' @export
mstDIF  <- function(resp, DIF_covariate, method, ...)
  UseMethod("mstDIF")

#' @describeIn mstDIF Default mstDIF method
mstDIF.default <- function(resp, DIF_covariate, method,
                           theta = NULL, see = NULL, ...){
  call <- match.call()

  nItem <- dim(resp)[2]
  # give column names if not given
  colnames(resp) <- 'if'(is.null(colnames(resp)),
                         sprintf(paste("it%0", nchar(nItem),
                                       "d", sep=''),
                                 seq_len(nItem)),
                         colnames(resp))

  if (method == "logreg") {
    newCall <- call[-4]  # remove method argument
    newCall[[1]] <- quote(log_reg)
    results <- eval(clean_call(newCall), envir = parent.frame())
    res <- results$results

    out <- list(
      resp = results$resp,
      method = "DIF-test using Logistic Regression",
      test = results$test,
      DIF_covariate = as.character(deparse(call$DIF_covariate)),
      DIF_test =
        list(overall = res[c("N", "stat", "p_value", "eff_size")],
             uniform = data.frame(N = res$N,
                                  stat = res$stat_u,
                                  p_value = res$p_value_u,
                                  eff_size = res$eff_size_u),
             'non-uniform' = data.frame(N = res$N,
                                        stat = res$stat_nu,
                                        p_value = res$p_value_nu,
                                        eff_size = res$eff_size_nu)),
      call = call,
      method_results = results)
  }

  if (method == "mstsib") {
    newCall <- call[-4]  # remove method argument
    newCall[[1]] <- quote(mstSIB)
    results <- eval(clean_call(newCall), envir = parent.frame())
    res <- results$results

    out <- list(
      resp = results$resp,
      method = "SIB test for DIF in MST",
      test = results$test,
      DIF_covariate = as.character(deparse(call$DIF_covariate)),
      DIF_test =
        list(overall = data.frame(N = res$N_R + res$N_F,
                                  res[c("stat", "SE", "p_value",
                                        "N_R", "N_F", "NCell")],
                                  stringsAsFactors = FALSE)),
      call = call,
      method_results = results)
  }

  if (method == "bootstrap") {
    newCall <- call[-4]  # remove method argument
    newCall[[1]] <- quote(bootstrap_sctest)
    newCall$item_selection <- NULL
    results <- eval(clean_call(newCall), envir = parent.frame())
    DIF_covariate_name <- names(results$DIF_covariate)[1]

    out <- list(
      resp = results$resp,
      method = paste0("Bootstrap score-based DIF test with ",
                      results$nSamples, " samples"),
      test = results$DIF_covariate[[DIF_covariate_name]]$statistic$name,
      DIF_covariate = DIF_covariate_name,
      DIF_test =
        list(overall = data.frame(N = apply(results$resp, 2,
                                            function(row) sum(!is.na(row))),
                                  stat = results$stat[DIF_covariate_name,],
                                  p_value = results$p[DIF_covariate_name,],
                                  stringsAsFactors = FALSE)),
      theta = theta,
      call = call,
      method_results = results)
  }

  if (method == "permutation") {
    newCall <- call[-4]  # remove method argument
    newCall[[1]] <- quote(permutation_sctest)
    newCall$item_selection <- NULL
    results <- eval(clean_call(newCall), envir = parent.frame())
    DIF_covariate_name <- names(results$DIF_covariate)[1]

    out <- list(
      resp = results$resp,
      method = paste0("Permutation score-based DIF test with ",
                      results$nSamples, " samples"),
      test = results$DIF_covariate[[DIF_covariate_name]]$statistic$name,
      DIF_covariate = DIF_covariate_name,
      DIF_test =
        list(overall = data.frame(N = apply(results$resp, 2,
                                            function(row) sum(!is.na(row))),
                                  stat = results$stat[DIF_covariate_name,],
                                  p_value = results$p[DIF_covariate_name,],
                                  stringsAsFactors = FALSE)),
      theta = theta,
      call = call,
      method_results = results)
  }

  if (method == "analytical") {
    stop("DIF detection using the assymptotic score based tests is \n\t",
         "only implemented for mirt-objects of class 'AllModelClass'.")

  }
  class(out) <- "mstDIF"
  return(out)
}



#' @describeIn mstDIF mstDIF method for mirt-objects
mstDIF.AllModelClass <- function(object, DIF_covariate, method,
                                 theta = NULL, see = NULL,
                                 theta_method = "WLE", ...){

  call <- match.call()
  # get the data
  resp <- object@Data$data

  if(method == "analytical") {
    newCall <- call[-4]  # remove method argument
    newCall[[1]] <- quote(scDIFtest)
    newCall$item_selection <- NULL
    results <- eval(clean_call(newCall), envir = parent.frame())
    summary <- summary(results)
    out <-  list(
      resp = resp,
      method = "Assymptotic score-based DIF test",
      test = results$info$test_info$stat_name,
      DIF_covariate = as.character(deparse(call$DIF_covariate)),
      DIF_test =
        list(overall = data.frame(N = apply(resp, 2,
                                            function(row) sum(!is.na(row))),
                                  summary[c("stat", "p_value")],
                                  stringsAsFactors = FALSE)),
      theta = theta,
      call = call,
      method_results = results)
    class(out) <- "mstDIF"
    out
  } else {
    newCall <- call[-2]  # remove object argument
    # get theta
    if(is.null(newCall[["theta"]])){
      wle_est <- mirt::fscores(object, method = theta_method,
                               full.scores.SE = TRUE)
      newCall$theta <- as.numeric(wle_est[,1])

      # get see if needed
      if(method == "mstsib" & is.null(newCall[["see"]]))
        newCall$see <- wle_est[,2]
    }

    # get the item parameters
    if(method %in% c("boostrap", "permutation")) {
      if(any(!mirt::extract.mirt(object, "itemtype") %in% c("Rasch", "2PL", "3PL")))
        stop(paste0("The ", method, " DIF method only works for 1PL,  2PL, and 3PL items."))
      it_pars <- extract_it_pars(object)
      newCall$a <- it_pars$a
      newCall$b <- it_pars$b
      newCall$c <- it_pars$u
    }

    newCall[[1]] <- quote(mstDIF.default)
    newCall$resp <- resp
    out <- eval(newCall)
    out$call <- call
  }
  return(out)

}

#' @describeIn mstDIF mstDIF method for dRm-objects
mstDIF.dRm <- function(object, DIF_covariate, method,
                       theta = NULL, see = NULL, ...){

  call <- match.call()
  newCall <- call[-2]  # remove object argument

  # get the data
  resp <- object$X

  # get theta
  if(is.null(newCall[["theta"]])){
    ppar <- eRm::person.parameter(object)
    newCall$theta <- ppar$theta.table$`Person Parameter`
    if(method == "mstsib" & is.null(newCall[["see"]])){
      # get number of all 0 or all 1 responses
      exclude <- ppar$pers.ex
      if(length(exclude) == 0){
        newCall$see <- ppar$se.theta[[1]]
      } else {
        newCall$see <- rep(NA, length(newCall$theta))
        newCall$see[-ppar$pers.ex] <- ppar$se.theta[[1]]
      }
    }
  }

  if(method %in% c("bootstrap", "permutation"))
    newCall$b <- - coef(object)

  newCall[[1]] <- quote(mstDIF.default)
  newCall$resp <- resp
  out <- eval(newCall)
  out$call <- call
  out
}




