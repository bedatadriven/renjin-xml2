
library(hamcrest)
library(xml2)

test.parse.raw <- function() {

    html <- read_html(as.raw(c(65,66,67)))

    print(as.character(html))

    para <- xml_text(xml_find_first(html, "/html/body"))

    assertThat(para, equalTo("ABC"))

}
