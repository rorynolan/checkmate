context("checkMatrix")

test_that("checkMatrix", {
  myobj = matrix(1:9, 3)
  expect_succ_all(Matrix, myobj)
  myobj = TRUE
  expect_fail_all(Matrix, myobj)

  x = matrix(1:9, 3)
  expect_true(testMatrix(x))
  expect_true(testMatrix(matrix(nrow=0, ncol=0)))
  expect_false(testMatrix(NULL))
  x[2,2] = NA
  expect_true(testMatrix(x))
  expect_false(testMatrix(x, any.missing = FALSE))

  xl = matrix(TRUE)
  xi = matrix(1L)
  xr = matrix(1.)
  xs = matrix("a")
  xc = matrix(1+1i)
  xx = array(list(1, 1), dim = c(1, 2))
  xe = matrix(nrow = 0, ncol = 0); storage.mode(xe) = "double"
  expect_true(testMatrix(xl, "logical"))
  expect_true(testMatrix(xi, "integer"))
  expect_true(testMatrix(xr, "double"))
  expect_true(testMatrix(xe, "double"))
  expect_true(testMatrix(xr, "numeric"))
  expect_true(testMatrix(xc, "complex"))
  expect_true(testMatrix(xs, "character"))
  expect_true(testMatrix(xx, "list"))
  expect_false(testMatrix(xs, "logical"))
  expect_false(testMatrix(xs, "integer"))
  expect_false(testMatrix(xs, "double"))
  expect_true(testMatrix(xe, "logical")) # empty, so all are missing
  expect_false(testMatrix(xs, "numeric"))
  expect_false(testMatrix(xs, "complex"))
  expect_false(testMatrix(xl, "character"))
  expect_false(testMatrix(xx, "numeric"))
  expect_false(testMatrix(xx, "atomic"))
  expect_true(testMatrix(xi, "integerish"))
  expect_true(testMatrix(xr, "integerish"))
  expect_false(testMatrix(xi+0.1, "integerish"))

  expect_true(testMatrix(x, min.rows = 1, min.cols = 1))
  expect_true(testMatrix(x, max.rows = 5, max.cols = 5))
  expect_true(testMatrix(x, nrows = 3, ncols = 3))
  expect_true(testMatrix(xx, nrows = 1, ncols = 2))
  expect_true(testMatrix(xe, nrows = 0, ncols = 0))
  expect_false(testMatrix(x, max.rows = 1))
  expect_false(testMatrix(x, max.cols = 1))
  expect_false(testMatrix(x, min.rows = 5))
  expect_false(testMatrix(x, min.cols = 5))
  expect_false(testMatrix(x, nrows = 5))
  expect_false(testMatrix(x, ncols = 5))

  expect_false(testMatrix(x, row.names = "named"))
  expect_false(testMatrix(x, col.names = "named"))
  rownames(x) = letters[1:3]; colnames(x) = NULL
  expect_true(testMatrix(x, row.names = "named"))
  expect_false(testMatrix(x, col.names = "named"))
  colnames(x) = letters[1:3]; rownames(x) = NULL
  expect_false(testMatrix(x, row.names = "named"))
  expect_true(testMatrix(x, col.names = "named"))
  colnames(x) = rownames(x) = letters[1:3]
  expect_true(testMatrix(x, row.names = "named"))
  expect_true(testMatrix(x, col.names = "named"))

  # named and unnamed is the same for "empty" matricies
  expect_true(testMatrix(xe, row.names = "unnamed"))
  expect_true(testMatrix(xe, col.names = "unnamed"))
  expect_true(testMatrix(xe, row.names = "strict"))
  expect_true(testMatrix(xe, col.names = "strict"))

  expect_error(assertMatrix(iris), "matrix")
  expect_error(assertMatrix(matrix(), min.rows = 99), "99")
})

test_that("dimension arguments are checked", {
  x = matrix(1)
  expect_error(checkMatrix(x, min.rows = 1.2), "close")
  expect_error(checkMatrix(x, min.rows = NA_integer_), "missing")
  expect_error(checkMatrix(x, min.rows = -1), ">= 0")
})

test_that("dimensions are reported correctly", {
  x = matrix(1:42, ncol = 1)
  expect_true(grepl(42, checkMatrix(x, nrows = 43)))
  expect_true(grepl(42, checkMatrix(x, min.rows = 43)))

  x = t(x)
  expect_true(grepl(42, checkMatrix(x, ncols = 43)))
  expect_true(grepl(42, checkMatrix(x, min.cols = 43)))
})

test_that("missing locations are reported correctly", {
  x = matrix(1:12, ncol = 3); x[1, 1] = NA
  expect_true(grepl("row 1, col 1", checkMatrix(x, any.missing = FALSE)))
  x = matrix(1:12, ncol = 3); x[2, 3] = NA
  expect_true(grepl("row 2, col 3", checkMatrix(x, any.missing = FALSE)))
  x = matrix(1:12, ncol = 3); x[4, 3] = NA
  expect_true(grepl("row 4, col 3", checkMatrix(x, any.missing = FALSE)))
})

test_that("mode accepts all missing values (#184)", {
  x = matrix(NA, nrow = 3, ncol = 3)
  expect_true(test_matrix(x, mode = "double"))
})
