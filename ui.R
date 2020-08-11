library(shiny)
library(shinythemes)

ui <- shinyUI(fluidPage(
  
  theme = shinytheme("united"),
  # title and text
  fluidRow(align = "center",
           titlePanel("Sample Size for your A/B Test"),
           column(10, offset = 1,
                  p("This shiny app allows you to calculate the minimum sample
          size for your A/B test.  The plot shows you the hypothetical
          probability density for the test along with errors.  Use the
          controller to select the parameters for your test and hit the",
                    code("submit"),
                    "button to calculate the sample size.  All values in the
          controller are as a percent.  (note that if the sample size is very
          large, it may take ggplot a second to render)")
           )
  ),
  # horizontal ruler
  tags$hr(),
  # density plot
  plotOutput("main_plot"),
  # horizontal ruler
  tags$hr(),
  # sample size output
  fluidRow(align = "center",
           h4("sample size:"),
           h1(textOutput("pred_out"))
  ),
  # horizontal ruler
  tags$hr(),
  # selector/controller for sample size and plot
  fluidRow(
    column(4,
           numericInput("numericP", "current baseline conversion rate",
                        value = 15, min = 1, max = 98, step = 0.5),
           numericInput("numericDmin", "desired minimum detectable change",
                        value = 2, min = 0.5, max = 20, step = 0.5)
    ),
    column(4,
           sliderInput("sliderAlpha", "significance level",
                       value = 5, min = 1, max = 20, step = 0.5),
           sliderInput("sliderPower", "statistical power",
                       value = 80, min = 50, max = 98, step = 0.5)
    ),
    column(4,
           radioButtons("type", "Test for change in:",
                        c("either direction" = "two",
                          "one direction - less" = "less",
                          "one direction - greater" = "greater")),
           submitButton("submit")
    )
  )
  
))
