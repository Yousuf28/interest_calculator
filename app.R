# Car Loan Interest Calculator - Shiny App
# Allows user to input loan amount and term, shows comparison table

library(shiny)
library(DT)

# ============================================================================
# Calculation Functions
# ============================================================================

#' Calculate monthly payment for a loan
#' @param principal Loan amount
#' @param apr Annual percentage rate (as percentage, e.g., 5 for 5%)
#' @param months Loan term in months
#' @return Monthly payment amount
calculate_monthly_payment <- function(principal, apr, months) {
  if (apr == 0) {
    return(principal / months)
  } else {
    monthly_rate <- apr / 100 / 12
    payment <- principal * (monthly_rate * (1 + monthly_rate)^months) / 
               ((1 + monthly_rate)^months - 1)
    return(payment)
  }
}

#' Calculate loan details for a single APR rate
#' @param principal Loan amount
#' @param apr Annual percentage rate
#' @param months Loan term in months
#' @return List with APR, monthly payment, total paid, and total interest
calculate_loan_details <- function(principal, apr, months) {
  monthly_payment <- calculate_monthly_payment(principal, apr, months)
  total_paid <- monthly_payment * months
  total_interest <- total_paid - principal
  
  return(list(
    APR = apr,
    Monthly_Payment = monthly_payment,
    Total_Paid = total_paid,
    Total_Interest = total_interest
  ))
}

#' Calculate loan details for multiple APR rates
#' @param principal Loan amount
#' @param months Loan term in months
#' @param apr_rates Vector of APR rates to calculate
#' @return Data frame with loan details for each APR rate
calculate_all_loan_details <- function(principal, months, apr_rates = seq(0, 6, by = 0.5)) {
  # Calculate for each APR
  loan_list <- lapply(apr_rates, function(apr) {
    calculate_loan_details(principal, apr, months)
  })
  
  # Convert to data frame
  loan_df <- do.call(rbind, lapply(loan_list, function(x) {
    data.frame(
      APR = x$APR,
      Monthly_Payment = x$Monthly_Payment,
      Total_Paid = x$Total_Paid,
      Total_Interest = x$Total_Interest,
      stringsAsFactors = FALSE
    )
  }))
  
  # Calculate difference from previous row (consecutive APR rates)
  loan_df$Difference_From_Previous <- c(0, diff(loan_df$Total_Paid))
  
  return(loan_df)
}

# ============================================================================
# Formatting Functions
# ============================================================================

#' Format currency value
#' @param value Numeric value
#' @return Formatted string with $ and commas
format_currency <- function(value) {
  paste0("$", format(round(value, 2), nsmall = 2, big.mark = ","))
}

#' Format percentage value
#' @param value Numeric value (e.g., 0.05 for 5%)
#' @param decimals Number of decimal places
#' @return Formatted string with % sign
format_percentage <- function(value, decimals = 2) {
  paste0(format(round(value, decimals), nsmall = decimals), "%")
}

#' Format difference display (shows "-" for first row)
#' @param diff_value Difference value
#' @param apr APR value to check if it's the first row
#' @return Formatted string
format_difference <- function(diff_value, apr) {
  if (diff_value == 0 && apr == 0) {
    return("-")
  } else {
    return(format_currency(diff_value))
  }
}

# ============================================================================
# Table Creation Functions
# ============================================================================

#' Create detailed breakdown data frame for display
#' @param loan_df Data frame with loan calculations
#' @param loan_amount Original loan amount
#' @return Formatted data frame for DataTable
create_detailed_table <- function(loan_df, loan_amount) {
  data.frame(
    APR = paste0(loan_df$APR, "%"),
    APR_Sort = loan_df$APR,  # Numeric value for sorting (hidden)
    `Monthly Payment` = format_currency(loan_df$Monthly_Payment),
    `Total Interest` = format_currency(loan_df$Total_Interest),
    `Total Paid` = format_currency(loan_df$Total_Paid),
    `Interest as % of Loan` = format_percentage(loan_df$Total_Interest / loan_amount * 100),
    `Difference from Previous Rate` = mapply(format_difference, 
                                             loan_df$Difference_From_Previous, 
                                             loan_df$APR),
    check.names = FALSE
  )
}

