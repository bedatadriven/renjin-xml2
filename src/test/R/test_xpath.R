
library(hamcrest)
library(xml2)

test.from_elements <- function() {
    x <- read_xml("<ul><li>A</li><li>B</li><li>C</li></ul>")
    ns <- xml_find_all(x, "//li")

    print(ns)

    assertTrue(length(ns) == 3)

}