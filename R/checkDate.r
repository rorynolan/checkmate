#' Check that an argument is a Date
#'
#' @description
#' Checks that an object is of class \code{\link[base]{Date}}, \code{\link[base]{POSIXlt}} or
#' \code{\link[base]{POSIXct}}.
#'
#'
#' @templateVar fn Atmoic
#' @template x
#' @param lower [\code{\link[base]{Date}}]\cr
#'  All dates in \code{x} must be after this date.
#'  Comparison is performed on the operators defined for class \code{\link[base]{Date}}.
#'  Both \code{x} and \code{lower} will be converted using \code{\link[base]{as.Date}} with origin \dQuote{1970-01-01}.
#' @param upper [\code{\link[base]{Date}}]\cr
#'  All dates in \code{x} must be before this date.
#'  Comparison is performed on the operators defined for class \code{\link[base]{Date}}.
#'  Both \code{x} and \code{upper} will be converted using \code{\link[base]{as.Date}} with origin \dQuote{1970-01-01}.
#' @inheritParams checkVector
#' @template checker
#' @export
checkDate = function(x, lower = NULL, upper = NULL, any.missing = TRUE, all.missing = TRUE, len = NULL, min.len = NULL, max.len = NULL, unique = FALSE) {
  if (!inherits(x, c("Date", "POSIXlt", "POSIXct")))
    return("Must be of class 'Date', 'POSIXlt' or 'POSIXct'")

  checkInteger(as.integer(x), any.missing = any.missing, all.missing = all.missing, len = len, min.len = min.len, max.len = max.len, unique = unique) %and% checkDateBounds(as.Date(x), lower = lower, upper = upper)

}

checkDateBounds = function(x, lower, upper) {
  if (!is.null(lower)) {
    lower = as.Date(lower, origin = "1970-01-01")
    if (length(lower) != 1L || is.na(lower))
      stop("Argument 'lower' must be a single (non-missing) date")
    if (any(x < lower))
      return(sprintf("Date must be >= %s", lower))
  }

  if (!is.null(upper)) {
    upper = as.Date(upper, origin = "1970-01-01")
    if (length(upper) != 1L || is.na(upper))
      stop("Argument 'upper' must be a single (non-missing) date")
    if (any(x > upper))
      return(sprintf("Date must be <= %s", upper))
  }

  return(TRUE)
}

#' @export
#' @include makeAssertion.r
#' @template assert
#' @rdname checkDate
assertDate = makeAssertionFunction(checkDate)

#' @export
#' @rdname checkDate
assert_date = assertDate

#' @export
#' @include makeTest.r
#' @rdname checkDate
testDate = makeTestFunction(checkDate)

#' @export
#' @rdname checkDate
test_date = testDate

#' @export
#' @include makeExpectation.r
#' @template expect
#' @rdname checkDate
expect_date = makeExpectationFunction(checkDate)
