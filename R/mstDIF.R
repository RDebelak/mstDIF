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
#' @param AllModelClass A SingleGroup or Multigroup object as returned by mirt.
#' @param dRm_object A Rm objcect as returned by the RM function in eRm.
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
mstDIF  <- function(resp, ...)
  UseMethod("mstDIF")

#' @describeIn mstDIF Default mstDIF method
mstDIF.default <- function(resp, DIF_covariate, method,
                           theta = NULL, see = NULL, ...){
  call <- match.call()

  if (method == "logreg") {
    results <- log_reg(resp, DIF_covariate, theta)
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
    results <- mstSIB(resp, DIF_covariate, theta, see, ...)
    res <- results$results

    out <- list(
      resp = results$resp,
      method = "SIB test for DIF in MST",
      test = results$test,
      DIF_covariate = as.character(deparse(call$DIF_covariate)),
      DIF_test =
        list(overall = res[c("stat", "SE", "p_value", "N_R", "N_F", "NCell")]),
      call = call,
      method_results = results)
  }

  if (method == "bootstrap") {
    results <- bootstrap_sctest(resp = resp, DIF_covariate = DIF_covariate,
                                theta = theta, ...)
    DIF_covariate_name <- names(results$DIF_covariate)

    out <- list(
      resp = results$resp,
      method = paste0("Bootstrap score-based DIF test with ",
                      results$nSamples, " samples"),
      test = results$DIF_covariate[[DIF_covariate_name]]$statistic$name,
      DIF_covariate = DIF_covariate_name,
      DIF_test =
        list(overall = data.frame(stat = results$stat[DIF_covariate_name,],
                                  p_value = results$p[DIF_covariate_name,])),
      theta = theta,
      call = call,
      method_results = results)
  }

  if (method == "permutation") {
    results <- permutation_sctest(resp = resp, DIF_covariate = DIF_covariate,
                                  theta = theta, ...)
    DIF_covariate_name <- names(results$DIF_covariate)[1]

    out <- list(
      resp = results$resp,
      method = paste0("Permutation score-based DIF test with ",
                      results$nSamples, " samples"),
      test = results$DIF_covariate[[DIF_covariate_name]]$statistic$name,
      DIF_covariate = DIF_covariate_name,
      DIF_test =
        list(overall = data.frame(stat = results$stat[DIF_covariate_name,],
                                  p_value = results$p[DIF_covariate_name,])),
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
mstDIF.AllModelClass <- function(AllModelClass, DIF_covariate, method,
                                 theta = NULL, see = NULL,
                                 theta_method = "WLE", ...){

  call <- match.call()

  if(method == "analytical") {
    results <- scDIFtest(AllModelClass, DIF_covariate, ...)
    summary <- summary(results)
    out <-  list(
      resp = AllModelClass@Data$data,
      method = "Assymptotic score-based DIF test",
      test = results$info$test_info$stat_name,
      DIF_covariate = as.character(deparse(call$DIF_covariate)),
      DIF_test =
        list(overall = summary[c("stat", "p_value")]),
      theta = theta,
      call = call,
      method_results = results)
    class(out) <- "mstDIF"
    out
  } else {
    # get the data
    resp <- AllModelClass@Data$data

    # get theta
    if(is.null(theta)){
      wle_est <- mirt::fscores(AllModelClass, method = theta_method,
                         full.scores.SE = TRUE)
      theta <- wle_est[,1]

      # get see if needed
      if(method == "mstsib" & is.null(see))
        see <- wle_est[,2]
    }

    # get the item parameters
    if(method %in% c("boostrap", "permutation")) {
      if(any(!mirt::extract.mirt(AllModelClass, "itemtype") %in% c("Rasch", "2PL", "3PL")))
        stop(paste0("The ", method, " DIF method only works for 1PL,  2PL, and 3PL items."))
      it_pars <- extract_it_pars(AllModelClass)
      a <- it_pars$a
      b <- it_pars$b
      c <- it_pars$u
    }

    out <- mstDIF(resp, DIF_covariate, method, theta = theta,
                  see = see, a = a, b = b, c = c, ...)
  }
  return(out)

}

#' @describeIn mstDIF mstDIF method for dRm-objects
mstDIF.dRm <- function(dRm_object, DIF_covariate, method, ...){
  # get the data
  resp <- dRm_object$X
  if(is.null(theta)){
    ppar <- eRm::person.parameter(dRm_object)
    theta <- ppar$theta.table$`Person Parameter`
    if(method == "mstsib" & is.null(see)){
      # get number of all 0 or all 1 responses
      exclude <- ppar$pers.ex
      if(length(exclude == 0)){
        see <- ppar$se.theta[[1]]
      } else {
        see <- rep(NA, length(theta))
        see[-ppar$pers.ex] <- ppar$se.theta[[1]]
      }
    }
  }
  b <- - coef(dRm_object)

  mstDIF(resp, DIF_covariate, method, theta = theta, see = see,
         b = b,  ...)
}





