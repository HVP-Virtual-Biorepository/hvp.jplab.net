
# Source all files in R/ directory (except ourselves)
files <- dir('R', full.names = TRUE)
files <- setdiff(files, 'R/runtime.R')
lapply(files, source)


# Entrypoint for lambda routine
handler <- function(action, ...) {
  
  tryCatch(
    error = function (e) { list(error = e$message) },
    expr  = {
  
      # action should be the unprefixed function name
      assert_string(action, 3, 20)
      stopifnot(grepl('^[a-z_]+$', action))
      
      # Find the api_* function and its incoming args.
      handler_args    <- list(...)
      action_function <- get(paste0('api_', action))
      action_params   <- formalArgs(action_function)
      action_args     <- handler_args[action_params]
    
      if (length(missing_args <- setdiff(action_params, names(action_args))) > 0)
        stop(action, ' is missing argument(s): ', paste(collapse = ', ', missing_args))
    
      # Call the api_* function.
      do.call(action_function, action_args)
      
    }
  )

}


lambdr::start_lambda()
