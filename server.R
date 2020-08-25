library(shiny)


# Server Structure -------------------------------------------------------------
# Define server logic required to draw a histogram
shinyServer(
  
  function(input, output) {
    # Reactive function to do the actual sample size calculation. This has error
    # checking baked in. And, it returns a number or a string
    calc_prop_results <- reactive({
      tryCatch(
        {
          # Calculate the result
          calc_n <- power.prop.test(p1 = input$prop_test_baseline/100,
                                    p2 = (input$prop_test_baseline/100) * (1 + input$prop_test_min_effect/100),
                                    sig.level = (100 - input$prop_test_alpha)/100,
                                    power = input$prop_test_beta/100,
                                    alternative = input$prop_test_tail_option)
          
          # Extract the sample size from the returned list and return it
          return(round(calc_n$n))
        }#,
        # error = function(e){
        #   return("N/A")
        # }
      )
    })
    
    calc_t_results <- reactive({
      tryCatch(
        {
          # Calculate the result
          calc_n <- power.t.test(
            delta = input$t_test_min_effect/100*input$t_test_mean,
            sd = input$t_test_sd,
            sig.level = (100 - input$t_test_alpha)/100,
            power = input$t_test_beta/100,
            alternative = input$t_test_tail_option
          )
          
          # Extract the sample size from the returned list and return it
          return(round(calc_n$n))
        }#,
        # error = function(e){
        #   return("N/A")
        # }
      )
    })
    
    comma_format <- function(x){
      format(x, big.mark=",", scientific = FALSE)
    }
    
    # proportion test
    output$propTestSampleSizeBox <- renderText({
      comma_format(calc_prop_results())
    })
    
    output$propTestTotalVisitors <- renderText({
      paste(
        "(", 
        comma_format(
          calc_prop_results()*input$prop_test_variations),
        "total visitors)"
      )
    })
    
    # t-test
    output$tTestSampleSizeBox <- renderText({
      comma_format(calc_t_results())
    })
    
    output$tTestTotalVisitors <- renderText({
      paste(
        "(",
        comma_format(calc_t_results()*input$t_test_variations),
        " total visitors, which affects", 
        round(
          calc_t_results()*
            input$t_test_variations/input$t_test_user_count,
          digits = 4
        )*100,
        "% of the total targets.)"
      )
    })
    
    # download function: prop.test
    output$downloadDataProp <- downloadHandler(
      filename = function() {
        paste("proportion-test-data-", Sys.Date(), ".csv", sep="")
      },
      content = function(file) {
        data = data.frame(
          date = Sys.Date(),
          test_type = "proportion test",
          baseline_cvr = input$prop_test_baseline,
          expected_lift_percentage = input$prop_test_min_effect,
          n_variations = input$prop_test_variations,
          test_tail_type = input$prop_test_tail_option,
          confidence_level = input$prop_test_alpha,
          power = input$prop_test_beta,
          min_sample_size = calc_prop_results(),
          total_variations_size = calc_prop_results()*input$prop_test_variations)
        
        write.csv(data, file)
      }
    )
    
    # download function: prop.test
    output$downloadDataT <- downloadHandler(
      filename = function() {
        paste("t-test-data-", Sys.Date(), ".csv", sep="")
      },
      content = function(file) {
        data = data.frame(
          date = Sys.Date(),
          test_type = "t-test",
          n_users = input$t_test_user_count,
          metric_mean = input$t_test_mean,
          metric_sd = input$t_test_sd,
          expected_lift_percentage = input$t_test_min_effect,
          n_variations = input$t_test_variations,
          test_tail_type = input$t_test_tail_option,
          confidence_level = input$t_test_alpha,
          power = input$t_test_beta,
          min_sample_size = calc_t_results(),
          total_variations_size = calc_t_results()*input$t_test_variations,
          affected_targets_percentage = round(calc_t_results()*input$t_test_variations/input$t_test_user_count, digits = 4)
        )
        
        write.csv(data, file)
      }
    )
  }
)