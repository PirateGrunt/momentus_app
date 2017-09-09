library(shiny)
library(ggplot2)

shinyServer(function(input, output) {

  which_dist <- reactive({
    if (input$in_which_dist == "Lognormal") {
      dist <- "Lognormal"
    }
    if (input$in_which_dist == "Gamma") {
      dist <- "Gamma"
    }
    dist
  })

  lstParams <- reactive({
    if (which_dist() == "Lognormal") {
      LognormalParams(input$in_mean, input$in_CV)
    } else {
      GammaParams(input$in_mean, input$in_CV)
    }
  })

  sample_data <- reactive({
    validate(
      need(length(lstParams()) == 2, "Parameters not initialized")
    )
    if (which_dist() == "Lognormal") {
      rlnorm(input$in_num_sims, lstParams()[[1]], lstParams()[[2]])
    } else {
      rgamma(input$in_num_sims, lstParams()[[1]], lstParams()[[2]])
    }
  })

  output$out_mu <- renderText({
    if (which_dist() == "Lognormal") {
      paste0("Mu: ", format(lstParams()[[1]], digits = 3))
    } else {
      paste0("Alpha: ", format(lstParams()[[1]], digits = 3))
    }
  })

  output$out_sigma <- renderText({
    if (which_dist() == "Lognormal") {
      paste0("Sigma: ", format(lstParams()[[2]], digits = 3))
    } else {
      paste0("Beta: ", format(lstParams()[[2]], digits = 3))
    }
  })

  output$plt <- renderPlot({
    validate(
      need(length(sample_data() != 0), "No sample data found.")
    )
    plt <- ggplot(data.frame(x = sample_data()), aes(x)) + geom_density()
    plt + scale_x_continuous(labels = scales::comma)
  })

  output$btnDownloadData <- downloadHandler(
    filename = function() {
      "sample_data.csv"
    },
    content = function(file) {
      write.csv(sample_data(), file, row.names = FALSE)
    }
  )

})
