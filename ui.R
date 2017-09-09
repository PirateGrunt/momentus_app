library(shiny)
library(momentus)

shinyUI(fluidPage(

  titlePanel("Momentus"),

  sidebarLayout(
    sidebarPanel(
        radioButtons("in_which_dist", "Which distribution", choices = c("Lognormal", "Gamma"), selected = "Lognormal")
      , sliderInput("in_mean", "Mean:", min = 10e3, max = 100e3, value = 500, step = 5e3)
      , textOutput("out_mu")
      , sliderInput("in_CV", "CV:", min = 0.05, max = 5, value = 0.05, step = .05)
      , textOutput("out_sigma")
      , sliderInput("in_num_sims", "Number of simulations: ", min = 1, max = 10e3, value = 500)
      , downloadButton("btnDownloadData")
    ),

    mainPanel(
        plotOutput("plt")
      , dataTableOutput("tblData")
    )
  )
))
