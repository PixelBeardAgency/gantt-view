## 0.0.7
- Labels now use a builder to render in a list
- Dates now use a builder to render in a list
- Title and subtitle now use a builder to render in a list
- Canvas now only used to render the task bars

## 0.0.6
- A bug where tooltips would only appear for the first column has been fixed
- A bug where sometimes the legend would scroll in the wrong direction has been fixes
- A bug where the tooltip area would be misaligned has been fixed 

## 0.0.5
- A bug where `weekendColor` being null would cause an exception has been fixed

## 0.0.4
- Cells are now built by the painters on the fly, instead of being built prior to painting
  - On large lists, this can be a significant performance boost (~35 seconds to ~20 seconds to render for 1 million rows and 100 columns)

## 0.0.3
- Optimised loops for builders
- Benchmarked loops

## 0.0.2
- Added exports to only expose parts of the library to be used externally
- Package structure update

## 0.0.1

* Initial Release