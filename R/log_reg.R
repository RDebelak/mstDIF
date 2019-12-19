#' A logistic regression DIF test for MSTs
#'
#' This function allows the detection of itemwise DIF for Multistage Tests. It is based on the comparison
#' of three logistic regression models for each item. The first logistic regression model (Model 1)
#' predicts the positiveness of each response solely on the estimated ability parameters. The second
#' logistic regression model (Model 2) predicts the positiveness based on the ability parameters
#' and the membership to the focal and reference group as additive predictor variables.
#' The third model (Model 3) uses the same predictors as Model 2 to predict the positiveness of the responses, but
#' also includes an interaction effect. Three model comparisons are carried out (Models 1/2, Models 1/3, Models 2/3)
#' based on two criteria: The comparison of the Nagelkerke R squared values, and the p-values of a likelihood ratio test.
#'
#' Author: Sebastian Appelbaum, with minor changes by Rudolf Debelak
#'
#' @param \code{resp} A data frame containing the response matrix. Rows correspond to respondents, columns to items
#' @param \code{theta} A vector of ability estimates for each respondent.
#' @param \code{group} A vector indicating the membership to the reference and focal groups. 0 for reference group, 1 for focal group.
#'
#' @return A data frame where each row corresponds to an item. The columns correspond to the following entries:
#' \describe{
#'   \item{\code{N}}{The number of responses observed for this item.}
#'   \item{\code{overall_chi_sq}}{The chi squared statistic of the likelihood ratio test comparing Model 2 and Model 0.}
#'   \item{\code{overall_p_value}}{The p-values of the likelihood ratio test comparing Model 2 and Model 0 as
#'   an indicator for the overall DIF effect.}
#'   \item{\code{Delta_NagelkerkeR2}}{The difference of the Nagelkerke R squared values for Model 2 and Model 0.}
#'   \item{\code{UDIF_chi_sq}}{The chi squared statistic of the likelihood ratio test comparing Model 1 and Model 0.}
#'   \item{\code{UDIF_p_value}}{The p-values of the likelihood ratio test comparing Model 1 and Model 0.}
#'   \item{\code{UDIF_Delta_NagelkerkeR2}}{The difference of the Nagelkerke R squared values for Model 1 and Model 0.}
#'   \item{\code{CDIF_chi_sq}}{The chi squared statistic of the likelihood ratio test comparing Model 2 and Model 1.}
#'   \item{\code{CDIF_p_value}}{The p-values of the likelihood ratio test comparing Model 2 and Model 1.}
#'   \item{\code{CDIF_Delta_NagelkerkeR2}}{The difference of the Nagelkerke R squared values for Model 2 and Model 1.}
#' }
#'
#' @export
log_reg <- function(resp, theta, group){

  R2 <- function(m, n) 1 - (exp(-m$null.deviance/2 + m$deviance/2))^(2/n)
  R2max <- function(m, n) 1 - (exp(-m$null.deviance/2))^(2/n)
  R2DIF <- function(m, n) R2(m, n)/R2max(m, n)

  d <- as.data.frame(cbind(theta, group, resp))
  aux <- matrix(NA, nrow = ncol(resp), ncol = 10)
  rownames(aux) <- names(resp)
  colnames(aux) <- c("N",
                     "overall_chi_sq", "overall_p_value", "Delta_NagelkerkeR2",
                     "UDIF_chi_sq", "UDIF_p_value", "UDIF_Delta_NagelkerkeR2",
                     "CDIF_chi_sq", "CDIF_p_value", "CDIF_Delta_NagelkerkeR2")
  C_matrix <- matrix(c(0, 0, 0, 0, 1, 0, 0, 1),nrow = 2)
  for (i in 1:ncol(resp)) {
    glm_2 <- glm(formula = as.formula(paste0(names(resp)[i]," ~ theta*group")), family = binomial, data = d)
    glm_1 <- glm(formula = as.formula(paste0(names(resp)[i]," ~ theta+group")), family = binomial, data = d)
    glm_0 <- glm(formula = as.formula(paste0(names(resp)[i]," ~ theta")), family = binomial, data = d)
    test_udif <- anova(glm_0, glm_1, test = "LRT")
    test_cdif <- anova(glm_1, glm_2, test = "LRT")
    test_dif <- anova(glm_0, glm_2, test = "LRT")

    sum_glm_1 <- summary(glm_2)$coef
    if (dim(sum_glm_1)[1]==4){
      aux[i,1] <- summary(glm_2)$ df.null + 1
      aux[i,2] <- test_dif$Deviance[2]
      aux[i,3] <- test_dif$`Pr(>Chi)`[2]
      aux[i,4] <- R2DIF(glm_2, aux[i,1]) - R2DIF(glm_0, aux[i,1])
      aux[i,5] <- test_udif$Deviance[2]
      aux[i,6] <- test_udif$`Pr(>Chi)`[2]
      aux[i,7] <- R2DIF(glm_1, aux[i,1]) - R2DIF(glm_0, aux[i,1])
      aux[i,8] <- test_udif$Deviance[2]
      aux[i,9] <- test_udif$`Pr(>Chi)`[2]
      aux[i,10] <- R2DIF(glm_2, aux[i,1]) - R2DIF(glm_1, aux[i,1])
      } else {
      aux[i,1] <- summary(glm_1)$ df.null +1
      aux[i,2] <- NA
      aux[i,3] <- NA
      aux[i,4] <- NA
      aux[i,5] <- NA
      aux[i,6] <- NA
      aux[i,7] <- NA
      aux[i,8] <- NA
      aux[i,9] <- NA
      aux[i,10] <- NA
      }
  }
  aux <- as.data.frame(aux)
  aux
}
