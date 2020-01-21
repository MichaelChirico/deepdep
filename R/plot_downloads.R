#' @title Plot download count of CRAN packages.
#'
#' @description This function uses \href{https://github.com/r-hub/cranlogs}{\bold{API}} of
#' \href{http://cran-logs.rstudio.com/}{\bold{CRAN Logs}} to scrap the download logs of the packages and
#' then plots the data. It works on objects of class \code{character} (vector),
#' \code{deepdep}, \code{package_dependencies} and \code{package_downloads}.
#'
#' @param x A \code{character} vector. Names of the packages that are on CRAN.
#' @param from A \code{Date} class object. From which date plot the data. By default it's one year back.
#' @param to A \code{Date} class object. To which date plot the data. By default it's now.
#'
#' @return A \code{ggplot2} class object.
#'
#' @examples
#' library(deepdep)
#'
#' plot_downloads("ggplot2")
#'
#' dd <- deepdep("ggplot2")
#' plot_downloads(dd)
#'
#' @rdname plot_downloads
#' @export
plot_downloads <- function(x, ...) {
  UseMethod("plot_downloads")
}

#' @rdname plot_downloads
#' @export
plot_downloads.default <- function(x, ...) {
  stop("This type of object does not have implemented method for 'plot_downloads'")
}

#' @rdname plot_downloads
#' @export
plot_downloads.deepdep <- function(x, from = Sys.Date()-365, to = Sys.Date(), ...) {

  temp <- c(attr(x, "package_name"), unique(x$name))
  plot_downloads(temp, from, ...)
}

#' @rdname plot_downloads
#' @export
plot_downloads.package_dependencies <- function(x, from = Sys.Date()-365, to = Sys.Date(), ...) {

  temp <- c(attr(x, "package_name"), unique(x$name))
  plot_downloads(temp, from, ...)
}

#' @rdname plot_downloads
#' @export
plot_downloads.package_downloads <- function(x, from = Sys.Date()-365, to = Sys.Date(), ...) {

  temp <- attr(x, "package_name")
  plot_downloads(temp, from, ...)
}

#' @rdname plot_downloads
#' @export
plot_downloads.character <- function(x, from = Sys.Date()-365, to = Sys.Date(), ...) {

  # add some x check

  ind <- c()
  p <- length(x)

  for (i in 1:p) {
    tryCatch(check_package_name(x[i], FALSE, FALSE),
            error = function(e) {
              warning(paste0(x[i], " is not on CRAN."))
              ind <- c(ind, i)
            }
    )
  }

  if (!is.null(ind)) x <- x[-ind]

  n <- to - from - 1
  if (n <= 0) stop("'to' argument is not greater than 'from'")

  data <- data.frame(matrix(NA, ncol = p, nrow = n))
  colnames(data) <- x

  for (i in 1:p) {
    package <- x[[i]]

    downloads <- cranlogs::cran_downloads(package, from = from, to = to)

    # remove zeros from last few days without data
    downloads_count <- rev(downloads$count)
    # first two entries are 0
    downloads_count <- downloads_count[3:length(downloads_count)]

    data[package] <- rev(downloads_count)
  }

  # base::reshape is hard
  data_long <- reshape(data, direction  = "long", varying = list(1:p),
                       times = names(data), timevar = "package_name",
                       v.names = "downloads", idvar = "time")

  ggplot(data_long, aes(time, downloads, color = package_name)) +
    geom_smooth() + theme(legend.position = "bottom")
}