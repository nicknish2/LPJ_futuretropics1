#' Override scales - helper for facet_wrap_custom
scale_override <- function(which, scale) {
  if(!is.numeric(which) || (length(which) != 1) || (which %% 1 != 0)) {
    stop("which must be an integer of length 1")
  }
  
  if(is.null(scale$aesthetics) || !any(c("x", "y") %in% scale$aesthetics)) {
    stop("scale must be an x or y position scale")
  }
  
  structure(list(which = which, scale = scale), class = "scale_override")
}

#'Custom facet_wrap with separate scales
#'https://fishandwhistle.net/post/2018/modifying-facet-scales-in-ggplot2/
#'
facet_wrap_custom <- function(..., scale_overrides = NULL) {
  scale_override <- function(which, scale) {
    if(!is.numeric(which) || (length(which) != 1) || (which %% 1 != 0)) {
      stop("which must be an integer of length 1")
    }
    
    if(is.null(scale$aesthetics) || !any(c("x", "y") %in% scale$aesthetics)) {
      stop("scale must be an x or y position scale")
    }
    
    structure(list(which = which, scale = scale), class = "scale_override")
  }
  
  CustomFacetWrap <- ggproto(
    "CustomFacetWrap", FacetWrap,
    init_scales = function(self, layout, x_scale = NULL, y_scale = NULL, params) {
      # make the initial x, y scales list
      scales <- ggproto_parent(FacetWrap, self)$init_scales(layout, x_scale, y_scale, params)
      
      if(is.null(params$scale_overrides)) return(scales)
      
      max_scale_x <- length(scales$x)
      max_scale_y <- length(scales$y)
      
      # ... do some modification of the scales$x and scales$y here based on params$scale_overrides
      for(scale_override in params$scale_overrides) {
        which <- scale_override$which
        scale <- scale_override$scale
        
        if("x" %in% scale$aesthetics) {
          if(!is.null(scales$x)) {
            if(which < 0 || which > max_scale_x) stop("Invalid index of x scale: ", which)
            scales$x[[which]] <- scale$clone()
          }
        } else if("y" %in% scale$aesthetics) {
          if(!is.null(scales$y)) {
            if(which < 0 || which > max_scale_y) stop("Invalid index of y scale: ", which)
            scales$y[[which]] <- scale$clone()
          }
        } else {
          stop("Invalid scale")
        }
      }
      
      # return scales
      scales
    }
  )
  
  # take advantage of the sanitizing that happens in facet_wrap
  facet_super <- facet_wrap(...)
  
  # sanitize scale overrides
  if(inherits(scale_overrides, "scale_override")) {
    scale_overrides <- list(scale_overrides)
  } else if(!is.list(scale_overrides) || 
            !all(vapply(scale_overrides, inherits, "scale_override", FUN.VALUE = logical(1)))) {
    stop("scale_overrides must be a scale_override object or a list of scale_override objects")
  }
  
  facet_super$params$scale_overrides <- scale_overrides
  
  ggproto(NULL, CustomFacetWrap,
          shrink = facet_super$shrink,
          params = facet_super$params
  )
}

#' Custom function used for contours
#' https://stackoverflow.com/questions/62543112/how-to-make-discrete-gradient-color-bar-with-geom-contour-filled
#' 
craftbrewer_pal <- function (type = "seq", palette = 1, direction) 
{
  pal <- scales:::pal_name(palette, type)
  force(direction)
  function(n) {
    n_max_palette <- RColorBrewer:::maxcolors[names(RColorBrewer:::maxcolors) == palette]
    
    if (n < 3) {
      pal <- suppressWarnings(RColorBrewer::brewer.pal(n, pal))
    } else if (n > n_max_palette){
      rlang::warn(paste(n, "colours used, but", palette, "has only",
                        n_max_palette, "- New palette created based on all colors of", 
                        palette))
      n_palette <- RColorBrewer::brewer.pal(n_max_palette, palette)
      colfunc <- grDevices::colorRampPalette(n_palette)
      pal <- colfunc(n)
    }
    else {
      pal <- RColorBrewer::brewer.pal(n, pal)
    }
    pal <- pal[seq_len(n)]
    if (direction==-1) {
      pal <- rev(pal)
    }
    pal
  }
}

scale_fill_craftfermenter <- function(..., type = "seq", palette = 1, direction, 
                                      na.value = "grey50", guide = "coloursteps", 
                                      aesthetics = "fill") {
  type <- match.arg(type, c("seq", "div", "qual"))
  if (type == "qual") {
    warn("Using a discrete colour palette in a binned scale.\n  Consider using type = \"seq\" or type = \"div\" instead")
  }
  binned_scale(aesthetics, "fermenter", 
               ggplot2:::binned_pal(craftbrewer_pal(type, palette, direction)), 
               na.value = na.value, guide = guide, ...)
}

#' Negate %in%
'%!in%' <- function(x,y)!('%in%'(x,y))

#' Read netcdf variable directly
nc_read <- function(file, varname=NULL, ...){
  nc <- nc_open(file, ...)
  if (is.null(varname)){
    vars <- names(nc$var)
    # ignore lat_bounds lon_bounds time_bnds
    ignore <- c('lat_bounds', 'lat_bnds', 'lon_bounds', 'lon_bnds', 
                'time_bnds', 'time_bounds')
    vars <- vars[vars %!in% ignore]
    if (length(vars)==1){
      varname <- vars
      print(paste0('No variable selected. Only variable available chosen: ', 
                   vars))
    } else {
      varname <- readline(prompt = paste0('Select variable from ', 
                                          paste(vars, collapse = ' '), ': '))
    }
  }
  ncvar <- ncvar_get(nc, varid = varname)
  print(dim(ncvar))
  nc_close(nc)
  return(ncvar)
}

#' Squash axis (from https://stackoverflow.com/questions/61010786/error-nas-are-not-allowed-in-subscripted-assignments-while-using-squash-axis-i)
#' 
squash_axis <- function(from, to, factor) { 
  # A transformation function that squashes the range of [from, to] by factor on a given axis 
  
  # Args:
  #   from: left end of the axis
  #   to: right end of the axis
  #   factor: the compression factor of the range [from, to]
  #
  # Returns:
  #   A transformation called "squash_axis", which is capsulated by trans_new() function
  
  trans <- function(x) {    
    # get indices for the relevant regions
    isq <- x > from & x < to
    ito <- x >= to
    
    # apply transformation
    x[isq] <- from + (x[isq] - from)/factor
    x[ito] <- from + (to - from)/factor + (x[ito] - to)
    
    return(x)
  }
  
  inv <- function(x) {
    
    # get indices for the relevant regions
    isq <- x > from & x < from + (to - from)/factor
    ito <- x >= from + (to - from)/factor
    
    # apply transformation
    x[isq] <- from + (x[isq] - from) * factor
    x[ito] <- to + (x[ito] - (from + (to - from)/factor))
    
    return(x)
  }
  
  # return the transformation
  return(scales::trans_new("squash_axis", trans, inv, domain = c(from, to)))
}