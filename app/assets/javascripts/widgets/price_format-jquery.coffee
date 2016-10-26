$ ->
  $('input[name$="price]"], input[name$="cents]"]').priceFormat(
    allowNegative: true,
    limit: 8
  )
