handler <- function(context) {
  lambdr::as_stringified_json(
    list(
      isBase64Encoded = FALSE,
      statusCode = 200L,
      body = lambdr::as_stringified_json(context)
    )
  )
}

lambdr::start_lambda()