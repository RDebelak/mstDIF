extract_it_pars <- function(AllModelClass){
  itemnames <- mirt::extract.mirt(AllModelClass, "itemnames")
  pars <- mirt::coef(AllModelClass, IRTpars = TRUE, as.data.frame = TRUE)
  if(!is.data.frame(pars)) {
    warning("Only the item parameters based on the first group are used for the DIF test.", call. = FALSE)
    pars <- pars[[1]]
  }
  get_it_pars(pars)
}

get_it_pars <- function(pars){
  row_names <- rownames(pars)
  data.frame(a = pars[grep(".a", row_names, fixed = TRUE), ],
             b = pars[grep(".b", row_names, fixed = TRUE), ],
             g = pars[grep(".g", row_names, fixed = TRUE), ],
             u = pars[grep(".u", row_names, fixed = TRUE), ],
             row.names = sub(".a", "",
                             grep(".a", row_names,
                                  fixed = TRUE, value = TRUE),
                             fixed = TRUE))
}
