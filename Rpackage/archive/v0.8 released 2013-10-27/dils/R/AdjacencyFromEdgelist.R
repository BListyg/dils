#' Convert an edgelist to an adjacency matrix
#'
#' Given the adjacency matrix for a network return a data.frame listing all possible edges and the weights for each edge.
#' 
#' @param elist data.frame, see 'Details' for formatting assumptions.
#' @return list, containing an adjacency matrix and a vector of node ids identifying the rows and columns
#' \tabular{ll}{
#' \code{adjacency} \tab The adjacency matrix for the network. The row indicates the node the edge is coming 'from', the column indicates the node the edge is going 'to', and the value in the adjacency matrix is the weight given to the edge.\cr
#' \code{nodelist} \tab The ids of the nodes in the same order as the the rows and columns of the adjacency matrix.\cr
#' }
#' @export
#' @seealso \code{\link{EdgelistFill}}
#' @references
#' \url{https://github.com/shaptonstahl/}
#' @author Stephen R. Haptonstahl \email{srh@@haptonstahl.org}
#' @details This assumes that \code{elist} is a data.frame with three columns. Each row is an edge in the network. The first column lists the node the edge is coming from, the second column lists the node the edge is going to, and the third column lists the weight of the edge.
#' @examples
#' edgelist <- cbind(expand.grid(letters[1:2], letters[1:2]), runif(4))
#' AdjacencyFromEdgelist(edgelist)
AdjacencyFromEdgelist <- function(elist) {
  # Guardians
  stopifnot(is(elist, "data.frame"),
            3 == ncol(elist),
            is.numeric(elist[,3]))
  
  filled.elist <- EdgelistFill(elist)  # I assume that this is sorted by first col, then second, 
                                       # so the third col has consecutive rows of the adjacency matrix
  
  nodelist <- sort(unique(filled.elist[,1]))
  n <- length(nodelist)
  
  adjacency <- matrix(0, nrow=n, ncol=n)
  for(i in 1:n) {
    adjacency[i,] <- filled.elist[((i-1)*n+1):(i*n),3]
  }
  out <- list(adjacency=adjacency, nodelist=nodelist)
  return(out)
}
