# This file contains functions for creating graphics common accross all BIST Diagrams

# TODO: Test function for ggplotBist?
#' The ggplotBist sets up a standard plot format for all tax plots
#'
#' This function sets up the common coordinates and axis number displays for all BIST plots 
#' @param frame The data frame the plot is built upon
#' @param xAxisLimit The x axis starts at 0 and ends at the xAxisLimit + half an xTick padding
#' @param xAxisTick Distance between displayed numbers on the x axis
#' @param yAxisLimit The y axis starts at 0 and ends at the yAxisLimit + half a yTick padding
#' @param yAxisTick Distance between displayed numbers on the y axis
#' @keywords dataFrame, plot, axis, ticks
#' @export
#' @examples
#' ggplotBist()
ggplotBist <- function(frame,xAxisLimit,xAxisTick,yAxisLimit,yAxisTick,mapping=aes()){
  xPaddingRight <- xAxisTick/2
  yPaddingTop <- yAxisTick/2
  ggplot(frame,mapping) +
    coord_cartesian(
      xlim=c(0,xAxisLimit + xPaddingRight),
      ylim=c(0,yAxisLimit + yPaddingTop),
      expand = FALSE) + 
    scale_x_continuous(breaks = seq(0,xAxisLimit,xAxisTick)) + 
    scale_y_continuous(breaks = seq(0,yAxisLimit,yAxisTick))
}