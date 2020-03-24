``` r
library(magrittr)

list.example <- c(-1, 2, 3, 4)

lapply(list.example, function(x) abs(x) + 1)
#> [[1]]
#> [1] 2
#> 
#> [[2]]
#> [1] 3
#> 
#> [[3]]
#> [1] 4
#> 
#> [[4]]
#> [1] 5
purrr::map(list.example, abs) %>%
  purrr::map(+1)
#> [[1]]
#> [1] 1
#> 
#> [[2]]
#> [1] 2
#> 
#> [[3]]
#> [1] 3
#> 
#> [[4]]
#> [1] 4

# lapply and map can also accept custom functions!

list.function <- function(x) {abs(x)+1}
lapply(list.example, function(x) list.function(x))
#> [[1]]
#> [1] 2
#> 
#> [[2]]
#> [1] 3
#> 
#> [[3]]
#> [1] 4
#> 
#> [[4]]
#> [1] 5

purrr::map(list.example, list.function)
#> [[1]]
#> [1] 2
#> 
#> [[2]]
#> [1] 3
#> 
#> [[3]]
#> [1] 4
#> 
#> [[4]]
#> [1] 5
```

<sup>Created on 2020-03-24 by the [reprex package](https://reprex.tidyverse.org) (v0.3.0)</sup>