#' Create summary text
#' @param loan_df Data frame with loan calculations
#' @param loan_amount Original loan amount
#' @param term_months Loan term in months
#' @return Formatted summary text string
create_summary_text <- function(loan_df, loan_amount, term_months) {
  min_interest <- min(loan_df$Total_Interest)
  max_interest <- max(loan_df$Total_Interest)
  min_payment <- min(loan_df$Monthly_Payment)
  max_payment <- max(loan_df$Monthly_Payment)
  
  # Get 1.5% to 2% difference
  apr_1_5_paid <- loan_df$Total_Paid[loan_df$APR == 1.5]
  apr_2_paid <- loan_df$Total_Paid[loan_df$APR == 2]
  diff_1_5_to_2 <- if (length(apr_1_5_paid) > 0 && length(apr_2_paid) > 0) {
    apr_2_paid - apr_1_5_paid
  } else {
    0
  }
  
  paste0(
    "Loan Amount: ", format_currency(loan_amount), "\n",
    "Term: ", term_months, " months\n\n",
    "Interest Range:\n",
    "  Minimum (0% APR): ", format_currency(min_interest), "\n",
    "  Maximum (6% APR): ", format_currency(max_interest), "\n\n",
    "Monthly Payment Range:\n",
    "  Minimum (0% APR): ", format_currency(min_payment), "\n",
    "  Maximum (6% APR): ", format_currency(max_payment), "\n\n",
    "Cost Comparison (1.5% vs 2% APR):\n",
    "  At 1.5% APR: ", format_currency(apr_1_5_paid), "\n",
    "  At 2% APR: ", format_currency(apr_2_paid), "\n",
    "  Additional Cost (1.5% to 2%): ", format_currency(diff_1_5_to_2)
  )
}

# ============================================================================
# UI
# ============================================================================

ui <- fluidPage(
  titlePanel("Car Loan Interest Calculator"),
  
  sidebarLayout(
    sidebarPanel(
      h4("Loan Parameters"),
      numericInput("loan_amount", 
                   "Loan Amount ($):", 
                   value = 40000, 
                   min = 1000, 
                   max = 1000000, 
                   step = 1000),
      numericInput("term_months", 
                   "Loan Term (months):", 
                   value = 60, 
                   min = 12, 
                   max = 120, 
                   step = 6),
      br(),
      h5("APR Range: 0% to 6%"),
      p("The table shows loan details for different APR rates."),
      p("The 'Difference from Previous Rate' column shows how much more you pay when moving from one APR rate to the next (e.g., from 1.5% to 2%).")
    ),
    
    mainPanel(
      h4("Detailed Breakdown"),
      DT::dataTableOutput("detailed_table"),
      br(),
      h4("Summary"),
      verbatimTextOutput("summary")
    )
  )
)

# ============================================================================
# Server
# ============================================================================

server <- function(input, output) {
  
  # Calculate loan data for all APR rates
  loan_data <- reactive({
    calculate_all_loan_details(
      principal = input$loan_amount,
      months = input$term_months
    )
  })
  
  # Detailed breakdown table
  output$detailed_table <- DT::renderDataTable({
    df <- loan_data()
    detailed_df <- create_detailed_table(df, input$loan_amount)
    
    DT::datatable(
      detailed_df,
      options = list(
        pageLength = 15,
        dom = 't',
        order = list(list(1, 'asc')),  # Sort by numeric APR value (hidden column 1)
        columnDefs = list(
          list(visible = FALSE, targets = 1),  # Hide the numeric APR column
          list(className = 'dt-center', targets = c(0, 2, 3, 4, 5, 6))
        )
      ),
      rownames = FALSE,
      filter = 'none'
    ) %>%
      DT::formatStyle(
        columns = c(0, 2, 3, 4, 5, 6),
        textAlign = 'center'
      ) %>%
      DT::formatStyle(
        'Difference from Previous Rate',
        backgroundColor = DT::styleInterval(
          cuts = c(-0.01, 0.01),
          values = c('lightgreen', 'lightyellow', 'lightcoral')
        )
      )
  })
  
  # Summary output
  output$summary <- renderText({
    df <- loan_data()
    create_summary_text(df, input$loan_amount, input$term_months)
  })
}

# Run the application
shinyApp(ui = ui, server = server)
